# Single-Cell RNA-Seq (scRNA-seq) Analysis Portfolio

Welcome! This repository serves as a comprehensive collection of my work, code, and notebooks as I upskill in **Single-Cell RNA Sequencing (scRNA-seq) analysis**. My goal is to master the end-to-end pipeline—from raw reads to biological insights.

### 🧬 Project Overview

The focus of this repository is on processing high-dimensional transcriptomic data to understand cellular heterogeneity. I explore various workflows using industry-standard libraries like **Scanpy (Python)** and **Seurat (R)**.

### 🛠️ Tech Stack & Tools

* **Languages:** Python, R
* **Key Libraries:** Scanpy, AnnData, Seurat, Bioconductor
* **Frameworks:** Jupyter Notebooks, RStudio
* **Analysis Steps:**
  * Quality Control (QC) & Filtering
  * Normalization & Scaling
  * Feature Selection (Highly Variable Genes)
  * Dimensionality Reduction (PCA, UMAP, t-SNE)
  * Clustering & Cell Type Annotation
  * Differential Expression (DE) Analysis

---

### 📂 Repository Structure

```text
├── Scanpy_notebooks/
|──DE_Demo/
│   ├── 01_Preprocessing_QC.ipynb      # Filtering, mitochondrial counts, and doublet detection
│   ├── 02_Normalization_Reduction.ipynb # Scaling and UMAP/t-SNE visualization
│   ├── 03_Clustering_Annotation.ipynb  # Identifying cell clusters and biomarkers
│   └── 04_Trajectory_Inference.ipynb   # Pseudotime analysis
├── data/
│   └── raw/                           # Placeholder for raw data (e.g., FASTQ or .h5ad)
├── scripts/                           # Utility Python/R scripts
└── README.md
```

## 📈 Learning MilestonesQC Mastery

Understanding why we filter based on

* QC Mastery based on
    - $n\_genes$,
    - $n\_counts$, and
    - $pct\_counts\_mt$.

* Batch Correction: Learning how to integrate multiple samples while removing technical noise.
* Biological Interpretation: Mapping clusters to known cell types using marker gene databases.

## 🚀 How to Use

Clone the repo:

```Bash
git clone [https://github.com/yourusername/scRNA-seq-analysis.git](https://github.com/yourusername/scRNA-seq-analysis.git)
```

Install dependencies:
(Provide a requirements.txt or environment.yml if available)

Explore the Notebooks:

1. Scanpy Notebooks
    -

2. Seurat Notebooks
    -

Note: The datasets used in these notebooks are typically sourced from public repositories like the 10x Genomics Dataset Gallery or GEO.
