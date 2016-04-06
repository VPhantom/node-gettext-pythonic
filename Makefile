JS     := node_modules/.bin/uglifyjs --compress --mangle --comments "/Free software under/"
JSLINT := node_modules/.bin/eslint --fix
TAP    := node_modules/.bin/faucet

help:
	echo "Try one of: clean, build, lint, test"

clean:
	rm -f *.min.js *.js.map

build:	gettext-pythonic.min.js

lint:
	$(JSLINT) --fix gettext-pythonic.js

test:
	node test.js |$(TAP)

%.min.js:	%.js
	$(JS) --source-map $@.map -o $@ -- $<

.PHONY: help clean build lint test

.SILENT:	help
