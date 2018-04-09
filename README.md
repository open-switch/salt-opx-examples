# Sample Salt states for OpenSwitch OPX

Salt (sometimes referred to as SaltStack) is a Python-based open source configuration management software and remote execution engine. Salt supports the *Infrastructure as Code* approach to deployment and cloud management.

    https://saltstack.com/about/
	https://docs.saltstack.com/en/latest/

Salt has two main components:

- **Salt master** - Salt master (server) is the location where users interact with all Salt minions (client); all Salt minions (clients) are subscribed to the Salt master

- **Salt minion** - client nodes are the minions (such as OPX devices) that are managed by the Salt master; the Salt minion is installed on each client (such as an OPX device) and the Salt master IP is configured in the minion

- The Salt master acts as a hub for configuration data; the Salt master stores all modules, states, formulas, and templates; Salt key describes each subscribed minions that is being managed by the Salt master

This directory contains sample states files, templates that facilitate the configuration of various features like LLDP, interface, route, BGP (quagga) and port mirroring.

## Dependencies
It requires tge Salt minion which should be installed and run on the OpenSwitch OPX device (client).

**Salt master installation**

    sudo add-apt-repository --remove ppa:saltstack/salt
        # if this fails run this , sudo apt-get install -y software-properties-common
    apt-get install curl
    curl -L https://bootstrap.saltstack.com -o install_salt.sh
    sh install_salt.sh -P -M
        # if this fails , kill all salt process “ps -ef | grep -i salt” and run the command again
    mkdir -p /srv/{salt,pillar}
    mkdir -p /srv/salt/{templates,states}
    In /etc/salt/master file do the following
        # Uncomment "interface 0.0.0.0"
        # add pillar_roots (intend is important as this is yaml structure)
          pillar_roots:
            base:
              - /srv/pillar
        # add the file_roots (intend is important as this is yaml structure)
          file_roots:
            base:
              - /srv/salt
              - /srv/salt/templates/
              - /srv/salt/states/
              - /srv/pillar/
              - /srv/formulas

    service salt-master restart
    service salt-master status

**Salt minion installation on an OPX device**

    apt-get install curl
    curl -L https://bootstrap.saltstack.com -o install_salt.sh
    sh install_salt.sh -P
    In /etc/salt/minion file update the master IP
        master: <salt master_ip>

    service salt-minion restart
    service salt-minion status

**Configure the key in Salt master**

    Run “salt-key –A” command, this will ask n/Y, give Y, while your running this command in output your OPX box name should be present
    Run “salt-key –L” , your OPX box name should be present in output of this command
	
Reference : https://docs.saltstack.com/en/latest/ref/configuration/index.html#key-management

**Verify Salt minion started successfully in OPX device**

    service salt-minion restart
    service salt-minion status

## Reference - Salt setup and execution

- https://docs.saltstack.com/en/latest/topics/releases/releasecandidate.html
- https://docs.saltstack.com/en/latest/ref/configuration/master.html
- https://docs.saltstack.com/en/latest/ref/configuration/minion.html
- https://docs.saltstack.com/en/latest/ref/states/all/

Copyright (c) 2018, Dell EMC. All rights reserved.
