FROM pytorch/pytorch:latest

RUN apt-get update -y \
    && apt install -y \
        unzip curl wget \
        libopenblas-base libomp-dev \
        build-essential cmake git \
        libgl1-mesa-dev libglib2.0-0 ffmpeg \
        libatlas-base-dev \
        libeigen3-dev \
        libgoogle-glog-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install --upgrade pip && \
    pip install \
        scipy numpy sklearn h5py tensorboardX \
        faiss-gpu jupyter jupyterlab

# Ceres
RUN \
    mkdir -p /opt/src && cd /opt/src && \
    wget http://ceres-solver.org/ceres-solver-1.14.0.tar.gz && \
    tar -xzvf ceres-solver-1.14.0.tar.gz && \
    cd /opt/src/ceres-solver-1.14.0 && \
    mkdir -p build && cd build && \
    cmake .. -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF && \
    make -j4 install && \
    cd / && rm -rf /opt/src/ceres-solver-1.14.0

# OpenVG
RUN \
    mkdir -p /opt/src && cd /opt/src && \
    git clone https://github.com/paulinus/opengv.git && \
    cd /opt/src/opengv && \
    git submodule update --init --recursive && \
    mkdir -p build && cd build && \
    cmake .. -DBUILD_TESTS=OFF \
             -DBUILD_PYTHON=ON \
             -DPYBIND11_PYTHON_VERSION=3.8 \
             -DPYTHON_INSTALL_DIR=/opt/conda/lib/python3.8/site-packages \
             && \
    make install && \
    cd / && rm -rf /opt/src/opengv

# TODO: Install OpenCV
# TODO: http://ceres-solver.org/ceres-solver-2.0.0.tar.gz
# TODO: https://github.com/mapillary/OpenSfM/archive/1e083558893d97c3344df653f03aff108d242f3b.zip

# OpenFSM
# RUN mkdir -p /opt/src && cd /opt/src && \
#     git clone --recursive https://github.com/mapillary/OpenSfM && \
#     cd OpenSfM && git submodule update --init --recursive && \
#     python setup.py build
