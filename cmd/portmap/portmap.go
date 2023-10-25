package main

// Maps an external port to an internal port on the router using NAT-PMP.
// portmap -i 8080 -e 8080
// The result is the external IP address and port that is mapped to the internal port:
// 1.1.1.1:8080

import (
	"fmt"
	"log"
	"net"
	"os"

	"github.com/jackpal/gateway"
	natpmp "github.com/jackpal/go-nat-pmp"
	"github.com/umputun/go-flags"
)

var Options struct {
	Proto        string `long:"proto" short:"p" env:"PROTO" default:"tcp" description:"protocol to use (tcp, udp)"`
	InternalPort int    `long:"internal" short:"i" env:"INTERNAL" description:"internal port to map"`
	ExternalPort int    `long:"external" short:"e" env:"EXTERNAL" description:"external port to map"`
	Lifetime     int    `long:"lifetime" short:"l" env:"LIFETIME" default:"3600" description:"lifetime of the mapping in seconds"`
	Verbose      bool   `long:"verbose" short:"v" env:"VERBOSE" description:"verbose output (default: false)"`
}

func Map() error {

	if Options.InternalPort == 0 {
		return fmt.Errorf("internal port must be specified")
	}

	if Options.ExternalPort == 0 {
		return fmt.Errorf("external port must be specified")
	}

	gatewayIP, err := gateway.DiscoverGateway()
	if err != nil {
		return fmt.Errorf("failed to discover gateway: %v", err)
	}

	client := natpmp.NewClient(gatewayIP)
	response, err := client.GetExternalAddress()
	if err != nil {
		return fmt.Errorf("failed to get external address: %v", err)
	}

	pm, err := client.AddPortMapping(Options.Proto, Options.InternalPort, Options.ExternalPort, Options.Lifetime)
	if err != nil {
		log.Fatalf("Failed to add port mapping: %v", err)
	}

	ipv4 := net.IPv4(response.ExternalIPAddress[0], response.ExternalIPAddress[1], response.ExternalIPAddress[2], response.ExternalIPAddress[3])

	if Options.Verbose {
		fmt.Printf("External IP address: %v\n", ipv4)

		fmt.Printf("Mapped external port %v to internal port %v for %v seconds\n", pm.MappedExternalPort, pm.InternalPort, pm.PortMappingLifetimeInSeconds)

		fmt.Printf("To test, run listener:\n")
		fmt.Printf("nc -l %v\n", pm.InternalPort)

		fmt.Printf("Connect to the listener from outside NAT:\n")
		fmt.Printf("nc %v %v\n", ipv4, pm.MappedExternalPort)
		return nil
	}

	fmt.Printf("%v:%v\n", ipv4, pm.MappedExternalPort)

	return nil
}

func main() {
	if _, err := flags.Parse(&Options); err != nil {
		os.Exit(1)
	}

	if err := Map(); err != nil {
		log.Fatalf("Failed to map port: %v", err)
	}

}
