FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
apt-get install --no-install-recommends -y bash git ca-certificates locales

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

COPY . dotfiles/
RUN cd dotfiles && ./packages.sh
RUN cd dotfiles && ./install.zsh