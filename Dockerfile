FROM ubuntu:xenial
LABEL maintainer "Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>"

ARG dike_pkg=dikeIC-linux-x86_64.deb
ARG uid=1000
ARG user
ARG dike=/usr/bin/DikeIC

RUN apt-get update && apt-get -y install \
	python-nautilus \
	libnotify4  \
	libappindicator1 \
	usb-modeswitch \
	libpcsclite1 \
	pcscd \
	libgstreamer1.0-0 \
	libgstreamer-plugins-base1.0-0 \
	libgl1-mesa-glx \
	libice6 \
	libsm6 \
	libxslt1.1 \
	libnss3 \
	libldap-2.4.2 \
	libasound2 \
	sudo \
	udev \
	libxtst6 \
	usbutils \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

COPY $dike_pkg /tmp
RUN dpkg -i /tmp/$dike_pkg

RUN useradd --uid $uid --create-home --home-dir /home/$user $user \
	&& chown -R $user:$user /home/$user

USER $user
ENTRYPOINT [ $dike ]
