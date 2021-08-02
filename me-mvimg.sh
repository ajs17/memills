#!/bin/bash
# run in top level image folder, probably /data_files

git mv $1 $2
git mv ../metadata_files/$1 ../../metadata_files$2