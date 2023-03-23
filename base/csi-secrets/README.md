- Create the secret on ASM
- Create cluster with eks
- Create IAM OIDC provider for eks
  - Go to the cluster and copy the oidc provider url
  - Go to IAM identity providers and add new provider using the oidc url of the cluster copied
  - `Get Thumbrint`, under the audience, add `sts.amazonaws.com`
- Create IAM policy to read secrets `CustomSecretManagerAccess`
- Create WebIdentity IAM role for k8 service account and attach the policy above
-  Edit trust relationship of the role and add the service account, so it is only one service account `secrets` in default namespace can use it
```yaml
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::139080726045:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/F9CCF32F36D585F3662DC5AAE2F5D69B"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.us-east-1.amazonaws.com/id/F9CCF32F36D585F3662DC5AAE2F5D69B:sub": "system:serviceaccount:default:secrets"
                }
            }
        }
    ]
}
```

- create a service account `secretsa`
- Install the kubernetes secret store csi driver. `kubectl apply -f ~/RimsysDevops/RimsysGitOps/base/csi-secrets/secrets-store-csi-driver`
  - In the cluster-role.yaml, you will see that `resources: secrets` was specified. This is if you want to use your secrets as environment variables. So the csi driver will retrieve the  variables from ASM and create a secret, then you wil use this secret in your deployment
  - If installing with helm, you have to manually create the cluster-role and binding to give access for that to happen 
  `helm repo add secrets-store-csi-driver https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/master/charts`
  `helm -n kube-system install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver`
  Does same thing but without kubernetes secret access by default, if not you will only be able to mount secret as files

- Install AWS secrets and configuration provider `kubectl apply -f ~/RimsysDevops/RimsysGitOps/base/csi-secrets/aws-provider-installer`

- Create a secret provider class, will map the secret in the aws secret manager with the k8 provider