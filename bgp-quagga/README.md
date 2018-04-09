# Sample BGP configuration for OpenSwitch OPX

The sample BGP state file facilitates the configuration of border gateway protocol (BGP) using quagga. It requires the Salt setup (Salt master) to be done, and Salt minion and quagga should installed on the OpenSwitch OPX device.

## Dependencies

- Quagga should install on the OpenSwitch OPX device
- Place the ``bgpd.conf`` file in the Salt template path
- Place the ``top.sls`` file in the pillar path
- Place the ``switch.sls`` file in the pillar path
- Place the ``bgp.sls`` file in the Salt path

**Quagga Installation**

    apt-get install -y quagga

In ``/etc/quagga/daemons`` file change the daemon status to "yes" for bgpd.

    zebra=yes
    bgpd=yes
    ospfd=no
    ospf6d=no
    ripd=no
    ripngd=no
    isisd=no
    babeld=no

Restart quagga.

    service quagga restart

Check the quagga status.

    service quagga status

## Sample BGP configuration

The sample BGP state file uses the file push mechanism where the ``bgpd.conf`` file containing all BGP configuration commands is first pushed to the ``/etc/quagga/`` path in the target device, and the quagga is restarted for the change to take effect.

This module contains the configuration file ``/srv/salt/templates/bgpd.conf``, pillar files ``/srv/pillar/top.sls`` and ``/srv/pillar/switch.sls``, and state file ``/srv/salt/bgp.sls``.

**Sample conf file - /srv/salt/templates/bgpd.conf**

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

**Sample pillar top file - /srv/pillar/top.sls**

    base:
      'OPX':
        - switch

> **NOTE**: ``OPX`` is the Salt minion name.

**Sample pillar conf file - /srv/pillar/switch.sls**

    config:
      bgp: bgpd.conf

**Sample state file - /srv/salt/bgp.sls**

    /etc/quagga/bgpd.conf:
      file.managed:
        - source:
          - salt://{{ pillar.get('config')['bgp'] }}
    service quagga restart:
      cmd.run

**Run**

Run in a specific Salt minion.

    salt <minion name> state.sls bgp

    #if your minion name is OPX

    salt OPX state.sls bgp

Run in all Salt minions.

    salt '*' state.sls bgp

**To view the BGP configuration in an OPX device**

    salt <minion name> cmd.run 'vtysh -c "show bgp neighbors"'

> **NOTE**: Change the ``show`` command to view the diffrent configuration (such as ``salt OPX cmd.run 'vtysh -c "show ip prefix-list detail"'``.

## Reference

https://docs.saltstack.com/en/latest/topics/pillar/

Copyright (c) 2018, Dell EMC. All rights reserved.
