#!/bin/bash
if [ "$in" = "lol" ] || [ "$out" = "pout" ]; then
echo "a"
fi
#
if [ "$pro" = "true" ] && [ "$in" = "lol" ] || [ "$out" = "pout" ]; then
echo "b"
fi
