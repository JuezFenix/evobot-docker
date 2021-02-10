FROM node:14.15.5-slim

ENV USER=evobot
ENV VERSION=0.10.0

# install python and make
RUN apt-get update && \
        apt-get install -y python3 build-essential git && \
        apt-get purge -y --auto-remove

# install requisites
RUN npm install i18n --save && npm install i18n-js ytdl-core-discord

# Clone evobot repo
RUN git clone https://github.com/eritislami/evobot.git /home/evobot 

# create evobot user
RUN groupadd -r ${USER} && \
        useradd --home /home/evobot -r -g ${USER} ${USER} && chown -R evobot /home/evobot



# set up volume and user
USER ${USER}
WORKDIR /home/evobot

RUN cd /home/evobot && npm install
VOLUME [ "/home/evobot" ]

ENTRYPOINT [ "node", "index.js" ]
