/etc/lldpd.conf:
  file.managed:
    - source:
      - salt://{{ pillar.get('config')['lldp'] }}
/etc/init.d/lldpd restart:
  cmd.run
