docker build . -t NirmalMilroy/node-web-app

docker run --name=node-web-app -p 49160:8080 -d NirmalMilroy/node-web-app