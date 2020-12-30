#!/bin/sh -e

# shellcheck disable=SC1091
. ../../lib/sh-test-lib
# shellcheck disable=SC1091
. ../../lib/android-test-lib

TEST_URL="http://kataja.tp.testnet.banksys.be:8080/job/...."

usage() {
    echo "Usage: $0 [-o timeout] [-n serialno] [-u acts_url] [-t test_params] [-p test_path] [-f failures_printed] [-a <ap_ssid>] [-k <ap_key>]" 1>&2
    exit 1
}


# Run test script.
# disable selinux for acts test
selinux=$(adb shell getenforce)
if [ "X${selinux}" = "XEnforcing" ]; then
    adb shell setenforce 0
fi

adb shell "${TEST_SCRIPT}" | tee "${LOGFILE}"


# enable selinux again after the test
# to avoid affecting next test
if [ "X${selinux}" = "XEnforcing" ]; then
    adb shell setenforce 1
fi
