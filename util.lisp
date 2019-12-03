(in-package :cl-peg)

(defun delete-rules (pkg)
  "clear the rules of symbols in package pkg 
   relies on non-exported knowledge of esrap function delete-rule-cell"
  (do-symbols (sym (find-package pkg))
    (let ((pname (package-name (symbol-package sym))))
      (when (string= pkg pname)
        (format *standard-output* "~&esrap deleting ~A ~A~%" pname sym)
        (esrap::delete-rule-cell sym)))))
