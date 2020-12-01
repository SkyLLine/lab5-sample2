%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}
%token T_CHAR T_INT T_STRING T_BOOL 

%token PRINTF SCANF

%token IF ELSE WHILE FOR RETURN

%token SEMICOLON COMMA

%token LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK

%token ASSIGN 

%token IDENTIFIER INTEGER CHAR BOOL STRING

%left GREATER LESS EQUAL NOTEQUAL GREATEROREQUAL LESSOREQUAL

%left ADD SUB
%left MUL DIV MOD
%left OR
%left AND 
%right NOT

%%

program
: statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);};

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
|  LBRACE statements RBRACE{$$ = $2;}
;

statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| declaration SEMICOLON {$$ = $1;}
| instruction SEMICOLON {$$ = $1;}
| if_else {$$ = $1;}
| if {$$ = $1;}
| while {$$ = $1;}
| printf {$$ = $1;}
| scanf {$$ = $1;}
;

scanf
: SCANF LPAREN STRING RPAREN SEMICOLON{
    $$ = new TreeNode(lineno, NODE_STMT);
    $$->stype = STMT_SCANF;
    $$->addChild($3);
}
;

printf
: PRINTF LPAREN STRING RPAREN SEMICOLON{
    $$ = new TreeNode(lineno, NODE_STMT);
    $$->stype = STMT_PRINTF;
    $$->addChild($3);
}
;

while
: WHILE bool_instruction statements{
    TreeNode *node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_WHILE;
    node->addChild($2);
    node->addChild($3);
    $$ = node;
}
;

if_else
: IF bool_instruction statements ELSE statements{
    TreeNode *node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_IF;
    node->addChild($2);
    node->addChild($3);
    node->addChild($5);
    $$ = node;
}
;

if
: IF bool_instruction statements{
    TreeNode *node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_IF;
    node->addChild($2);
    node->addChild($3);
    $$ = node;
}
;

bool_instructions
: LPAREN bool_instructions LPAREN{$$ = $2;}
| bool_instructions OR bool_instructions{
    TreeNode *node = new TreeNode(lineno, NODE_EXPR);
    $$ = node;
    $$->optype = OP_OR;
    $$->addChild($1);
    $$->addChild($3);
}
| bool_instructions AND bool_instructions{
    TreeNode *node = new TreeNode(lineno, NODE_EXPR);
    $$ = node;
    $$->optype = OP_AND;
    $$->addChild($1);
    $$->addChild($3);
}
| NOT bool_instructions{
    TreeNode *node = new TreeNode(lineno, NODE_EXPR);
    $$ = node;
    $$->optype = OP_NOT;
    $$->addChild($2);
}

| bool_instruction{$$ = $1;}
;

bool_instruction
: expr{$$=$1;}
| bool_instruction LESS bool_instruction{
    $$ = new TreeNode(lineno, NODE_EXPR);
    $$->optype = OP_LS;
    $$->addChild($1);
    $$->addChild($3);
}
| bool_instruction GREATER bool_instruction{
    $$ = new TreeNode(lineno, NODE_EXPR);
    $$->optype = OP_GR;
    $$->addChild($1);
    $$->addChild($3);
}
| bool_instruction GREATEROREQUAL bool_instruction{
    $$ = new TreeNode(lineno, NODE_EXPR);
    $$->optype = OP_GE;
    $$->addChild($1);
    $$->addChild($3);
}
| bool_instruction LESSOREQUAL bool_instruction{
    $$ = new TreeNode(lineno, NODE_EXPR);
    $$->optype = OP_LE;
    $$->addChild($1);
    $$->addChild($3);
}
| bool_instruction NOTEQUAL bool_instruction{
    $$ = new TreeNode(lineno, NODE_EXPR);
    $$->optype = OP_NE;
    $$->addChild($1);
    $$->addChild($3);
}
| bool_instruction EQUAL bool_instruction{
    $$ = new TreeNode(lineno, NODE_EXPR);
    $$->optype = OP_LE;
    $$->addChild($1);
    $$->addChild($3);
}
;

declaration
: T instructions SEMICOLON{
    $$ = new TreeNode(lineno, NODE_STMT);
    $$->stype = STMT_DECL;
    $$->addChild($1);
    $$->addChild($2);
}
| T idlist{
    $$ = new TreeNode(lineno, NODE_STMT);
    $$->stype = STMT_DECL;
    $$->addChild($1);
    $$->addChild($2);
}
;

instructions
: instructions COMMA instruction{
    $$ = $1;
    $$->addSibling($3);
}
| instruction{
    $$ = $1;
}
;

instruction
: IDENTIFIER ASSIGN expr{
    $$ = new TreeNode(lineno, NODE_STMT);
    $$->stype = STMT_ASSIGN;
    $$->addChild($1);
    $$->addChild($3);
}
idlist
:
idlist COMMA IDENTIFIER{
    $$ = $1;
    $$->addSibling($3);
}
| IDENTIFIER{
    $$ = $1;
}
;

exprs
: exprs COMMA expr{
    $$=$1;
    $$->addSibling($3);
}
| expr{ $$ = $1; }
;

expr
: LPAREN expr RPAREN{
    $$= $2;
}
| expr ADD expr{
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->optype=OP_ADD;
    $$->addChild($1);
    $$->addChild($3);
}
| expr SUB expr{
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->optype=OP_SUB;
    $$->addChild($1);
    $$->addChild($3);
}
| expr MUL expr{
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->optype=OP_MUL;
    $$->addChild($1);
    $$->addChild($3);
}
| expr DIV expr{
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->optype=OP_DIV;
    $$->addChild($1);
    $$->addChild($3);
}
| expr MOD expr{
    $$=new TreeNode($1->lineno,NODE_EXPR);
    $$->optype=OP_MOD;
    $$->addChild($1);
    $$->addChild($3);
}
|IDENTIFIER {
    $$ = $1;
}
| INTEGER {
    $$ = $1;
}
| CHAR {
    $$ =$1;
}
| STRING {
    $$ = $1;
}
;

T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}