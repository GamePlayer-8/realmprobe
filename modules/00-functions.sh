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

printqx() {
	level="$1"
	shift
	text="$*"
	printf '%s' "[$(date)] $level >> $text" >&2
}

isDev() {
	__device="$1"
	if [ -d "$__device" ]; then
		echo 'OK'
	elif [ -b "$__device" ]; then
		echo 'OK (with -b)'
	else
		echo 'NO'
		return 1
	fi
}

isFile() {
	__file="$1"
	if [ -f "$__file" ]; then
		echo 'OK'
		return
	fi
	echo 'NO'
	return 1
}

isPath() {
	__path="$1"
	if [ -d "$__path" ]; then
		echo 'OK'
		return
	fi
	echo 'NO'
	return 1
}

check() {
	printqx 'CHECKER' "Looking for ${1}... "
	"$2" "$1"
	return $?
}
