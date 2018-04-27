#!/bin/bash

set -x

docker run --rm --volume="$PWD:/srv/jekyll" -e JEKYLL_ENV=production -it jekyll/builder:3.5 jekyll build