(peg:into-package :grammar-test)

(peg:rules "Top <- Three-x Abc Three-y")
(peg:rules "Abc <-'abc'")
(peg:rules "Three-x <- X X X")
(peg:rules "X <- 'x'")
(peg:rules "Three-y <- Y Y Y")
(peg:rules "Y <- 'y'")

