#!/bin/bash

function run_test {
    expected=$1
    shift
    echo "running test: $command $@"
    $command $@
    status=$?
    if [ $status -ne $expected ]; then
        echo "exit $status != $expected"
        exit 1
    fi
    echo "exit status $status == $expected"
    echo OK
    return
}

for module in local server
do

command="coverage run -p -a asshole/$module.py"

mkdir -p tmp

run_test 0 -c tests/aes.json -d stop --pid-file tmp/asshole.pid --log-file tmp/asshole.log

run_test 0 -c tests/aes.json -d start --pid-file tmp/asshole.pid --log-file tmp/asshole.log
run_test 0 -c tests/aes.json -d stop --pid-file tmp/asshole.pid --log-file tmp/asshole.log

run_test 0 -c tests/aes.json -d start --pid-file tmp/asshole.pid --log-file tmp/asshole.log
run_test 1 -c tests/aes.json -d start --pid-file tmp/asshole.pid --log-file tmp/asshole.log
run_test 0 -c tests/aes.json -d stop --pid-file tmp/asshole.pid --log-file tmp/asshole.log

run_test 0 -c tests/aes.json -d start --pid-file tmp/asshole.pid --log-file tmp/asshole.log
run_test 0 -c tests/aes.json -d restart --pid-file tmp/asshole.pid --log-file tmp/asshole.log
run_test 0 -c tests/aes.json -d stop --pid-file tmp/asshole.pid --log-file tmp/asshole.log

run_test 0 -c tests/aes.json -d restart --pid-file tmp/asshole.pid --log-file tmp/asshole.log
run_test 0 -c tests/aes.json -d stop --pid-file tmp/asshole.pid --log-file tmp/asshole.log

run_test 1 -c tests/aes.json -d start --pid-file tmp/not_exist/asshole.pid --log-file tmp/asshole.log

done
