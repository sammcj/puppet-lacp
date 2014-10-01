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
    address       => '10.51.11.143',
    netmask       => '255.255.254.0',
    gateway       => '10.51.11.1',
    nameservers   => '10.51.11.10',
    searchdomains => 'mycompany.com',
  }
```
