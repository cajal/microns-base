#! /bin/bash
docker build . -t registry.atlab.stanford.edu:5000/microns-base:ubuntu20.04-cuda11.8.0-python3.8
docker push registry.atlab.stanford.edu:5000/microns-base:ubuntu20.04-cuda11.8.0-python3.8

