(defsystem "peg-test"
  :depends-on ("esrap")
  :components ((:module "source"
                        :serial t 
                        :pathname "./"
                        :components ((:file "package")
                                     (:file "peg")
                                     (:file "macro")
                                     (:file "parser")
                                     (:file "parser2")
                                     (:file "parser3")
                                     (:file "parser4")
                                     (:file "parser5")
				     (:file "main")))))
