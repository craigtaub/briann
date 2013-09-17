#Paramaterized build
SHA=f91e004aa0943aff6657c52537f9da1858901b33
#give commit ID
#PR=

# Workspace parameters
OLD_PATH=$PATH
PATH=$WORKSPACE/git-ci/bin:$PATH

# Github parameters
OWNER=craigtaub
REPO=briann
BRANCH=master
USERNAME=craighub
PASSWORD=

update_github() {
#echo "https://api.github.com/repos/$OWNER/$REPO/statuses/$SHA?access_token=$USERNAME"
    set -e
    if [ $1 -eq 0 ]; then
       STATUS="success"
    elif [ $1 -eq 1 ]; then
       STATUS="pending"
    else
       STATUS="failure"
    fi

BUILD_URL="http://craigtaub.dyndns.org:8181/job/project-build/"
#need add build num
   POST="{\"state\":\"${STATUS}\",\"target_url\":\"$BUILD_URL\",\"description\":\"$2\"}"
    curl --basic -u craigtaub:Chloeytb01 --silent --insecure --data "$POST" https://api.github.com/repos/$OWNER/$REPO/statuses/$SHA?access_token=$USERNAME
#Post status for commit
}

finish() {
    git checkout $BRANCH
    git branch -D pr/$PR
    PATH=$OLD_PATH
    exit $1
}

update_github 1 "Build in progress..."

update_github 0 "Everything looks good..tra"
finish 0
