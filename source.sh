#!/bin/bash

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

set -e

cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

if ! [ -d nvm ] || ! [ -d node_modules ] || ! [ -d pylint ] || ! [ -d trivy ]; then
	./autogen.sh
fi

export PATH="$PATH:$PWD/node_modules/.bin:$PWD/trivy"
export NVM_DIR="$PWD/nvm"

. "$NVM_DIR/nvm.sh"
. ./pylint/bin/activate

set +e
