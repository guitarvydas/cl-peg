(in-package :test-grammar)

(cl-peg:into-package "TEST-GRAMMAR")

;; this isn't a bug - the problem was that a PEG comment is "#..." not "%..."
(defun not-bug ()
  (let ((parsed (cl-peg:fullpeg"not-bug <- ! '/' .")))
    (eval parsed)    
    (esrap:parse 'test-grammar::not-bug "a")))
