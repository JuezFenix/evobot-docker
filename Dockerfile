FROM node:14.15.5-slim

ENV USER=evobot
ENV VERSION=0.10.0

# install python and make
RUN apt-get update && \
        apt-get install -y python3 build-essential git && \
        apt-get purge -y --auto-remove

# install requisites
RUN npm install i18n --save && npm install i18n-js

# create evobot user
RUN groupadd -r ${USER} && \
        useradd --create-home --home /home/evobot -r -g ${USER} ${USER}

# Clone evobot repo
RUN git clone https://github.com/eritislami/evobot.git /home/evobot/evobot && chown -R evobot /home/evobot/evobot

# set up volume and user
USER ${USER}
WORKDIR /home/evobot/evobot

RUN cd /home/evobot/evobot && npm install
VOLUME [ "/home/evobot/evobot" ]

ENTRYPOINT [ "node", "index.js" ]
