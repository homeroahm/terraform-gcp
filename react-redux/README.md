Dockerizing  a RealWorld app


#Clone the React-Redux app codebase

git clone https://github.com/homeroahm/terraform-gcp.git 

cd ~/terraform-gcp/react-redux

#Dockerfile is already created in the root folder of the app

cat << EOF>> Dockerfile
FROM node:16
WORKDIR /usr/src/app
COPY . /usr/src/app/
RUN npm install
RUN ls /usr/src/app
RUN ls /usr/src/app/public
EXPOSE 3000
CMD npm start
EOF


#Build and tag the Docker image:

docker build -t react-redux .


#Execute the following command to create a container from the react-redux image, which your application will run in:

docker run -d -p 8092:4100   --name react-redux-app react-redux


#If docker run is successful, open your browser and access your API or application. You should be able to access it at 127.0.0.1:8092. If you can see the *conduit homepage*, then your container is up and running.



=======================================================

Deploying and running on on LOCAL Kubernetes (Minikube)


# you can use my dockerhub repo : homeroahm/react-redux:v1   or  create your own.

docker tag react-redux <you dockerhub repo>/react-redux:v1

docker push <you dockerhub repo>/react-redux:v1


Minikube start

minikube kubectl -- create deployment react-redux --image=homeroahm/react-redux:v1

minikube kubectl -- get deployment -o wide

minikube kubectl -- expose deploy react-redux --type=LoadBalancer --port=4100

minikube kubectl -- get services -o wide

minikube service react-redux

=======================================================

Minikube service react-redux  will display the Conduit app in the Browser

