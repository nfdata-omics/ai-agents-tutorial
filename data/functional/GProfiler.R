############################################################
# ORA analysis with g:Profiler from DESeq2 results
############################################################

library(gprofiler2)

############################################################
# 1. Input settings
############################################################

input_file <- "../dea/DESeq2_results_airway_trt_vs_untrt.csv"

padj_cutoff <- 0.05
lfc_cutoff <- log2(1.5)

output_file <- "gProfiler_ORA_results.txt"

############################################################
# 2. Read DESeq2 results
############################################################

res <- read.csv(input_file)
rownames(res) <- res$gene_id

# Keep genes with usable adjusted p-values and log2 fold changes
res <- res[!is.na(res$padj) & !is.na(res$log2FoldChange), ]

# Remove Ensembl version numbers if present
# Example: ENSG000001234.5 -> ENSG000001234
genes <- sub("\\..*", "", rownames(res))

############################################################
# 3. Define gene sets for ORA
############################################################

# Background: all genes tested in DESeq2
background_genes <- genes

# All significant DE genes
de_all <- genes[
  res$padj < padj_cutoff &
    abs(res$log2FoldChange) > lfc_cutoff
]

# Up-regulated significant genes
de_up <- genes[
  res$padj < padj_cutoff &
    res$log2FoldChange > lfc_cutoff
]

# Down-regulated significant genes
de_down <- genes[
  res$padj < padj_cutoff &
    res$log2FoldChange < -lfc_cutoff
]

# Print gene set sizes
cat("Background genes:", length(background_genes), "\n")
cat("All DE genes:", length(de_all), "\n")
cat("Up-regulated genes:", length(de_up), "\n")
cat("Down-regulated genes:", length(de_down), "\n")

############################################################
# 4. Run ORA with g:Profiler
############################################################

ora_results <- gost(
  query = list(
    all_DE = de_all,
    upregulated = de_up,
    downregulated = de_down
  ),
  organism = "hsapiens",
  ordered_query = FALSE,
  significant = FALSE,
  correction_method = "g_SCS",
  sources = c('KEGG'),
  custom_bg = background_genes,
  domain_scope = "custom"
)

############################################################
# 5. Save results
############################################################

ora_table <- ora_results$result

# filter out very small or very broad terms
ora_table_filtered <- ora_table[
  ora_table$term_size >= 10 &
    ora_table$term_size <= 350 &
    ora_table$intersection_size >= 4,
]


write.table(
  #discard columns containing lists
  ora_table_filtered[, !vapply(ora_table_filtered, is.list, logical(1))],
  file = output_file,
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)


############################################################
# 6. Show top results
############################################################

top_results <- ora_table_filtered[order(ora_table_filtered$p_value), ]

head(top_results, 20)