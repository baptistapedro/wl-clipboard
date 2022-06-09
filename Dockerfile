FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev meson ninja-build
RUN git clone https://github.com/bugaevc/wl-clipboard.git
WORKDIR /wl-clipboard
RUN CC=afl-clang CXX=afl-clang++ meson build .
RUN ninja -C build
RUN ninja -C build install
RUN mkdir /wlpngCorpus
RUN wget https://file-examples.com/wp-content/uploads/2017/10/file_example_PNG_500kB.png
RUN wget https://download.samplelib.com/png/sample-boat-400x300.png
RUN wget https://download.samplelib.com/png/sample-hut-400x300.png
RUN wget https://download.samplelib.com/png/sample-hut-400x300.png
RUN mv *.png /wlpngCorpus


ENTRYPOINT ["afl-fuzz", "-i", "/wlpngCorpus", "-o", "/wlOut"]
CMD ["/usr/bin/wl-copy", "<", "@@"]

