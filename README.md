puppet-lacp
===========

Puppet module to setup a LACP bond on Debian
Designed to work with HP / Intel 10GbE NICs (ixgbe driver) but can easily be modified to work with others.


## Requirements:

* Augeas
* A Debian based distro

## Example:

```
  class { 'lacp':
    devices       => [ 'ixgbe0', 'ixgbe1' ],
    address       => '192.168.0.2',
    netmask       => '255.255.255.0',
    gateway       => '192.168.0.1',
    searchdomains => 'my.company.local your.company.com',
    nameservers   => '192.168.0.10 192.168.1.10',
  }
```
