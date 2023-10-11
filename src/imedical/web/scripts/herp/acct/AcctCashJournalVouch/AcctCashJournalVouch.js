Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uTabPanel = new Ext.Panel({
		// activeTab: 0,
		//title:"现金日记账生成凭证",
		layout: 'border',
		region: 'center',
		items: [queryPanel,itemGrid]                          
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});


