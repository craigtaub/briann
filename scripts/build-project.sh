#Paramaterized build
#SHA=
#PR=

# Workspace parameters
OLD_PATH=$PATH
PATH=$WORKSPACE/git-ci/bin:$PATH

# Github parameters
OWNER=craigtaub
REPO=briann
BRANCH=master
USERNAME=craigtaubdev
PASSWORD=craigtaub01

update_github() {
    set -e
    if [ $1 -eq 0 ]; then
       STATUS="success"
    elif [ $1 -eq 1 ]; then
       STATUS="pending"
    else
       STATUS="failure"
    fi
   POST="{\"state\":\"${STATUS}\",\"target_url\":\"$BUILD_URL\",\"description\":\"$2\"}"
    curl --silent --insecure --data "$POST" https://api.github.com/repos/$OWNER/$REPO/statuses/$SHA?access_token=$USERNAME
}

finish() {
    git checkout $BRANCH
    git branch -D pr/$PR
    PATH=$OLD_PATH
    exit $1
}

update_github 1 "Build in progress..."

update_github 0 "Everything looks good"
finish 0
