FROM ubuntu:artful AS sphinx_builder

WORKDIR /app/sphinx

RUN apt-get update && \
    apt-get install -y \
      make \
      g++ \
      git \
      bison \
      autoconf \
      libtool \
      automake \
      python3-dev \
      swig && \
# INSTALL SPHINX BASE
    git clone https://github.com/cmusphinx/sphinxbase.git && \
    cd sphinxbase && \
    git checkout a74a11df3a021e9a26b0d20c3de999b8eb0afcef && \
    ./autogen.sh --prefix=/app/sphinx/sphinxbase/install && \
    make && \
    make install && \
    cd .. && \
# INSTALL POCKETSPHINX
    git clone https://github.com/cmusphinx/pocketsphinx.git && \
    cd pocketsphinx && \
    git checkout c178c8dc1948685ed93c6c4ee93122a7bc789cfd && \
    ./autogen.sh --prefix=/app/sphinx/pocketsphinx/install && \
    make && \
    make install


FROM ubuntu:artful

WORKDIR /app

COPY --from=sphinx_builder /app/sphinx/sphinxbase/install/ /app/sphinx/sphinxbase/
COPY --from=sphinx_builder /app/sphinx/pocketsphinx/install/ /app/sphinx/pocketsphinx/

ENV LD_LIBRARY_PATH /app/sphinx/sphinxbase/lib:/app/sphinx/pocketsphinx/lib
