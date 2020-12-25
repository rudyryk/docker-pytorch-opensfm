FROM rudyryk/pytorch-opensfm:base

RUN apt-get update \
    && apt-get install -y \
        #software-properties-common \
        colmap \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
