To mitigate against using the accesskey and ID, in the policy allow access only from some vpn ips and some subnets. And also be only able to access some certain keys


### Install ESO provider
helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets external-secrets/external-secrets -n external-secrets --create-namespace

### Apply
kubectl apply -f ~/RimsysDevops/RimsysGitOps/base/eso-secrets