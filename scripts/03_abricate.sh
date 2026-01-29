#!/usr/bin/env bash
set -euo pipefail

# Load config
source 01_config.sh

# Databases to run
DBS=("resfinder" "vfdb" "ecoli_vf")

echo "Starting Abricate analysis..."

for db in "${DBS[@]}"; do
  echo "Running database: $db"
  mkdir -p "$ABRICATE_DIR/$db"

  for genome in "$ASSEMBLY_DIR"/*.fna; do
    sample=$(basename "$genome" .fna)

    abricate --db "$db" "$genome" \
      > "$ABRICATE_DIR/$db/${sample}_${db}.tsv"
  done
done

echo "Abricate analysis completed successfully."

