# raspberry-emulator
Provides a full raspbian stretch lite system in a docker container, emulated by qemu-system-arm. 

This way you don't have to deal with qemu sw setup, parameters, kernel options, image mounts...

Just start the container and enjoy your pi for example for testing purposes when you need the full running system and a simple raspbian docker container is not enough.

VNC to the emulated system can be accessed on port 5900 of the container and ssh to the emulated system on port 22

docker run -v ${PWD}/data:/data -p 5900:5900 -p 1022:22 jsurf/raspberry-emulator

Extracts an raspian stretch image to the /data volume. 
If volume is persisted between starts, the existing image will be reused
