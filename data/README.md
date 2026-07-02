Counts sources:
```
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("airway")
library(airway)
data("airway")

# Count matrix
counts_matrix <- assay(airway, "counts")

# Gene annotation
gene_info <- as.data.frame(rowData(airway))

# Combine annotation and counts
counts_annotated <- cbind(
  gene_info,
  counts_matrix
)

# Metadata
sample_metadata <- as.data.frame(colData(airway))

# Save to CSV
write.csv(counts_annotated,
          file = "/Users/camilla.callierotti/Library/CloudStorage/OneDrive-Htechnopole/Conferences/2026_piacenza/data/airway_counts.csv",
          row.names = TRUE)

write.csv(sample_metadata,
          file = "/Users/camilla.callierotti/Library/CloudStorage/OneDrive-Htechnopole/Conferences/2026_piacenza/data/airway_metadata.csv",
          row.names = TRUE)
```

Deseq2 results source:
https://www.kaggle.com/datasets/mannekuntanagendra/deseq2-dge-analysis-airway-dataset
