#!/bin/bash
if [ "$in" = "lol" ] or [ "$out" = "pout" ]; then
echo "a"
fi
#
if [ "$pro" = "true" ] && [ "$in" = "lol" ] or [ "$out" = "pout" ]; then
echo "b"
fi
