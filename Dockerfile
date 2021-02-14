# our base image
FROM alpine:3.5

# Install python and pip
RUN apk add --update python3 git

# update from repo
RUN git pull --rebase

# copy files required for the app to run
COPY app /usr/src/app/
COPY config.ini /usr/src/app/

# tell the port number the container should expose
#EXPOSE 5000

# run the application
CMD ["bash", "/usr/src/app/build.sh"]
