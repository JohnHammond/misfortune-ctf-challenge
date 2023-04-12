FROM ubuntu:18.04

RUN apt-get update -y \
    && apt-get install -y xinetd gcc build-essential \
    && apt-get clean -y

# Create challenge user
RUN useradd -u 1000 -d /home/challenge -s /bin/bash challenge
RUN mkdir /home/challenge

# Poor man's pipe to docker logs
RUN ln -sf /proc/1/fd/1 /var/log/challenge.log

# Copy xinetd and other dependencies
COPY deps/challenge.xinetd /etc/xinetd.d/challenge
COPY deps/entrypoint.sh /entrypoint.sh

RUN chmod 551 entrypoint.sh

# Set up chroot
RUN mkdir /home/challenge/usr
RUN cp -R /lib* /home/challenge && \
    cp -R /usr/lib* /home/challenge/usr

RUN mkdir /home/challenge/dev && \
    mknod /home/challenge/dev/null c 1 3 && \
    mknod /home/challenge/dev/zero c 1 5 && \
    mknod /home/challenge/dev/random c 1 8 && \
    mknod /home/challenge/dev/urandom c 1 9 && \
    chmod 666 /home/challenge/dev/*

RUN mkdir /home/challenge/bin && \
    mkdir /home/challenge/etc && \
    mkdir /home/challenge/src && \
    cp /bin/* /home/challenge/bin && \
    cp /usr/bin/id /home/challenge/bin/id && \
    cp /usr/bin/whoami /home/challenge/bin/whoami && \
    cp /etc/shadow /home/challenge/etc && \
    cp /etc/passwd /home/challenge/etc && \
    rm /home/challenge/bin/rm

# Set up challenge and flag
WORKDIR /home/challenge

COPY src/main.c /home/challenge/src
COPY Makefile /home/challenge
RUN make

RUN chmod 111 misfortune

RUN chown -R root:root /home/challenge

CMD ["/entrypoint.sh"]

EXPOSE 9999
