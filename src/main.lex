%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
%}

BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*

EOL	(\r\n|\r|\n)
WHITESPACE [\t ]

STRING \".+\"
INTEGER 0|[1-9][0-9]*
IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*



%%


{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */



"int" return T_INT;
"bool" return T_BOOL;
"char" return T_CHAR;
"string" return T_STRING;



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

{STRING} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_STRING;
    int i;
    for(i=1;yytext[i]!='\"';i++)
    {
      node->str_val+=(char)yytext[i];
    }
    node->str_val[i] = '\0';
    node->cotype = CONST_STRING;
    yylval = node;
    return STRING;
}

{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}

{WHITESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%