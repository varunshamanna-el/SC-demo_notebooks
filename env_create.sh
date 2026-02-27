#!/usr/bin/sh

#disable automatic killing of notebook
sudo kill -9 $(sudo ps -aux | grep autostop.py | head -n 2 | awk '{print $2}')

#deactivate current conda envs
conda deactivate || true
# conda deactivate
# conda deactivate
# conda deactivate

#define and create work dir
WORKING_DIR=/home/ec2-user/SageMaker/.sc_varun
mkdir -p "$WORKING_DIR"

#get the miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.3.0-0-Linux-x86_64.sh -O "$WORKING_DIR/miniconda.sh"


#install miniconda
bash "$WORKING_DIR/miniconda.sh" -b -u -p "$WORKING_DIR/miniconda"


#activate newly installed env
source "$WORKING_DIR/miniconda/bin/activate"

# conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
# conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

#define, create and activate a env
ENV_NAME="seurat_env"
conda create --yes --name "$ENV_NAME"
conda activate $ENV_NAME

mamba install -y -c conda-forge r-base
mamba install -y -c conda-forge gcc gxx pkg-config freetype fontconfig zlib

mkdir -p ~/.R
echo "CC=$CONDA_PREFIX/bin/gcc
CXX=$CONDA_PREFIX/bin/g++
CFLAGS=-I\"$CONDA_PREFIX/include\"
CXXFLAGS=-I\"$CONDA_PREFIX/include\"
LDFLAGS=-L\"$CONDA_PREFIX/lib\"" > ~/.R/Makevars

#R Kernel
R -e 'install.packages("IRkernel", repos = "https://cloud.r-project.org/")'
R -e 'IRkernel::installspec(name="seurat_env", displayname = "seurat_env")'

mamba install -y -c conda-forge   r-igraph   r-leiden   r-rcpp   r-rcppannoy   r-uwot   r-reticulate
mamba install -y -c conda-forge   r-systemfonts   r-textshaping   r-ragg   r-xml2   r-rvest
conda install -y -c conda-forge r-v8
R -e 'install.packages("tidyverse", repos="https://cloud.r-project.org/")'
#installing R packages needed for the analysis
R -e 'install.packages("BiocManager", repos="https://cloud.r-project.org/")'
R -e 'install.packages("Seurat", repos="https://cloud.r-project.org/")'
R -e 'install.packages("SeuratObject", repos="https://cloud.r-project.org/")'
#R -e 'install.packages("hdf5r", repos="https://cloud.r-project.org/")'
mamba install -y -c conda-forge r-hdf5r
R -e 'install.packages("patchwork", repos="https://cloud.r-project.org/")'
R -e 'install.packages("remotes", repos="https://cloud.r-project.org/")'
R -e 'install.packages("RPresto", repos="https://cloud.r-project.org/")'
R -e 'install.packages("future", repos="https://cloud.r-project.org/")'
R -e 'install.packages("future.apply", repos="https://cloud.r-project.org/")'
R -e 'install.packages("cowplot", repos="https://cloud.r-project.org/")'
R -e 'install.packages("data.table", repos="https://cloud.r-project.org/")'
R -e 'install.packages("openxlsx", repos="https://cloud.r-project.org/")'
R -e 'remotes::install_github("chris-mcginnis-ucsf/DoubletFinder")'
R -e 'remotes::install_github("immunogenomics/presto")'

# ---- Bioconductor ----
R -e 'if (!require("BiocManager")) install.packages("BiocManager")'
R -e 'BiocManager::install("glmGamPoi")'
R -e 'BiocManager::install("SingleR")'
R -e 'BiocManager::install("celldex")'
R -e 'BiocManager::install("MAST")'



#create python env
ENV_NAME_2="scanpy_env"
conda create --yes --name "$ENV_NAME_2" python=3.10
conda activate "$ENV_NAME_2"


mamba install -y sos-notebook jupyterlab-sos sos-papermill -c conda-forge
python -m sos_notebook.install

pip install numpy scipy pandas matplotlib seaborn scikit-learn

# ---- scanpy ecosystem ----
mamba install -y -c conda-forge   hdf5   h5py
pip install scanpy anndata

# ---- single-cell utilities ----
mamba install -y -c conda-forge   'python-igraph<=0.12'   leidenalg
pip install harmonypy
pip install scrublet
pip install louvain

# ---- file format support ----
pip install h5py tables

# ---- optional but commonly used ----
pip install umap-learn
pip install statsmodels
pip install tqdm

# ---- Jupyter support (if using notebooks) ----
pip install notebook ipykernel
python -m ipykernel install --user --name scanpy_env --display-name "scanpy_env"


#block to check the installation
echo "===== Checking Seurat (R) ====="

Rscript - <<'EOF'
if (!requireNamespace("Seurat", quietly = TRUE)) {
  stop("Seurat is NOT installed")
} else {
  cat("Seurat version:", as.character(packageVersion("Seurat")), "\n")
}
EOF

echo "===== Checking Scanpy (Python) ====="

python - <<'EOF'
try:
    import scanpy as sc
    print("scanpy version:", sc.__version__)
except ImportError:
    raise SystemExit("scanpy is NOT installed")
EOF

echo "===== VERSION CHECK COMPLETE ====="


TAR_NAME=$(basename "$WORKING_DIR" | sed 's/^\.//')
tar -czvf "/home/ec2-user/SageMaker/${TAR_NAME}.tar.gz" "$WORKING_DIR"

polly files copy \
  --source "/home/ec2-user/SageMaker/${TAR_NAME}.tar.gz" \
  --destination "polly://${TAR_NAME}.tar.gz" \
  --workspace-id 21743

