 /**
 Creator:	�Ž���
 Desc:		�������ֵ��ӳ��   ֵ������  �ұ���
 */
 //������
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
	text: 'ֵ������',
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
	parent.reloadstoreright(nodeids[0],nodeids[1]);//����dicDataValueMap.js����ķ�����reloadstoreright(nodeid);
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
				text: '����',
				cls: 'x-btn-text-icon',
				icon: '../scripts/epr/Pics/btnSearch.gif',
				pressed: false
		}]
		}
		
		]
});
//���Ұ�ť�¼�
var btnSearch= Ext.getCmp('btnSearch'); 
btnSearch.on('click',function(){
	findData=Ext.getCmp('finddata').getValue();
	document.getElementById('findDataright').name=findData;
	root.reload();
	
});	