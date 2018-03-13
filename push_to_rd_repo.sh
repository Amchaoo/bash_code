#!/bin/bash
set -e

FE_DIST="/Users/anchao01/code/dest/prod/"  # 前端文件打包地址, 默认dirname ${0} 为前端项目根目录
RD_DIST="/Users/anchao01/code/src/main/resources/static/"  #要拷贝到的地址
NEED_RM_DIRS=("/Users/anchao01/code/src/main/resources/static/dist/") #需要在拷贝前删除的, 传入一个数组

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
    for dir in ${NEED_RM_DIRS[@]}
    do
        rm -rf ${dir}
    done
    echo "cleaned"
}

cloneSource() {
    cp -R "$FE_DIST" "$RD_DIST"
    echo "copy end"
}

checkBranch() {
    echo -n "type the branch you want checkout >"
    read branch
    git checkout "$branch">/dev/null
}

gitPush() {
    clearRdRepoDist
    cloneSource
    git add .
    git commit -m "$COMMIT_MSG"
    git push
}

pushSource() {
    cd "$RD_DIST"
    git pull
    branch=$(git status | grep "On branch" | awk '{print $3}')
    echo -n "you are in branch $branch, are you sure continue? (y/n)>"
    read result
    if [ "$result" = "y" ]
    then
        gitPush
    else
        until checkBranch; do
            echo -n 'error, please try again!'
            echo
        done
        gitPush
    fi
    echo "push to origin repo success"
}

feBuild
pushSource