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
