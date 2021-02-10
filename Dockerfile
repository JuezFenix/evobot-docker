FROM node:14.15.5-slim

ENV USER=evobot

# install python and make
RUN apt-get update && \
        apt-get install -y python3 build-essential git && \
        apt-get purge -y --auto-remove

# create evobot user
RUN groupadd -r ${USER} && \
        useradd --create-home --home /home/evobot -r -g ${USER} ${USER}

# set up volume and user
USER ${USER}
WORKDIR /home/evobot

RUN git clone https://github.com/eritislami/evobot.git /home/evobot
RUN npm install
VOLUME [ "/home/evobot" ]
VOLUME [ "/home/evobot/config.json" ]

COPY . .

ENTRYPOINT [ "node", "index.js" ]
