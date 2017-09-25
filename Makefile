index.html: elm-stuff src/**/*.elm
	elm make --output=$@ src/Main.elm

elm-stuff: elm-package.json
	elm package install --yes
	touch -m $@

names.json: names.csv exclusions.csv
	sed 1d $< \
		| cut -d, -f5 \
		| grep -v -f exclusions.csv \
		| jq --indent 0 -sR 'split("\n") | map(select(. != ""))' > $@
