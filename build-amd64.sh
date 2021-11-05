NAMESPACE=$1
TAG=$2

set -e

cd ./Base && docker buildx build --platform linux/amd64 -t $NAMESPACE/selenium-base:$TAG . --push

cd ../Hub && sh generate.sh $TAG $NAMESPACE studocu \
   && docker buildx build --platform linux/amd64 -t $NAMESPACE/selenium-hub:$TAG . --push

cd ../NodeBase && sh generate.sh $TAG $NAMESPACE studocu \
   && docker buildx build --platform linux/amd64 -t $NAMESPACE/selenium-node-base:$TAG . --push

# && sed 's/chromium=.*/chromium=91.0.4472.124/' Dockerfile > Dockerfile \
cd ../NodeChromium && sh generate.sh $TAG $NAMESPACE studocu \
   && docker buildx build --platform linux/amd64 -t $NAMESPACE/selenium-node-chromium:$TAG . --push

cd ../Standalone && sh generate.sh StandaloneChromium selenium-node-chromium $TAG $NAMESPACE studocu \
   && cd ../StandaloneChromium \
   && docker buildx build --platform linux/amd64 -t $NAMESPACE/selenium-chrome:$TAG . --push