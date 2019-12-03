(IN-PACKAGE :peg-grammar)

;; this part allows "full" peg grammar rules inside one cl-peg:fullpeg...

(ESRAP:DEFRULE PG:PEGGRAMMAR (cl:AND pg::SPACING (+ pg::FULLDEFINITION) pg::SPACING pg::ENDOFFILE)
  (:DESTRUCTURE
   (SPC DEF SPC2 EOF)
   (DECLARE (IGNORE SPC EOF SPC2))
   `(PROGN ,@DEF)))

(ESRAP:DEFRULE pg::FULLDEFINITION
               (cl:AND pg::IDENTIFIER
                    pg::LEFTARROW
                    pg::EXPRESSION
                    pg::SPACING
                    (ESRAP:? pg::SEMANTICCODE))
  (:DESTRUCTURE
   (ID ARR E SPC CODE)
   (DECLARE (IGNORE ARR SPC))
   (let ((sym (cl:INTERN (cl:STRING-UPCASE ID) (cl-peg:peg-package))))
     ;(format *error-output* "~&defining ~a::~a~%" (cl:package-name (cl-peg:peg-package)) sym)
     (IF (NULL CODE)
         `(esrap:DEFRULE ,sym ,E)
     `(esrap:DEFRULE ,sym ,E ,CODE)))))

(ESRAP:DEFRULE pg::SEMANTICCODE (cl:AND pg::OPENBRACE (+ pg::NOTBRACE) pg::CLOSEBRACE)
  (:DESTRUCTURE
   (LB CODE RB)
   (DECLARE (IGNORE LB RB))
   (READ-FROM-STRING (esrap:TEXT CODE))))

(ESRAP:DEFRULE pg::NOTBRACE (OR pg::UQLITERAL (cl:AND (ESRAP:! "}") esrap::CHARACTER))
  (:TEXT T))

(ESRAP:DEFRULE PG::OPENBRACE (CL:AND "{" PG::SPACING)
  (:LAMBDA (LIST) (CL:DECLARE (cl:IGNORE LIST)) 'esrap::CHARACTER))
(ESRAP:DEFRULE PG::CLOSEBRACE (CL:AND "}" PG::SPACING)
  (:LAMBDA (LIST) (CL:DECLARE (cl:IGNORE LIST)) 'esrap::CHARACTER))


;; ^ addition for full-peg to here



(ESRAP:DEFRULE PG:PEG (cl:AND PG::SPACING PG::DEFINITION PG::SPACING PG::ENDOFFILE)
  (:DESTRUCTURE
   (SPC DEF SPC2 EOF)
   (CL:DECLARE (cl:IGNORE SPC EOF SPC2))
   def))

(ESRAP:DEFRULE PG::DEFINITION
    (CL:AND
     PG::EXPRESSION
     PG::SPACING)
  (:DESTRUCTURE
   (E SPC)
   (CL:DECLARE (cl:IGNORE SPC))
   e))

(ESRAP:DEFRULE PG::EXPRESSION (CL:AND PG::PSEQUENCE (esrap:* PG::SLASHSEQUENCE))
  (:DESTRUCTURE (SEQ SEQS) (cl:IF SEQS `(CL:OR ,SEQ ,@SEQS) SEQ)))

(ESRAP:DEFRULE PG::SLASHSEQUENCE (CL:AND PG::SLASH PG::PSEQUENCE)
  (:DESTRUCTURE (SL SEQ) (CL:DECLARE (cl:IGNORE SL)) SEQ))

(ESRAP:DEFRULE PG::PSEQUENCE (esrap:* PG::PREFIX)
  (:DESTRUCTURE
   (cl:&REST PREF)
   (cl:IF PREF
       (cl:IF (CL:AND (cl:CONSP PREF) (cl:> (cl:LENGTH PREF) 1))
           `(CL:AND ,@PREF)
         (cl:FIRST PREF))
     (cl:VALUES))))

(ESRAP:DEFRULE PG::PREFIX (CL:AND (ESRAP:? (CL:OR PG::PAND PG::PNOT)) PG::SUFFIX)
  (:DESTRUCTURE (PREF SUFF) (CL:IF PREF (cl:LIST PREF SUFF) SUFF)))

(ESRAP:DEFRULE PG::SUFFIX (CL:AND PG::PRIMARY (ESRAP:? (CL:OR PG::QUESTION PG::STAR PG::PLUS)))
  (:DESTRUCTURE (PRIM SUFF) (CL:IF SUFF (cl:LIST SUFF PRIM) PRIM)))

(ESRAP:DEFRULE PG::PRIMARY (CL:OR PG::P1 PG::P2 PG::LITERAL PG::PCLASS PG::DOT) (:LAMBDA (X) X))

(ESRAP:DEFRULE PG::P1 (CL:AND PG::IDENTIFIER (ESRAP:! PG::LEFTARROW))
  (:FUNCTION cl:FIRST))

(ESRAP:DEFRULE PG::P2 (CL:AND PG::OPENPAREN PG::EXPRESSION PG::CLOSEPAREN)
  (:FUNCTION cl:SECOND))

(ESRAP:DEFRULE PG::IDENTIFIER PG::STRINGIDENTIFIER
  (:LAMBDA (X) (cl:INTERN (cl:STRING-UPCASE X) (cl-peg:peg-package))))

(ESRAP:DEFRULE PG::STRINGIDENTIFIER (CL:AND PG::IDENTSTART (esrap:* PG::IDENTCONT) PG::SPACING)
  (:TEXT T))

(ESRAP:DEFRULE PG::IDENTSTART
               (ESRAP:CHARACTER-RANGES (#\a #\z) (#\A #\Z) #\_))

(ESRAP:DEFRULE PG::IDENTCONT
               (CL:OR PG::IDENTSTART "-" (ESRAP:CHARACTER-RANGES (#\0 #\9))))

(ESRAP:DEFRULE PG::LITERAL
               (CL:OR (CL:AND (ESRAP:CHARACTER-RANGES #\')
                        (esrap:* PG::NOTSINGLE)
                        (ESRAP:CHARACTER-RANGES #\')
                        PG::SPACING)
                   (CL:AND (ESRAP:CHARACTER-RANGES #\")
                        (esrap:* PG::NOTDOUBLE)
                        (ESRAP:CHARACTER-RANGES #\")
                        PG::SPACING))
  (:DESTRUCTURE
   (Q1 str Q2 SPC)
   (CL:DECLARE (cl:IGNORE Q1 Q2 SPC))
   (esrap:TEXT str)))

(ESRAP:DEFRULE PG::UQLITERAL
               (CL:AND (ESRAP:CHARACTER-RANGES #\")
                    (esrap:* PG::NOTDOUBLE)
                    (ESRAP:CHARACTER-RANGES #\")
                    PG::SPACING)
  (:DESTRUCTURE
   (Q1 str Q2 SPC)
   (CL:DECLARE (cl:IGNORE SPC))
   `(,Q1 ,@str ,Q2)))

(ESRAP:DEFRULE PG::NOTSINGLE
               (CL:AND (ESRAP:! (ESRAP:CHARACTER-RANGES #\')) PG::PCHAR)
  (:FUNCTION cl:SECOND))

(ESRAP:DEFRULE PG::NOTDOUBLE
               (CL:AND (ESRAP:! (ESRAP:CHARACTER-RANGES #\")) PG::PCHAR)
  (:FUNCTION cl:SECOND))

(ESRAP:DEFRULE PG::PCLASS (CL:AND "[" (esrap:* PG::NOTRB) "]" PG::SPACING)
  (:DESTRUCTURE
   (LB RANGE RB SPC)
   (CL:DECLARE (cl:IGNORE LB RB SPC))
   (CL:IF (CL:AND (cl:CONSP RANGE)
            (CL:OR (cl:NOT (cl:= 2 (cl:LENGTH RANGE)))
                (CL:OR (cl:CONSP (cl:FIRST RANGE)) (cl:CONSP (cl:SECOND RANGE)))))
       `(esrap:CHARACTER-RANGES ,@RANGE)
     `(esrap:CHARACTER-RANGES ,RANGE))))

(ESRAP:DEFRULE PG::NOTRB (CL:AND (ESRAP:! "]") PG::RANGE) (:FUNCTION cl:SECOND))

(ESRAP:DEFRULE PG::RANGE (CL:OR PG::CHARRANGE PG::SINGLECHAR))

(ESRAP:DEFRULE PG::CHARRANGE (CL:AND PG::PCHAR "-" PG::PCHAR)
  (:DESTRUCTURE (C1 DASH C2) (CL:DECLARE (cl:IGNORE DASH)) (cl:LIST C1 C2)))

(ESRAP:DEFRULE PG::SINGLECHAR PG::PCHAR (:LAMBDA (C) C))

(ESRAP:DEFRULE PG::PCHAR (CL:OR PG::ESCCHAR PG::NUMCHAR1 PG::NUMCHAR2 PG::ANYCHAR))

(ESRAP:DEFRULE PG::ESCCHAR
               (CL:AND "\\"
                    (CL:OR "n"
                        "r"
                        "t"
                        (ESRAP:CHARACTER-RANGES #\')
                        "\""
                        "["
                        "]"
                        "\\"
                        "{"
                        "}"))
  (:DESTRUCTURE
   (SL CH)
   (CL:DECLARE (cl:IGNORE SL))
   (cl:LET ((C (CL:OR (CL:AND (cl:CHARACTERP CH) CH) (cl:CHAR CH 0))))
     (cl:CASE C
       (#\n #\Newline)
       (#\r #\Return)
       (#\t #\Tab)
       (cl:OTHERWISE C)))))

(ESRAP:DEFRULE PG::NUMCHAR1
               (CL:AND "\\"
                    (ESRAP:CHARACTER-RANGES (#\0 #\2))
                    (ESRAP:CHARACTER-RANGES (#\0 #\7))
                    (ESRAP:CHARACTER-RANGES (#\0 #\7)))
  (:DESTRUCTURE
   (SL N1 N2 N3)
   (CL:DECLARE (cl:IGNORE SL))
   (cl:CODE-CHAR (cl:PARSE-INTEGER (cl:CONCATENATE 'cl:STRING N1 N2 N3) :RADIX 8))))

(ESRAP:DEFRULE PG::NUMCHAR2
               (CL:AND "\\"
                    (ESRAP:CHARACTER-RANGES (#\0 #\7))
                    (ESRAP:? (ESRAP:CHARACTER-RANGES (#\0 #\7))))
  (:DESTRUCTURE
   (SL N1 N2)
   (CL:DECLARE (cl:IGNORE SL))
   (cl:CODE-CHAR (cl:PARSE-INTEGER (cl:CONCATENATE 'cl:STRING N1 N2) :RADIX 8))))

(ESRAP:DEFRULE PG::ANYCHAR (CL:AND (ESRAP:! "\\") esrap::CHARACTER)
  (:DESTRUCTURE (SL C) (CL:DECLARE (cl:IGNORE SL)) C))

(ESRAP:DEFRULE PG::LEFTARROW (CL:AND "<-" PG::SPACING)
  (:lambda (list) (CL:DECLARE (cl:ignore list)) (cl:VALUES)))

(ESRAP:DEFRULE PG::SLASH (CL:AND "/" PG::SPACING)
  (:lambda (list) (CL:DECLARE (cl:ignore list)) (cl:VALUES)))

(ESRAP:DEFRULE PG::PAND (CL:AND "&" PG::SPACING)
  (:lambda (list) (CL:DECLARE (cl:ignore list)) 'CL:AND))

(ESRAP:DEFRULE PG::PNOT (CL:AND "!" PG::SPACING)
  (:lambda (list) (CL:DECLARE (cl:ignore list)) 'esrap:!))

(ESRAP:DEFRULE PG::QUESTION (CL:AND "?" PG::SPACING)
  (:lambda (list) (CL:DECLARE (cl:ignore list)) 'esrap:?))

(ESRAP:DEFRULE PG::STAR (CL:AND "*" PG::SPACING)
  (:LAMBDA (LIST) (CL:DECLARE (cl:IGNORE LIST)) 'esrap:*))

(ESRAP:DEFRULE PG::PLUS (CL:AND "+" PG::SPACING)
  (:LAMBDA (LIST) (CL:DECLARE (cl:IGNORE LIST)) 'esrap:+))

(ESRAP:DEFRULE PG::OPENPAREN (CL:AND "(" PG::SPACING)
  (:LAMBDA (LIST) (CL:DECLARE (cl:IGNORE LIST)) (cl:VALUES)))

(ESRAP:DEFRULE PG::CLOSEPAREN (CL:AND ")" PG::SPACING)
  (:LAMBDA (LIST) (CL:DECLARE (cl:IGNORE LIST)) (cl:VALUES)))

(ESRAP:DEFRULE PG::DOT (CL:AND "." PG::SPACING)
  (:LAMBDA (LIST) (CL:DECLARE (cl:IGNORE LIST)) 'esrap::CHARACTER))

(ESRAP:DEFRULE PG::SPACING (esrap:* (CL:OR PG::PSPACE PG::COMMENT))
  (:LAMBDA (LIST) (CL:DECLARE (cl:IGNORE LIST)) (cl:VALUES)))

(ESRAP:DEFRULE PG::COMMENT
               (CL:AND "#"
                    (esrap:* (CL:AND (ESRAP:! PG::ENDOFLINE) PG::CHAR1))
                    (CL:OR PG::ENDOFLINE PG::ENDOFFILE))
  (:LAMBDA (LIST) (CL:DECLARE (cl:IGNORE LIST)) (cl:VALUES)))

(ESRAP:DEFRULE PG::CHAR1 esrap::CHARACTER (:LAMBDA (C) C))

(ESRAP:DEFRULE PG::PSPACE (CL:OR " " "	" PG::ENDOFLINE)
  (:LAMBDA (LIST) (CL:DECLARE (cl:IGNORE LIST)) (cl:VALUES)))

(ESRAP:DEFRULE PG::ENDOFLINE
               (CL:OR "
"
                   "
"
                   "")
  (:LAMBDA (LIST) (CL:DECLARE (cl:IGNORE LIST)) (cl:VALUES)))

(ESRAP:DEFRULE PG::ENDOFFILE (ESRAP:! esrap::CHARACTER)
  (:LAMBDA (LIST) (CL:DECLARE (cl:IGNORE LIST)) (cl:values)))

