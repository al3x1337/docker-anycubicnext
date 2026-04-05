# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG ANYCUBIC_SLICER_VERSION
LABEL build_version="al3x1337 version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="al3x1337"

# title
ENV TITLE=AnycubicSlicer \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/bambustudio-logo.png && \
  echo "**** install packages ****" && \
  add-apt-repository ppa:xtradeb/apps && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    firefox \
    fonts-dejavu \
    fonts-dejavu-extra \
    gir1.2-gst-plugins-bad-1.0 \
    gir1.2-gstreamer-1.0 \
    gstreamer1.0-nice \
    gstreamer1.0-plugins-* \
    gstreamer1.0-pulseaudio \
    libosmesa6 \
    libwebkit2gtk-4.1-0 \
    libwx-perl \
    x11-utils && \
  echo "**** install anycubic slicer next ****" && \
  echo "deb [trusted=yes] https://cdn-universe-slicer.anycubic.com/prod noble main" | tee /etc/apt/sources.list.d/acnext.list && \
  apt-get update && \
  apt-get install -y anycubicslicernext && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /usr/share/dbus-1/system-services/org.freedesktop.hostname1.service \
    /config/.cache \
    /config/.launchpadlib \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /
RUN \
  find /defaults -type f -exec sed -i 's/\r$//' {} + && \
  chmod +x /defaults/autostart*

# ports and volumes
EXPOSE 3001
VOLUME /config
