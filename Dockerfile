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

# OpenCV
ARG OPENCV_VERSION=3.4.13
RUN \
    mkdir -p /opt/src && cd /opt/src && \
    wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip -O opencv.zip && \
    unzip -q opencv.zip && rm opencv.zip && \
    mv ./opencv-${OPENCV_VERSION} ./opencv && \
    wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip -O opencv_contrib.zip && \
    unzip -q opencv_contrib.zip && rm opencv_contrib.zip && \
    mv ./opencv_contrib-${OPENCV_VERSION} ./opencv_contrib && \
    cd ./opencv && \
    mkdir ./build && cd ./build && \
    cmake \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D BUILD_PYTHON_SUPPORT=ON \
        -D BUILD_DOCS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_TESTS=OFF \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D OPENCV_EXTRA_MODULES_PATH=/opt/src/opencv_contrib/modules \
        -D BUILD_opencv_python3=ON \
        -D BUILD_opencv_python2=OFF \
        -D PYTHON_DEFAULT_EXECUTABLE=$(which python) \
        -D BUILD_EXAMPLES=OFF \
        -D WITH_IPP=OFF \
        -D WITH_FFMPEG=ON \
        -D ENABLE_PRECOMPILED_HEADERS=OFF \
        .. \
    && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# TODO: http://ceres-solver.org/ceres-solver-2.0.0.tar.gz
# TODO: https://github.com/mapillary/OpenSfM/archive/1e083558893d97c3344df653f03aff108d242f3b.zip

# OpenFSM
RUN mkdir -p /opt/src && cd /opt/src && \
    git clone --recurse-submodules https://github.com/mapillary/OpenSfM && \
    python setup.py build
