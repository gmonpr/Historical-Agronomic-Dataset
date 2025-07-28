# Data Processing Scripts for Historical Dataset

This repository contains R scripts developed to preprocess and standardize the historical dataset accessible via the provided link. While the link is available in the repository’s About section, it is also included here for ease of reference.
(https://data.cimmyt.org/dataset.xhtml?persistentId=hdl:11529/10548986).

## Files Included

   **Standardization_&_translation.R**
   
This script includes the following preprocessing steps:
- Standardization of Spanish terms: Ensures consistent terminology across the dataset by homogenizing variations in Spanish-language entries.
- Numerical variable transformations: Applies value ranges to selected numerical variables, where applicable.
- Translation to English: Translates standardized Spanish content into English for broader accessibility and analysis.

 **Dataset_joins.R**

This script demonstrates how to merge multiple sheets from the historical dataset. These sheets are originally provided separately and need to be joined into a single, unified dataset for analysis, according to the type of information required to be worked with.
