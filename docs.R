# Make list of of files from machine learning journal
files <- list.files('./clean')


docs <- c()
for (i in files) {
  a <- readLines(paste('./clean/', i, sep = ''))
  docs <- c(docs, paste(a[20:360], sep = ' ', collapse = ''))
} 

docs <- as.list(docs)
names(docs) <- files


tfidf.matrix <- index(docs)
search('latent', tfidf.matrix, docs, F)

# Figure out a better way to handle search, right now it has side effects
# of print, should return the results.

