%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}
%token T_CHAR T_INT T_STRING T_BOOL
 
%token MAIN VOID

%token PRINTF SCANF

%token IF ELSE WHILE FOR RETURN

%token SEMICOLON COMMA

%token LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK

%token ASSIGN ADD_ASSIGN SUB_ASSIGN SADD SSUB 

%token IDENTIFIER INTEGER CHAR BOOL STRING

%token UP_THAN_ELSE ADDRESS

%left GREATER LESS EQUAL NOTEQUAL GREATEROREQUAL LESSOREQUAL

%left ADD SUB
%left MUL DIV MOD
%left OR
%left AND 
%right NOT
%left SADD SSUB

%token NSUB NADD

%%

program
: statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);};

statements
:  VOID MAIN LPAREN RPAREN block{
    $$ = $5;
} 
|  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
|  statements block{$$ = $1;$$->addSibling($2);
}
;
block
: LBRACE statements RBRACE{
    TreeNode* node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_BLOCK;
    node->addChild($2);
    $$ = node;
}
;
sentense: block {$$=$1;} | statement {$$=$1;}
statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| declaration SEMICOLON {$$ = $1;}
| instruction SEMICOLON {$$ = $1;}
| IDENTIFIER SADD SEMICOLON {$$ = $1;}
| IDENTIFIER SSUB SEMICOLON {$$ = $1;}
| IDENTIFIER ADD_ASSIGN expr {$$ = new TreeNode(lineno, NODE_STMT);$$->stype = STMT_ADD_ASSIGN;$$->addChild($1);$$->addChild($3);}
| IDENTIFIER SUB_ASSIGN expr {$$ = new TreeNode(lineno, NODE_STMT);$$->stype = STMT_SUB_ASSIGN;$$->addChild($1);$$->addChild($3);}
| for {$$ = $1;}
| if_else {$$ = $1;}
| while {$$ = $1;}
| printf {$$ = $1;}
| scanf {$$ = $1;}
;


for 
: FOR LPAREN instructions SEMICOLON bool_instruction SEMICOLON instructions RPAREN sentense{
    TreeNode *node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_FOR;
    node->addChild($3);
    node->addChild($5);
    node->addChild($7);
    node->addChild($9);
    $$ = node;  
}
| FOR LPAREN declaration SEMICOLON bool_instruction SEMICOLON instructions RPAREN sentense{
    TreeNode *node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_FOR;
    node->addChild($3);
    node->addChild($5);
    node->addChild($7);
    node->addChild($9);
    $$ = node;  
}
;

scanf
: SCANF LPAREN STRING COMMA add_table RPAREN SEMICOLON{
    $$ = new TreeNode(lineno, NODE_STMT);
    $$->stype = STMT_SCANF;
    $$->addChild($3);
    $$->addChild($5);
}
;

add_table
: add_table COMMA add{
    $$ = $1;
    $$->addChild($3);
}
| add{
    $$ = $1;
}
;

add
: ADDRESS IDENTIFIER{
    $$ = new TreeNode(lineno, NODE_EXPR);
    $$->optype = OP_AD;
    $$->addChild($2);
}
;

printf
: PRINTF LPAREN STRING RPAREN SEMICOLON{
    $$ = new TreeNode(lineno, NODE_STMT);
    $$->stype = STMT_PRINTF;
    $$->addChild($3);
}
| PRINTF LPAREN STRING COMMA exprs RPAREN SEMICOLON{
    $$ = new TreeNode(lineno, NODE_STMT);
    $$->stype = STMT_PRINTF;
    $$->addChild($3);
    $$->addChild($5);
}
;

while
: WHILE bool_instructions sentense{
    TreeNode *node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_WHILE;
    node->addChild($2);
    node->addChild($3);
    $$ = node;
}
;

if_else
: IF bool_instructions sentense ELSE sentense %prec UP_THAN_ELSE{
    TreeNode *node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_IF;
    node->addChild($2);
    node->addChild($3);
    node->addChild($5);
    $$ = node;
}
| IF bool_instructions sentense{
    TreeNode *node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_IF;
    node->addChild($2);
    node->addChild($3);
    $$ = node;
}
;

bool_instructions
: LPAREN bool_instructions RPAREN{$$ = $2;}
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
    $$->optype = OP_EQ;
    $$->addChild($1);
    $$->addChild($3);
}
;

declaration
: T instructions{
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
| IDENTIFIER ADD_ASSIGN expr {
    $$ = new TreeNode(lineno, NODE_STMT);
    $$->stype = STMT_ADD_ASSIGN;
    $$->addChild($1);
    $$->addChild($3);
}
| IDENTIFIER SUB_ASSIGN expr {
    $$ = new TreeNode(lineno, NODE_STMT);
    $$->stype = STMT_SUB_ASSIGN;
    $$->addChild($1);
    $$->addChild($3);
}
| expr SADD{
    $$ = new TreeNode(lineno, NODE_EXPR);
    $$->optype = OP_N;
    $$->addChild($2);
}
;

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
| SUB expr %prec NSUB{
    $$=new TreeNode(lineno,NODE_EXPR);
    $$->optype=OP_N;
    $$->addChild($2);
}
| ADD expr %prec NADD{
    $$=new TreeNode(lineno, NODE_EXPR);
    $$->optype = OP_P;
    $$->addChild($2);
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