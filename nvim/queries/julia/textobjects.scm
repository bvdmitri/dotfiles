; function call arguments
(call_expression
  (argument_list
    (_) @parameter.inner))

(call_expression
  (argument_list) @parameter.outer)

; ----------------------------
; Block-style functions
; ----------------------------

(function_definition) @function.outer

(function_definition
  (block) @function.inner)

; ----------------------------
; Assignment-style functions
; f(x) = expr
; ----------------------------

(assignment
  (call_expression)
  (operator)
  (_) @function.inner) @function.outer


; ----------------------------
; Structs as "class"
; ----------------------------

(struct_definition) @class.outer

(struct_definition
  (block) @class.inner)
