#!/bin/bash

# Set path to SoX (not required if
# path is known to the system)

# Check whether in- and outfile have been specified
if [ $# -lt 2 ]; then
  echo "Usage: $0 infile outfile"
  exit 1
fi

# Do the actual decoding
sox "$1" "$2" remix -m 1v0.5,2v0.5 1v0.5,2v-0.5 norm -1

exit 0
