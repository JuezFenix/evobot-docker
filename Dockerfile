FROM node:14.15.5-slim

ENV USER=evobot
ENV VERSION=0.10.0
ENV NODE_ID=root

# install python and make
RUN apt-get update && \
        apt-get install -y python3 build-essential git wget fuse && \
        apt-get purge -y --auto-remove

# install requisites
RUN npm install i18n --save && npm install i18n-js ytdl-core-discord

# Clone evobot repo
RUN git clone https://github.com/eritislami/evobot.git /home/evobot 

# create evobot user
RUN groupadd -r ${USER} && \
        useradd --home /home/evobot -r -g ${USER} ${USER} && chown -R evobot /home/evobot

# Prepare plexdrive
RUN mkdir /home/evobot/music && mkdir /config/plexdrive
RUN wget https://github.com/plexdrive/plexdrive/releases/latest/plexdrive-linux-amd64 -o /usr/local/bin/plexdrive && chmod 755 /usr/local/bin/plexdrive

# set up volume and user
USER ${USER}
WORKDIR /home/evobot

RUN cd /home/evobot && npm install
VOLUME [ "/config/plexdrive" ]
VOLUME [ "/home/evobot" ]
VOLUME [ "/home/evobot/clips" ]

ENTRYPOINT [ "node", "index.js" ]
