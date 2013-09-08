# Create text data.
doc1 <- "Stray cats are running all over the place. I see 10 a day!"
doc2 <- "Cats are killers. They kill billions of animals a year."
doc3 <- "The best food in Columbus, OH is   the North Market."
doc4 <- "Brand A is the best tasting cat food around. Your cat will love it."
doc5 <- "Buy Brand C cat food for your cat. Brand C makes healthy and happy cats."
doc6 <- "The Arnold Classic came to town this weekend. It reminds us to be healthy."
doc7 <- "I have nothing to say. In summary, I have told you nothing."
doc8 <- "THIS IS ALL CAPS, DOES IT PICK UP"


doc.list <- list(doc1, doc2, doc3, doc4, doc5, doc6, doc7, doc8)
rm(doc1, doc2, doc3, doc4, doc5, doc6, doc7, doc8)
N.docs <- length(doc.list)
names(doc.list) <- paste("doc", c(1:N.docs), sep = '')

tfidf <- function(tfidf.row) {
  term.df <- sum(tfidf.row[1:N.docs] > 0)
  weight <- rep(0, N.docs + 1)
  weight[tfidf.row > 0] <- (1 + log2(tfidf.row[tfidf.row > 0])) * log2(N.docs/term.df)
  return(weight)
}

query <- 'misc cat food'
# query <- "Healthy cat food"

library(tm)
library(SnowballC)
  
search <- function(query) {
  if (query == '') print ("Input Text")
  else {

  my.docs <- VectorSource(c(doc.list, query = query))

  my.corpus <- Corpus(my.docs)
  my.corpus <- tm_map(my.corpus, tolower)
  my.corpus <- tm_map(my.corpus, removePunctuation)
  my.corpus <- tm_map(my.corpus, stemDocument)
  my.corpus <- tm_map(my.corpus, removeNumbers)
  my.corpus <- tm_map(my.corpus, stripWhitespace)

  term.doc.matrix <- as.matrix(TermDocumentMatrix(my.corpus))
  
  # Kill row where word only appears in query.
  term.doc.matrix <- term.doc.matrix[rowSums(term.doc.matrix[, 1:N.docs]) > 0, ]

  tfidf.matrix <- t(apply(term.doc.matrix, c(1), FUN = tfidf))
  colnames(tfidf.matrix) <- colnames(term.doc.matrix)

  tfidf.matrix <- scale(tfidf.matrix, center = FALSE, 
                      scale = sqrt(colSums(tfidf.matrix^2)))

  query.vector <- tfidf.matrix[, (N.docs + 1)]
  tfidf.matrix <- tfidf.matrix[, 1:N.docs]

  doc.scores <- t(query.vector) %*% tfidf.matrix

  results.df <- data.frame(doc = names(doc.list), score = t(doc.scores), text = unlist(doc.list))
  results.df <- results.df[order(results.df$score, decreasing = TRUE), ]
  results.df <- results.df[results.df$score > 0, ]

  options(width = 2000)
  print(results.df, row.names = FALSE, right = FALSE, digits = 2)
  }
}
