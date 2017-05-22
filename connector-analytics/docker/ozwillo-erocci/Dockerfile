FROM jeanparpaillon/erlang-mini
MAINTAINER Marc Dutoo, Smile

ENV DEBIAN_FRONTEND noninteractive

ADD sys.config /tmp/sys.config
ADD run.sh /root/run.sh
COPY erocci /

RUN apt-get update
RUN apt-get -y install --no-install-recommends git \
    build-essential ca-certificates && \
    apt-get -y clean
#RUN git clone https://github.com/erocci/erocci.git && \
#    cd erocci && make FRONTENT=1

CMD [ "/root/run.sh" ]

EXPOSE 80

