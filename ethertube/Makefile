env = morden
DAPPLE ?= dapple

test:
	$(DAPPLE) test --report
deploy:
	$(DAPPLE) run deploy/$(env).ds -e $(env)
	$(DAPPLE) build -e $(env)

.PHONY: deploy
