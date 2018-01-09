#!/bin/bash

RD_REPO="RD_REPO"     # 本地的目的仓库地址
RELATIVE_DIST="./uL"  # 相对working directory的代码地址

if [ -z "$1" ]
then
    COMMIT_MSG="fix bug"
else
    COMMIT_MSG="$1"
fi

feBuild() {
    echo "fe build start"
    matriks2 dest
    echo "fe build end"
}

clearRdRepoDist() {
    echo "cleaning rd repo..."
    rm -rf "$RD_REPO"
    echo "cleaned"
}

cloneSource() {
    cp -R "$RELATIVE_DIST" "$RD_REPO"
    echo "copy end"
}

checkBranch() {
    echo -n "type the branch you want checkout >"
    read branch
    git checkout "$branch">/dev/null
}

pushSource() {
    cd "$RD_REPO"
    git pull
    branch=$(git status | grep "On branch" | awk '{print $3}')
    echo -n "you are in branch $branch, are you sure continue? (y/n)>"
    read result
    if [ "$result" = "y" ]
    then 
        echo 'y'
        git add .
        git commit -m "$COMMIT_MSG"
        git push
    else
        until checkBranch; do
            echo -n 'error, please try again!'
            echo
        done
        git add .
        git commit -m "$COMMIT_MSG"
        git push
    fi
    echo "push to origin repo success"
}

feBuild
clearRdRepoDist
cloneSource
pushSource
