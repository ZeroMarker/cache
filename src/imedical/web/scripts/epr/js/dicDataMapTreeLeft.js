 /**
 Creator:	杜金蓉
 Desc:		代码表与值域映射   自定义字典 左边树
 */
var nodeid='';
var nodeCode='';
//生成左边数
var Tree = Ext.tree
var treeLoader = new Tree.TreeLoader({ dataUrl :"../CT.WS.web.DicDataValueLeftJson.cls"});
var tree = new Tree.TreePanel({
	el: 'categoryTreediv',
	id: "categoryTree",
	rootVisible: true,
	autoScroll: false,
	animate: false,
	autoHeight: true,
	containerScroll: true,
	lines: true,
	checkModel: 'cascade',
	border: false,
	loader: treeLoader
});
//左边树枝
var root = new Tree.AsyncTreeNode({
	text: '自定义字典',
	nodeType: 'async',
	draggable: false,
	id: "RT0"
});
//展开左边树
tree.setRootNode(root);
root.expand();
//点击树的叶子执行时间
tree.on('dblclick', function(node, event) {
	SelectedNode = node;
	this.fireEvent('treeselected', node);
});
//选择树时执行函数
tree.on('treeselected', function(node, event) {
	nodeid =node.id
	var nodeids=nodeid.split("^");
	parent.reloadstore(nodeids[0],nodeids[1],nodeids[2]);//调用dicDataValueMap.js里面的方法。reloadstore(nodeid);
	parent.reloadMapstore(nodeids[0],nodeids[1],nodeids[2]);//调用dicDataValueMap.js里面的方法。reloadMapstore(nodeid);
});
//显示数
var treeport = new Ext.Viewport({
	id: 'treeport',
	width: 300,
	height: 300,
	autoScroll: true,
	items:[
		tree
		]
});
