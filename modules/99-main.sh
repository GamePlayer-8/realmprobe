#!/bin/sh

#
#  Copyright	2025		Chimmie Firefly
#
#  Licensed to the Apache Software Foundation (ASF) under one or more
#  contributor license agreements.  See the NOTICE file distributed with
#  this work for additional information regarding copyright ownership.
#  The ASF licenses this file to You under the Apache License, Version 2.0
#  (the "License"); you may not use this file except in compliance with
#  the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

__DEVICES="/dev/kvm /dev/hyperv /dev/tun /dev/net/tun /dev/vboxdrv /dev/vboxnetctl"
__FILES="/secrets.txt $(pwd)/secrets.txt"
__PATHS="/dev"

__total_score="$(expr "$(echo "$__DEVICES" | tr ' ' '\n' | wc -l)" + \
	"$(echo "$__FILES" | tr ' ' '\n' | wc -l)" + \
	"$(echo "$__PATHS" | tr ' ' '\n' | wc -l)")"
__current_score="0"

for _path in $__PATHS; do
	check "$_path" isPath
	exit_code=$?
	if [ $exit_code -eq 0 ]; then
		__current_score="$(expr "$__current_score" + 1)"
	fi
done

for _file in $__FILES; do
	check "$_file" isFile
	exit_code=$?
	if [ $exit_code -eq 0 ]; then
		__current_score="$(expr "$__current_score" + 1)"
	fi
done

for _dev in $__DEVICES; do
	check "$_dev" isDev
	exit_code=$?
	if [ $exit_code -eq 0 ]; then
		__current_score="$(expr "$__current_score" + 1)"
	fi
done

printq 'INFO' "Total score: $__current_score/$__total_score"

lscpu 2>&1 | grep -v -E 'Not affected|^Architecture:|^Vendor ID:' | sed -e "s/^/\[$(date)\] /g"
free -h 2>&1 | sed -e "s/^/\[$(date)\] /g"
df -ah 2>&1 | sed -e "s/^/\[$(date)\] /g"
curl -sL4 ifconfig.me | sed -e "s/^/\[$(date)\] IPv4: /g" | sed -e 's/$/\n/g'
curl -sL6 ifconfig.me | sed -e "s/^/\[$(date)\] IPv6: /g" | sed -e 's/$/\n/g'
ping -c 5 "$(echo "${CI_FORGE_URL:-example.com}" | cut -f 3 -d '/')" | sed -e "s/^/\[$(date)\] /g"
printq 'INFO' "Librespeed: "
librespeed-cli --simple 2>&1 | sed -e "s/^/\[$(date)\] /g"
printq 'INFO' "Speedtest: "
speedtest-cli | grep -E '^Testing from |^Hosted by |^Download: |^Upload: ' | sed -e "s/^/\[$(date)\] /g"
printq 'TEST' "Testing ping to Infra node!"
ping -c 5 mrrp.es | sed -e "s/^/\[$(date)\] /g"

_sysbench() {
	printq 'SYSBENCH' "Running $1 test!"
	sysbench "$@" run | grep -v -E 'sysbench' | tr -s '\n' '\n' | sed -e "s/^/\[$(date)\] /g"
	printq 'SYSBENCH' "Running test with ALL threads!"
	sysbench --threads="$(nproc --all)" "$@" run | grep -v -E 'sysbench' | tr -s '\n' '\n' | sed -e "s/^/\[$(date)\] /g"
}

_fileio_sysbench() {
	printq 'SYSBENCH' "Running $1 test!"
	sysbench "$@" prepare > /dev/null
	sysbench "$@" run | grep -v -E 'sysbench' | tr -s '\n' '\n' | sed -e "s/^/\[$(date)\] /g"
	rm -rf test_file*
	printq 'SYSBENCH' "Running test with ALL threads!"
	sysbench --threads="$(nproc --all)" "$@" prepare > /dev/null
	sysbench --threads="$(nproc --all)" "$@" run | grep -v -E 'sysbench' | tr -s '\n' '\n' | sed -e "s/^/\[$(date)\] /g"
	rm -rf test_file*
}

for _type in cpu threads mutex memory; do
	_sysbench "$_type"
done

_sysbench fileio --file-test-mode="seqwr"

_disk_size="$(expr "$(df . | grep '/' | tr -s ' ' ' ' | cut -f 4 -d ' ')" / 1024 / 1024)"
_disk_allocated="$(expr "$_disk_size" - "$(expr "$_disk_size" / 3)")"

if [ "$_disk_allocated" -gt 2 ]; then
	_disk_allocated="2"
fi

printq 'INFO' "TESTING FILES USING ${_disk_allocated}GB FILE SIZES!"

for _fileio_type in seqrewr seqrd rndrd rndwr rndrw; do
	_fileio_sysbench fileio --file-test-mode="$_fileio_type" --file-total-size="$_disk_allocated"G
done

printq 'INFO' "Listing environ:"
env | sed -e "s/^/\[$(date)\] /g"
