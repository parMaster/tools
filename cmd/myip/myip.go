package main

// Prints the external IP address of the router.
// Can take up to 128 seconds to return a result
// go build
// myip | xargs ping

import (
	"fmt"
	"log"
	"net"

	"github.com/jackpal/gateway"
	natpmp "github.com/jackpal/go-nat-pmp"
)

func main() {

	gatewayIP, err := gateway.DiscoverGateway()
	if err != nil {
		log.Fatalf("Failed to discover gateway: %v", err)
	}

	client := natpmp.NewClient(gatewayIP)
	response, err := client.GetExternalAddress()
	if err != nil {
		log.Fatalf("Failed to get external address: %v", err)
	}

	ipv4 := net.IPv4(response.ExternalIPAddress[0], response.ExternalIPAddress[1], response.ExternalIPAddress[2], response.ExternalIPAddress[3])

	fmt.Println(ipv4)
}
