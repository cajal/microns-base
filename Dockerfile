FROM nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04
LABEL mantainer="Zhuokun Ding <zhuokund@bcm.edu>, Stelios Papadopoulos <spapadop@bcm.edu>, Christos Papadopoulos <cpapadop@bcm.edu>"
# Deal with pesky Python 3 encoding issue
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install essential Ubuntu packages
# and upgrade pip

# added to overcome known issue with nvidia image 
# per https://github.com/NVIDIA/nvidia-docker/issues/1632#issuecomment-1112667716
RUN rm /etc/apt/sources.list.d/cuda.list 
RUN rm /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update &&\
    apt-get install -y software-properties-common \
                       build-essential \
                       git \
                       wget \
                       vim \
                       curl \
                       zip \
                       zlib1g-dev \
                       unzip \
                       pkg-config \
                       libblas-dev \
                       liblapack-dev \
                       python3-tk \
                       python3-wheel \
                       graphviz \
                       libhdf5-dev \
                       python3.8 \
                       python3.8-dev \
                       python3.8-distutils \
                       swig \
                       fish &&\
    apt-get clean &&\
    ln -s /usr/bin/python3.8 /usr/local/bin/python &&\
    ln -s /usr/bin/python3.8 /usr/local/bin/python3 &&\
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py &&\
    python3 get-pip.py &&\
    rm get-pip.py &&\
    # best practice to keep the Docker image lean
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Node.js for rebuilding jupyter lab
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

# Install essential Python packages
# TODO: consider reducing non-essential common dependencies (e.g. jupyterlab)
RUN python3 -m pip --no-cache-dir install \
         pytest \
         pytest-cov \
         numpy \
         matplotlib \
         scipy \
         pandas \
         jupyterlab \
         ipywidgets \
         ipympl \
         scikit-learn \
         scikit-image \
         seaborn \
         graphviz \
         h5py \
         simplejson \
         networkx[default] \
         pylint \
         meshparty

# Install DataJoint with datajoint_plus
ADD "https://api.github.com/repos/cajal/datajoint-plus/releases?per_page=1" latest
RUN python3 -m pip install datajoint-plus

# Add profiling library support
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:${LD_LIBRARY_PATH}

# Install Cajal packages from latest tag
ADD "https://api.github.com/repos/cajal/microns-utils/releases?per_page=1" latest
RUN pip3 install microns-utils

ADD "https://api.github.com/repos/cajal/microns-nda/releases?per_page=1" latest
RUN export TAG=$(curl -s 'https://api.github.com/repos/cajal/microns-nda/releases?per_page=1' | grep -oP '"name": "\K(.*)(?=")'); \ 
    pip3 install git+https://github.com/cajal/microns-nda.git@$TAG#subdirectory=python/microns-nda-api

ADD "https://api.github.com/repos/cajal/microns-materialization/releases?per_page=1" latest
RUN export TAG=$(curl -s 'https://api.github.com/repos/cajal/microns-materialization/releases?per_page=1' | grep -oP '"name": "\K(.*)(?=")'); \ 
    pip3 install git+https://github.com/cajal/microns-materialization.git@$TAG#subdirectory=python/microns-materialization-api

ADD "https://api.github.com/repos/cajal/microns-morphology/releases?per_page=1" latest
RUN export TAG=$(curl -s 'https://api.github.com/repos/cajal/microns-morphology/releases?per_page=1' | grep -oP '"name": "\K(.*)(?=")'); \ 
    pip3 install git+https://github.com/cajal/microns-morphology.git@$TAG#subdirectory=python/microns-morphology-api

ADD "https://api.github.com/repos/cajal/microns-coregistration/releases?per_page=1" latest
RUN export TAG=$(curl -s 'https://api.github.com/repos/cajal/microns-coregistration/releases?per_page=1' | grep -oP '"name": "\K(.*)(?=")'); \ 
    pip3 install git+https://github.com/cajal/microns-coregistration.git@$TAG#subdirectory=python/microns-coregistration-api

ADD "https://api.github.com/repos/cajal/microns-manual-proofreading/releases?per_page=1" latest
RUN export TAG=$(curl -s 'https://api.github.com/repos/cajal/microns-manual-proofreading/tags?per_page=1' | grep -oP '"name": "\K(.*)(?=")'); \ 
    pip3 install git+https://github.com/cajal/microns-manual-proofreading.git@$TAG#subdirectory=python/microns-manual-proofreading-api