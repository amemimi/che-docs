#!/bin/bash
#
# Copyright (c) 2012-2017 Codenvy, S.A.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#   Codenvy, S.A. - initial API and implementation
#

GLOBAL_HOST_ARCH=$(docker version --format {{.Client}} | cut -d" " -f5)

docker() {
  if has_docker_for_windows_client; then
    MSYS_NO_PATHCONV=1 docker.exe "$@"
  else
    "$(which docker)" "$@"
  fi
}

has_docker_for_windows_client(){
  if [ "${GLOBAL_HOST_ARCH}" = "windows" ]; then
    return 0
  else
    return 1
  fi
}


BUILD_OR_RUN=${1:-"--build"}

if [ "$BUILD_OR_RUN" = "--build" ]; then
	COMMAND="jekyll build --incremental"
  echo ""
	echo "Outputting site contents into /_site"
  echo ""
elif [ "$BUILD_OR_RUN" = "--run" ]; then
	COMMAND="jekyll serve -w --force_polling --incremental"	

  echo ""
	echo "View generated docs at http://localhost:9080/docs/"
  echo ""
fi

docker rm -f jekyll > /dev/null 2>&1
docker run --rm -it -p 9080:4000 --name jekyll \
       -v "${PWD}":/srv/jekyll \
       -v "${PWD}"/_site:/srv/jekyll/_site \
           jekyll/jekyll $COMMAND

