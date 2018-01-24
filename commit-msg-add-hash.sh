#!/bin/sh
# 适用: 部署仓库和前端开发仓库不在一起, 每次打包部署, 尤其是bug fix阶段,
# 在提交仓库里加上前端commit hash便于追踪记录 
# commit-msg hook, 加载部署仓库里

FE_REPO #需要配置下前端仓库地址
HASH="/Users/anchao01/code/fe_repo"

gen_hash() {
    cd ${FE_REPO}
	HASH=$(git log | grep commit | head -1 | awk '{print $2}')
	cd - >/dev/null
}

add_fe_repo_hash() {
	SUFFIX="\nhash: $HASH"
    echo $(cat $1) ${SUFFIX} > $1
}

add_fe_repo_hash