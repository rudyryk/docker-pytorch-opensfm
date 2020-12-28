FROM rudyryk/pytorch-opensfm:base

RUN \
    mkdir -p /opt/src && cd /opt/src \
    && git clone --recurse-submodules https://github.com/mapillary/OpenSfM \
    && cd ./OpenSfM && python setup.py install \
    && mv ./bin/clean ./bin/openfsm_clean \
    && mv ./bin/* /opt/conda/bin \
    && cd /opt/src && rm -rf ./OpenSfM

RUN apt-get update \
    && apt-get install -y \
        colmap \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && pip install --no-cache-dir opencv-python

# TODO: figure out (probably) how to add `pycolmap`
# && pip install --no-cache-dir git+https://github.com/mihaidusmanu/pycolmap
