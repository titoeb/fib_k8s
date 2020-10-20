# This script builds all docker images, pushes them to docker hub and applies the k8s configuration

# Build all images.
echo "Starting building images."
docker build -t titoeb/multi-client:latest -t titoeb/multi-client:${GIT_SHA} -f ./client/Dockerfile ./client
echo "Build multi-client complete."

docker build -t titoeb/multi-server:latest -t titoeb/multi-server:${GIT_SHA} -f ./server/Dockerfile ./server
echo "Build multi-server complete."

docker build -t titoeb/multi-worker:latest -t titoeb/multi-worker:${GIT_SHA} -f ./worker/Dockerfile ./worker
echo "Build multi-worker complete."

echo "All builds completed."

# Push images to docker hub.
echo "Starting pushing images."
docker push titoeb/multi-client:LATEST
docker push titoeb/multi-server:LATEST
docker push titoeb/multi-worker:LATEST
docker push titoeb/multi-client:${GIT_SHA}
docker push titoeb/multi-server:${GIT_SHA}
docker push titoeb/multi-worker:${GIT_SHA}
echo "Pushed all images."

# Apply all configs
echo "Applying all configs in k8s."
kubectl apply -f k8s
echo "Applied all configs in k8s."

# Force last image for k8s
echo "Change the images in k8s."
kubectl set image deployments/client-deployment client=titoeb/multi-client:${GIT_SHA}
kubectl set image deployments/server-deployment server=titoeb/multi-server:${GIT_SHA}
kubectl set image deployments/worker-deployment worker=titoeb/multi-worker:${GIT_SHA}
echo "Changed the images in k8s."