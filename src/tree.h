#ifndef TREE_H
#define TREE_H

#include "pch.h"
#include "type.h"

enum NodeType
{
    NODE_CONST, 
    NODE_VAR,
    NODE_EXPR,
    NODE_TYPE,
    NODE_STMT,
    NODE_PROG,
    NODE_MAIN,
};

enum OperatorType
{
    OP_EQ,  // ==
    OP_GR,
    OP_LS,
    OP_GE,
    OP_LE,
    OP_NE,
    OP_LOGI_AND,
    OP_LOGI_OR,
    OP_ADD,
    OP_SUB,
    OP_MUL,
    OP_DIV,
    OP_MOD,
    OP_AND,
    OP_OR,
    OP_NOT,
    OP_SADD,
    OP_SSUB,
    OP_N,
    OP_P,
    OP_AD, 
};

enum ConstType{
    CONST_INT,
    CONST_STRING,
    CONST_CHAR,
};

enum StmtType {
    STMT_SKIP,
    STMT_DECL,
    STMT_IF,
    STMT_ELSE,
    STMT_WHILE,
    STMT_ASSIGN,
    STMT_ADD,
    STMT_SUB,
    STMT_DIV,
    STMT_MUL,
    STMT_MOD,
    STMT_FOR,
    STMT_SCANF,
    STMT_PRINTF,
    STMT_BLOCK,
    STMT_ADD_ASSIGN,
    STMT_SUB_ASSIGN,
    STMT_RETURN

}
;

struct TreeNode {
public:
    int nodeID;  // 用于作业的序号输出
    int lineno;
    NodeType nodeType;
    
    TreeNode* child = nullptr;
    TreeNode* sibling = nullptr;

    void addChild(TreeNode*);
    void addSibling(TreeNode*);
    
    void printNodeInfo();
    void printChildrenId();

    void printAST(); // 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
    void printSpecialInfo();

    void genNodeId();

public:
    ConstType cotype;
    OperatorType optype;  // 如果是表达式
    Type* type;  // 变量、类型、表达式结点，有类型。
    StmtType stype;
    int int_val;
    char ch_val;
    bool b_val;
    string str_val;
    int block_id;
    string var_name;
public:
     string nodeType2String ();
     string opType2String ();
     string sType2String ();
     string coType2String();
     string Type2String();

public:
    TreeNode(int lineno, NodeType type);
};

struct thing{
        string T;
        string N;
        thing *next;
    };

struct BlockNode{
    int nodeID;
    BlockNode * father = nullptr;
    BlockNode * child = nullptr;
    BlockNode * sibling = nullptr;
    thing * name;
    void addChild(BlockNode *);
    BlockNode(int nodeID);
};

#endif