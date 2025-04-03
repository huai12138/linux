#!/bin/bash
while true; do
swww img --transition-type random $(find ~/Pictures -type f | shuf | head -n 1)
sleep 180
done
