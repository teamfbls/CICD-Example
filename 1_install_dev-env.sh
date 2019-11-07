# This is based on the book "Openshift in Action" but works with OCP 4

PROJECT="dev"
TESTPROJECT="test"
PRODPROJECT="prod"

oc new-project ${PROJECT} --display-name="ToDo App - Dev"

# ... to be sure we are in the correct project
oc project ${PROJECT}
oc create -f templates/dev-todo-app-flask-mongo.json
oc new-app --template="dev/dev-todo-app-flask-mongo-gogs"

echo "Wait 30 seconds and let pods start"
sleep 30
sh ./cicd-configurator.sh
