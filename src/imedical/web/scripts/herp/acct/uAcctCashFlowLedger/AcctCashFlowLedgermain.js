
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
		//title: '�ֽ��������ݳ�ʼ��',
		region: 'center',
		layout: 'border',
		items: [itemGrid,query]
	});
	//items: [itemGrid,detailGrid]
	// var uTabPanel = new Ext.TabPanel({
		// activeTab: 0,
		// region: 'center',
		// items: uPanel                           
	// });

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uPanel,
		renderTo: 'uViewPort'
	});
});