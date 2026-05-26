#!/bin/bash

mkdir -p ~/.cache/typst/packages

rm -rf ~/.cache/typst/packages/local

ln -sfn $(pwd) ~/.cache/typst/packages/local