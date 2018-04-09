# Provision CLOS fabric using Salt modules example

This example describes how to use Salt to build a CLOS fabric with Dell EMC Networking OS10 switches (OpenSwitch OPX). The sample topology is a two-tier CLOS fabric with two spines and two leafs connected as mesh. EBGP is running between the two tiers.
All switches in spine have the same AS number, and each leaf switch has a unique AS number. All AS numbers used are private. Below is the example for configuring BGP and interace using Quagga and LLDP.

## Create a simple Salt module

**Step 1**

Establish the connection between the Salt master and the Salt minion (OpenSwitch OPX), for leaf1 the Salt minion name is “leaf1”, for spine1 the Salt minion name is “spine1” and so on (name accordingly).  

    ``salt-key leaf1 -A``  - Accept the key from leaf1 
    ``salt-key  -L``  - List the minion 

**Step 2**

Create a BGP configuration file called ``/srv/salt/templates/leaf1-bgp.conf``, then define parameter values for leaf1 (this configuration file is the same as the quagga ``bgpd.conf`` file) and create the BGP configuration file for all leafs and spines.

    interface e101-020-0
      ip address 10.1.1.1/24
      no shutdown
    interface e101-021-0
      ip address 20.1.1.1/24
      no shutdown
    interface e101-001-0
      ip address 11.1.1.1/24
      no shutdown
    router bgp 64501
      neighbor 10.1.1.2 remote-as 64555
      neighbor 20.1.1.2 remote-as 64555
      network 10.1.1.0/24
      network 20.1.1.0/24
      network 11.1.1.0/24
      maximum-paths 16

Create an LLDP configuration file called ``/srv/salt/templates/leaf1-lldp.conf``, then define parameter values for leaf1 (this configuration file is the same as the ``lldpd.conf`` file in Linux) and create the LLDP configuration file for all leafs and spines.

    configure lldp tx-interval 33
    configure lldp tx-hold 3
    configure med fast-start enable
    configure med fast-start tx-interval 3

**Step 3**

Create a pillar configuration file called ``/srv/pillar/leaf1.sls`` for each spine and leaf, then define the configuration file name.

    config:
      bgp: leaf1-bgp.conf
      lldp: leaf1-lldp.conf
      hostname: OPX-1

> **NOTE**: ``OPX-1`` is the host name. 

**Step 4**

Create a pillar top sls file called ``/srv/pillar/top.sls``, then map the pillar configuration files to the respective Salt minion.

    base:
      'leaf1':
        - leaf1
      'leaf2':
        - leaf2
      ' spine1':
        - spine1
      ' spine2':
        - spine2
        
Format:

    base:
      '<minion name>':
        - <pillar conf file name>

**Step 5**

Create an ``opx-config.sls`` file called ``/srv/salt/opx-config.sls`` which will transfer the BGP and LLDP configuration files to leafs and spines, then restart the service.

    /etc/lldpd.conf:
      file.managed:
        - source:
          - salt://{{ pillar.get('config')['lldp'] }}
    /etc/init.d/lldpd restart:
      cmd.run
    /etc/quagga/Quagga.conf:
      file.managed:
        - source:
          - salt://{{ pillar.get('config')['bgp'] }}
    service quagga restart:
      cmd.run
    hostname {{ pillar.get('config')['hostname'] }}:
      cmd.run

**Step 5**

Run the module.

    salt ‘*’ state.sls opx-config

Copyright (c) 2018, Dell EMC. All rights reserved.
