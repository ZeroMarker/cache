//树形结构导入器
var detailTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});

//加载前事件
detailTreeLoader.on('beforeload', function(detailTreeLoader,node){
	if(detailTreeRoot.value!="undefined"){
		var url="../csp/dhc.pa.schemauditexe.csp?action=schemdetaillist";
		detailTreeLoader.dataUrl=url+"&parent="+node.id+'&schemDr='+Ext.getCmp('schemField').getValue();
	}
});

//树形结构的根
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'绩效方案明细管理',
	layer:0,
	draggable:false,
	expanded:false,
	value:''
});