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

SCRIPT_RPATH="$(realpath "$0")"
SCRIPT_PATH="$(dirname "$(realpath "$0")")"

export USER="${USER:-root}"
export TZ="${TZ:-UTC}"

printq() {
	level="$1"
	shift
	text="$*"
	echo "[$(date)] $level >> $text" >&2
}

if [ "$USER" != "root" ]; then
	if which sudo > /dev/null 2>&1; then
		sudo /bin/sh "$SCRIPT_RPATH" "$@"
		exit $?
	elif which doas > /dev/null 2>&1; then
		doas /bin/sh "$SCRIPT_PATH" "$@"
		exit $?
	else
		printq 'WARN' "Command system will be executed under '${USER}' user!"
		printq 'WARN' "Misses can happen."
	fi
fi

prune() {
	rm -f "$MODULES"
	printq 'WARN' "Process destroyed!"
	exit 1
}

trap prune INT TERM

MODULES="$(mktemp "/tmp/$(basename "$0").XXXXXX")"

find "$SCRIPT_PATH/modules" -type f -name "*.sh" | sort > "$MODULES"

while IFS= read -r _module; do
	printq 'INFO' "Loading module ${_module}..."
	# shellcheck source=./modules/*
	. "$_module"
done < "$MODULES"

rm -f "$MODULES"
