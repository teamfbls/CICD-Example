# This is based on the book "Openshift in Action" but works with OCP 4

PROJECT=`cat 1_install_dev-env.sh | grep "^PROJECT" | awk -F"=" '{print $2}' | sed -e 's/\"//g'`
echo PROJECT="$PROJECT"

IMGSTREAM=$(oc describe imagestream todo-app-flask-mongo | grep sha256 | grep '*' | sed -e 's/  \* image-registry.openshift-image-registry.svc:5000\/dev\///' | head -n 1)

echo "Tagging as promoteToTest"
oc tag ${IMGSTREAM} ${PROJECT}/todo-app-flask-mongo:promoteToTest
