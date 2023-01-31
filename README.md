Generate a public/private keypair

ssh-keygen -m PEM

wget https://s3.amazonaws.com/session-manager-downloads/plugin/latest/windows/SessionManagerPluginSetup.exe

Then install the session manager

Then connect to the instance with:

aws ssm start-session --target i-057efac8c95000b20 --profile=main