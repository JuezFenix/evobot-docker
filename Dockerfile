FROM node:14.15.5-slim

ENV USER=evobot
ENV EVOBOT_VERSION=0.10.0
ENV PLEXDRIVE_VERSION=5.1.0
ENV NODE_ID=root

# install python and make
RUN apt-get update && \
        apt-get install -y python3 build-essential git wget fuse unzip && \
        apt-get purge -y --auto-remove

# install requisites
RUN npm install i18n --save && npm install i18n-js ytdl-core-discord

# Clone evobot repo
#RUN git clone https://github.com/eritislami/evobot.git /home/evobot
RUN wget https://github.com/eritislami/evobot/archive/${EVOBOT_VERSION}.zip && \
        unzip ${EVOBOT_VERSION}.zip /home && mv /home/evobot-${EVOBOT_VERSION} /home/evobot

# create evobot user
RUN groupadd -r ${USER} && \
        useradd --home /home/evobot -r -g ${USER} ${USER} && chown -R evobot /home/evobot

# Prepare plexdrive
RUN mkdir /home/evobot/music /config /config/plexdrive
RUN wget https://github.com/plexdrive/plexdrive/releases/download/${PLEXDRIVE_VERSION}/plexdrive-linux-amd64 -O /usr/local/bin/plexdrive && chmod 755 /usr/local/bin/plexdrive

# set up volume and user
USER ${USER}
WORKDIR /home/evobot

RUN cd /home/evobot && npm install
VOLUME [ "/config/plexdrive" ]
VOLUME [ "/home/evobot/clips" ]

ENTRYPOINT [ "node", "index.js" ]
