Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
		title: 'Ω±œÓπ‹¿Ì',
		region: 'center',
		layout: 'border',
		items: [itemGrid]
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                           
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uPanel,
		renderTo: 'uViewPort'
	});
});