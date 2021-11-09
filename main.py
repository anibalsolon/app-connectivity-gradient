import argparse
import os.path

import nibabel as nb
from nibabel.gifti.gifti import GiftiImage, GiftiDataArray
from nilearn import signal

import numpy as np
from brainspace.gradient import GradientMaps
from nilearn.connectome import ConnectivityMeasure


def is_valid_file(parser, arg):
    if not os.path.exists(arg):
        parser.error(f"The file {arg} does not exist!")
    return arg

parser = argparse.ArgumentParser(description='Connectivity Gradients')
parser.add_argument('approach', choices=['diffusion-maps', 'laplacian-eigenmaps', 'pca-maps'])
parser.add_argument('kernel', choices=['pearson', 'spearman', 'normalized-angle', 'cosine', 'gaussian'])
parser.add_argument('input', nargs=2, metavar=('left', 'right'), type=lambda x: is_valid_file(parser, x))
parser.add_argument('--confounds', default=None)
parser.add_argument('--threshold', default=0.0, type=float)
parser.add_argument('--n_components', default=3, type=int)
parser.add_argument('--random_state', default=0, type=int)

args = parser.parse_args()

approach = {
    'diffusion-maps': 'dm',
    'laplacian-eigenmaps': 'le',
    'pca-maps': 'pca',
}[args.approach]
kernel = args.kernel.replace('-', '_')

lh = np.asarray([arr.data for arr in nb.load(args.input[0]).darrays]).T.squeeze()
rh = np.asarray([arr.data for arr in nb.load(args.input[1]).darrays]).T.squeeze()

lh_shape = lh.shape
rh_shape = rh.shape

data = np.concatenate((lh, rh)).astype(np.float32)
data_shape = data.shape

print('LH shape', lh_shape)
print('RH shape', rh_shape)
del lh, rh

print('Data shape', data.shape)
if args.confounds is not None:
    confounds = np.loadtxt(args.confounds, skiprows=1)
    data = signal.clean(data.T, confounds=confounds).T
    print('Data shape', data.shape)

parcellation = '/parcellations/Schaefer2018/hcp/Schaefer2018_1000Parcels_7Networks_order.dlabel.nii'
parcellation = nb.load(parcellation).get_fdata()[0]
# lh, _, lh_annot_names = fs.read_annot('/parcellations/Schaefer2018/fsaverage5/lh.Schaefer2018_1000Parcels_7Networks_order.annot')
# rh, _, rh_annot_names = fs.read_annot('/parcellations/Schaefer2018/fsaverage5/rh.Schaefer2018_1000Parcels_7Networks_order.annot')
# lh_annot_shape = lh.shape
# rh_annot_shape = rh.shape

print('Parcellation shape:', parcellation.shape)
labels = np.unique(parcellation)
labels = labels[labels != 0].tolist()
data = np.array([np.mean(data[parcellation == l], axis=0) for l in labels])

print('Computing correlation matrix')
corr = ConnectivityMeasure(kind='correlation').fit_transform([data.T])[0]
if args.threshold > 0.0:
    row_percentile = np.percentile(corr, args.threshold * 100, axis=1)
    corr[corr < row_percentile] = 0.0

print('Matrix size', corr.shape)

print('Computing gradients')
gm = GradientMaps(
    n_components=args.n_components,
    kernel=kernel,
    approach=approach,
    random_state=args.random_state
)
gm.fit(corr)

del corr

print('Saving data')
gradients = np.zeros((data_shape[0], gm.gradients_.shape[1]))
for i, l in enumerate(labels):
    gradients[parcellation == l] = gm.gradients_[i]
# gradients = gm.gradients_

lh_new_img = GiftiImage()
rh_new_img = GiftiImage()
for g in range(args.n_components):
   lh_new_img.add_gifti_data_array(
        GiftiDataArray(
            gradients[:lh_shape[0], g],
            'NIFTI_INTENT_TIME_SERIES',
            'NIFTI_TYPE_FLOAT32'
        )
    )
   rh_new_img.add_gifti_data_array(
        GiftiDataArray(
            gradients[lh_shape[0]:, g],
            'NIFTI_INTENT_TIME_SERIES',
            'NIFTI_TYPE_FLOAT32'
        )
    )

nb.save(lh_new_img, f'gradients/left.gii')
nb.save(rh_new_img, f'gradients/right.gii')
