Attempt at using PEG to parse in small chunks.

PEG is more powerful than regex, since PEG can match structure across lines.

Peg.lisp is a generated, manually edited, file that uses ESRAP to parse PEG syntax.  It converts the PEG syntax into legal ESRAP calls.  It uses the package :peg-grammar.

Macro.lisp contains support macros for parsing PEG into ESRAP (i.e. above).

Package.lisp defines 3 packages, notably :peg which is used by this peg parser library.
The package :peg-grammar is used by peg.lisp and should be invisible to the user of this peg parser library.
The package :test-grammar is meant to be used for testing the library.

The file "parser.lisp" contains a sample usage of this library.  It defines a simple grammar using a handful of peg:rule declarations.  (See below for API doc).

The file "main.lisp" invokes the test grammar and parses the string "xxxabcyyy".

Parser API:

(peg:into-package <string>)
  This macro sets the destination package for the final parser.  See an example usage in parser.lisp.

(peg:rule <destination-grammar::rule-name> <string of PEG matching syntax> <body>)
  This macro creates a rule in the destination package of name "rule-name".  The PEG string is a single (or multiple) 
  line description of PEG parsing rules (see Bryan Ford's thesis http://bford.info/pub/lang/peg.pdf).  
  <Body> is a single Lisp sexpr in the form accepted by ESRAP (see ESRAP documentation).  "Parser.lisp" shows the use
  of two kinds of ESRAP syntax, :destructure and :lambda.  The sexpr is invoked when a match is made.  The single
  argument to lambda is the list of all matching items (returned recursively "from below"). :Destructure allows one to
  label each element of a return value.
