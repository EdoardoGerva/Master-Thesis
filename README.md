# Thesis
My Thesis and related codes.

With **Data generator.ipynb** the data are read thank to PyPlink.

With **selecting-main-effects.R** the SNPs presenting main effects on the phenotype are selected.

Feature selection is then performed for ReliefF with the python code:
`./rebate.py -a relieff -c Y -T 100 -f complete_withAnswer.csv -k 100`

and for Episcan with the R code:
`episcan(data, pheno = class, phetype ="case-control", outfile = "episcan", suffix = ".txt", zpthres = 1e-06, chunksize = 1000, scale = TRUE)`.

In **Filtering.ipynb** feature selection and removal of main effects is preformed on the data.

**bootstrap-relief.R** and **bootstrap-episcan.R** are used to perform the bootstrap procedure on the filtered data.

**graphs.R** is the code used to produce images of the networks.

Finally, **gtbn-2-modified.R** is the modified version of **gtbn-2** function of Epi-GTBN. The modifications were made since the boolean function to compute mutual information, *mi.2*, was sensitive to the structure of the input dataset. The function was changed with the non boolean *mi*, already present in Epi-GTBN files. Following these changes, the structure learning algorithm is slower but more reliable.
