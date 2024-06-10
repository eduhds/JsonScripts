#/bin/bash

os=$(uname -s)
arch=$(uname -m)

if [ "$(uname)" == "Darwin" ]; then
    xcrun --toolchain swift \
        swift build --configuration release
else
    swift build --configuration release \
        --static-swift-stdlib
fi

if [ $? -eq 0 ]; then
    tar -C .build/release -czvf .build/release/jsonscripts-${os,}-${arch}.tar.gz jsonscripts
fi
