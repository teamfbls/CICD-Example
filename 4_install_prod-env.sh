# This is based on the book "Openshift in Action" but works with OCP 4

PRODPROJECT=`cat 1_install_dev-env.sh | grep "^PRODPROJECT" | awk -F"=" '{print $2}' | sed -e 's/\"//g'`
echo PRODPROJECT="$PRODPROJECT"
PROJECT=`cat 1_install_dev-env.sh | grep "^PROJECT" | awk -F"=" '{print $2}' | sed -e 's/\"//g'`
echo PROJECT="$PROJECT"

IMGSTREAM=$(oc describe imagestream todo-app-flask-mongo | grep sha256 | grep '*' | sed -e 's/  \* image-registry.openshift-image-registry.svc:5000\/dev\///' | head -n 1)
echo "Tagging as promoteToProd"
oc tag ${IMGSTREAM} ${PROJECT}/todo-app-flask-mongo:promoteToProd

echo "Creating project ${TESTPROJECT}"
oc new-project ${PRODPROJECT} --display-name="ToDo App - Prod"

# ... to be sure we are in the correct project
oc project ${PRODPROJECT}

oc create -f templates/prod-todo-app-flask-mongo.json

oc new-app --template="prod/prod-todo-app-flask-mongo"
