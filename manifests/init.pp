# Class: lacp

class lacp($address, $netmask, $nameservers, $searchdomains, $gateway, $bondmode = '802.3ad', $devices = [ 'ixgbe0','ixgbe1' ] ) {

  package { 'ifenslave-2.6':
    ensure => latest,
  }

  file { '/etc/modprobe.d/bonding.conf':
    ensure => file,
    source => 'puppet:///modules/lacp/bonding.conf',
    owner  => 'root',
    group  => 'root',
    mode   => 0644,
  }

  augeas{ 'lacpmodules' :
    context => '/files/etc/modules',
    changes => [ 'clear bonding', 'clear mii'] ,
  }

  slave_device { $devices:
  }

  $bondiface = [
        "set auto[child::1 = 'bond0']/1 bond0",
        "set iface[. = 'bond0'] bond0",
        "set iface[. = 'bond0']/family inet",
        "set iface[. = 'bond0']/method static",
        "set iface[. = 'bond0']/address $address",
        "set iface[. = 'bond0']/netmask $netmask",
        "set iface[. = 'bond0']/gateway $gateway",
        "set iface[. = 'bond0']/bond-mode $bondmode",
        "set iface[. = 'bond0']/bond-miimon 100",
        "set iface[. = 'bond0']/bond-downdelay 200",
        "set iface[. = 'bond0']/bond-updelay 200",
        #"set iface[. = 'bond0']/bond-lacp-rate 30",
        "set iface[. = 'bond0']/bond-slaves none",
        "set iface[. = 'bond0']/dns-nameservers $nameservers",
        "set iface[. = 'bond0']/dns-search $searchdomains",
      ]

  augeas{ "interface_bond0" :
    context => '/files/etc/network/interfaces',
    changes => $bondiface,
  }

}
