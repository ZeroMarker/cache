Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uTabPanel = new Ext.Panel({
		// activeTab: 0,
		//title:"�ֽ��ռ�������ƾ֤",
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


