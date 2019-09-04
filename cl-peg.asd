(defsystem "cl-peg"
  :depends-on ("esrap")
  :components ((:module "source"
                        :serial t 
                        :pathname "./"
                        :components ((:file "package")
                                     (:file "peg")
                                     (:file "macro")))))
