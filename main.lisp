(defun test1 ()
  (cl-peg:parse test-grammar::Top "xxxabcyyy"))


(defun test2 ()
  (cl-peg:parse test-grammar::Sexpr "(xxxabcyyy)"))


(defun test4 ()
  (cl-peg:parse test-grammar::Sexpr4 "(xxxabcyyy)"))

(defun test5 ()
  (cl-peg:parse test-grammar::Sexpr5 "(
xxxabcyyy
)"))

(defun main ()
  (test1)
  (test2)
  (test4)
  (multiple-value-bind (match position-or-nil success)
      (test5)
    (declare (ignore position-or-nil))
    (when success
      match)))