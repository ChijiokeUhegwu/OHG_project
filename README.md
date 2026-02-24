# One Health Comparative Genomics of *Escherichia coli* Isolates: Tracking Regional AMR Burden and Emerging Genetic Determinants Across Nine Nations (2018–2022)

![dashboard_overview](outputs/dashboard_overview.jpeg)


## Project Overview

This project provides an integrated genomic analysis of Antimicrobial Resistance (AMR) across human, animal, and environmental sectors. By analyzing 100 isolates of *E. coli* from nine countries, the study aimed to map the global distribution of critical resistance genes and identify emerging "unclassified" resistance reservoirs.
The study follows a One Health framework to highlight how antibiotic pressure in one sector (such as poultry) directly influences the resistance profiles found in human clinical settings.

## Study Scope

- Data Timeframe: 2018–2022

- Geographic Reach: Argentina, Brazil, New Zealand, China, France, Germany, Nigeria, UK, and USA.

- Isolate Source: NCBI Pathogen Detection Portal.

- Target Species: *Escherichia coli* and *Shigella*.

## Methodology & Workflow

The analysis pipeline spans from raw genomic data screening on Linux to visualization on R. A total of 100 assembled isolates were retrieved from NCBI Pathogen Detection. Identification of AMR genes was done using ResFinder. Data cleaning/Wrangling was done using the tidyverse package on R. Bar Charts, Heatmaps, and Temporal Trend Plots were generated using ggplot2.

## Key Findings

- Human clinical isolates carry the highest AMR gene burden, followed closely by poultry.

- China and Nigeria emerged as high-intensity MDR hotspots, while South American and New Zealand isolates showed high levels of unclassified resistance mechanisms.

- Read the full report  [here](https://chijiokeuhegwu.github.io/OHG_project/05_report.html)

- View the dashboard [here](https://chijiokeuhegwu.github.io/OHG_project/)

## How to Use This Repository

- /abricate_results: Contains the raw files derived from ResFinder.

- /docs: Includes the .Rmd file for data analysis and the Linux commands for ResFinder.

- /outputs: High-resolution versions of the Figure 1–8 discussed in the report and the cleaned .csv file.

