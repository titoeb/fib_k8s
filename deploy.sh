# This script builds all docker images, pushes them to docker hub and applies the k8s configuration

# Build all images.
docker build -t titoeb/multi-client:latest -t titoeb/multi-client:${GIT_SHA} -f ./client/Dockerfile ./client
docker build -t titoeb/multi-server:latest -t titoeb/multi-server:${GIT_SHA} -f ./server/Dockerfile ./server
docker build -t titoeb/multi-worker:latest -t titoeb/multi-worker:${GIT_SHA} -f ./worker/Dockerfile ./worker

# Push images to docker hub.
docker push titoeb/multi-client:LATEST
docker push titoeb/multi-server:LATEST
docker push titoeb/multi-worker:LATEST
docker push titoeb/multi-client:${GIT_SHA}
docker push titoeb/multi-server:${GIT_SHA}
docker push titoeb/multi-worker:${GIT_SHA}

# Apply all configs
kubectl apply -f k8s

# Force last image for k8s
kubectl set image deployments/client-deployment client=titoeb/multi-client:${GIT_SHA}
kubectl set image deployments/server-deployment server=titoeb/multi-server:${GIT_SHA}
kubectl set image deployments/worker-deployment worker=titoeb/multi-worker:${GIT_SHA}