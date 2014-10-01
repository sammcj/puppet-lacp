# Class: lacp

class lacp($address, $netmask, $nameservers, $searchdomains, $gateway) {

  package { 'ifenslave-2.6':
    ensure => latest,
  }

  file { '/etc/modprobe.d/bonding.conf':
    ensure => file,
    source => 'puppet:///modules/lacp/bonding.conf',
    owner  => 'root',
    group  => 'root',
    mode   => 0644,
    notify => Exec['lacpmodules'],
  }

  exec { 'lacpmodules':
    command     => 'echo "bonding" >> /etc/modules && echo "mii" >> /etc/modules',
    refreshonly => true,
  }

  $ixgbe0 = [
      "set auto[child::1 = 'ixgbe0']/1 ixgbe0",
      "set iface[. = 'ixgbe0'] ixgbe0",
      "set iface[. = 'ixgbe0']/family inet",
      "set iface[. = 'ixgbe0']/method manual",
      "set iface[. = 'ixgbe0']/bond-master bond0",
    ]

  augeas{ "interface_ixgbe0" :
    context => '/files/etc/network/interfaces',
    changes => $ixgbe0,
  }

  $ixgbe1 = [
      "set auto[child::1 = 'ixgbe1']/1 ixgbe1",
      "set iface[. = 'ixgbe1'] ixgbe1",
      "set iface[. = 'ixgbe1']/family inet",
      "set iface[. = 'ixgbe1']/method manual",
      "set iface[. = 'ixgbe1']/bond-master bond0",
    ]

  augeas{ "interface_ixgbe1" :
    context => '/files/etc/network/interfaces',
    changes => $ixgbe1,
  }

  $bondiface = [
        "set auto[child::1 = 'bond0']/1 bond0",
        "set iface[. = 'bond0'] bond0",
        "set iface[. = 'bond0']/family inet",
        "set iface[. = 'bond0']/method static",
        "set iface[. = 'bond0']/address $address",
        "set iface[. = 'bond0']/netmask $netmask",
        "set iface[. = 'bond0']/gateway $gateway",
        "set iface[. = 'bond0']/bond-mode 802.3ad",
        "set iface[. = 'bond0']/bond-miimon 100",
        "set iface[. = 'bond0']/bond-downdelay 200",
        "set iface[. = 'bond0']/bond-updelay 200",
        "set iface[. = 'bond0']/bond-lacp-rate 30",
        "set iface[. = 'bond0']/bond-slaves none",
        "set iface[. = 'bond0']/dns-nameservers $nameservers",
        "set iface[. = 'bond0']/dns-search $searchdomains",
      ]

  augeas{ "interface_bond0" :
    context => '/files/etc/network/interfaces',
    changes => $bondiface,
  }


}
