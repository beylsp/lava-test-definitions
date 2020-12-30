#!/bin/bash -x
# shellcheck disable=SC2154
# shellcheck disable=SC1091

. ../../lib/sh-test-lib
. ../../lib/android-test-lib

PKG_DEPS="python3-setuptools python3-pip protobuf-compiler"

# Install dependencies.
dist_name
case "${dist}" in
    ubuntu)
        dpkg --add-architecture i386
        apt-get update -q
        install_deps "${PKG_DEPS}"
        ;;
    *)
        error_msg "Please use Ubuntu for ACTS test."
        ;;
esac

# Download ACTS test package or copy it from local disk.
if echo "${TEST_URL}" | grep "^http" ; then
    wget -S --progress=dot:giga "${TEST_URL}"
else
    cp "${TEST_URL}" ./
fi
file_name=$(basename "${TEST_URL}")
unzip -q "${file_name}"
rm -f "${file_name}"

# Update pip and setuptools.
pip3 install --upgrade pip setuptools

# Install ACTS.
python3 acts_tests/acts/framework/setup.py -q install

# Setup adb.
initialize_adb
adb_root
