# Private Remote Server on GCP

GCP has this amazin feature called `iap-tunnel` that is enabled in `gcloud`. This allows you to create a private tunnel from your local machine to a remote machine on GCP without granting the remote machine an internet/external ip.

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

Modify `config` and then paste into your own location, on macOS this is typically `~/.ssh/config`.

# Usage

	$ ssh <hostname>

Because it works like normal ssh, you can even use remote VSCode for this.

# Port Binding

Sometimes you want to bind ports on the remote to your local, so you can host webserver on the remote and access it via localhost on your local:

	$ gcloud compute start-iap-tunnel remote-machine 8080 \
	  --local-host-port=localhost:8080 \
	  --zone=<ZONE_NAME> \ 
	  --project=<PROJECT_ID>

Because of the firewall rules set via terraform only port 8080 is open for now. You can modify this if you want to bind another port on the remote.

