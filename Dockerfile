FROM continuumio/miniconda3

RUN pip install brainspace==0.1.2 nibabel==3.2.1 nilearn==0.8.0
RUN mkdir /scratch
WORKDIR /scratch
