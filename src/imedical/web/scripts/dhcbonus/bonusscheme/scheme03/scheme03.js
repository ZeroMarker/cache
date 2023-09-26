Ext.onReady(function(){
	
	Ext.QuickTips.init();
	

	var uPanel = new Ext.Panel({
		title: '½±½ð·½°¸ÉóºË',
		region: 'center',
		layout: 'border',
		items: [schemeMain,schemeUnitMain,itemMain]
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