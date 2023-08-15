FROM archlinux
ENV IMG_PROFILE=profile
ENV IMG_USER=josh
ENV IMG_GROUP=users
RUN pacman -Syy 
RUN pacman -S --noconfirm archiso
RUN useradd -r -g $IMG_GROUP $IMG_USER
WORKDIR /wallaroo
CMD scripts/docker.mkimage
