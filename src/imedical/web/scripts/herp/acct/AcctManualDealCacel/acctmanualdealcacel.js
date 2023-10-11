Ext.onReady(function(){
	Ext.QuickTips.init();
	
	
	var uPanel = new Ext.Panel({
		//title: '往来核销-手动核销',
		region: 'center',
		layout: 'border',
		items: [queryPanel,DebitGrid,CreditGrid]
	});

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