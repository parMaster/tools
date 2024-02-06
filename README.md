## Building, installing
Build the binaries:
>make build

Build the binaries and installs them to $GOPATH/bin:

>make install

Uninstall the binaries:
>make uninstall

# Tools

## myip
Prints the external IP address of the router. Note, that it can take up to 128 seconds to return a result. 

Can be used in a pipe:

>myip | xargs ping

or

>ping ${myip}

In my network, WhatIsMyIp shows wrong IP address, this tool shows the correct one.

## portmap

Maps an external port to an internal port on the router using NAT-PMP.
> portmap -i 8080 -e 8080

The result is the external IP address and port that is mapped to the internal port:
> 1.1.1.1:8080

```
Usage:
  portmap [OPTIONS]

Application Options:
  -p, --proto=    protocol to use (tcp, udp) (default: tcp) [$PROTO]
  -i, --internal= internal port to map [$INTERNAL]
  -e, --external= external port to map [$EXTERNAL]
  -l, --lifetime= lifetime of the mapping in seconds (default: 3600) [$LIFETIME]
  -v, --verbose   verbose output (default: false) [$VERBOSE]

Help Options:
  -h, --help      Show this help message
```