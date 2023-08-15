FROM archlinux:latest
LABEL Name=installer Version=0.0.1
RUN mkdir /installer
WORKDIR /installer
COPY ./target/debug/installer .
CMD [ "./installer" ]