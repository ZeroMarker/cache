this.filterFieldName = new Ext.form.TextField({
name:'fdcName'
});
//this.tree.getTopToolbar().add(['功能名称：',this.filterFieldName,this.filterBtn,'->',this.expandBtn,this.collapseBtn]);

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
text: '根'
}),
autoHeight: true,
renderTo: 'tree'
});

tree.expandAll();

var filter = new Ext.tree.TreeFilter(tree, {
clearBlank: true,
autoClear: true
});

// 保存上次隐藏的空节点
var hiddenPkgs = [];
var field = Ext.get('filter');

// 按键后触发事件
field.on('keyup', function(e) {
var text = field.dom.value;

// 先要显示上次隐藏掉的节点
Ext.each(hiddenPkgs, function(n){
n.ui.show();
});

// 如果输入的数据不存在，就执行clear()
if(!text){
filter.clear();
return;
}
tree.expandAll();

// 根据输入制作一个正则表达式，'i'代表不区分大小写
var re = new RegExp(Ext.escapeRe(text), 'i');
filter.filterBy(function(n){
// 只过滤叶子节点，这样省去枝干被过滤的时候，底下的叶子都无法显示
return !n.isLeaf() || re.test(n.text);
});

// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
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

