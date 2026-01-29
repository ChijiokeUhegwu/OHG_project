#!/usr/bin/env bash

# Exit on error
set -euo pipefail

# load path variables
source 01_config.sh

echo "Downloading assemblies from NCBI..."

# Download all assemblies listed in the accession file
datasets download genome accession \
  --inputfile "$ACCESSION_FILE" \
  --include genome \
  --filename "$ZIP_DIR/ncbi_dataset.zip"

echo "Download complete, ready for unzip."

echo "Unzipping assemblies..."
unzip -o "$ZIP_DIR/ncbi_dataset.zip" -d "$ZIP_DIR"

echo "Extracting FASTA files..."
cp "$ZIP_DIR"/ncbi_dataset/data/*/*.fna "$ASSEMBLY_DIR"

echo "All assemblies are ready in assembled_genome/"

