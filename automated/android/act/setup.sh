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
        apt-get update -q
        install_deps "${PKG_DEPS}"
        ;;
    *)
        error_msg "Please use Ubuntu for ACTS test."
        ;;
esac

# Download ACTS test package or copy it from local disk.
if echo "${TEST_URL}" | grep "^http" ; then
    wget -q "${TEST_URL}"
else
    cp "${TEST_URL}" ./
fi
file_name=$(basename "${TEST_URL}")
unzip -q "${file_name}"
rm -f "${file_name}"

# Update pip and setuptools.
pip3 -q install --upgrade pip setuptools

# Install ACTS.
cd acts_tests/acts/framework
python3 setup.py -q install
cd -

# Setup adb.
initialize_adb
wait_boot_completed "300"
adb_root
