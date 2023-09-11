FROM ubuntu:22.04

RUN apt update && apt install -y tzdata
ENV TZ="America/New_York"
RUN apt update && apt install -y git cmake build-essential wget unrar
WORKDIR /app

# XNNPACK
RUN git clone https://github.com/google/XNNPACK.git
# Find commit with
# cd XNNPACK && git rev-list -n 1 --before="2023-06-27 00:00" master
RUN cd XNNPACK && git checkout 1f2ea6aab6c3d9fa4a95e93fc4a1a5ca83beba2b && mkdir build
RUN cd XNNPACK && cd build && cmake -DXNNPACK_BUILD_TESTS=OFF -DXNNPACK_BUILD_BENCHMARKS=OFF ..
RUN cd XNNPACK && cd build && cmake --build . -j --config Release

# OnnxStream
RUN git clone https://github.com/vitoplantamura/OnnxStream.git
RUN cd OnnxStream && cd src && mkdir build && cd build && cmake -DMAX_SPEED=ON -DXNNPACK_DIR=/app/XNNPACK ..
RUN cd OnnxStream/src/build && cmake --build . --config Release
ENV PATH="${PATH}:/app/OnnxStream/src/build/"

# Download weights
RUN mkdir /weights/
RUN cd /weights/ && wget https://github.com/vitoplantamura/OnnxStream/releases/download/v0.1/StableDiffusion-OnnxStream-Windows-x64-with-weights.rar
RUN cd /weights && unrar x -y StableDiffusion-OnnxStream-Windows-x64-with-weights.rar
