(ql:quickload "esrap")

(defsystem peg-test (:optimize ((speed 0) (space 0) (safety 3) (debug 3)))
  :members (
            "package"
            "peg"
            "macro"
            "parser2"
            "parser3"
            "parser4"
            "parser5"
            "main"
            )
  :rules ((:compile :all (:requires (:load :previous)))))
