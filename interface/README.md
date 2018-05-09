# Sample interface configuration for OpenSwitch OPX

The sample interface state file facilitates the configuration of an interface using the linux cli commands. It requires the Salt setup (Salt master) to be done, and the Salt minion should be installed in the OpenSwitch OPX device.

## Dependencies

- Place the interface.conf file in Salt template path
- Place the top.sls file in pillar path
- Place the switch.sls file in pillar path
- Place the interface.sls file in Salt path

## Sample interface configuration

The sample interface states file uses the linux cli commands. List of "ifconfig" commands placed in interface.conf file, using "cmd.script" module in Salt , listed "ifconfig" commands sequentially executed in the target minion (OpenSwitch OPX device). This module contains conf file ``/srv/salt/templates/interface.conf``, pillar files ``/srv/pillar/top.sls`` and ``/srv/pillar/switch.sls`` , state file ``/srv/salt/interface.sls``.

**Sample conf file - /srv/salt/templates/interface.conf**

    ifconfig e101-030-0 11.10.10.1 netmask 255.255.255.0 up
    ifconfig e101-031-0 down

**Sample pillar top file - /srv/pillar/top.sls**

    base:
      'OPX':
        - switch

> **NOTE**: ``OPX`` is the Salt minion name.

**Sample pillar conf file - /srv/pillar/switch.sls**

    config:
      interface: interface.conf

**Sample state file - /srv/salt/interface.sls**

    salt://{{ pillar.get('config')['interface'] }}:
      cmd.script
	
**Run**

Run in a specific Salt minion.

    salt <minion name> state.sls interface

    #if your minion name is OPX

    salt OPX state.sls interface

Run in all Salt minions.

    salt '*' state.sls interface

**View all the interface configuration in an OPX device**

    salt <minion name> network.interfaces

**View specific interface details in an OPX device**

    salt <minion name> network.interface eth0

## References

- https://docs.saltstack.com/en/latest/topics/pillar/

- http://net-tools.sourceforge.net/man/ifconfig.8.html

(c) 2018 Dell Inc. or its subsidiaries. All Rights Reserved.
