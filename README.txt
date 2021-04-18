This is a demo for Trifork. The demo implements a client-server grpc service example (Hello, from https://grpc.io/docs/languages/python/quickstart/).
Both, the server and client run over Docker containers. 

The demo has been built on the triforkdemo direcory, which was created on /usr/src/. The file tree is then:
/usr/src/triforkdemo/
		    - Dockerfile
		    - app/
			  greeter_client.py
		          helloworld_pb2_grpc.py
		          greeter_server.py
		          helloworld_pb2.py

Below is detailed the process of the demo:

1. Download the example by cloning the repository:
	git clone -b v1.35.0 https://github.com/grpc/grpc

2. Copy the necessary files from grpc/examples/python/helloworld into /usr/src/triforkdemo/app

3. Create a Dockerfile to build an image for the server container. Here, an ubuntu-based imaged will be used, some dependencies installed and, exposing the port for the server to listen the requests.

4. Loging to any image registry. Here, Docker Hub is used.

5. Build the Docker images for the server and client containers:
	docker build . -t <username>/triforkdemo:v1

6. Push the created image to the registry:
	docker push <username>/triforkdemo:v1

7. Check the images:
	docker images

##IF THE SERVICE RUNS ON CONTAINERS ONLY##

8. Run one container for the server and another one one for the client, from the images previously created:
        docker run -d --name triforkserver -ti trifork-demo-server
        docker run -d --name triforkclient -ti trifork-demo-client

9. Create a network for the containers to communicate:
	docker network create trifork-demonet
	docker network connect trifork-demonet <server_container_id> --alias server
	docker network connect trifork-demonet <client_container_id> --alias client

10. Execute the server and client scripts on the containers (server first, otherwise there will be no port listening):
	docker exec -it <server_container_id> python3 app/greeter_server.py
        docker exec -it <client_container_id> python3 app/greeter_client.py

##TO DEPLOY THE GRPC SERVICE INTO KUBERNETES##

11. Configure a yaml file, declaring the deployment and the service.

12. Create the both the deployment and the service from the .yaml file:
	kubectl create -f deploymentdemo.yaml

13. Check the port-forwarding for the server to listen in the desired port (50051)
	kubectl port-forward deployment.apps/triforkdemo-deployment 50051:30051

14. Run the client(s). Be sure the client is requesting the right server.
	python3 app/greeter_client.py

##MONITORING WITH PROMETHEUS GRAFANA##
15. Install helm. It will manage the Kubernetes cluster charts, alongside Tiller. The helm directory contains the configuration files to create and apply the Kubernetes resources for Tiller.

16. Deploy Prometheus with helm:
	 helm install prometheus stable/prometheus

17. Set up a configuration file for Grafana (monitoring/grafana/config.yml) and apply:
	 kubectl apply -f grafana/config.yml

18. Configuring the port-forwarding to access Prometheus and Grafana from the web browser. Prometheus server uses port 9090, while Grafana uses port 3000:
	kubectl port-forward prometheus-server-7bc886d65-nhr22 9090
	kubectl port-forward grafana-5cf78bb5dc-p8st9 3000

19. Access to Grafana, connect the Prometheus datasource and import the Dashboard ID 1860.
