(defsystem :cl-peg
  :depends-on (:esrap)
  :components ((:module "source"
                        :serial t 
                        :pathname "./"
                        :components ((:file "package")
                                     (:file "macro")
                                     (:file "peg")
                                     (:file "util")))))

(defsystem "cl-peg/test"
  :depends-on (:cl-peg)
  :components ((:module "source"
                        :serial t 
                        :pathname "./"
                        :components (
				     (:file "simple-test")
				     (:file "not-bug")))))
