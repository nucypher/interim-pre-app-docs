.PHONY: clean-build docs

help:
	@echo "clean - remove build artifacts"
	@echo "docs - build docs and open in default browser (linux)"
	@echo "mac-docs - build docs and open in default browser (mac only)"

clean: clean-build

clean-build:
	rm -rf docs/build

build-docs:
	$(MAKE) -C docs clean
	$(MAKE) -C docs html

docs: build-docs
	readlink -f docs/build/html/index.html

mac-docs: build-docs
	open docs/build/html/index.html
