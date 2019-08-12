(peg:into-package :grammar-test)

(peg:rules "Top <- Three-x Second Three-y")

(peg:rules "Second <-'abc'")

(peg:rules "Three-x <- X X X")

(peg:rules "X <- 'x'")

(peg:rules "Three-y <- Y Y Y")

(peg:rules "Y <- 'y'")

