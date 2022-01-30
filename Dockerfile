# our base image
FROM ubuntu:latest

# Set timezone
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install packages
RUN apt-get update
RUN apt-get install git python3 -y
RUN apt-get install openjdk-17-jre-headless -y

# Write dummy git config
RUN git config --global user.email "mail@example.com"
RUN git config --global user.name "John Doe"

#HERE

# copy files required for the app to run
COPY app /app/
COPY config.ini /app/
RUN mkdir /app/build
RUN chmod +x /app/build.sh

# tell the port number the container should expose
# EXPOSE 80

# run the application
CMD ["bash", "/app/build.sh"]

#CMD ["/app/build.sh"]

# to get the compiled files do:
# docker cp <containerId>:/app/build/ /host/target_path/%     