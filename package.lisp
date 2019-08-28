(defpackage :peg
  (:use :cl)
  (:export
   #:into-package
   #:rule
   #:multiple-rules
   #:parse
   #:peg-package
   ))

(defpackage :PEG-GRAMMAR
  (:use :cl)
  (:nicknames "PG")
  (:export
   #:peg))

(defpackage :test-grammar
  (:use :cl))

