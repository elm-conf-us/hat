ELM_FILES=src/Main.elm src/Names.elm

.PHONY: all
all: index.html

.PHONY: clean
clean:
	rm -rf elm-stuff
	rm -f src/Names.elm names.json

index.html: elm-stuff ${ELM_FILES}
	elm make --output=$@ src/Main.elm

elm-stuff: elm-package.json
	elm package install --yes
	touch -m $@

names.json: names.csv exclusions.csv
	sed 1d $< \
		| cut -d, -f5 \
		| grep -v -f exclusions.csv \
		| jq --indent 0 -sR 'split("\n") | map(select(. != ""))' > $@

src/Names.elm: names.json
	printf "module Names exposing (names)\n\nnames : List String\nnames = " > $@
	cat names.json >> $@
	elm-format --yes $@
