Sample port mirroring configuration for OpenSwitch OPX
=====================================

The sample port-mirroring state file facilitates the configuration of port mirroring using CPS. It requires the Salt setup (Salt master) to be done, and the Salt minion should be installed in the OpenSwitch OPX device.

Dependencies
------------
- Place the port-mirroring.conf file in Salt template path
- Place the top.sls file in pillar path
- Place the switch.sls file in pillar path
- Place the port-mirroring.sls file in Salt path

Sample port mirroring configuration
-------------------------

The sample ``port-monitoring.sls`` state file uses CPS in an OPX device and configuration via CPS CLI commands. List of CPS CLI commands placed in ``port-mirroring.conf`` file and using ``cmd.script`` module in Salt , listed CPS commands sequentially executed in the target minion (OpenSwitch OPX device).

The CPS-provided Python script ``cps_config_mirror.py`` facilitates options for port mirroring:

 - ``sudo cps_config_mirror.py create [type] [dst_intf] [source_intf] [dir]``
 
 - ``sudo cps_config_mirror.py get [mirror_id]``

 - ``sudo cps_config_mirror.py delete [mirror_id]``

 - ``sudo cps_config_mirror.py set_source [mirror_id] [source_intf] [dir]``

 - ``sudo cps_config_mirror.py set_dest [mirror_id] [dst_intf]``

> **NOTE**: ``mirror_id`` returned when mirror created 


**Sample conf file - /srv/salt/templates/port-mirroring.conf**

	sudo cps_config_mirror.py create span e101-020-0 e101-031-0 both
	sudo cps_config_mirror.py delete 6

**Sample pillar top file - /srv/pillar/top.sls**

	base:
	  'OPX':
	    - switch

> **NOTE**: ``OPX`` is minion name

**Sample pillar conf file - /srv/pillar/switch.sls**

	config:
	  port-mirroring: port-mirroring.conf

**Sample state file - /srv/salt/port-mirroring.sls**

	salt://{{ pillar.get('config')['port-mirroring'] }}:
	  cmd.script

**Run**

Run in a specific Salt minion.

        salt <minion name> state.sls port-mirroring

        #if your minion name is OPX

        salt OPX state.sls port-mirroring

Run in all Salt minions.

        salt '*' state.sls port-mirroring

Reference
----------

https://docs.saltstack.com/en/latest/topics/pillar/


(c) 2018 Dell Inc. or its subsidiaries. All Rights Reserved.
