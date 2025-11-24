.DEFAULT_GOAL := test

.PHONY: setup
setup:
	pnpm install

.PHONY: clean
	:

.PHONY: test
test:
	pnpm run lint:text

.PHONY: all
all: setup test
