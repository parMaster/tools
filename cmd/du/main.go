package main

import (
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"

	"github.com/jessevdk/go-flags"
)

var Options struct {
	// Dir        bool `long:"dir" short:"d" description:"show help message"`
	Help       bool `long:"help" short:"h" description:"show help message"`
	Verbose    bool `long:"verbose" short:"v" env:"VERBOSE" description:"verbose output (default: false)"`
	Positional struct {
		Dir string
	} `positional-args:"yes"`
}

type node struct {
	name  string
	isDir bool
	size  int64
	child map[string]*node
}

// add adds a file to the tree
// path is the path to the file, split into components: ["a", "b", "c"]
// info is the file info for the file at the end of the path
// node size is the sum of the sizes of all files in the subtree rooted at the node
// leaf node is a file, non-leaf node is a directory
func (n *node) add(path []string, info fs.FileInfo) {
	if len(path) == 0 {
		n.size = info.Size()
		n.isDir = false
		return
	}
	n.size += info.Size()

	name := path[0]
	if n.child == nil {
		n.child = map[string]*node{}
	}

	child, ok := n.child[name]
	if !ok {
		child = &node{name: name, isDir: true}
		n.child[name] = child
	}

	child.add(path[1:], info)
}

// helper function that prints the tree
// indent is the indentation string
func (n *node) printTree(indent string) {
	fmt.Printf("%s%s %d\n", indent, n.name, n.size)
	for _, child := range n.child {
		child.printTree(indent + "  ")
	}
}

func (n *node) printLevel(indent string) {
	fmt.Printf("%s%s %d\n", indent, n.name, n.size)
	for _, child := range n.child {
		fmt.Printf("%s%s %d %v\n", indent+indent, child.name, child.size, child.isDir)
	}
}

func main() {

	if _, err := flags.Parse(&Options); err != nil {
		os.Exit(1)
	}

	var dir string
	var err error
	if len(Options.Positional.Dir) != 0 {
		dir = Options.Positional.Dir
	} else {
		dir, err = os.Getwd()
		if err != nil {
			panic(err)
		}
	}

	fmt.Println("dir:", dir)

	fs := &node{name: dir, isDir: true}

	filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		path = strings.TrimPrefix(path, dir)
		path = strings.TrimPrefix(path, "/")

		if !info.IsDir() {
			fs.add(strings.Split(path, string(filepath.Separator)), info)
		}

		return nil
	})

	fmt.Println("result:")

	fs.printTree("\t")
	fs.printLevel("\t")
}
