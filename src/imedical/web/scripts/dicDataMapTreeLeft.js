 /**
 Creator:	�Ž���
 Desc:		�������ֵ��ӳ��   �Զ����ֵ� �����
 */
var nodeid='';
var nodeCode='';
//���������
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
//�����֦
var root = new Tree.AsyncTreeNode({
	text: '�Զ����ֵ�',
	nodeType: 'async',
	draggable: false,
	id: "RT0"
});
//չ�������
tree.setRootNode(root);
root.expand();
//�������Ҷ��ִ��ʱ��
tree.on('dblclick', function(node, event) {
	SelectedNode = node;
	this.fireEvent('treeselected', node);
});
//ѡ����ʱִ�к���
tree.on('treeselected', function(node, event) {
	nodeid =node.id
	var nodeids=nodeid.split("^");
	parent.reloadstore(nodeids[0],nodeids[1],nodeids[2]);//����dicDataValueMap.js����ķ�����reloadstore(nodeid);
	parent.reloadMapstore(nodeids[0],nodeids[1],nodeids[2]);//����dicDataValueMap.js����ķ�����reloadMapstore(nodeid);
});
//��ʾ��
var treeport = new Ext.Viewport({
	id: 'treeport',
	width: 300,
	height: 300,
	autoScroll: true,
	items:[
		tree
		]
});
