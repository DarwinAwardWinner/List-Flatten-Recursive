all: build

build: .build-timestamp

FIND_NON_HIDDEN_CMD := find $(1) -iname [^.#]*
FIND_NON_HIDDEN := $(shell $(FIND_NON_HIDDEN_CMD))

.build-timestamp: $(call FIND_NON_HIDDEN,lib) dist.ini weaver.ini
	dzil clean && \
	dzil build && \
	date > .build-timestamp

test:
	dzil test

clean:
	rm -f .build-timestamp && \
	dzil clean

.PHONY: all clean build test
