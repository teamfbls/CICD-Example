# This is based on the book "Openshift in Action" but works with OCP 4

TESTPROJECT=`cat installer.sh | grep "^TESTPROJECT" | awk -F"=" '{print $2}' | sed -e 's/\"//g'`
echo TESTPROJECT="$TESTPROJECT"
PROJECT=`cat installer.sh | grep "^PROJECT" | awk -F"=" '{print $2}' | sed -e 's/\"//g'`
echo PROJECT="$PROJECT"

echo "Creating project ${TESTPROJECT}"
oc new-project ${TESTPROJECT} --display-name="ToDo App - Test"

# ... to be sure we are in the correct project
oc project ${TESTPROJECT}

echo "Create mongodb:3.2 application"
oc new-app \
  -e MONGODB_USER=oiatestuser \
  -e MONGODB_PASSWORD=password \
  -e MONGODB_DATABASE=tododb \
  -e MONGODB_ADMIN_PASSWORD=password \
  mongodb:3.2

echo "change policy so that project ${TESTPROJECT} can read imagestream of project ${PROJECT}"
oc policy add-role-to-group \
  system:image-puller \
  system:serviceaccounts:test \
  -n dev

echo "Sleeping for 20 seconds"
sleep 20
echo "Add aplication based on imagestream promoteToTest"
oc new-app --image-stream="${PROJECT}/todo-app-flask-mongo:promoteToTest"

echo "Sleeping for 20 seconds"
sleep 20

echo "patch ports for the service"
oc patch svc todo-app-flask-mongo --type merge \
  --patch '{"spec":{"ports":[{"port": 8080, "targetPort": 5000 }]}}'

echo "Expose the service"
oc expose svc todo-app-flask-mongo

echo "Sleeping for 15 seconds"
sleep 15

oc get pods

echo ">> POD will crash since it cannot disconver the service at this point"