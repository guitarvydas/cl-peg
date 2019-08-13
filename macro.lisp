(in-package :peg)

(defmacro into-package (pkg)
  ;; tbd
  (declare (ignore pkg))
  nil)

(defmacro rules (rulestr &body body)
  "parse the rule to be added using the PEG grammar"
  ;; this results in an esrap sexpr that creates the new rule 
  ;; in the package :new-grammar
  `(let ((*package* (find-package "NEW-GRAMMAR")))
     ,(macroexpand-dammit:macroexpand-dammit (macroexpand (esrap:parse 'peg-grammar:peg rulestr)))))

(defmacro parser (sym string-to-be-parsed)
  "rulenamestr is a string ; the starting rule"
  `(esrap:parse ',sym ,string-to-be-parsed))


