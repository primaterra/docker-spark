.PHONY: sphinx-ci-test

sphinx-ci:
	docker build -t sphinx-ci docker/

sphinx-ci-test:
	docker run --rm \
	  -v $(PWD):/app \
	  -w /app \
	  --user root \
	  sphinx-ci sh -c '\
	    rm -f docs/source/modules.rst docs/source/*_*.rst && \
	    sphinx-apidoc -o docs/source src --force --separate && \
	    sphinx-build -b html docs/source docs/_build/html -v \
	  '
