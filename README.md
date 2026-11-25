<h1 align="center">Connectivity Gradients</h1>

<p align="center">
  Computes functional connectivity gradients from left and right surface fMRI time series with BrainSpace, using Schaefer-1000 parcel correlations, and outputs the gradients as surface maps.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.574"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.574-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-see_LICENSE-lightgrey.svg" alt="License"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Computes functional connectivity gradients from left and right surface fMRI time series with BrainSpace, using Schaefer-1000 parcel correlations, and outputs the gradients as surface maps.**

Averages the surface time series within the Schaefer 2018 1000-parcel atlas (fsaverage or HCP 32k space), optionally regresses confounds with nilearn, computes a parcel correlation matrix (optionally thresholded per row) and fits BrainSpace GradientMaps with the chosen approach and kernel. Use it to derive the principal gradients of cortical functional organisation. Input surfaces must be in fsaverage, fsaverage5/6 or HCP 32k space.

| | |
|---|---|
| **Inputs** | `neuro/surface/data` · `neuro/regressors` (optional) |
| **Outputs** | `neuro/surface/gradient` |
| **Container** | `anibalsolon/app-connectivity-gradient` |
| **Resources** | 16 CPUs |
| **Run it** | [doi.org/10.25663/brainlife.app.574](https://doi.org/10.25663/brainlife.app.574) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `input` | `neuro/surface/data` | yes | Left and right hemisphere surface fMRI time series (GIfTI) in fsaverage or HCP 32k space. |
| `regressors` | `neuro/regressors` | no | Optional confounds table (TSV) regressed from the time series before computing connectivity. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `gradients` | `neuro/surface/gradient` | Gradient maps for the left and right hemispheres (GIfTI, one data array per component). |

<details>
<summary><b>Parameters</b> (5)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `approach` | enum | `diffusion-maps` | Dimensionality-reduction method used by BrainSpace: diffusion maps, Laplacian eigenmaps or PCA. Options: `diffusion-maps`, `laplacian-eigenmaps`, `pca-maps`. |
| `kernel` | enum | `normalized-angle` | Affinity kernel applied to the connectivity matrix before the embedding. Options: `pearson`, `spearman`, `normalized-angle`, `cosine`, `gaussian`. |
| `n_components` | number | `2` | Number of gradients to compute. |
| `random_state` | number | `0` | Random seed for the embedding. |
| `threshold` | number | `0` | Row-wise percentile (0-1) below which correlations are set to zero; 0 keeps the full matrix. |

</details>

<!-- brainlife-app:end -->

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.574](https://doi.org/10.25663/brainlife.app.574), choose `neuro/surface/data`, `neuro/regressors` from your project, set the parameters and press **Execute**. The results are saved to your project as `neuro/surface/gradient`.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/) (the App runs in `anibalsolon/app-connectivity-gradient`), [`jq`](https://jqlang.github.io/jq/).

1. Clone this repository.
2. Create `config.json` with the paths to your inputs and the parameters:

   ```json
   {
       "left": "/path/to/input/left",
       "right": "/path/to/input/right",
       "label": "/path/to/input/label",
       "confounds": "/path/to/regressors/confounds",
       "json": "/path/to/regressors/json",
       "approach": "diffusion-maps",
       "kernel": "normalized-angle",
       "n_components": 2,
       "random_state": 0,
       "threshold": 0
   }
   ```

3. Run `./main`.

## Citing

If you use this App, please cite it, the software it builds on and brainlife.io:

- Connectivity Gradients. brainlife.io App. [doi:10.25663/brainlife.app.574](https://doi.org/10.25663/brainlife.app.574)
- Abraham et al. Machine learning for neuroimaging with scikit-learn. *Frontiers in Neuroinformatics* 8 (2014). [doi:10.3389/fninf.2014.00014](https://doi.org/10.3389/fninf.2014.00014)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

Maintained by [@anibalsolon](https://github.com/anibalsolon).

## License

See [LICENSE](LICENSE).
