(in-package :cl-peg)

(defparameter *peg-package* "TEST-GRAMMAR")

(defmacro @loop (&body body) `(loop ,@body))
(defmacro @exit-when (expr) `(when ,expr (return)))

(defmacro into-package (id)
  `(in-package
    ,(cond ((stringp id)
            (setf *peg-package* (find-package id))
            id)
           ((keywordp id)
            (setf *peg-package* (find-package (symbol-name id)))
            (symbol-name id))
           ((packagep id)
            (setf *peg-package* id)
            (cl:package-name id))
           (t
            (error "bad argument for cl-peg:into-package, need string/keyword/package")
            id))))

(defun peg-package () *peg-package*)

(defmacro rule (id rulestr &body body)
  "parse the rule to be added using the PEG grammar"
  ;; this results in an esrap sexpr that creates the new rule 
  ;; in the package *peg-package*
  (let ((esrap-syntax (esrap:parse 'peg-grammar:peg rulestr)))
    `(esrap:defrule ,id ,esrap-syntax ,@body)))

(defmacro fullpeg (rules-str)
  `(esrap:parse 'PG:PEGGRAMMAR ,rules-str))

(defmacro multiple-rules (&body body)
  "parse multiple PEG rules as triplets (name string body)"
  (let ((form nil))
    (@loop
     (@exit-when (null body))
     (when (>= (length body) 3)
       (let ((id (pop body)))
         (let ((rulestr (pop body)))
           (let ((sexpr (pop body)))
             (push `(esrap:defrule ,id ,(esrap:parse 'peg-grammar:peg rulestr) ,sexpr)
                   form))))))
    (cons 'progn form)))

(defmacro parse (sym string-to-be-parsed)
  "rulenamestr is a string ; the starting rule"
  (assert (symbolp sym))  ;; dont quote the sym in cl-peg:parse
  `(esrap:parse ',sym ,string-to-be-parsed))


