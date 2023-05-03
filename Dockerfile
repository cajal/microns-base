FROM at-docker:5000/datascience-notebook:cuda11.4.0-python3.8

USER root

# Install Python packages that were not available on conda
RUN pip --no-cache-dir install meshparty

# Install DataJoint with datajoint_plus
ADD "https://api.github.com/repos/cajal/datajoint-plus/releases?per_page=1" latest
RUN pip install datajoint-plus

# Install Cajal packages from latest tag
ADD "https://api.github.com/repos/cajal/microns-utils/releases?per_page=1" latest
RUN pip install microns-utils

ADD "https://api.github.com/repos/cajal/microns-nda/releases?per_page=1" latest
RUN export TAG=$(curl -s 'https://api.github.com/repos/cajal/microns-nda/releases?per_page=1' | grep -oP '"name": "\K(.*)(?=")'); \ 
    pip install git+https://github.com/cajal/microns-nda.git@$TAG#subdirectory=python/microns-nda-api

ADD "https://api.github.com/repos/cajal/microns-materialization/releases?per_page=1" latest
RUN export TAG=$(curl -s 'https://api.github.com/repos/cajal/microns-materialization/releases?per_page=1' | grep -oP '"name": "\K(.*)(?=")'); \ 
    pip install git+https://github.com/cajal/microns-materialization.git@$TAG#subdirectory=python/microns-materialization-api

ADD "https://api.github.com/repos/cajal/microns-morphology/releases?per_page=1" latest
RUN export TAG=$(curl -s 'https://api.github.com/repos/cajal/microns-morphology/releases?per_page=1' | grep -oP '"name": "\K(.*)(?=")'); \ 
    pip install git+https://github.com/cajal/microns-morphology.git@$TAG#subdirectory=python/microns-morphology-api

ADD "https://api.github.com/repos/cajal/microns-coregistration/releases?per_page=1" latest
RUN export TAG=$(curl -s 'https://api.github.com/repos/cajal/microns-coregistration/releases?per_page=1' | grep -oP '"name": "\K(.*)(?=")'); \ 
    pip install git+https://github.com/cajal/microns-coregistration.git@$TAG#subdirectory=python/microns-coregistration-api

ADD "https://api.github.com/repos/cajal/microns-manual-proofreading/releases?per_page=1" latest
RUN export TAG=$(curl -s 'https://api.github.com/repos/cajal/microns-manual-proofreading/tags?per_page=1' | grep -oP '"name": "\K(.*)(?=")'); \ 
    pip install git+https://github.com/cajal/microns-manual-proofreading.git@$TAG#subdirectory=python/microns-manual-proofreading-api
