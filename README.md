[![DOI](https://zenodo.org/badge/989036892.svg)](https://doi.org/10.5281/zenodo.17050427)

# Parietal-epithelial-cell-quantification-in-human-nephrectomies
Parietal epithelial cell quantification in human nephrectomies

This repository contains code for quantifying parietal epithelial cell (PEC) and podocyte densities in PAS-WT1-stained human nephrectomy samples using a U-Net-assisted segmentation pipeline. WT1-positive nuclei are first identified within each glomerulus. These nuclei are then classified as either PECs or podocytes based on their spatial location within the glomerular structure. To account for variation in glomerular size, PEC and podocyte densities are normalized to glomular perimeter and area, respectively. This pipeline enables reproducible and scalable quantification of cell populations across kidney tissue samples.

