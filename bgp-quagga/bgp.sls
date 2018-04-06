/etc/quagga/bgpd.conf:
  file.managed:
    - source:
      - salt://{{ pillar.get('config')['bgp'] }}
service quagga restart:
  cmd.run
