#!/bin/bash

set -x

docker run --rm --volume="$PWD:/srv/jekyll" -p 4000:4000 -it jekyll/jekyll:3.5 jekyll serve --source src