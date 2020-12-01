#include "tree.h"
int i = 0;
void TreeNode::addChild(TreeNode* child) {
  if(this->child == nullptr)
  {
      this->child = child;
      this->child->father = this;
  }
  else
  {
    this->child->addSibling(child);
    child->father = this;
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
    string print
}

void TreeNode::printChildrenId() {

}

void TreeNode::printAST() {

}


// You can output more info...
void TreeNode::printSpecialInfo() {
    switch(this->nodeType){
        case NODE_CONST:
            break;
        case NODE_VAR:
            break;
        case NODE_EXPR:
            break;
        case NODE_STMT:
            break;
        case NODE_TYPE:
            break;
        default:
            break;
    }
}

string TreeNode::sType2String(StmtType type) {
    return "?";
}


string TreeNode::nodeType2String (NodeType type){
    return "<>";
}
