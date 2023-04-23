#!/bin/bash
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin

GAIAD_PATH=$(go env GOPATH)/bin/gaiad

if [ ! -d "$HOME/.gaia/data/blockstore.db" ]; then
    echo "Downloading snapshot ..."
    export URL=`curl -L https://quicksync.io/cosmos.json|jq -r '.[] |select(.file=="cosmoshub-4-pruned")|.url'`
    echo $URL
    cd $HOME/.gaia
    aria2c -x5 $URL
    export SNAPSHOT=`basename $URL`
    echo `Snapshot $SNAPSHOT downloaded, extracting ...`
    lz4 -c -d `basename $URL` | tar xf -
    rm -rf `$SNAPSHOT`
fi

gaiad start --x-crisis-skip-assert-invariants