FROM raspbian/jessie

ENV SRC_DIR /src
ENV TARGET_DIR /target
ENV BIN_DIR /out_bin
ENV PATH $BIN_DIR:$PATH
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p $SRC_DIR $TARGET_DIR $BIN_DIR

RUN apt-get update
RUN apt-get install -yq --force-yes wget git-core libtool \
    autoconf cmake mercurial build-essential pkg-config \
    libgtk2.0-dev

WORKDIR $SRC_DIR

RUN git clone --depth 1 --branch 3.4 https://github.com/opencv/opencv.git
RUN git clone --depth 1 --branch 3.4 https://github.com/opencv/opencv_contrib.git

RUN (cd opencv && \
    mkdir build && \
    cd build && \
    cmake \
          -D ENABLE_NEON=ON \
          -D ENABLE_VFPV3=ON \
          -D BUILD_SHARED_LIBS=OFF \
          -D BUILD_PERF_TESTS=OFF \
          -D BUILD_DOCS=OFF \
          -D BUILD_TESTS=OFF \
          -D BUILD_EXAMPLES=OFF \
          -D INSTALL_PYTHON_EXAMPLES=OFF \
          -D INSTALL_C_EXAMPLES=OFF \
          -D OPENCV_EXTRA_MODULES_PATH=/src/opencv_contrib/modules \
          -D CMAKE_BUILD_TYPE=Release \
          -D BUILD_NEW_PYTHON_SUPPORT=ON \
          -D WITH_OPENCL=OFF \
          -D WITH_V4L=ON \
          -D CMAKE_INSTALL_PREFIX="$TARGET_DIR" \
          ..)

RUN (cd /src/opencv/build && \
    make -j4 && \
    make install)
