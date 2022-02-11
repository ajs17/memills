#!/bin/bash

CITEFILES=$(rg -l -t md '^citation: ')
for FILE in ${CITEFILES}; do
  vi "${FILE}"
done

