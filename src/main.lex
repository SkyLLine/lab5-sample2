%option noyywrap
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
%}
EOL	(\r\n|\r|\n)

INTEGER 0|[1-9][0-9]*
ID [[:alpha:]_][[:alpha:][:digit:]_]*

ENDCOMMENT "*/"
WHITESPACE [\t ]
STRING \"[^\"]*\"
COMMENTELEMENT .|\n
LINECOMMENTELEMENT .

%x COMMENT
%x LINECOMMENT
%%


"/*" BEGIN COMMENT;
<COMMENT>{COMMENTELEMENT}
<Comment>{ENDCOMMENT}{BEGIN INITIAL;}

"//" BEGIN LINECOMMENT;
<LINECOMMENT>{LINECOMMENTELEMENT}
<LINECOMMENT>{EOL}{BEGIN INITIAL;}



"int" return INT;
"bool" return BOOL;
"char" return CHAR;
"void" return VOID;
"string" return STRING;

"main" return MAIN;

"if" return IF;
"for" return FOR;
"else" return ELSE;
"while" return WHILE;
"return" return RETURN;

"printf" return PRINTF;
"scanf" return SCANF;

"=" return ASSIGN;
"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
"%" return MOD;
 
"~" return REV;
"!" return NOT;
"!=" return NOTEQUAL;
"&&" return AND;
"||" return OR;
"==" return EQUAL;
"<" return LESS;
"<=" return LESSOREQUAL;
">" return GREATER;
">=" return GREATEROREQUAL;

"(" return LPAREN;
")" return RPAREN;
"{" return LBRACE;
"}" return RBRACE;
"[" return LBRACK;
"]" return RBRACK;

"," return COMMA;
";" return SEMICOLON;


{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{ID} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}

{STRING}{
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_STRING;
    int i = 1;
    while(yytext[i] != '"')
    {
      node->str_val[i-1] = yytext[i];
      i++;
    }
    node->str_val[i-1] = '\0';
    node->cotype = CONST_STRING;
    yylval = node;
    return STRING;
}
{WHILTESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%