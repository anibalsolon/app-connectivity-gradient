<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Computes functional connectivity gradients from left and right surface fMRI time series with BrainSpace, using Schaefer-1000 parcel correlations, and outputs the gradients as surface maps.**

Averages the surface time series within the Schaefer 2018 1000-parcel atlas (fsaverage or HCP 32k space), optionally regresses confounds with nilearn, computes a parcel correlation matrix (optionally thresholded per row) and fits BrainSpace GradientMaps with the chosen approach and kernel. Use it to derive the principal gradients of cortical functional organisation. Input surfaces must be in fsaverage, fsaverage5/6 or HCP 32k space.

| | |
|---|---|
| 📥 **Inputs** | `neuro/surface/data` · `neuro/regressors` (optional) |
| 📤 **Outputs** | `neuro/surface/gradient` |
| 🐳 **Container** | `anibalsolon/app-connectivity-gradient` |
| ⚙️ **Resources** | 16 CPUs |
| 🔗 **Run it** | [doi.org/10.25663/brainlife.app.574](https://doi.org/10.25663/brainlife.app.574) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `input` | `neuro/surface/data` | yes | Left and right hemisphere surface fMRI time series (GIfTI) in fsaverage or HCP 32k space. |
| `regressors` | `neuro/regressors` | no | Optional confounds table (TSV) regressed from the time series before computing connectivity. |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `gradients` | `neuro/surface/gradient` | Gradient maps for the left and right hemispheres (GIfTI, one data array per component). |

<details>
<summary><b>⚙️ Parameters</b> (5)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `approach` | enum | `diffusion-maps` | Dimensionality-reduction method used by BrainSpace: diffusion maps, Laplacian eigenmaps or PCA. Options: `diffusion-maps`, `laplacian-eigenmaps`, `pca-maps`. |
| `kernel` | enum | `normalized-angle` | Affinity kernel applied to the connectivity matrix before the embedding. Options: `pearson`, `spearman`, `normalized-angle`, `cosine`, `gaussian`. |
| `n_components` | number | `2` | Number of gradients to compute. |
| `random_state` | number | `0` | Random seed for the embedding. |
| `threshold` | number | `0` | Row-wise percentile (0-1) below which correlations are set to zero; 0 keeps the full matrix. |

</details>

<!-- brainlife-app:end -->

# Connectivity Gradient