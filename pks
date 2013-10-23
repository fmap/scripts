#!/usr/bin/env bash

URI.escape() {
  ruby -ropen-uri -lpe '$_=URI::escape($_)' <<<"$@"
}

PKS.lookup() {
  [[ -n "$@" ]] && local q="$@" || local q="$(cat -)"
  curl -s "http://pgp.mit.edu:11371/pks/lookup?search=$q"
}

HTML.toMarkdown() {
  pandoc -r html -w markdown
}

String.chomp() {
  grep -vE '^[* ]*$'
}

URI.escape "$@" | PKS.lookup | HTML.toMarkdown | String.chomp
