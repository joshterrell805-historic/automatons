# The Merging Process (overview)
- Compute an independent (of all other records) value for each column used to
  cluster the records
- Use closest pair to cluster the records based on the independently calculated
  values and some threshold
- Run n^2 algorithm on clusters to determine matches
