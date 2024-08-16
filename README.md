This CI/CD pipeline refred as for Azure DevOps. Also whole architecture defined on Azure enviroment.

Please create a CI pipeline usig CI.yaml file. Please update your connection string and try to run the pipeline. Once succeeded we can see our image repository have created a new one with build number as image Tag.

Next we can create a release pipline using CD.Json file, for better understanding perspective, I have created a release pipline separete for deploying perspective. Here I have used "BAKE" process to deploy our manifests using kustomizatio.yml file

Once we update our kuberenets connection string, we can trigger the release pipline. 

Once its succeeded we can use the command "kubectl get pods" to make sure all pods are running"

To browse the site we can use "kubectl port-forward <podname> 3001:300 

I have terraform file structure in the terraform folder. we can use "terraform init ---------> terraform plan ----------> terraform apply to deploy our resources in to azure.
