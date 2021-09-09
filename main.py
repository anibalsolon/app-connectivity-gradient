import argparse
import os.path

import nibabel as nb
import numpy as np
from brainspace.gradient import GradientMaps
from nilearn.connectome import ConnectivityMeasure


def is_valid_file(parser, arg):
    if not os.path.exists(arg):
        parser.error("The file %s does not exist!" % arg)
    return arg

parser = argparse.ArgumentParser(description='Connectivity Gradients')
parser.add_argument('approach', choices=['diffusion-maps', 'laplacian-eigenmaps', 'pca-maps'])
parser.add_argument('kernel', choices=['pearson', 'spearman', 'normalized-angle', 'cosine', 'gaussian'])
parser.add_argument('input', type=lambda x: is_valid_file(parser, x))
parser.add_argument('--mask', type=lambda x: is_valid_file(parser, x))
parser.add_argument('--n_components', default=3, type=int)
parser.add_argument('--random_state', default=0, type=int)

args = parser.parse_args()

approach = {
    'diffusion-maps': 'dm',
    'laplacian-eigenmaps': 'le',
    'pca-maps': 'pca',
}[args.approach]
kernel = args.kernel.replace('-', '_')

mask = nb.load(args.mask).get_fdata()
data = nb.load(args.input).get_fdata()[mask > 0].astype(np.float32)
corr = ConnectivityMeasure(kind='correlation').fit_transform([data.T])[0]
gm = GradientMaps(n_components=args.n_components, kernel=kernel, approach=approach, random_state=args.random_state)
gm.fit(corr)

