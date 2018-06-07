#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

(cd $DIR && git add -A && git commit -m "auto commit message" && git push ) &

(cd $DIR/secondpage-pythonutils && git add -A && git commit -m "auto commit message"; git push ) &
(cd $DIR/secondpage-api && git add -A && git commit -m "auto commit message"; git push ) &
(cd $DIR/secondpage-render && git add -A && git commit -m "auto commit message"; git push ) &
(cd $DIR/secondpage-frontend && git add -A && git commit -m "auto commit message"; git push ) &
(cd $DIR/secondpage-rssparse && git add -A && git commit -m "auto commit message"; git push ) &
