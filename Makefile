index.html: elm-stuff src/**/*.elm
	elm make src/Main.elm

elm-stuff: elm-package.json
	elm package install --yes
	touch -m $@
