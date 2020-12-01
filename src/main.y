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

%token SEMICOLON

%token IDENTIFIER INTEGER CHAR BOOL STRING

%left GREATER LESS EQUAL NOTEQUAL

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
|  LBRACE statements RBRACEP{$$ = $2;}
;

statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| declaration SEMICOLON {$$ = $1;}
| assign SEMICOLON {$$ = $1;}
| if_else {$$ = $1;}
| if {$$ = $1;}
| while {$$ = $1;}
| printf {$$ = $1;}
| scanf {$$ = $1;}
;

scanf
: SCANF LPAREN STRING RPAREN{
    $$ = new TreeNode(lineno, NODE_STMT);
    $$->stype = STMT_SCANF;
    $$->addChild($3);
}
;

printf
: PRINTF LPAREN STRING RPAREN{
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
: 
declaration
: T IDENTIFIER LOP_ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    node->addChild($4);
    $$ = node;   
} 
| T IDENTIFIER {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$ = node;   
}
;

expr
: IDENTIFIER {
    $$ = $1;
}
| INTEGER {
    $$ = $1;
}
| CHAR {
    $$ = $1;
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