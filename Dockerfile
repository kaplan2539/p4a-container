FROM ubuntu:jammy-20240911.1

RUN apt -y update -qq > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt install -qq --yes --no-install-recommends \
    locales && \
    locale-gen en_US.UTF-8

ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

RUN apt -y update -qq > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt install -qq --yes --no-install-recommends \
        ca-certificates \
        curl \
        ant \
        autoconf \
        automake \
        ccache \
        cmake \
        g++ \
        gcc \
        git \
        lbzip2 \
        libffi-dev \
        libltdl-dev \
        libtool \
        libssl-dev \
        make \
        openjdk-17-jdk \
        patch \
        pkg-config \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        sudo \
        unzip \
        vim \
        wget \
        zip \
    && apt -y autoremove \
    && apt -y clean \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install \
    python-for-android \
    Cython

ENV ANDROID_HOME="/opt/android" \
    ANDROIDSDK="/opt/android/android-sdk" \
    ANDROIDNDK="/opt/android/android-ndk"\
    ANDROIDAPI="30" \
    NDKAPI="21" \ 
    JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"

ADD android.mk /tmp/android.mk 
RUN mkdir /opt/android \
 && make --file /tmp/android.mk 

RUN sed -i -e '/# Allow members/ d; /%sudo.*/ d; /@include.*/ d' /etc/sudoers \
 && echo '%sudo   ALL=(ALL:ALL) NOPASSWD:ALL' >>/etc/sudoers
