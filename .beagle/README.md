# git

```bash
git remote add upstream git@github.com:grafana/grafana.git

git fetch upstream

git merge v7.3.6

git remote add beagle git@cloud.wodcloud.com:cloud/grafana.git

git fetch beagle

git push beagle master
```

## build

```bash
docker run -ti --rm \
-v /usr/local/share/.cache/yarn:/usr/local/share/.cache/yarn \
-v $PWD/:/go/src/github.com/grafana/grafana \
-w /go/src/github.com/grafana/grafana \
registry.cn-qingdao.aliyuncs.com/wod/devops-node:12.19.0-buster \
bash -c 'yarn install --pure-lockfile && npm rebuild node-sass && export NODE_ENV=production && yarn build'

docker run -it \
--rm \
-v /go/pkg/:/go/pkg/ \
-v $PWD/:/go/src/github.com/grafana/grafana \
-w /go/src/github.com/grafana/grafana \
-e GOPROXY=https://goproxy.cn \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.15.6-buster \
bash .beagle/build.sh
```

## cache

```bash
# dev
docker run \
--rm \
-v $PWD/:/go/src/github.com/grafana/grafana \
-v $PWD/bin/cache/:/cache \
-w /go/src/github.com/grafana/grafana \
-e PLUGIN_REBUILD=true \
-e PLUGIN_CHECK=yarn.lock \
-e PLUGIN_MOUNT=./node_modules \
-e DRONE_COMMIT_BRANCH=master \
-e CI_WORKSPACE=/go/src/github.com/grafana/grafana \
registry.cn-qingdao.aliyuncs.com/wod/devops-cache:1.0
```
