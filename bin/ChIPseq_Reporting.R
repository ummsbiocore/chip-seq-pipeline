#!/usr/bin/env Rscript
# This script is used to generate a report for ChIP-seq data analysis.
# Usage: Rscript chipseq_report.r <sample_id> <total_reads> <cleaned_reads> <aligned_reads> <unique_reads> <alignment_rate> <enriched_regions> <peaks_identified>

args <- commandArgs(trailingOnly = TRUE)

if (require("tidyverse") == FALSE) {
  install.packages("tidyverse", repos = "http://cran.us.r-project.org")
  library(tidyverse)
}
if (require("readr") == FALSE) {
  install.packages("readr", repos = "http://cran.us.r-project.org")
  library(readr)
}
if (require("stringr") == FALSE) {
  install.packages("stringr", repos = "http://cran.us.r-project.org")
  library(stringr)
}
if (require("dplyr") == FALSE) {
  install.packages("dplyr", repos = "http://cran.us.r-project.org")
  library(dplyr)
}
if (require("tidyr") == FALSE) {
  install.packages("tidyr", repos = "http://cran.us.r-project.org")
  library(tidyr)
}
if (require("rmarkdown") == FALSE) {
  install.packages("rmarkdown", repos = "http://cran.us.r-project.org")
  library(rmarkdown)
}
if (require("scales") == FALSE) {
  install.packages("scales", repos = "http://cran.us.r-project.org")
  library(scales)
}
if (require("rsvg") == FALSE) {
  install.packages("rsvg", repos = "http://cran.us.r-project.org")
  library(rsvg)
}
if (require("ggnewscale") == FALSE) {
  install.packages("ggnewscale", repos = "http://cran.us.r-project.org")
  library(ggnewscale)
}
if (require("ggplot2") == FALSE) {
  install.packages("ggplot2", repos = "http://cran.us.r-project.org")
  library(ggplot2)
}
if (require("ggrepel") == FALSE) {
  install.packages("ggrepel", repos = "http://cran.us.r-project.org")
  library(ggrepel)
}
if (require("grid") == FALSE) {
  install.packages("grid", repos = "http://cran.us.r-project.org")
  library(grid)
}
if (require("gridExtra") == FALSE) {
  install.packages("gridExtra", repos = "http://cran.us.r-project.org")
  library(gridExtra)
}
if (require("kableExtra") == FALSE) {
  install.packages("kableExtra", repos = "http://cran.us.r-project.org")
  library(kableExtra)
}
if (require("htmltools") == FALSE) {
  install.packages("htmltools", repos = "http://cran.us.r-project.org")
  library(htmltools)
}

id <- args[2]
genome_build <- args[3] # "mouse_mm39_gencode_m36"
host       <- sub("_.*$", "", genome_build)          # "mouse"
annotation <- sub("^[^_]*_", "", genome_build)       # "mm39_gencode_m36"
mate <- args[4]
peak_calling_type <- args[5]

# Get the tables for stats
overall_df <- read.csv("report/summary/overall_summary.tsv", sep = "\t", header = TRUE)
peaks_df <- read.csv(paste0("report/bed/", id, "_peaks.", peak_calling_type, "Peak"), sep = "\t", header = FALSE)
annot_path <- paste0("report/annotated_peaks/", id, "_annotated_peaks.txt")

if (file.exists(annot_path)) {
  annot_df <- read.csv(annot_path, sep = "\t", header = TRUE)

  annot_df$Peak.Length <- abs(annot_df$End - annot_df$Start) + 1
  annot_df$Peak.Type <- vapply(annot_df$Annotation, function(x) strsplit(x, " ")[[1]][1], character(1))
} else {
  message("[WARN] Missing annotated peaks file: ", annot_path, " — continuing without annotation section.")

  # Placeholder with expected columns
  annot_df <- data.frame(
    Start = integer(0),
    End = integer(0),
    Annotation = character(0),
    Peak.Length = numeric(0),
    Peak.Type = character(0),
    stringsAsFactors = FALSE
  )
}

# Extract fastqc_data.txt from zip
# Path to the FastQC zip
if (mate == "single") {
  zip_path <- paste0("report/qc/", id, "_fastqc.zip")
} else {
  zip_path <- paste0("report/qc/", id, ".R1_fastqc.zip")
}

# Discover inner files (robust to missing/corrupt zip)
safe_unzip_list <- function(path) {
  if (!file.exists(path)) {
    message("[WARN] FastQC zip not found: ", path, " — skipping FastQC-derived QC metrics.")
    return(NULL)
  }
  tryCatch(utils::unzip(path, list = TRUE),
           error = function(e) {
             message("[WARN] FastQC zip cannot be opened: ", path, " — skipping FastQC-derived QC metrics. (", conditionMessage(e), ")")
             NULL
           })
}

zinfo <- safe_unzip_list(zip_path)
inner_data <- character(0)
if (!is.null(zinfo) && ("Name" %in% names(zinfo))) {
  inner_data <- zinfo$Name[grepl("fastqc_data.txt$", zinfo$Name)]
}

# Read fastqc_data.txt lines
con <- NULL
lines <- tryCatch({
  if (!length(inner_data)) stop("fastqc_data.txt not found in zip")
  con <- unz(zip_path, inner_data[1])
  readLines(con, warn = FALSE)
}, error = function(e) {
  message("Failed to read fastqc_data.txt: ", conditionMessage(e))
  character(0)
}, finally = {
  if (!is.null(con) && inherits(con, "connection") && isOpen(con)) close(con)
})

# Parse 'Basic Statistics' block into data frame
basic_stats_df <- data.frame(Measure = character(0), Value = character(0), stringsAsFactors = FALSE)
if (length(lines)) {
  start <- which(grepl("^>>Basic Statistics", lines))
  if (length(start)) {
    # find the next >>END_MODULE after start
    end <- which(lines == ">>END_MODULE")
    end <- end[end > start[1]]
    if (length(end)) {
      block <- lines[(start[1] + 1):(end[1] - 1)]
      tc <- NULL
      basic_stats_df <- tryCatch({
        tc <- textConnection(paste(block, collapse = "\n"))
        tab <- utils::read.delim(tc, sep = "\t", header = TRUE, check.names = FALSE, stringsAsFactors = FALSE)
        # Normalize column names so downstream indexing is stable
        if (ncol(tab) >= 2) {
          names(tab)[1:2] <- c("Measure", "Value")
        }
        tab
      }, error = function(e) {
        message("Failed to parse Basic Statistics: ", conditionMessage(e))
        data.frame(Measure = character(0), Value = character(0), stringsAsFactors = FALSE)
      }, finally = {
        if (!is.null(tc)) close(tc)
      })
    }
  }
  rm(tc, block, start, end)
}

gc_content <- suppressWarnings(as.numeric(basic_stats_df$Value[basic_stats_df$Measure == "%GC"]))

tot_bases <- NA_real_
avg_length  <- NA_real_
q20_reads <- NA_integer_
q30_reads <- NA_integer_
q20_rate  <- NA_real_
q30_rate  <- NA_real_
q20_bases_approx <- NA_real_
q30_bases_approx <- NA_real_
total_seqs <- suppressWarnings(as.numeric(basic_stats_df$Value[basic_stats_df$Measure == "Total Sequences"]))
if (length(total_seqs) == 0) total_seqs <- NA_real_

start <- which(grepl("^>>Sequence Length Distribution", lines))
if (length(start)) {
  end <- which(lines == ">>END_MODULE"); end <- end[end > start[1]][1]
  if (!is.na(end) && end > start[1] + 1) {
    block <- lines[(start[1] + 1):(end - 1)]
    block <- block[nzchar(block)]
    block <- sub("^#", "", block) # strip leading '#' from header

    tc <- textConnection(paste(block, collapse = "\n"))
    df <- try(utils::read.delim(tc, sep = "\t", header = TRUE, stringsAsFactors = FALSE), silent = TRUE)
    close(tc)

    if (!inherits(df, "try-error") && all(c("Length", "Count") %in% names(df))) {
      df$Length <- as.numeric(df$Length)
      df$Count  <- as.numeric(df$Count)
      tot_bases <- sum(df$Length * df$Count, na.rm = TRUE)
      avg_length  <- if (total_seqs > 0) tot_bases / total_seqs else NA_real_
    }
  }
}

clean_seqs <- as.numeric(overall_df[overall_df$Sample == id, "Reads.After.Adapter.Removal"])
overall_total_reads <- suppressWarnings(readr::parse_number(as.character(overall_df[overall_df$Sample == id, "Total.Reads"])))
if (length(overall_total_reads) == 0) overall_total_reads <- NA_real_

if (length(lines)) {
  ps_start <- which(grepl("^>>Per sequence quality scores", lines))
  if (length(ps_start)) {
    ps_end_all <- which(lines == ">>END_MODULE")
    ps_end <- ps_end_all[ps_end_all > ps_start[1]][1]
    if (!is.na(ps_end) && ps_end > ps_start[1] + 1) {
      ps_block <- lines[(ps_start[1] + 1):(ps_end - 1)]
      ps_block <- ps_block[nzchar(ps_block)]
      ps_block <- sub("^#", "", ps_block) # remove leading '#' in header

      tc_ps <- textConnection(paste(ps_block, collapse = "\n"))
      ps_df <- try(utils::read.delim(tc_ps, sep = "\t", header = TRUE, stringsAsFactors = FALSE), silent = TRUE)
      close(tc_ps)

      if (!inherits(ps_df, "try-error") && all(c("Quality", "Count") %in% names(ps_df))) {
        ps_df$Quality <- as.numeric(ps_df$Quality)
        ps_df$Count   <- as.numeric(ps_df$Count)

        total_reads_calc <- sum(ps_df$Count, na.rm = TRUE) # should equal total_seqs
        q20_reads <- sum(ps_df$Count[ps_df$Quality >= 20], na.rm = TRUE)
        q30_reads <- sum(ps_df$Count[ps_df$Quality >= 30], na.rm = TRUE)

        denom <- if (!is.na(total_seqs)) total_seqs else total_reads_calc
        if (!is.na(denom) && denom > 0) {
          q20_rate <- round(q20_reads / denom, 4) * 100
          q30_rate <- round(q30_reads / denom, 4) * 100
        }

        # Optional approximation for bases (assumes uniform read length = avg_length)
        if (!is.na(avg_length)) {
          q20_bases_approx <- q20_reads * avg_length
          q30_bases_approx <- q30_reads * avg_length
        }
      }
    }
  }
}

aligned_multi <- as.numeric(overall_df$`Multimapped.Reads.Aligned..Bowtie2.`[overall_df$Sample == id])
aligned_unique <- as.numeric(overall_df$`Unique.Reads.Aligned..Bowtie2.`[overall_df$Sample == id])
aligned_reads <- as.numeric(aligned_unique + aligned_multi)
aligned_unmapped <- if (!is.na(overall_total_reads)) as.numeric(overall_total_reads) - as.numeric(aligned_reads) else as.numeric(total_seqs) - as.numeric(aligned_reads)

rmd_path    <- normalizePath(args[1], winslash = "/", mustWork = FALSE)
report_dir  <- dirname(rmd_path)
project_dir <- normalizePath(file.path(report_dir, ".."), winslash = "/", mustWork = FALSE)

has_annot <- nrow(annot_df) > 0

peaks_len_mean   <- if (has_annot) round(mean(annot_df$Peak.Length, na.rm = TRUE), 2) else NA_real_
peaks_len_median <- if (has_annot) median(annot_df$Peak.Length, na.rm = TRUE) else NA_real_
peaks_len_min    <- if (has_annot) min(annot_df$Peak.Length, na.rm = TRUE) else NA_real_
peaks_len_max    <- if (has_annot) max(annot_df$Peak.Length, na.rm = TRUE) else NA_real_

# Helper to compute bases/count/rate for a given Peak.Type label
type_stats <- function(label) {
  if (!has_annot) return(list(bases="0", cnt=0L, rate=0))
  idx <- annot_df$Peak.Type == label
  cnt <- sum(idx, na.rm = TRUE)
  bases <- sum(annot_df$Peak.Length[idx], na.rm = TRUE)
  rate <- if (nrow(annot_df) > 0) round(cnt / nrow(annot_df), 3) * 100 else 0
  list(bases=as.character(bases), cnt=as.integer(cnt), rate=rate)
}

exon      <- type_stats("exon")
intron    <- type_stats("intron")
interg    <- type_stats("Intergenic")
tts_all   <- type_stats("TTS")
tss_all   <- type_stats("promoter-TSS")
noncoding <- type_stats("non-coding")
otherNA   <- type_stats("NA")
utr5      <- type_stats("5' UTR")
utr3      <- type_stats("3' UTR")



# Set the parameter list
param_list <- list(sample_id = id,
                   host_genome = host,
                   annotation_version = annotation,
                   mode = ifelse(mate == "pair", "Paired-End", "Single-End"),
                   peak_type = peak_calling_type,
                   total_reads = as.character(overall_total_reads),
                   cleaned_reads = ifelse(is.null(clean_seqs), "0", as.character(clean_seqs)),
                   unique_reads = as.character(overall_df[overall_df$Sample == id, "Total.Reads"]),
                   total_bases = as.character(tot_bases),
                   cleaned_bases = as.character(clean_seqs * avg_length),
                   aligned_reads = as.character(aligned_reads),
                   aligned_unique = as.character(aligned_unique),
                   aligned_multi = as.character(aligned_multi),
                   aligned_unmapped = as.character(aligned_unmapped),
                   pairs_rate = 0,
                   q20_raw_rate = q20_rate,
                   q30_raw_rate = q30_rate,
                   q20_clean_rate = q20_rate,
                   q30_clean_rate = q30_rate,
                   gc_content_raw = gc_content,
                   gc_content_clean = gc_content,
                   alignment_rate = round(as.numeric(overall_df$`Unique.Reads.Aligned..Bowtie2.`[overall_df$Sample == id] + overall_df$`Multimapped.Reads.Aligned..Bowtie2.`[overall_df$Sample == id]) / as.numeric(overall_df$Total.Reads[overall_df$Sample == id]), 4) * 100,
                   aligned_unique_rate = round(as.numeric(overall_df$`Unique.Reads.Aligned..Bowtie2.`[overall_df$Sample == id]) / as.numeric(overall_df$Total.Reads[overall_df$Sample == id]), 4) * 100,
                   aligned_multi_rate = round(as.numeric(overall_df$`Multimapped.Reads.Aligned..Bowtie2.`[overall_df$Sample == id]) / as.numeric(overall_df$Total.Reads[overall_df$Sample == id]), 4) * 100,
                   aligned_unmapped_rate = round(as.numeric(as.numeric(overall_df$Total.Reads[overall_df$Sample == id] - as.numeric(overall_df$`Unique.Reads.Aligned..Bowtie2.`[overall_df$Sample == id] + overall_df$`Multimapped.Reads.Aligned..Bowtie2.`[overall_df$Sample == id]))) / as.numeric(overall_df$Total.Reads[overall_df$Sample == id]), 4) * 100,
                   peaks_identified = as.numeric(nrow(peaks_df)),
                   
                   mean_peak_signal = round(as.numeric(mean(peaks_df$V7)), 2),
                   mean_qval = round(as.numeric(mean(peaks_df$V9)), 2),
                   genes_annotated = 0,
                   go_terms = 0,
                   kegg_terms = 0,
                   enriched_terms = 0,
                   cds_exons_bases = exon$bases,
  peaks_len_mean   = peaks_len_mean,
  peaks_len_median = peaks_len_median,
  peaks_len_min    = peaks_len_min,
  peaks_len_max    = peaks_len_max,
  cds_exons_cnt   = exon$cnt,
  cds_exons_rate  = exon$rate,

  introns_bases = intron$bases,
  introns_cnt   = intron$cnt,
  introns_rate  = intron$rate,

  intergenic_bases = interg$bases,
  intergenic_cnt   = interg$cnt,
  intergenic_rate  = interg$rate,

  tts_all_bases = tts_all$bases,
  tts_all_cnt   = tts_all$cnt,
  tts_all_rate  = tts_all$rate,

  tss_all_bases = tss_all$bases,
  tss_all_cnt   = tss_all$cnt,
  tss_all_rate  = tss_all$rate,

  noncoding_bases = noncoding$bases,
  noncoding_cnt   = noncoding$cnt,
  noncoding_rate  = noncoding$rate,

  other_bases = otherNA$bases,
  other_cnt   = otherNA$cnt,
  other_rate  = otherNA$rate,

  utr5_exons_bases = utr5$bases,
  utr5_exons_cnt   = utr5$cnt,
  utr5_exons_rate  = utr5$rate,

  utr3_exons_bases = utr3$bases,
  utr3_exons_cnt   = utr3$cnt,
  utr3_exons_rate  = utr3$rate,
  tss_up1kb_bases = 0, # these are from rseqc results
                   tss_up1kb_cnt = 0, # and not used in the report.
                   tss_up1kb_rate = 0, # these are here to show that
                   tss_up5kb_bases = 0, # they are obtainable through
                   tss_up5kb_cnt = 0, # the pipeline.
                   tss_up5kb_rate = 0, # these are here so that
                   tss_up10kb_bases = 0, # one day they may be
                   tss_up10kb_cnt = 0, # implemented in the report.
                   tss_up10kb_rate = 0,
                   tts_down1kb_bases = 0,
                   tts_down1kb_cnt = 0,
                   tts_down1kb_rate = 0,
                   tts_down5kb_bases = 0,
                   tts_down5kb_cnt = 0,
                   tts_down5kb_rate = 0,
                   tts_down10kb_bases = 0,
                   tts_down10kb_cnt = 0,
                   tts_down10kb_rate = 0,
                   bigwig_file_size = if (file.exists(paste0("report/outputs/bigwig/", id, ".bw"))) paste(round(file.info(paste0("report/outputs/bigwig/", id, ".bw"))$size / 1024^2, 2), "MB") else "N/A",
                   bigwig_file_ready = ifelse(file.exists(paste0("report/outputs/bigwig/", id, ".bw")), "Ready", "Unavailable"),
                   peak_path = paste0("report/bed/", id, "_peaks.", peak_calling_type, "Peak"),
                   annot_path = annot_path,
                   motif_path = paste0("report/homer_motifs/", id, "_motifs/nonRedundant.motifs"),
                   peakHeatmapPath = file.path("report","bigwig", paste0(id, "_heatmap.png")),        
                   motif1Path = file.path("report","homer_motifs", paste0(id, "_motifs/homerResults/motif1.logo.svg")),
                   motif2Path = file.path("report","homer_motifs", paste0(id, "_motifs/homerResults/motif2.logo.svg")),
                   motif3Path = file.path("report","homer_motifs", paste0(id, "_motifs/homerResults/motif3.logo.svg")),
                   poweredby = args[8],
                   poweredbylogo = args[7],
                   company_link = args[9],
                   company_email = args[10],
                   company_name = args[11],
                   rmd_dir = report_dir,
                   clogo = args[6],
                   company_message = args[12],
                   analysisid = args[13])
                   
# --- Debug prints ---
cat("\n[DEBUG] getwd()               :", getwd(), "\n")
cat("[DEBUG] args[1] (raw)         :", args[1], "\n")
cat("[DEBUG] rmd_path (norm)       :", rmd_path, "  exists? ", file.exists(rmd_path), "\n")
cat("[DEBUG] report_dir            :", report_dir, "  exists? ", dir.exists(report_dir), "\n")
cat("[DEBUG] project_dir (parent)  :", project_dir, "  exists? ", dir.exists(project_dir), "\n")

fmt <- rmarkdown::html_document(
  self_contained = TRUE,
  pandoc_args = c(
    sprintf("--resource-path=%s", paste(c(project_dir, report_dir), collapse=":"))
  )
)

render(rmd_path,  output_format  = fmt, output_dir = report_dir, output_file = paste0("ChIP-seq_Report_", id, ".html"), params = param_list, knit_root_dir = project_dir, envir  = new.env(parent = globalenv()))
