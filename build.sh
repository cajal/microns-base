#! /bin/bash
docker build . -t at-docker:5000/microns-base:cuda11.4.0-python3.8
docker push at-docker:5000/microns-base:cuda11.4.0-python3.8

