%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
int type = 0;
int wrong = 0;
int id = 0;
BlockNode *roots = new BlockNode(0);
BlockNode *p = roots;
%}

BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*

EOL	(\r\n|\r|\n)
WHITESPACE [\t ]

CHAR \'.?\'
STRING \".+\"
INTEGER 0|[1-9][0-9]*
IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*



%%


{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */



"int" {type = 1;return T_INT;}
"bool" return T_BOOL;
"char" {type = 2;return T_CHAR;}
"string" return T_STRING;
"void" {return VOID;}
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
"+=" return ADD_ASSIGN;
"-=" return SUB_ASSIGN;
"++" return SADD;
"--" return SSUB;

"!" return NOT;
"!=" return NOTEQUAL;
"&&" return AND;
"||" return OR;
"==" return EQUAL;
"<" return LESS;
"<=" return LESSOREQUAL;
">" return GREATER;
">=" return GREATEROREQUAL;

"&" return ADDRESS;
"(" return LPAREN;
")" return RPAREN;
"{" {id++;BlockNode *t = new BlockNode(id);p->addChild(t);p = t;return LBRACE;}
"}" {p = p->father;return RBRACE;}
"[" return LBRACK;
"]" return RBRACK;

"," return COMMA;
";" {type = 0;return SEMICOLON;}


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

{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->ch_val=yytext[1];
    node->cotype=CONST_CHAR;
    yylval = node;
    return CHAR;
}
{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    if(type != 0)
    {
        node->block_id = p->nodeID;
        thing *s = p->name;
        while(s != nullptr)
        {
            s = s->next;
        }
        s = new thing;
        if(type == 1)s->T = "int";
        else s->T = "char";
        s->N = string(yytext);
    }
    else
    {
        BlockNode *qq = p;
        int m = 0;
        while(qq != nullptr)
        {
            thing *s = qq->name;
            while(s != nullptr)
            {
                if(s->N == string(yytext))
                {
                    m = 1;
                    break;
                }
                s = s->next;
            }
          if(m == 0)
          {
             qq = qq->father;
          }
        }
        if(qq == nullptr)
        {
            wrong = 1;
        }
    }
    yylval = node;
    return IDENTIFIER;
}

{WHITESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%