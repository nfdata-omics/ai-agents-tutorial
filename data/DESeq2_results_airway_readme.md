# 🧬 DESeq2 Differential Gene Expression Analysis: Airway Dexamethasone Dataset

## 1. Overview (Project Description)

This repository documents a complete and reproducible **Differential Gene Expression (DGE)** analysis workflow for **RNA-sequencing (RNA-Seq)** data, using the widely known **Airway dataset**. This study evaluates the **transcriptional changes in human airway smooth muscle cells** following treatment with **Dexamethasone** (a potent anti-inflammatory corticosteroid).

The project is designed as an end-to-end tutorial using the **DESeq2** R package to perform all necessary steps, from raw data preparation to statistical testing and visualization.

Key stages of this project include:
* **Data Preparation:** Loading the raw gene count matrix and metadata from the `airway` Bioconductor package into the required **DESeqDataSet** object structure in R.
* **Normalization and Filtering:** Performing **size factor estimation** (normalization) to account for sequencing depth and filtering out lowly expressed genes.
* **Statistical Testing:** Running the core DESeq2 function to fit the Negative Binomial model and perform **Wald testing** to identify significantly differentially expressed genes.
* **LFC Shrinkage:** Applying **Log-Fold Change (LFC) shrinkage** (e.g., using `apeglm`) to generate more accurate and stable fold change estimates, especially for low-count genes.
* **Visualization:** Generating critical diagnostic and result plots, including **Volcano Plots** (for significance), **Heatmaps** (for top genes), and **PCA plots** (for sample clustering).

## 2. Dataset

### Data Source
* **Source:** Kaggle / Bioconductor RNA-seq Data (Airway R package)
* **Context:** RNA-Seq analysis of **human airway smooth muscle cells** comparing $\text{Dexamethasone}$ treatment ($\text{dex}$) versus Control ($\text{untrt}$).
* **Link:** [DESeq2 DGE Analysis airway Dataset](https://www.kaggle.com/datasets/mannekuntanagendra/deseq2-dge-analysis-airway-dataset)
* **Files:** The project uses data typically sourced directly from the `airway` Bioconductor package.

### Key Data Components

| Component | Description | Data Type |
| :--- | :--- | :--- |
| **Count Matrix** | Raw sequencing read counts for each gene across all samples. | Integer |
| **Metadata** | Sample-specific information, specifically the **condition** (`dex` column). | Categorical |
| **DGE Results** | Output table containing **LFC**, **$\text{p-value}$**, and **$\text{padj}$** (Adjusted p-value). | Numerical |

### Target Output

The final output is a table of **significantly differentially expressed genes** (DEGs) that represent the molecular pathways activated or repressed by Dexamethasone.

## 3. Technology Stack

* **Language:** **R**
* **Core Packages:** **DESeq2** (Bioconductor), `airway` (for data access), `pheatmap`, `EnhancedVolcano`, `apeglm`.
* **Statistical Methods:** Negative Binomial GLM, Wald Test, LFC Shrinkage.
* **Environment:** RStudio or a comparable R environment.

## 4. Getting Started

### Prerequisites

You need **R** installed with access to the **Bioconductor** repositories.

```R
# 1. Install required packages (run once)
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(c("DESeq2", "pheatmap", "EnhancedVolcano", "airway", "apeglm"), update = FALSE, ask = FALSE)
