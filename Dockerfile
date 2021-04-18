FROM ubuntu:bionic
RUN apt-get update
RUN apt-get install python3 -y
RUN apt-get install python3-pip -y
RUN pip3 install --upgrade pip
RUN pip install --upgrade google-api-python-client
RUN pip install google-cloud
RUN pip install google-cloud-vision
RUN pip3 install grpcio

WORKDIR /usr/src/triforkdemo

COPY . .

#For the server:
CMD ["app/greeter_server.py"]
EXPOSE 50051

ENTRYPOINT ["python3"]
