this.filterFieldName = new Ext.form.TextField({
name:'fdcName'
});
//this.tree.getTopToolbar().add(['�������ƣ�',this.filterFieldName,this.filterBtn,'->',this.expandBtn,this.collapseBtn]);

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>05.tree</title>
<link rel="stylesheet" type="text/css" href="../../resources/css/ext-all.css" />
<script type="text/javascript" src="../../adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext-all-debug.js"></script>
<script type="text/javascript" src="localXHR.js"></script>
<script type="text/javascript">
Ext.onReady(function(){

var tree = new Ext.tree.TreePanel({
loader: new Ext.tree.TreeLoader({
dataUrl: 'http://localhost:8080/sos/TreeNodesServlet'
}),
root: new Ext.tree.AsyncTreeNode({
id: '0',
text: '��'
}),
autoHeight: true,
renderTo: 'tree'
});

tree.expandAll();

var filter = new Ext.tree.TreeFilter(tree, {
clearBlank: true,
autoClear: true
});

// �����ϴ����صĿսڵ�
var hiddenPkgs = [];
var field = Ext.get('filter');

// �����󴥷��¼�
field.on('keyup', function(e) {
var text = field.dom.value;

// ��Ҫ��ʾ�ϴ����ص��Ľڵ�
Ext.each(hiddenPkgs, function(n){
n.ui.show();
});

// �����������ݲ����ڣ���ִ��clear()
if(!text){
filter.clear();
return;
}
tree.expandAll();

// ������������һ���������ʽ��'i'���������ִ�Сд
var re = new RegExp(Ext.escapeRe(text), 'i');
filter.filterBy(function(n){
// ֻ����Ҷ�ӽڵ㣬����ʡȥ֦�ɱ����˵�ʱ�򣬵��µ�Ҷ�Ӷ��޷���ʾ
return !n.isLeaf() || re.test(n.text);
});

// �������ڵ㲻��Ҷ�ӣ���������û���ӽڵ㣬��Ӧ�����ص�
hiddenPkgs = [];
tree.root.cascade(function(n) {
if(!n.isLeaf() && n.ui.ctNode.offsetHeight < 3){
n.ui.hide();
hiddenPkgs.push(n);
}
});

})

});
</script>
</head>
<body>
<script type="text/javascript" src="../examples.js"></script>
<input id="filter" type="text" />
<div id="tree" style="height:300px;"></div>
</body>
</html>
