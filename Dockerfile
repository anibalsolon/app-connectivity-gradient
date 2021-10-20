FROM continuumio/miniconda3

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git build-essential ca-certificates curl tcsh rsync \
        libxext-dev libxpm-dev libxmu-dev libxt6 libxft2 libglu1-mesa-dev

RUN curl -LO http://ftp.debian.org/debian/pool/main/libx/libxp/libxp6_1.0.2-2_amd64.deb && \
    curl -LO http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb && \
    apt-get install -y ./libxp6_1.0.2-2_amd64.deb ./libpng12-0_1.2.54-1ubuntu1_amd64.deb && \
    rm ./libxp6_1.0.2-2_amd64.deb ./libpng12-0_1.2.54-1ubuntu1_amd64.deb

ENV PARCELLATIONS_REPO="https://github.com/ThomasYeoLab/CBIG/blob/master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal/Parcellations"
RUN bash -c "mkdir -p /parcellations/Schaefer2018/{hcp,fsaverage,fsaverage5,fsaverage6}" && \
    curl -L -o /parcellations/Schaefer2018/hcp/Schaefer2018_1000Parcels_7Networks_order.dlabel.nii $PARCELLATIONS_REPO/HCP/fslr32k/cifti/Schaefer2018_1000Parcels_7Networks_order.dlabel.nii?raw=true && \
    curl -L -o /parcellations/Schaefer2018/fsaverage/lh.Schaefer2018_1000Parcels_7Networks_order.annot $PARCELLATIONS_REPO/FreeSurfer5.3/fsaverage/label/lh.Schaefer2018_1000Parcels_7Networks_order.annot?raw=true && \
    curl -L -o /parcellations/Schaefer2018/fsaverage/rh.Schaefer2018_1000Parcels_7Networks_order.annot $PARCELLATIONS_REPO/FreeSurfer5.3/fsaverage/label/rh.Schaefer2018_1000Parcels_7Networks_order.annot?raw=true && \
    curl -L -o /parcellations/Schaefer2018/fsaverage5/lh.Schaefer2018_1000Parcels_7Networks_order.annot $PARCELLATIONS_REPO/FreeSurfer5.3/fsaverage5/label/lh.Schaefer2018_1000Parcels_7Networks_order.annot?raw=true && \
    curl -L -o /parcellations/Schaefer2018/fsaverage5/rh.Schaefer2018_1000Parcels_7Networks_order.annot $PARCELLATIONS_REPO/FreeSurfer5.3/fsaverage5/label/rh.Schaefer2018_1000Parcels_7Networks_order.annot?raw=true && \
    curl -L -o /parcellations/Schaefer2018/fsaverage6/lh.Schaefer2018_1000Parcels_7Networks_order.annot $PARCELLATIONS_REPO/FreeSurfer5.3/fsaverage6/label/lh.Schaefer2018_1000Parcels_7Networks_order.annot?raw=true && \
    curl -L -o /parcellations/Schaefer2018/fsaverage6/rh.Schaefer2018_1000Parcels_7Networks_order.annot $PARCELLATIONS_REPO/FreeSurfer5.3/fsaverage6/label/rh.Schaefer2018_1000Parcels_7Networks_order.annot?raw=true && \
    curl -L -o /parcellations/Schaefer2018/fsaverage/lh.pial $PARCELLATIONS_REPO/FreeSurfer5.3/fsaverage/surf/lh.pial?raw=true && \
    curl -L -o /parcellations/Schaefer2018/fsaverage/rh.pial $PARCELLATIONS_REPO/FreeSurfer5.3/fsaverage/surf/rh.pial?raw=true && \
    curl -L -o /parcellations/Schaefer2018/fsaverage/lh.inflated $PARCELLATIONS_REPO/FreeSurfer5.3/fsaverage/surf/lh.inflated?raw=true && \
    curl -L -o /parcellations/Schaefer2018/fsaverage/rh.inflated $PARCELLATIONS_REPO/FreeSurfer5.3/fsaverage/surf/rh.inflated?raw=true && \
    true

RUN pip install brainspace==0.1.2 nibabel==3.2.1 nilearn==0.8.0 ipython
RUN mkdir /scratch
WORKDIR /scratch
