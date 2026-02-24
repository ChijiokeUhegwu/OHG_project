# install and load the packages ----
if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, janitor)


# Import and standardize the metadata 
metadata <- read_csv("scripts/OHG Project Metadata.csv")
metadata_clean <- metadata %>%
  rename(sample_id = Assembly) %>%   # align naming with the abricate tables
  mutate(
    Collection_year = as.integer(Collection_year),
    Isolation_source = str_to_lower(Isolation_source),
    Isolation_type = str_to_lower(Isolation_type)
  ) %>%
  distinct(sample_id, .keep_all = TRUE)   

# standardize column names
metadata_clean <- clean_names(metadata_clean) 

# Read the resfinder results data into R ----
resfinder <- list.files("abricate_results/resfinder/", pattern = "*.tsv", full.names = TRUE)
# Read and merge, forcing all columns to character type
resfinder_data <- resfinder %>% 
  map_dfr(~read_tsv(.x, col_types = cols(.default = "c"))) %>%
  type.convert(as.is = TRUE)

# filter for high coverage and select relevant columns
resfinder_cleandata <- resfinder_data %>%
  filter(`%COVERAGE` >= 90, `%IDENTITY` >= 90) %>%
  mutate(`#FILE` = basename(`#FILE`), # Removes the directory path automatically
         `#FILE` = str_extract(`#FILE`, "GCA_\\d+\\.\\d+")) %>% # Extracts the ID, the dot, and the digit after the dot 
  select(
    sample_id = `#FILE`,
    gene = GENE,
    product = PRODUCT,
    drug_class = RESISTANCE
  ) %>%
  distinct()

# Merge AMR(Resfinder) with metadata ----
resfinder_full <- resfinder_cleandata %>%
  left_join(metadata_clean, by = "sample_id")

# Standardize all column names to lowercase in the dataset
colnames(resfinder_full) <- tolower(colnames(resfinder_full))
#clean_names(resfinder_full) # or use the clean_names() function from the janitor package to standardize to lowercase/snake_case
summary(resfinder_full)


# classify the unmapped drug class; all instnaces of is.na(drug_class) into "Unclassified" or "No annotation"
resfinder_fulldata <- resfinder_full %>%
  mutate(
    drug_class = if_else(is.na(drug_class),
                         "Unclassified",
                         drug_class)
  ) %>%
  # Group individual antimicrobial agents reported by ResFinder into higher-level antimicrobial classes based on shared mechanisms of action.
  separate_rows(drug_class, sep = ";") %>%
  mutate(
    drug_class_group = case_when(
      str_detect(drug_class, "Amoxicillin|Ampicillin|Cef|Ceph|Piperacillin|Ticarcillin|Aztreonam") ~ "Beta-lactams",
      str_detect(drug_class, "Tetracycline|Doxycycline") ~ "Tetracyclines",
      str_detect(drug_class, "Ciprofloxacin") ~ "Fluoroquinolones",
      str_detect(drug_class, "Colistin") ~ "Polymyxins",
      str_detect(drug_class, "Chloramphenicol|Florfenicol") ~ "Phenicols",
      drug_class == "Unclassified" ~ "Unclassified",
      TRUE ~ "Other"
    )
  )

# save the clean data as csv
write_csv(resfinder_fulldata, "outputs/resfinder_fulldata.csv")