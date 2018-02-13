# Dike Docker images

If you are not running Ubuntu Xenial (16.04) on your machine there's good chances that the
debian package from Infocert won't work out of the box. And their packaging-fu
does not look that sharp. So better run the thing under a Docker container.

There are two different free (as in beer) version of Dike: the InfoCert generic one and the
InfoCamere branded one. Since I have a CNS from InfoCamere that's the default. There's
instruction for building both though.

## Status of the project

This repository is still a work in progress, the containers should build fine and you
should be able to run Dike from inside it. Still I haven't actually signed anything :)
Here's a rough todo:
- sort out if the usb mode switch should happen in the host or in the docker image
- add more udev rules for other devices

Any help appreciated!

## InfoCamere Dike

First of all you have to download the debian package for the infocamere Dike version:

```
wget https://www.firma.infocert.it/software/dikeIC-linux-x86_64.deb
```

Then you have to install the udev rules for your cns usb device on the host:

```
sudo cp 99-cns_udev.rules /etc/udev/rules.d/
sudo cp cns_usb_mode.sh /usr/local/bin
sudo chmod 755 /usr/local/bin/cns_usb_mode.sh
sudo udevadm control --reload-rules && sudo udevadm trigger
```

Then you have to build the docker image:

```
docker build -t dike:ic --build-arg user=$(whoami) .
```

Then connect the usb key and run the built docker image use this command:

```
docker run -ti --rm \
	-e DISPLAY=$DISPLAY \
	-v /dev/bus/usb:/dev/bus/usb \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	dike:ic
```

## Generic Dike

If you want to build the generic Dike image you have to download:

```
wget https://rinnovofirma.infocert.it/download/x86_64/latest
```

Then use this command to built the generic image:

```
docker build -t dike:generic \
	--build-arg dike=/opt/dike6/Dike \
	--build-arg dike_pkg=Dike6-installer-x86_64.deb \
	--build-arg user=$(whoami) .
```

Finally connect the usb key and run the generic Dike docker image:

```
docker run -ti --rm \
	-e DISPLAY=$DISPLAY \
	-v /dev/bus/usb:/dev/bus/usb \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	dike:generic
```
