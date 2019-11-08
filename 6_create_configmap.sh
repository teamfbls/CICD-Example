#!/bin/bash

PROJECT=`cat 1_install_dev-env.sh | grep "^PROJECT" | awk -F"=" '{print $2}' | sed -e 's/\"//g'`
echo PROJECT="$PROJECT"

echo "Create a configmap in namespace ${PROJECT}"
oc create configmap \
  ui-config \
  --from-file=templates/style.properties \
  -n ${PROJECT}

echo "Create volume inside pod to mount secret"
oc set volumes dc/todo-app-flask-mongo \
  --add \
  --name=configmap-volume \
  --mount-path=/opt/app-root/ui \
  -t configmap --configmap-name=ui-config -n ${PROJECT}
