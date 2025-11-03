#!/bin/sh

#
#  Copyright	2025    	Echedelle López Romero
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

# Available env variables:
# AUTOGEN_NVM_VERSION ~ default is `0.40.3`
# AUTOGEN_NODE_VERSION ~ default is `22`
# AUTOGEN_COREPACK_VERSION ~ default is `latest`
# AUTOGEN_TRIVY_VERSION ~ default is `0.66.0`

set -e

SCRIPT_PATH="$(dirname "$(realpath "$0")")"

cd "$SCRIPT_PATH"

export NVM_DIR="${NVM_DIR:-$SCRIPT_PATH/nvm}"

_install() {
	if ! [ -d "$NVM_DIR" ]; then
		mkdir "$NVM_DIR"
		# Download and install nvm:
		curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${AUTOGEN_NVM_VERSION:-0.40.3}/install.sh" | bash
	fi

	# in lieu of restarting the shell
	. "$SCRIPT_PATH/nvm/nvm.sh"

	# Download and install Node.js:
	nvm install "${AUTOGEN_NODE_VERSION:-22}"

	# Verify the Node.js version:
	echo 'NodeJS version: '
	node -v # Should print "v22.xx.x" or anything similar.

	npm install -g --no-update-notifier corepack@"${AUTOGEN_COREPACK_VERSION:-latest}"

	# Download and install corepack:
	export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
	corepack enable
	corepack yarn -v > /dev/null
	unset COREPACK_ENABLE_DOWNLOAD_PROMPT

	# Verify yarn version:
	echo 'yarn version: '
	corepack yarn -v

	yarn install

	python3 -m venv pylint

	. ./pylint/bin/activate

	pip install --upgrade pip setuptools wheel

	pip install -r requirements.txt

	mkdir "$PWD/trivy"
	curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
		| sh -s -- -b "$PWD"/trivy v"${AUTOGEN_TRIVY_VERSION:-0.66.0}"
}

_clean() {
	rm -rf node_modules nvm pylint trivy
}

case "$1" in
	clean | clear)
		_clean
		;;
	*)
		_install
		;;
esac
