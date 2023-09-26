var curEvent = null;
var isPrevAuto = false;         //是否自动加载（上）
var isNextAuto = false;         //是否自动加载（下）
var isCallBack = false;         //是否回调
var selectTreeNode = null;      //当前选择的TreeNode

function selectPrev(e) {
    findPreviousSibling(selectTreeNode, e);
}

function selectNext(e) {
    findNextSibling(selectTreeNode, e);
}

//上一个
function findPreviousSibling(node, e) {
    //debugger;
    if (e == null) {
        e = curEvent;
    } else {
        if (event == null) {
            curEvent = e;
        }
    }
    if (node == null) {
        isCallBack = false;
        isPrevAuto = false;
        return;
    }
    var tree = Ext.getCmp('myTree');
    //如果是回调函数，则运行
    if (isCallBack) {
        var lastNode = node.lastChild;
        if (lastNode.isLeaf()) {
            isCallBack = false;
            isPrevAuto = false;
            if (tree.fireEvent('beforeclick', lastNode)) {
                tree.fireEvent('click', lastNode, e);
            }
        } else {
            isPrevAuto = true;
            lastNode.expand();
        }
    }
    //如果是自动展开，判断是否是叶子，如果是，则触发其事件，否则将其最后一个子节点传入递归调用。
    else if (isPrevAuto) {
        if (node.isLeaf()) {
            isPrevAuto = false;
            if (tree.fireEvent('beforeclick', node)) {
                tree.fireEvent('click', node, e);
            }
        } else {
            node.expand();
            findPreviousSibling(node.lastChild, e);
        }
    }
    //若不是回调函数
    else if (!node.isFirst()) {
        //如果前一个同级接点是leaf,则直接触发相关树的事件。
        if (node.previousSibling.isLeaf()) {
            isPrevAuto = false;
            if (tree.fireEvent('beforeclick', node.previousSibling)) {
                tree.fireEvent('click', node.previousSibling, e)
            }
        } else {
            //用长度来判断是否接点已经加载过
            if (node.previousSibling.childNodes.length > 0) {
                //若已经加载，则展开
                node.previousSibling.expand();
                //判断同级的前一个节点是否是leaf，若是，则直接触发相关树的事件，否则将传入本函数递归调用。
                if (node.previousSibling.lastChild.isLeaf()) {
                    isPrevAuto = false;
                    if (tree.fireEvent('beforeclick', node.previousSibling.lastChild)) {
                        tree.fireEvent('click', node.previousSibling.lastChild, e);
                    }
                } else {
                    isPrevAuto = true;
                    node.previousSibling.lastChild.expand();
                    findPreviousSibling(node.previousSibling.lastChild, e);
                }
            }
            //若以前未加载，则将起展开，自动执行回调函数
            else {
                isPrevAuto = true;
                node.previousSibling.expand();
            }
        }
    } else if (node.parentNode == null) {
        return;
    } else {
        var parentNode = node.parentNode;
        findPreviousSibling(parentNode, e);
    }
}

//下一个
function findNextSibling(node, e) {
    //debugger;
    if (e == null) {
        e = curEvent;
    } else {
        if (event == null) {
            curEvent = e;
        }
    }
    if (node == null) {
        isCallBack = false;
        isNextAuto = false;
        return;
    }
    var tree = Ext.getCmp('myTree');
    //如果是回调函数，则运行
    if (isCallBack) {
        var firstNode = node.firstChild;
        if (firstNode.isLeaf()) {
            isCallBack = false;
            isNextAuto = false;
            if (tree.fireEvent('beforeclick', firstNode)) {
                tree.fireEvent('click', firstNode, e);
            }
        } else {
            isNextAuto = true;
            firstNode.expand();
        }
    }
    //如果是自动展开，判断是否是叶子，如果是，则触发其事件，否则将其第一个子节点传入递归调用。
    else if (isNextAuto) {
        if (node.isLeaf()) {
            isNextAuto = false;
            if (tree.fireEvent('beforeclick', node)) {
                tree.fireEvent('click', node, e);
            }
        } else {
            node.expand();
            findNextSibling(node.firstChild, e);
        }
    }
    else if (!node.isLast()) {
        //如果后一个同级接点是leaf,则直接触发相关树的事件。
        if (node.nextSibling.isLeaf()) {
            isNextAuto = false;
            if (tree.fireEvent('beforeclick', node.nextSibling)) {
                tree.fireEvent('click', node.nextSibling, e);
            }
        } else {
            //用长度来判断是否接点已经加载过
            if (node.nextSibling.childNodes.length > 0) {
                //若已经加载，则展开
                node.nextSibling.expand();
                //判断同级的后一个节点是否是leaf，若是，则直接触发相关树的事件，否则将传入本函数递归调用。
                if (node.nextSibling.firstChild.isLeaf()) {
                    isNextAuto = false;
                    if (tree.fireEvent('beforeclick', node.nextSibling.firstChild)) {
                        tree.fireEvent('click', node.nextSibling.firstChild, e);
                    }
                } else {
                    isNextAuto = true;
                    node.nextSibling.firstChild.expand();
                    findNextSibling(node.nextSibling.firstChild, e);
                }
            }
            //若以前未加载，则将起展开，自动执行回调函数
            else {
                isNextAuto = true;
                node.nextSibling.expand();
            }
        }
    } else if (node.parentNode == null) {
        return;
    } else {
        var parentNode = node.parentNode;
        findNextSibling(parentNode, e);
    }
}