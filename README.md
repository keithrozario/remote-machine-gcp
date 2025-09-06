# Private Remote Server on GCP

GCP has this amazing feature called `iap-tunnel` that is enabled in `gcloud`. This allows you to create a private tunnel from your local machine to a remote machine on GCP without granting the remote machine an internet/external ip.

The tunnel also works with regular GCP credentials, so we don't use ssh keys or anything else. We login to the remote using our regular GCP credentials. 

This means the remote is fully secure from a network (no external ip) and identity (no static passwords) perspective. The tunnel emulates ssh completely (unlike session manager in AWS), and is complete enough for us to even use it as a vscode remote.

This project:

* Creates a VPC Network
* Creates a NAT router on the network
* Creates a special subnetwork in a region
* Deploys an ubuntu compute instance on the subnetwork
* Enables firewall rules for the IAP service to access the ubuntu compute instance (port 22, and port 8080)
* Has a example `~/.ssh/config` file for your configuration


# Installation

Modify `variables.tf` to change the region and stack_name, then:

	$ tf init
	$ tf apply --auto-approve

Modify `config` below and then paste into your own location, on macOS this is typically `~/.ssh/config`.

    Host krozario.remote.machine
        HostName <PRIVATE_IP_ADDRESS>
        IdentityFile ~/.ssh/google_compute_engine
        UserKnownHostsFile ~/.ssh/google_compute_known_hosts
        ProxyCommand gcloud compute start-iap-tunnel "<INSTANCE_NAME>" %p --listen-on-stdin --project "<PROJECT_ID>" --zone=<ZONE_NAME> --verbosity=warning
	    StrictHostKeyChecking no
	    User <USERNAME_REPLACE_ALL_@_AND_DOT_WITH_UNDERSCORE> # e.g. k@k.com ==> k_k_com

# Usage

	$ ssh <hostname>

Because it works like normal ssh, you can even use remote VSCode for this, the host will appear when you try to logon to a remote machine because it references the ssh config file.

# Port Binding

Sometimes you want to bind ports on the remote to your local, so you can host webserver on the remote and access it via localhost on your local:

	$ gcloud compute start-iap-tunnel remote-machine 8080 \
	  --local-host-port=localhost:8080 \
	  --zone=<ZONE_NAME> \ 
	  --project=<PROJECT_ID>

Because of the firewall rules set via terraform only port 8080 is open for now. You can modify this if you want to bind another port on the remote by changing the firewall rules to allow other ports for the IAP access.

