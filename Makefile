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

.PHONY: article
article:
	hugo new "articles/`openssl rand -hex 7`/index.md"

.PHONY: post
post:
	hugo new "posts/`openssl rand -hex 7`/index.md"
