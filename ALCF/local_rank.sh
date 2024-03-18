#!/bin/sh
export LOCAL_RANK=$PMI_LOCAL_RANK
export RANK=$PMI_RANK
export SIZE=$PMI_SIZE
echo "I am $RANK of $SIZE"
$@
