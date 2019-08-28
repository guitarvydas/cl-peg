(defun test1 ()
  (peg:parse test-grammar::Top "xxxabcyyy"))


(defun test2 ()
  (peg:parse test-grammar::Sexpr "(xxxabcyyy)"))


(defun test4 ()
  (peg:parse test-grammar::Sexpr4 "(xxxabcyyy)"))

(defun test5 ()
  (peg:parse test-grammar::Sexpr5 "(
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