############################################################
# Basic DESeq2 analysis: airway dexamethasone dataset
############################################################

library(DESeq2)

############################################################
# 1. Read input files
############################################################

counts_annotated <- read.csv("../../data/airway_counts.csv", row.names = 1, check.names = FALSE)
metadata <- read.csv("../../data/airway_metadata.csv", row.names = 1, check.names = FALSE)

# check for duplicated
table(duplicated(counts_annotated$gene_id))

############################################################
# 2. Extract count matrix
############################################################

# Sample columns are the rows of the metadata table
sample_ids <- rownames(metadata)

# Extract only count columns
count_matrix <- counts_annotated[, sample_ids]

# Make sure counts are integers
count_matrix <- round(as.matrix(count_matrix))

############################################################
# 3. Prepare metadata
############################################################

# Set untreated as reference level
metadata$dex <- factor(metadata$dex, levels = c("untrt", "trt"))

# Cell line / donor variable
metadata$cell <- factor(metadata$cell)

# Make sure sample order matches
metadata <- metadata[colnames(count_matrix), ]

############################################################
# 4. Create DESeq2 object
############################################################

dds <- DESeqDataSetFromMatrix(
  countData = count_matrix,
  colData = metadata,
  design = ~ cell + dex
)

# Remove genes with very low counts
dds <- dds[rowSums(counts(dds)) >= 10, ]

############################################################
# 5. Run DESeq2
############################################################

dds <- DESeq(dds)

############################################################
# 6. Extract results
############################################################

# Explicit contrast:
# trt vs untrt
# positive log2FC = higher in dexamethasone-treated samples
res <- results(
  dds,
  contrast = c("dex", "trt", "untrt")
)

# Order by adjusted p-value
res <- res[order(res$padj), ]

############################################################
# 7. Add gene annotation
############################################################

annotation <- counts_annotated[, c("gene_name", "symbol", "gene_biotype")]

res_table <- as.data.frame(res)
res_table$gene_id <- rownames(res_table)

res_table <- cbind(
  res_table,
  annotation[rownames(res_table), ]
)


table(duplicated(res_table$gene_id))

############################################################
# 8. Save results
############################################################

write.csv(
  res_table,
  file = "DESeq2_results_airway_trt_vs_untrt.csv",
  row.names = FALSE
)

############################################################
# 9. Quick checks
############################################################

summary(res)

head(res_table, 20)
