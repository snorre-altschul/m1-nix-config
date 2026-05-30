// grammar.js  
/// <reference types="tree-sitter-cli/dsl" />  
// @ts-check  
  
export default grammar({  
  name: 'fasto',  
  
  extras: $ => [  
    /\s/,  
    $.comment,  
  ],  
  
  word: $ => $.identifier,  
  
  rules: {  
    source_file: $ => repeat($._definition),  
  
    _definition: $ => choice(  
      $.function_definition,  
      $._expression,  
    ),  
  
    // fun int f(int n) = ...  
    function_definition: $ => seq(  
      choice('fun', 'fn'),  
      $._type,  
      field('name', $.identifier),  
      '(',  
      optional($.parameter_list),  
      ')',  
      '=',  
      field('body', $._expression),  
    ),  
  
    parameter_list: $ => seq(  
      $.parameter,  
      repeat(seq(',', $.parameter)),  
    ),  
  
    parameter: $ => seq(  
      field('type', $._type),  
      field('name', $.identifier),  
    ),  
  
    _expression: $ => choice(  
      $.let_expression,  
      $.if_expression,  
      $.binary_expression,  
      $.unary_expression,  
      $.call_expression,  
      $.array_literal,  
      $.boolean_literal,  
      $.integer_literal,  
      $.string_literal,  
      $.identifier,  
    ),  
  
    let_expression: $ => seq(  
      'let',  
      field('name', $.identifier),  
      '=',  
      field('value', $._expression),  
      'in',  
      field('body', $._expression),  
    ),  
  
    if_expression: $ => seq(  
      'if',  
      field('condition', $._expression),  
      'then',  
      field('consequence', $._expression),  
      'else',  
      field('alternative', $._expression),  
    ),  
  
    binary_expression: $ => prec.left(1, seq(  
      field('left', $._expression),  
      field('operator', $.operator),  
      field('right', $._expression),  
    )),  
  
    unary_expression: $ => choice(  
      seq('not', field('operand', $._expression)),  
      seq('~',   field('operand', $._expression)),  
      seq('op',  field('operator', $.operator)),  
    ),  
  
    call_expression: $ => seq(  
      field('function', $.identifier),  
      '(',  
      optional(seq(  
        $._expression,  
        repeat(seq(',', $._expression)),  
      )),  
      ')',  
    ),  
  
    array_literal: $ => seq(  
      '{',  
      optional(seq(  
        $._expression,  
        repeat(seq(',', $._expression)),  
      )),  
      '}',  
    ),  
  
    operator: $ => choice(  
      '+', '-', '*', '/', '&&', '||', '=>', '==', '<',  
    ),  
  
    _type: $ => choice(  
      $.primitive_type,  
      $.array_type,  
    ),  
  
    primitive_type: $ => choice('int', 'char', 'bool'),  
  
    array_type: $ => seq('[', $._type, ']'),  
  
    boolean_literal: $ => choice('true', 'false'),  
  
    integer_literal: $ => /\d+/,  
  
    // Matches the same string pattern as the Vim syntax file  
    string_literal: $ => /\"([ -!#-&(-\[\]-~]|\\[\x00-\x7f])*\"/,  
  
    identifier: $ => /[a-zA-Z][a-zA-Z0-9_]*/,  
  
    comment: $ => token(seq('//', /.*/)),  
  },  
});
