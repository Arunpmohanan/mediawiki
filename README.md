# mediawiki

This Repository contains 

Dockerfiles : mediawiki 1.37.2 with redhat base image  8 
               mariadb 


K8s Deployment files for media wiki image and mariadb image created with above Docker files  

K8s service file for the above deplyments 

Helm configuration for the above deployments 

The images created by the DOcker files are pushed to the registry docker.io/arunpmohanandocker/learn01
and used in the deployments files for k8s


Steps to run 

Install minikube 

minikube start 

clone the git repo https://github.com/Arunpmohanan/mediawiki.git

kubectl apply -f  /mediawiki/k8s/ 

output : 
deployment.apps/mariadb-deploy unchanged
deployment.apps/mediawiki-deploy unchanged
service/mariadb configured
service/mediawiki configured


kubectl get pods

NAME                                READY   STATUS    RESTARTS   AGE
mariadb-deploy-5f5f9f84c5-wdcz9     1/1     Running   0          29m
mediawiki-deploy-59bc4bc86c-rvvf5   1/1     Running   0          29m

kubectl get services 

AME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP          65m
mariadb      NodePort    10.109.226.246   <none>        3306:31534/TCP   26m
mediawiki    NodePort    10.106.160.95    <none>        8080:31035/TCP   26m

minikube service mediawiki --url 

The output url can be used to acces mediawiki application 

minikube service mariadb --url 

The output url can be used to acces mariadb instace in the  application 

-------

Helm steps 

Istall helm 

helm install mariadb /mediawiki/helm/mariadb 
helm install mediawiki /mediawiki/helm/mediawiki


















