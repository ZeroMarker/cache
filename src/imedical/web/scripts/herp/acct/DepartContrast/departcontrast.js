Ext.onReady(function(){
	Ext.QuickTips.init();
	var tabpanel=new Ext.Panel({
		title:'��ƿ��Ҷ���ά��',
		iconCls:'maintain',
		layout:'border',
		region:'center',
		items:[queryPanel,gridpanel]
	});
	
	var viewprot=new Ext.Viewport({
		layout:'border',
		items:tabpanel,
		renderTo:'viewprot'
	});
	
});