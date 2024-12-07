# Nanopore DNA Data Analysis for ATRX Knockdown and Methylation & Structural Variant (SV) Detection

## Project Overview

This project utilizes Nanopore long-read sequencing data to investigate the effects of ATRX gene knockdown on the methylation and structural variations (SVs) in human glioblastoma cells. The analysis includes four groups of data: control, ATRX knockdown at 0 days, 7 days, and 16 days. The primary aim is to explore the dynamics of SVs, particularly in repetitive regions such as telomeres and centromeres, and their potential role in cancer development.

### Background

ATRX (Alpha Thalassemia/Mental Retardation X-linked) is a chromatin remodeling protein that plays a crucial role in maintaining the stability of genomic repetitive regions. ATRX deficiency has been linked to structural genomic alterations in various cancers, particularly glioblastoma. Long-read sequencing technologies like Nanopore sequencing are well-suited to detect complex structural variants (SVs), especially those in repetitive genomic regions.

## Datasets

The analysis involves four datasets:
1. **Control group**: Wild-type astrocyte cells.
2. **ATRX knockdown (Day 0)**: Astrocyte cells with ATRX knockdown at the start of culture.
3. **ATRX knockdown (Day 7)**: Astrocyte cells with ATRX knockdown after 7 days of culture.
4. **ATRX knockdown (Day 16)**: Astrocyte cells with ATRX knockdown after 16 days of culture.

## Objectives

The primary objectives of this project are:
- To investigate the structural variants (SVs) arising over time in ATRX knockdown cells.
- To analyze methylation changes associated with ATRX knockdown.
- To identify and annotate SVs, particularly those affecting repetitive regions in the genome.

## Tools & Versions

The following tools were used for data processing and analysis:
- **Samtools**: v1.17
- **Guppy (GPU version)**: v6.5.7
- **Bedtools**: v2.30.0
- **CuteSV**: v1.0.0

## Methodology

### Data Processing

1. **Basecalling**: Raw Nanopore sequencing data were basecalled using Guppy (v6.5.7) to generate fastq files.
2. **Alignment**: The basecalled reads were aligned to the human reference genome using Samtools, generating BAM files.
3. **SV Detection**: Structural variants (SVs) were detected using CuteSV, which identifies insertions, deletions, translocations, and other complex structural variants.
4. **SV Annotation**: SVs were annotated with RepeatMasker to identify their relationship to repetitive regions of the genome.

### Key Findings

1. **SV Accumulation Over Time**: The number of detected SVs increased in the ATRX knockdown group as the culture time progressed.
2. **SV Types**: The majority of SVs detected were insertions and deletions, with a smaller proportion of translocations and other complex SVs.
3. **Enrichment in Repetitive Regions**: Structural variants in the ATRX knockdown group were enriched in repetitive genomic regions:
   - **Day 7**: 64% of detected SVs affected repetitive sequences.
   - **Day 16**: 80% of SVs involved repetitive regions, with a significant proportion occurring in centromeric sequences (up to 30%).
4. **SV Evolution**: Over time, the proportion of SVs involving homologous sequences increased, especially in centromeric regions, suggesting a potential role for non-allelic homologous recombination in SV formation.
5. **SV Validation**: Single-cell clonal validation confirmed the presence of SVs detected in mixed clone samples. Variations in SV types and frequencies were observed in isolated clones, likely due to differences in ATRX knockdown efficiency.

### Conclusion

ATRX knockdown leads to a significant increase in structural variants, particularly in centromeric and other repetitive regions of the genome. This suggests that ATRX plays a crucial role in maintaining genomic stability, and its loss may contribute to the formation of structural variations that could drive cancer development.

## Code and Scripts

All analysis scripts were developed by Qinixia and are available in the `src/` directory of the repository. The project was conducted from July 2023 to December 2023.

## Contact

For questions or further collaboration inquiries, please contact Qinixia at qinixia77@gmail.com.

