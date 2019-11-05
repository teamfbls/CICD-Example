# This is based on the book "Openshift in Action" but works with OCP 4

PROJECT="dev"

oc new-project ${PROJECT} --display-name="ToDo App - Dev"

# ... to be sure we are in the correct project
oc project ${PROJECT}
oc create -f cicd-template.yaml
oc new-app --template="dev/dev-todo-app-flask-mongo-gogs"

echo "Wait 30 seconds and let pods start"
sleep 30
sh ./cicd-configurator.sh
