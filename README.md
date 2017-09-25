# Hat

Draw names out of a hat

## Building

You'll need a `names.csv`.
In elm-conf's case, this is a list of attendees, with the full attendee name in the 5th column.

You'll also need `exclusions.csv`.
Organizers and some other folks are not eligible for giveaways (although this may change based on the giveaway, which is not implemented.)

These two files will combine to make `Names.elm`, which we generate to avoid having to run an HTTP server (trivial, yes, but another moving part and we need as few of those as possible on conference day.)

Anyway, once you have those files, run:

```
$ make index.html
```

and then open `index.html` in your browser.
You're done!
