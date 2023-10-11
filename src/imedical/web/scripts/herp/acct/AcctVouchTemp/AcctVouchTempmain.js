Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
		title: '∆æ÷§¡Ÿ ±±Ì',
		region: 'center',
		layout: 'border',
		items: [itemMain,itemDetail] 
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                           
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});

