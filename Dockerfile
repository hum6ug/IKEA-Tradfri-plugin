FROM debian:latest

RUN apt-get update -y && \
  apt-get install -y python3 python3-pip git autoconf automake libtool && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* build/

RUN mkdir -p /usr/src/app /usr/src/build
WORKDIR /usr/src/build

RUN python3 -m pip install cython
RUN python3 -m pip install ipython

RUN git clone https://github.com/ggravlingen/pytradfri.git
WORKDIR /usr/src/build/pytradfri
# RUN git checkout tags/2.2.3
WORKDIR /usr/src/build/pytradfri/script
# RUN chmod +x install-aiocoap.sh
# RUN ./install-aiocoap.sh
RUN ./install-coap-client.sh

WORKDIR /usr/src/build/pytradfri
RUN python3 setup.py install

RUN pip3 install twisted

WORKDIR /usr/src/app
COPY tradfri.tac /usr/src/app

EXPOSE 1234
CMD python3 tradfri.tac
