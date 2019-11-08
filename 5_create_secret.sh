#!/bin/bash

echo "Create a secret"
oc create secret generic \
  oia-prod-secret \
  --from-literal=mongodb_user=user-oia \
  --from-literal=mongodb_password=SecretPwd12 \
  --from-literal=mongodb_hostname=mongodb \
  --from-literal=mongodb_database=tododb

echo "Updaing variables for mongodb ... step is missing in the book"
oc set env --from=secret/oia-prod-secret dc/mongodb

echo "Create volume inside pod to mount secret"
oc set volumes dc/todo-app-flask-mongo \
  --add \
  --name=secret-volume \
  --mount-path=/opt/app-root/mongo \
  --secret-name=oia-prod-secret
