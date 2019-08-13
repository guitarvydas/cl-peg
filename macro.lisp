(in-package :peg)

(defparameter *peg-package* "TEST-GRAMMAR")

(defmacro into-package (id)
  `(cond ((stringp ,id)
          (setf *peg-package* (find-package ,id)))
         ((keywordp ,id)
          (setf *peg-package* (find-package (symbol-name ,id))))
         ((packagep ,id)
          (setf *peg-package* ,id))
         (t
          (error "bad argument for peg:into-package, need string/keyword/package"))))

(defun peg-package () *peg-package*)

(defmacro rules (id rulestr &body body)
  "parse the rule to be added using the PEG grammar"
  ;; this results in an esrap sexpr that creates the new rule 
  ;; in the package *peg-package*
  (let ((esrap-syntax (esrap:parse 'peg-grammar:peg rulestr)))
    `(esrap:defrule ,id ,esrap-syntax ,@body)))
;      `(esrap:defrule ,id ,esrap-syntax ,@body))))

(defmacro parser (sym string-to-be-parsed)
  "rulenamestr is a string ; the starting rule"
  `(esrap:parse ',sym ,string-to-be-parsed))


