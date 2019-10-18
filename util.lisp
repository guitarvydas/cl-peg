(in-package :peg)

(defun delete-rules (pkg)
  "clear the rules of symbols in package pkg 
   relies on non-exported knowledge of esrap function delete-rule-cell"
  (do-symbols (sym (find-package pkg))
    (esrap::delete-rule-cell sym)))
