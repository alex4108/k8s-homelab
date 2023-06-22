#!/usr/bin/env bash

## Somehow wire this up so that all the manifests in nested dirs get applied
## Like a run.sh in every dir...

for dir in */; do
    bash ./$dir/run.sh
    if [[ $? != "0" ]]; then
        echo "!! Component install failed : $dir !!"
        read -p "Press enter to continue installation or CTRL+C to quit"
    fi
done

echo "Install completed?!"