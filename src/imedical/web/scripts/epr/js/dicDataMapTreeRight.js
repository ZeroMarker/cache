 /**
 Creator:	杜金蓉
 Desc:		代码表与值域映射   值域代码表  右边树
 */
 //定义树
var Tree = Ext.tree
var treeLoader= new Tree.TreeLoader({ 
	dataUrl :"../CT.WS.web.DicDataValueMapRightTree.cls" ,
	method: 'POST',
	listeners: {
		'beforeload': function() {
		treeLoader.baseParams = {findData:document.getElementById('findDataright').name};
		}}
	
	});

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

var root = new Tree.AsyncTreeNode({
	text: '值域代码表',
	nodeType: 'async',
	draggable: false,
	id: "RT0"
});

tree.setRootNode(root);
root.expand();

tree.on('dblclick', function(node, event) {
	SelectedNode = node;
	this.fireEvent('treeselected', node);
});
tree.on('treeselected', function(node, event) {
	nodeid =node.id
	var nodeids=nodeid.split("^");
	parent.reloadstoreright(nodeids[0],nodeids[1]);//调用dicDataValueMap.js里面的方法。reloadstoreright(nodeid);
});

var treeport = new Ext.Viewport({
	id: 'treeport',
	width: 300,
	height: 300,
	autoScroll: true,
	items:[{
		items:tree,
		height:Ext.getBody().getHeight(),
		tbar: [
			{
				id: 'finddata',
				name: 'finddata',
				xtype: 'textfield'
			},
			'-',
			{
				id: 'btnSearch',
				text: '查找',
				cls: 'x-btn-text-icon',
				icon: '../scripts/epr/Pics/btnSearch.gif',
				pressed: false
		}]
		}
		
		]
});
//查找按钮事件
var btnSearch= Ext.getCmp('btnSearch'); 
btnSearch.on('click',function(){
	findData=Ext.getCmp('finddata').getValue();
	document.getElementById('findDataright').name=findData;
	root.reload();
	
});	