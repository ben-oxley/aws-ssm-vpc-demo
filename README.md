Generate a public/private keypair

```
ssh-keygen -m PEM -f ec2_instance_key
```

```
wget https://s3.amazonaws.com/session-manager-downloads/plugin/latest/windows/SessionManagerPluginSetup.exe

or

Invoke-WebRequest https://s3.amazonaws.com/session-manager-downloads/plugin/latest/windows/SessionManagerPluginSetup.exe -OutFile SessionManagerPluginSetup.exe

```

Then install the session manager

Then run the terraform (this code assumes you've set an aws profile up using `aws configure --profile=main`)

```
terraform init
terraform apply --profile=main
```

Once deployed, connect to the instance with:

```
aws ssm start-session --target i-057efac8c95000b20 --profile=main
```