#include "tree.h"
int i = 0;
void TreeNode::addChild(TreeNode* child) {
  if(this->child == nullptr)
  {
      this->child = child;
  }
  else
  {
    this->child->addSibling(child);
  }
}

void TreeNode::addSibling(TreeNode* sibling){
    if(this->sibling == nullptr)
    {
        this->sibling = sibling;
    }
    else
    {
        TreeNode *p = this->sibling;
        while(p->sibling != nullptr)
        {
            p = p->sibling;
        }
        p->sibling = sibling;
    }
    
}

TreeNode::TreeNode(int lineno, NodeType type) {
    this->lineno = lineno;
    this->nodeType = type;
    genNodeId();
}

void TreeNode::genNodeId() {
    this->nodeID = i;
    i++;
}

void TreeNode::printNodeInfo() {
    cout<<lineno<<"\t@"<<nodeID<<"\t"<<nodeType2String()<<"\tchildren:";
    printChildrenId();
    cout<<'\t';
    printSpecialInfo();
    cout<<endl;
}

void TreeNode::printChildrenId() {
for(TreeNode *t=this->child;t!=nullptr;t=t->sibling)
        cout<<" @"<<t->nodeID;
}

void TreeNode::printAST() {
this->printNodeInfo();
    if(this->child!=nullptr)
        this->child->printAST();
    if(this->sibling!=nullptr)
        this->sibling->printAST();
}


// You can output more info...
void TreeNode::printSpecialInfo() {
    switch(this->nodeType){
        case NODE_CONST:
            {cout<<coType2String();return;}
        case NODE_VAR:
            {cout<<this->var_name;return;}
        case NODE_EXPR:
            {cout<<opType2String();return;}
        case NODE_STMT:
            {cout<<sType2String();return;}
        case NODE_TYPE:
            {cout<<Type2String();return;}
        default:
            break;
    }
}

string TreeNode::Type2String(){

    switch(this->cotype){
        case CONST_INT:
            return "const: int ";
        case CONST_STRING:
            return "const: string \"";
        
        default:
            return "unknown const type";
    }
}
string TreeNode::sType2String() {
    switch (this->stype)
    {
    case STMT_SKIP:
    return "empty stmt";
    case STMT_DECL:
    return "declare stmt";
    case STMT_IF:
    return "if stmt";
    case STMT_ELSE:
    return "else stmt";
    case STMT_WHILE:
    return "else stmt";
    case STMT_ASSIGN:
    return "assign stmt";
    case STMT_ADD:
    return "add stmt";
    case STMT_SUB:
    return "sub stmt";   
    case STMT_DIV:
    return "div stmt";
    case STMT_MUL:
    return "mul stmt";
    case STMT_MOD:
    return "mod stmt";
    case STMT_FOR:
    return "for stmt";
    case STMT_SCANF:
    return "scanf stmt";
    case STMT_PRINTF:
    return "printf stmt"; 
    case STMT_RETURN:
    return "return stmt";

    default:
        return "unknown stmt";
    }
    return "?";
}

/*
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
    STMT_DOMAIN

*/
string TreeNode::nodeType2String (){
    switch(this->nodeType)
    {
        case NODE_CONST:
        return "const";
        case NODE_EXPR:
        return "expr";
        case NODE_STMT:
        return "statement";
        case NODE_PROG:
        return "program";
        case NODE_TYPE:
        return "type";
        case NODE_MAIN:
        return "main";

        default:
           return "unknown";
    }
    return "<>";
}

string TreeNode::coType2String(){
    switch(this->cotype)
    {
        case CONST_INT:
        return "const int";
        case CONST_STRING:
        return "const string";

        default:
        return "unknown const";
    }
    return "?";
}

string TreeNode:: opType2String()
{
    string a="op: ";
    switch(this->optype)
    {
        case OP_EQ:
            return "op: ==";
        case OP_GR:
            return "op: >";
        case OP_LS:
            return "op: <";
        case OP_GE:
            return "op: >=";
        case OP_LE:
            return "op: <=";
        case OP_NE:
            return "op: !=";
        case OP_ADD:
            return "op: +";
        case OP_SUB:
            return "op: -";
        case OP_MUL:
            return "op: *";
        case OP_DIV:
            return "op: /";
        case OP_MOD:
            return "op: %";
        case OP_AND:
            return "op: &&";
        case OP_OR:
            return "op: ||";
        case OP_NOT:
            return "op: !";
        default:
            return "unknown op";
    }
}
