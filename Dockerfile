FROM pdal/pdal:1.6-ubuntu

# Pick up some dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python \
        python-dev \
        rsync \
        software-properties-common \
        unzip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN apt-get update && apt-get install -y --fix-missing --no-install-recommends \
      pandoc \
      texlive-fonts-recommended \
      texlive-latex-base \
      texlive-latex-extra \
      texlive-fonts-extra \
      texlive-fonts-recommended \
      texlive-generic-recommended \
      texlive-xetex \
      && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists*

RUN pip --no-cache-dir install \
        ipyleaflet \
        ipyvolume \
        pyproj \
        shapely \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        scipy \
        sklearn \
        pandas \
        Pillow \
        pdal \
        && \
    python -m ipykernel.kernelspec

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
COPY notebooks /notebooks

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

# IPython
EXPOSE 8888

WORKDIR "/"

CMD ["/run_jupyter.sh", "--allow-root"]
