#!/bin/bash

set -e

setRepo () {
  name=$1
  directory=$2
  mkdir -p ~/tmp/$directory
  git clone git@github.com:CSVdB/$name.git ~/tmp/$directory --recursive
}

setRepo my_workflow workflow
setRepo personal-growth ref/personal-growth
setRepo platonic-systems ref/platonic/personal
setRepo books ref/books
setRepo scripts .scripts
setRepo entrepreneurship ref/entrepreneur
setRepo body ref/body
setRepo travel ref/travel
setRepo CV ref/CV
setRepo jobhunt ref/jobhunt
setRepo company ref/company
setRepo administration ref/administration
setRepo network ref/network
setRepo PACT-deployment ref/code/deployment
setRepo PACT-personal ref/pact
setRepo platonic ref/platonic
git clone git@github.com:NorfairKing/salsa.git /ref/code/salsa
