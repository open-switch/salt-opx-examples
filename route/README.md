# Sample static route configuration for OpenSwitch OPX

The sample static route configuration commands facilitate the configuration of a static route using Linux CLI commands. It requires the Salt setup (Salt master) to be done, and the Salt minion should be installed in an OpenSwitch OPX device.

## Dependencies

- Place the route.conf file in Salt template path
- Place the top.sls file in pillar path
- Place the switch.sls file in pillar path
- Place the route.sls file in Salt path

## Sample static route configuration

The sample static route configuration file uses "ip route" Linux CLI commands. The ``cmd.script`` command in Salt state file is used to sequentially execute the list of "ip route" commands in target Salt minions or clinets (OpenSwitch OPX devices). This module contains conf file ``/srv/salt/templates/route.conf``, pillar files ``/srv/pillar/top.sls`` and ``/srv/pillar/switch.sls`` , state file ``/srv/salt/route.sls``.

**Sample conf file - /srv/salt/templates/route.conf**

    ip route add 172.13.1.0/255.255.255.0 via 0.0.0.0 dev eth0
    ip route del 10.10.1.0/255.255.255.0 via 0.0.0.0 dev e101-030-0

**Sample pillar top file - /srv/pillar/top.sls**

    base:
      'OPX':
        - switch

> **NOTE**: ``OPX`` is the Salt minion name.

**Sample pillar conf file - /srv/pillar/switch.sls**

    config:
      route: route.conf

**Sample state file - /srv/salt/route.sls**

    salt://{{ pillar.get('config')['route'] }}:
      cmd.script

**Run**

Run in a specific Salt minion.

    salt <minion name> state.sls route

    #if your minion name is OPX

    salt OPX state.sls route

Run in all Salt minions.

    salt '*' state.sls route

**View routes**

View all routes in the device

    salt <minion name> network.routes   

View all IPv4 routes in the device

    salt <minion name> network.routes inet    

View all IPv6 routes in the device

    salt <minion name> network.routes inet6

## References

- https://docs.saltstack.com/en/latest/topics/execution/remote_execution.html

- https://docs.saltstack.com/en/latest/topics/pillar/

- https://manpages.debian.org/stretch/iproute2/ip-route.8.en.html

Copyright (c) 2018, Dell EMC. All rights reserved.
