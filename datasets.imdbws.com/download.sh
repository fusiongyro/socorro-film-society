#!/bin/sh

curl https://datasets.imdbws.com/ | sed -n 's/.*a href="\(.*\)".*/\1/gp' | grep -v developer | aria2c --input-file=-
