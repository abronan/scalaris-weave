##Dockerizing Scalaris with containers scattered over the network

Using [Weave](https://github.com/zettio/weave) with Docker to run a [Scalaris](https://code.google.com/p/scalaris/) cluster running on containers scattered across different Hosts.

###Setup

First, we launch 3 Virtual Machines with static IP addresses using Vagrant:

	vagrant up
	
Then ssh into each of the 3 VMs

	vagrant ssh host0
	vagrant ssh host1
	vagrant ssh host2
	
###Running the Scalaris cluster

In order to run the Scalaris Ring through containers on different hosts, we'll use [Weave](https://github.com/zettio/weave). For each host, we launch the Weave network and run a Scalaris Node through the Weave command line tool. The container is parameterized with environment variables.

If you want your node to be the initiator of the cluster just give the same IP for `JOIN_IP` and `LISTEN_ADDRESS`.

####Host 0 (Initiator)

	sudo weave launch 10.2.0.1/16 192.168.42.101 192.168.42.102
	sudo weave run 10.2.1.3/24 -d --name first -p 8000:8000 -e JOIN_IP=10.2.1.3 -e LISTEN_ADDRESS=10.2.1.3  abronan/scalaris

####Host 1

	sudo weave launch 10.2.0.1/16 192.168.42.100 192.168.42.102
	sudo weave run 10.2.1.4/24 -d --name second -p 8000:8000 -e JOIN_IP=10.2.1.3 -e LISTEN_ADDRESS=10.2.1.4  abronan/scalaris

####Host 2

	sudo weave launch 10.2.0.1/16 192.168.42.100 192.168.42.101
	sudo weave run 10.2.1.5/24 -d --name third -p 8000:8000 -e JOIN_IP=10.2.1.3 -e LISTEN_ADDRESS=10.2.1.5  abronan/scalaris
	
###Testing the cluster

You can now access the Scalaris web interface through each Hosts (the 8000 port is mapped from the container):

[http://192.168.42.100:8000](http://192.168.42.100:8000)

[http://192.168.42.101:8000](http://192.168.42.101:8000)

[http://192.168.42.102:8000](http://192.168.42.102:8000)

Store a simple Key/Value pair, then search for it. It just works!