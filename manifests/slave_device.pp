define slave_device ( $ethX = $name, $bondname = 'bond0' ) {

  augeas { "slave_interface_$ethX" :
    context => '/files/etc/network/interfaces',
    changes => [
      "set auto[child::1 = '${ethX}']/1 ${ethX}",
      "set iface[. = '${ethX}'] ${ethX}",
      "set iface[. = '${ethX}']/family inet",
      "set iface[. = '${ethX}']/method manual",
      "set iface[. = '${ethX}']/bond-master ${bondname}",
      ],
  }

}

