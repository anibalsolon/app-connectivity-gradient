FROM continuumio/miniconda3 AS base

ARG TARGETARCH

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git build-essential ca-certificates curl tcsh rsync \
        libxext-dev libxpm-dev libxmu-dev libxt6 libxft2 libglu1-mesa-dev


FROM base AS base-amd64

RUN curl -LO "https://launchpad.net/ubuntu/+source/libxp/1:1.0.2-2/+build/6314166/+files/libxp6_1.0.2-2_amd64.deb" && \
    dpkg --ignore-depends=multiarch-support -i libxp6_*.deb && \
    rm libxp6_*.deb

RUN curl -LO "https://launchpad.net/ubuntu/+source/libpng/1.2.54-1ubuntu1/+build/8809640/+files/libpng12-0_1.2.54-1ubuntu1_amd64.deb" && \
    dpkg --ignore-depends=multiarch-support -i libpng12-0_*.deb && \
    rm libpng12-0_*.deb


FROM base AS base-ppc64le

RUN curl -LO "https://launchpad.net/ubuntu/+source/libxp/1:1.0.2-2/+build/6314171/+files/libxp6_1.0.2-2_ppc64el.deb" && \
    dpkg --ignore-depends=multiarch-support -i libxp6_*.deb && \
    rm libxp6_*.deb

RUN curl -LO "https://launchpad.net/ubuntu/+source/libpng/1.2.54-1ubuntu1/+build/8809645/+files/libpng12-0_1.2.54-1ubuntu1_ppc64el.deb" && \
    dpkg --ignore-depends=multiarch-support -i libpng12-0_*.deb && \
    rm libpng12-0_*.deb


FROM base-$TARGETARCH

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

RUN conda install -y -c conda-forge numpy==1.22.4 scipy==1.8.1 vtk==9.1.0 pandas==1.4.2 pillow==9.1.1 matplotlib==3.5.2 scikit-learn==1.1.1 && conda clean -y --all
RUN pip install brainspace==0.1.2 nibabel==3.2.1 nilearn==0.8.0
RUN mkdir /scratch
WORKDIR /scratch
