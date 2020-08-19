ARG BUILD_FROM=hassioaddons/base-armv7:8.0.1
FROM $BUILD_FROM

ENV LANG C.UTF-8
MAINTAINER TomorrowTech

LABEL Description="Read thermal image data from MQTT client"
# Copy data for add-on 
RUN mkdir -p home-assistant
WORKDIR /home-assistant
COPY app .
COPY run.sh .

# Install requirements for add-on
# RUN apk add --no-cache python3  mosquitto-clients jq 
RUN apk add --no-cache nodejs nodejs-npm \
   && npm set unsafe-perm true \
   && npm i npm@latest -g 

RUN cd ui && npm install --unsafe-perm && npm run build && cd ..
RUN cd api && npm install --unsafe-perm && cd ..

# Use this variable when creating a container to specify the MQTT  
ENV MQTT_HOST="hassio.local"
ENV MQTT_USER="user1"
ENV MQTT_PASS="user1"
ENV MQTT_TOPIC1="home-assistant/sensor/temp1"
ENV MQTT_TOPIC2="home-assistant/sensor/info"
ENV MQTT_TOPIC3="home-assistant/image"

# Python 3 HTTP Server serves the current working dir
# So let's set it to our add-on persistent data directory.
RUN chmod a+x ./run.sh

CMD [ "./run.sh" ]