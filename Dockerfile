## The builder image
FROM ubuntu:22.04 AS builder

# Install dependencies for build
RUN apt-get update && \
    apt-get install -y \
    unzip \
    wget \ 
    xorg  \
    gcc  \
    libx11-dev  \
    libxt-dev  \
    libxext-dev  \
    make  \
    libmotif-dev  \
    libtirpc-dev 

# Defines environment variables required by SeisUnix
ENV CWPROOT=/usr/local/cwp
ENV PATH="$PATH:$CWPROOT/bin"

# Create the SeisUnix directory
RUN mkdir -p /usr/local/cwp
WORKDIR /usr/local/cwp

# Copy SeisUnix code to be built
COPY ./SeisUnix/ /usr/local/cwp

# Accepting SeisUnix license
RUN touch $CWPROOT/LICENSE_45R00_ACCEPTED && \
    touch $CWPROOT/LICENSE_43_ACCEPTED && \
    touch $CWPROOT/$MAILHOME_45R00

# Choosing right make file (Ubuntu 22.04) and bulding it
RUN cd $CWPROOT/src && \
    cp ./configs/Makefile.config_Linux_Ubuntu_22.04 ./Makefile.config && \
    make install && \
    make xtinstall

# We don't need this anymore.
RUN rm -rf $CWPROOT/src

## -----
# This is our actual image.
## -----
FROM ubuntu:22.04

## Installing XFCE and xRDP components.
## Reference: https://github.com/danielguerra69/ubuntu-xrdp/blob/master/Dockerfile
## Reference: https://github.com/danchitnis/container-xrdp/blob/master/ubuntu-xfce/Dockerfile
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && \
    apt-get install -y \
        xfce4 \
        xfce4-clipman-plugin \
        xfce4-cpugraph-plugin \
        xfce4-netload-plugin \
        xfce4-screenshooter \
        xfce4-taskmanager \
        xfce4-terminal \
        xfce4-xkb-plugin \ 
        vim \
        sudo \
        openssl \
        git \
        wget \
        xorgxrdp \
        xrdp && \
        apt remove -y light-locker xscreensaver && \
        apt autoremove -y && \
        rm -rf /var/cache/apt /var/lib/apt/lists

RUN mkdir /var/run/dbus && \
    cp /etc/X11/xrdp/xorg.conf /etc/X11 && \
    sed -i "s/console/anybody/g" /etc/X11/Xwrapper.config && \
    sed -i "s/xrdp\/xorg/xorg/g" /etc/xrdp/sesman.ini && \
    echo "xfce4-session" >> /etc/skel/.Xsession

# Copying data build image stage to our current image
COPY --from=builder /usr/local/cwp /usr/local/cwp
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu -p "$(openssl passwd -1 ubuntu)"
RUN chown -R ubuntu /usr/local/cwp
ENV CWPROOT=/usr/local/cwp
ENV PATH="$PATH:$CWPROOT/bin"

# Exporting environment variables to the ubuntu user
RUN echo export CWPROOT=/usr/local/cwp >> /home/ubuntu/.bashrc
RUN echo export PATH=$CWPROOT:$PATH >> /home/ubuntu/.bashrc

# Exposing port
EXPOSE 3389

# Creating a default volume
VOLUME /home/ubuntu/data

# Handling docker entrypoint
COPY ./docker-entrypoint.sh /root/docker-entrypoint.sh
RUN chmod +x /root/docker-entrypoint.sh
ENTRYPOINT ["/root/docker-entrypoint.sh"]
