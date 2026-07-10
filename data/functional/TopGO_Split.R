############################################################
# topGO analysis from DESeq2 results
############################################################

# Load packages
library(topGO)
library(GO.db)
library(AnnotationDbi)
library(org.Hs.eg.db)

############################################################
# 1. Read DESeq2 results
############################################################

# Assumes gene IDs are in the first column of the CSV file
res <- read.csv("../dea/DESeq2_results_airway_trt_vs_untrt.csv")
rownames(res) <- res$gene_id

# Remove genes without adjusted p-values
res <- res[!is.na(res$padj), ]

# Check duplicates
table(duplicated(rownames(res)))

# Remove Ensembl version numbers if present
genes <- sub("\\..*", "", rownames(res))

############################################################
# 2. Map genes to GO terms
############################################################

gene2go <- mapIds(
  org.Hs.eg.db,
  keys = genes,
  column = "GO",
  keytype = "ENSEMBL",
  multiVals = "list"
)

# Clean GO mapping: remove missing GO annotations
gene2go <- as.list(gene2go)
gene2go <- lapply(gene2go, function(x) unique(na.omit(x)))
gene2go <- gene2go[lengths(gene2go) > 0]

############################################################
# 3. Define a reusable topGO function
############################################################

run_topgo <- function(gene_status, output_file, ontology = "BP", node_size=6) {
  
  # topGO requires a named factor:
  # 1 = gene of interest
  # 0 = background gene
  allGenes <- factor(as.integer(gene_status))
  names(allGenes) <- genes
  
  # Keep only genes with GO annotations
  allGenes <- allGenes[names(allGenes) %in% names(gene2go)]
  
  # Create topGO object
  GOdata <- new(
    "topGOdata",
    ontology = ontology,
    allGenes = allGenes,
    geneSel = function(x) x == 1,
    annot = annFUN.gene2GO,
    gene2GO = gene2go, 
    nodeSize = node_size
  )
  
  # Run Fisher enrichment test using the weight01 algorithm
  result <- runTest(
    GOdata,
    algorithm = "weight01",
    statistic = "fisher"
  )
  
  # Export all tested GO terms
  results_table <- GenTable(
    GOdata,
    weight01 = result,
    topNodes = length(score(result))
  )
  
  write.table(
    results_table,
    file = output_file,
    sep = "\t",
    quote = FALSE,
    row.names = FALSE
  )
  
  return(results_table)
}

############################################################
# 4. Define gene groups
############################################################

# All differentially expressed genes
de_all <- res$padj < 0.05 & abs(res$log2FoldChange) > log2(1.5)

# Up-regulated genes only
de_up <- res$padj < 0.05 & res$log2FoldChange > log2(1.5)

# Down-regulated genes only
de_down <- res$padj < 0.05 & res$log2FoldChange < -log2(1.5)

############################################################
# 5. Run topGO and save results
############################################################

results_all <- run_topgo(
  de_all,
  "topGO_results_BP_all_DE.txt"
)

results_up <- run_topgo(
  de_up,
  "topGO_results_BP_upregulated.txt"
)

results_down <- run_topgo(
  de_down,
  "topGO_results_BP_downregulated.txt"
)

############################################################
# 6. View top results in R
############################################################

head(results_all)
head(results_up)
head(results_down)