GOCMD=go
XGOCMD=GOPATH=$(shell go env GOPATH) $(shell go env GOPATH)/bin/xgo
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
VERSION=$(shell git describe --tags)
DEBUG_LDFLAGS=''
RELEASE_LDFLAGS='-s -w -X main.version=$(VERSION)'
BUILD_TAGS?=fakedns shadowsocks socks
BUILDDIR=$(shell pwd)/build
CMDDIR=$(shell pwd)/cmd/tun2socks
PROGRAM=tun2socks
TARGETS?=ios/arm-7

.PHONY: build

all: build xbuild

build:
	mkdir -p $(BUILDDIR)
	$(GOBUILD) -ldflags $(RELEASE_LDFLAGS) -tags '$(BUILD_TAGS)' -v -o $(BUILDDIR)/$(PROGRAM) $(CMDDIR)

xbuild:
	mkdir -p $(BUILDDIR)
	$(XGOCMD)  -ldflags $(RELEASE_LDFLAGS) -tags '$(BUILD_TAGS)' -v -dest $(BUILDDIR) --targets $(TARGETS) $(CMDDIR)

travisbuild: xbuild

clean:
	rm -rf $(BUILDDIR)

cleancache:
	# go build cache may need to cleanup if changing C source code
	$(GOCLEAN) -cache
	rm -rf $(BUILDDIR)
