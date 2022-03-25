#! /usr/bin/env bash

set -Eeuo pipefail

sort-package-json && npm install &&
	fd index.html -x rm {} &&
	npm run prettify-all &&
	npm run lint &&
	pandoc index-0.md \
		-f markdown-auto_identifiers \
		-M document-css=false \
		--tab-stop=2 \
		-H desc.html \
		-H components/style-links-main.html \
		-B components/header-main.html \
		-A components/script-link-main.html \
		-o index.html &&
	fd index.md \
		-x pandoc {} \
		-f markdown-auto_identifiers \
		-M document-css=false \
		--tab-stop=2 \
		-H '{//}'/desc.html \
		-H components/style-links.html \
		-B components/header.html \
		-A components/footer.html \
		-A components/script-link.html \
		-o '{.}'.html &&
	npm run minify-html &&
	fd index.html -x sd '<style>.*</style>' '' {} &&
	fd index.html \
		-x sd 'a href="http' 'a target="_blank" rel="noopener" href="http' {} &&
	npm run prettify-html
