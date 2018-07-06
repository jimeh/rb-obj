NAME = rbheapleak
BINARY = bin/${NAME}
VERSION ?= $(shell cat VERSION)
SOURCES = $(shell find . -name '*.go' -o -name 'Makefile' -o -name 'VERSION')

$(BINARY): $(SOURCES)
	CGO_ENABLED=0 go build -a -o ${BINARY} -ldflags \ "\
		-s -w \
		-X main.version=${VERSION} \
		-X main.commit=$(shell git show --format="%h" --no-patch) \
		-X main.date=$(shell date +%Y-%m-%dT%T%z)"

.PHONY: build
build: $(BINARY)

.PHONY: run
run: $(BINARY)
	$(BINARY)

.PHONY: clean
clean:
	$(eval BIN_DIR := $(shell dirname ${BINARY}))
	if [ -f ${BINARY} ]; then rm ${BINARY}; fi
	if [ -d ${BIN_DIR} ]; then rmdir ${BIN_DIR}; fi

.PHONY: docker
docker:
	docker build -t "$(shell whoami)/$(NAME)" .
