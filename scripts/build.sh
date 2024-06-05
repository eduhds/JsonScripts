#/bin/bash

if [ "$(uname)" == "Darwin" ]; then
    xcrun --toolchain swift \
        swift build --configuration release
else
    swift build --configuration release \
        --static-swift-stdlib
fi