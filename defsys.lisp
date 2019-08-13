(ql:quickload "esrap")
(ql:quickload "macroexpand-dammit")

(defsystem peg-test (:optimize ((speed 0) (space 0) (safety 3) (debug 3)))
  :members (
            "package"
            "peg"
            "macro"
            "parser"
            "main"
            )
  :rules ((:compile :all (:requires (:load :previous)))))
