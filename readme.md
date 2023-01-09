*Disclaimer: This project should be seen as Proof-of-Concept (PoC). If you would like to use this in production environments, please carefully review the section “Considerations”.*

## Objective
Akamai’s platform only supports ports 80 and 443 for http(s) traffic, which means applications which use other ports cannot be onboarded to the Akamai platform directly.
To solve this obstacle, we send the requests of the application to a reverse proxy which listens on the custom port. The proxy then forwards the requests to Akamai on ports 80/443.

## Proxy requests on Linode
Linode as Cloud platform hosts this proxy. For production-ready workloads a dedicated Linode would be a good fit: https://www.linode.com/products/dedicated-cpu/ 
As proxy software I chose Envoy https://www.envoyproxy.io/ .
In my setup, the reverse proxy works on Layer 4 (TCP) only, which has advantages:
- Less resource overhead
- No TLS termination means less effort in handling TLS certificates and reduces privacy concerns, as traffic remains encrypted on the proxy
If required, the proxy could also be configured to work on Layer 7 which would bring a lot more functionality, but also complexity:
- Envoy as Edge Proxy: https://www.envoyproxy.io/docs/envoy/latest/configuration/best_practices/edge#best-practices-edge 
- Envoy SNI Dynamic Forwarding: https://www.envoyproxy.io/docs/envoy/latest/configuration/listeners/network_filters/sni_dynamic_forward_proxy_filter 
## Scalability and Availability: Kubernetes
Linode Kubernetes Engine (LKE) https://www.linode.com/products/kubernetes/ 
With LKE, we can create a k8s cluster which runs our proxy server. K8s will automagically take care of scaling and availability. This improves the scalability and availability of the proxy solution.

## Performance and Fault Tolerance: Extend the solution to additional Linode regions
We can deploy the Envoy proxy not only on one LKE in one region, but use all 11 available Linode regions, to set up a truly global reverse proxy infrastructure.

## Global Performance Based Load Balancing: Global Traffic Management (GTM)
Akamai’ Global Traffic Management https://www.akamai.com/products/global-traffic-management is a DNS based load balancing solution which dynamically assigns the optimal proxy location to the users.
Users will connect to GTM for DNS resolution, and GTM will automatically assign the users to the optimal LKE cluster our reverse proxy runs on. 
Performance will improve as:
- The last mile connection between the users and the proxy is minimized
- The connection between Linode and Akamai runs on the globally Akamai private backbone

## Build & Automate
We’ve seen that there are quite a few parts to be configured to achieve the final setup.
To simplify the onboarding process, we can automate the deployment of the solution.

*Assumption: You already have an up and running Akamai CDN configuration and Backend application.*

### Envoy Docker container
The core of the solution is the Envoy proxy, which is deployed on the Linode Kubernetes Engine. 
K8s is based on containers, so initially we need to create the Envoy container.
You can create a static container, which listens specifically on the ports configured, or create a container image which allows you to pass specific variables to configure Envoy dynamically. 
The Envoy image listens on port 80 (forwarded to port 80), port 443 (forwarded to 443) and a custom port which can be defined and will be forwarded either to port 80 or 443. 
Ports 80 and 443 are open as well, as it might be required that clients need to reach the application via these ports (e.g. TLS certificate validation).
The Forward hostname Envoy will connect to can also be dynamically specified. Typically this is the Akamai Edge Hostname of your existing Akamai configuration.
Please see the directory “envoy_docker” in Github.

### Deploying the Linode Kubernetes Engine clusters in all Linode regions automatically with Terraform
We use Linode’s Terraform provider https://registry.terraform.io/providers/linode/linode/latest/docs/resources/lke_cluster  to automatically deploy LKE clusters in all Linode regions.

*Assumption: You have a Linode account and a Personal Access Token. Terraform is installed on your machine.*

Should only specific regions be required, the files and scripts would have to be adapted. By default this solution deploys to all current 11 Linode regions (January 2023).
You will be able to give the cluster a specific name and input your Personal Access Token.
In this scenario we deploy 1 LKE cluster per Linode region, consisting of 3 Nodes, type “g6-dedicated-2” (2 vCPU, 4 GB RAM, https://api.linode.com/v4/linode/types ). We provision the LKE High Availability Control plane, and Cluster Autoscaling with a minimum of 3 Nodes and a maximum of 6 Nodes.
Terraform will then take care of the deployment. Further information on the Linode LKE Terraform provider can be found here: https://www.linode.com/docs/guides/how-to-deploy-an-lke-cluster-using-terraform/ 
After the deployment, Terraform will also create kubeconfig files and save them in the local directory. These files are required to connect to the clusters to configure them.
Please see the directory “lke_tf” in Github.

### Deploy the Envoy proxy on all LKE clusters
Now that the clusters are created, we can put the Envoy proxy on them.

*Assumption: kubectl is installed on your local machine.*

Initially, we give our input parameters to configure the Envoy setup:
- Envoy Custom port: the custom, non-80/443-port Envoy will listen on
- Envoy Forward port: the port, Envoy will use to connect to the Akamai platform (80 or 443)
- Envoy Forward Edge Host Name: the Edgehostname Envoy will use to determine the Akamai Edge server to connect to

Based on this data, we create dynamically our kubernetes .yaml configuration file. It contains:
- Namespace
- Service: The external NodeBalancer IP the cluster will be exposed with to the public, with the specified ports open to the public
- Deployment: Here we specify the Envoy Docker Image, number of replicas (3), Container ports, and resource requests for the pod
- Horizontal Pod Autoscaling: Automatically scale the number of pods based on resource limits. Should a pod hit 50% CPU utilization, k8s will automatically scale out to a maximum of 6 replicas (minimum 3).

The created .yaml file is then applied to all LKE clusters, using the previously generated kubeconfig files.

In order for the Horizontal Pod Autoscaling to work, we will also deploy a “metrics-server” on all clusters.

Please see the directory “envoy_k8s” in Github.

### Deploy Akamai GTM with Terraform
Finally, we deploy the Akamai Global Traffic Management.

*Assumption: You have GTM available in your contract, and an Akamai API account with access to the GTM API, local credentials in your .edgerc file in your home directory: ~/.edgerc.*

GTM will use the external IPs of the k8s Service LoadBalancer, the Linode NodeBalancer, of all regions as traffic targets. Therefore we need to retrieve these IPs from the LKE clusters and put them into the GTM Terraform files.
This is done automatically via the provided shell scripts. The external IPs are also stored locally in a “locations.txt” file for your convenience.

In the next step you need to configure the Akamai Terraform provider for GTM https://registry.terraform.io/providers/akamai/akamai/latest/docs/guides/get_started_gtm_domain  with these values: 
- Akamai Contract ID
- Akamai Group ID
- Notification Email
- GTM Domain Name (must end in .akadns.net)
- GTM Property Name

Terraform will then deploy GTM.

Please see the directory “gtm_tf” in Github.

### Putting the application live
The script will output the CNAME for the application hostname, which is the GTM Hostname.
After implementing the CNAME in the application’s DNS, the clients will connect to GTM for DNS resolution, GTM will respond with the most optimal LKE cluster, the client connects to the cluster, the Envoy proxy will take the request on the custom port and forward the request on port 80 or 443 to the Akamai CDN platform.

### Automate all steps
For your convenience, all the steps mentioned above are available in shell scripts: either an “all-in-one” script, which walks you through the setup from A to Z, or 7 individual scripts, step by step.
They are available in Github.

## Considerations
- Neither Envoy, nor the LKE clusters have been hardened for security
- The solution was not load-tested, nor was the performance impact assessed.
- Depending on the traffic, the Linode type, Cluster size, cluster autoscaling, pod replicas and pod resource limits and requests need to be adjusted. This is also important considering costs.
- Above LKE clusters in all 11 Linode regions create costs between 1650$ and 2640$ per month.
- If only one or a few regions are required, the solution can be adopted to that use case. (I still recommend at least 2 regionally independent setups for redundancy.)
- This example uses a Layer 4 (TCP) proxy for simplicity. Envoy can also be configured to work on Layer 7, e.g. on the SNI extension or http(s).
- This setup is designed to support one application. In theory, this can easily be extended to support multiple applications running on various ports. For applications sharing the same port and different Akamai setups, the proxy would have to be used on Layer 7.
- The Akamai CDN will not have any end-user connectivity for this application, as all requests are routed through the proxy. This will impact several things. Among the most crucial is that Akamai will lose the ability to properly apply Layer 7 DDoS protection (Rate Controls), as this is based on end user IP, which are essentially Linode IPs with this setup. You could use Layer 7 proxy to write the client IP in a http header and point the Rate Controls to that header.
- Any client based logic in Akamai (Geo, Edgescape, etc) will be lost, as the clients for Akamai are essentially Linode proxy servers. Again, putting the client IP in a http header on the proxy might help here.
- As the reverse proxy fronts Akamai, this will also be the target for any DDoS attacks. There is a risk that the clusters can go down when under attack, as they don’t offer the same Layer 3 / 4 protection as the Akamai platform, nor any other Layer 7 security, like Rate Controls or WAF.
- This project currently does not consider observability. In production, monitoring of the k8s deployments and the LKE clusters should be setup.
- The solution uses Kubernetes, which might not be required (or overkill), considering we run only one simple application in it.
- The idea of the project on Github is to run the shell scripts. When changing parameters, make sure to update relevant references in the file to ensure stability.

## Tools used
- Akamai https://www.akamai.com/ 
- Linode https://www.linode.com/products/dedicated-cpu/ 
- Envoy Proxy https://www.envoyproxy.io/ 
- Kubernetes https://kubernetes.io/ 
- Terraform https://www.terraform.io/ 
- Docker https://www.docker.com/ 

## Environment variables set by the shell scripts to dynamicall create the setup
- Linode
  - $LKE_CLUSTER_NAME : The name of the LKE cluster
  - $TOKEN : The Linode Personal Access Token

- Envoy
  - $ENVOY_CSTM_PORT : The custom (non-80/443) port the application uses
  - $ENVOY_FWD_PORT : The port Envoy will forward the requests to on the Akamai platform (80 or 443)
  - $ENVOY_FWD_EHN : The Akamai Edge Hostname of your Akamai configuration. Envoy will forward the requests to the Akamai CDN IPs resolved by this Hostname.

- Linode LKE External Node Balancer IPs
External IP of each LKE cluster. Will be used to configure Akamai GTM for Global Load Balancing.
  - $APWEST
  - $CACENTRAL
  - $APSOUTHEAST
  - $USCENTRAL
  - $USWEST
  - $USSOUTHEAST
  - $USEAST
  - $EUWEST
  - $APSOUTH
  - $EUCENTRAL
  - $APNORTHEAST

- Akamai
  - $AKAM_CONTRACT_ID : Your Akamai Contract ID
  - $AKAM_GROUP_ID : Your Akamai Group ID
  - $GTM_NOTIFICATION_EMAIL : GTM Notification Email
  - $GTM_DOMAIN_NAME : GTM Domain Name, must end in .akadns.net
  - $GTM_PROPERTY_NAME : GTM Property Name

## Testing setup
For testing purposes, the directory "__testing_setup" creates a trimmed down setup, which makes the creation faster and lets you test things out without having to deploy the full blown version.