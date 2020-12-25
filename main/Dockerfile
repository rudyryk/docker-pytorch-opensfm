FROM rudyryk/pytorch-opensfm:base

RUN apt-get update \
    && apt-get install -y \
        colmap \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && pip install --no-cache-dir git+https://github.com/mihaidusmanu/pycolmap \
    && pip install --no-cache-dir opencv-python
