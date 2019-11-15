# This is based on the book "Openshift in Action" but works with OCP 4

PRODPROJECT=`cat 1_install_dev-env.sh | grep "^PRODPROJECT" | awk -F"=" '{print $2}' | sed -e 's/\"//g'`
echo PRODPROJECT="$PRODPROJECT"
PROJECT=`cat 1_install_dev-env.sh | grep "^PROJECT" | awk -F"=" '{print $2}' | sed -e 's/\"//g'`
echo PROJECT="$PROJECT"
TESTPROJECT=`cat 1_install_dev-env.sh | grep "^TESTPROJECT" | awk -F"=" '{print $2}' | sed -e 's/\"//g'`
echo TESTPROJECT="$TESTPROJECT"


JENKINSPROJECT=`cat 1_install_dev-env.sh | grep "^JENKINSPROJECT" | awk -F"=" '{print $2}' | sed -e 's/\"//g'`
echo JENKINSPROJECT="$JENKINSPROJECT"

echo "Create new project ${JENKINSPROJECT}"
oc new-project ${JENKINSPROJECT} --display-name="ToDo App - CI/CD with Jenkins"

# ... to be sure we are in the correct project
oc project ${JENKINSPROJECT}
oc create -f templates/jenkins-s2i-template.json
echo "Add new application"
oc new-app --template="jenkins-oia"

sleep 5
echo "Allow jenkins service account to edit exising dev, test and prod project"
oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n ${PROJECT}
oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n ${TESTPROJECT}
oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n ${PRODPROJECT}

