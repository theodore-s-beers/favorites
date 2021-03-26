#! /opt/homebrew/bin/bash

fd '.*\.(css|html|js|json|md)' -E index.html --exec npx prettier --write {} &&

npx standard --fix switchTheme.js &&

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
--exec pandoc {} \
-f markdown-auto_identifiers \
-M document-css=false \
--tab-stop=2 \
-H '{//}'/desc.html \
-H components/style-links.html \
-B components/header.html \
-A components/footer.html \
-A components/script-link.html \
-o '{.}'.html &&

fd index.html \
--exec npx html-minifier {} \
--collapse-whitespace \
--minify-css true \
--remove-comments \
-o {} &&

fd index.html --exec sd '<style>.*</style>' '' {} &&

fd index.html \
--exec sd 'a href="http' 'a target="_blank" rel="noopener" href="http' {} &&

fd index.html --exec npx prettier --write {}
