#!/bin/bash

set -x

docker run --rm --volume="$PWD:/srv/jekyll" -it jekyll/jekyll:3.5 jekyll build