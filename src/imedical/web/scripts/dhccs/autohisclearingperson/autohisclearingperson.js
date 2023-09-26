Ext.onReady(function(){
	Ext.QuickTips.init();   

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : new Ext.TabPanel({
			activeTab: 0,
			region:'center',
			items:[unittypesMain]                              
		}),
		renderTo: 'mainPanel'
	});
});