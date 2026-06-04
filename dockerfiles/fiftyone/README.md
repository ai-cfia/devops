# FiftyOne

Custom FiftyOne image used by the Howard on-prem deployment.

The image extends:

```text
voxel51/fiftyone:1.15.0-python3.9-20260502
```

Installed plugins:

```text
@voxel51/annotation
@voxel51/io
@voxel51/brain
@voxel51/utils
```

Runtime packages:

- CPU-only `torch`
- CPU-only `torchvision`
- `umap-learn`

These packages support the Brain similarity and visualization workflows from
the FiftyOne UI.

Delegated operations are intentionally out of scope for this image.

## Build

Use the repository's `Image build` workflow and choose:

```text
image: fiftyone
tag: 1.15.0-python3.9-plugins-torch-20260604
```
