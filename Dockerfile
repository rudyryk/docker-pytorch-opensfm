FROM pytorch/pytorch:latest

RUN apt-get update -y \
    && apt-get install -y \
        unzip curl wget \
        build-essential cmake git \
        libopenblas-base libomp-dev \
        libgl1-mesa-dev libglib2.0-0 ffmpeg \
        libatlas-base-dev libeigen3-dev \
        libgoogle-glog-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# Python pip dependencies
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir \
        scipy numpy sklearn h5py tensorboardX \
        faiss-gpu jupyter jupyterlab \
# Ceres
    # TODO: http://ceres-solver.org/ceres-solver-2.0.0.tar.gz
    && export CERES_VERSION=1.14.0 \
    && mkdir -p /opt/src && cd /opt/src \
    && wget http://ceres-solver.org/ceres-solver-${CERES_VERSION}.tar.gz --progress=bar:force:noscroll \
    && tar -xzvf ceres-solver-${CERES_VERSION}.tar.gz \
    && cd /opt/src/ceres-solver-${CERES_VERSION} \
    && mkdir -p ./build && cd ./build \
    && cmake .. -DCMAKE_C_FLAGS=-fPIC \
        -DCMAKE_CXX_FLAGS=-fPIC \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTING=OFF \
    && make -j$(nproc) install \
    && cd /opt/src && rm -rf ./ceres-solver-${CERES_VERSION} \
# OpenVG
    && mkdir -p /opt/src && cd /opt/src \
    && git clone --recurse-submodules https://github.com/paulinus/opengv.git \
    && cd ./opengv \
    && mkdir -p ./build && cd ./build \
    && cmake .. -DBUILD_TESTS=OFF \
        -DBUILD_PYTHON=ON \
        -DPYBIND11_PYTHON_VERSION=3.8 \
        -DPYTHON_INSTALL_DIR=/opt/conda/lib/python3.8/site-packages \
    && make install \
    && cd /opt/src && rm -rf ./opengv \
# OpenCV
    && export OPENCV_VERSION=3.4.13 \
    && mkdir -p /opt/src && cd /opt/src \
    && wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip --progress=bar:force:noscroll -O opencv.zip \
    && unzip -q opencv.zip \
    && mv ./opencv-${OPENCV_VERSION} ./opencv \
    && wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip --progress=bar:force:noscroll -O opencv_contrib.zip \
    && unzip -q opencv_contrib.zip \
    && mv ./opencv_contrib-${OPENCV_VERSION} ./opencv_contrib \
    && cd ./opencv \
    && mkdir ./build && cd ./build \
    && cmake .. \
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
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd /opt/src && rm -rf ./opencv* \
# OpenFSM
    && mkdir -p /opt/src && cd /opt/src \
    && git clone --recurse-submodules https://github.com/mapillary/OpenSfM \
    && cd ./OpenSfM && python setup.py build \
    && cd /opt/src && rm -rf ./OpenSfM
