//���νṹ������
var detailTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});

//����ǰ�¼�
detailTreeLoader.on('beforeload', function(detailTreeLoader,node){
	if(detailTreeRoot.value!="undefined"){
		var url="../csp/dhc.pa.schemauditexe.csp?action=schemdetaillist";
		detailTreeLoader.dataUrl=url+"&parent="+node.id+'&schemDr='+Ext.getCmp('schemField').getValue();
	}
});

//���νṹ�ĸ�
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'��Ч������ϸ����',
	layer:0,
	draggable:false,
	expanded:false,
	value:''
});