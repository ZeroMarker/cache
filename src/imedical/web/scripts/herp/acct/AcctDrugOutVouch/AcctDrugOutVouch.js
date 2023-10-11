Ext.onReady(function(){
	
	Ext.QuickTips.init();
	var panel=new Ext.Panel({
		region:'center',
		layout:'border',
		items:[queryPanel,itemGrid,itemGridf]
		
	});
	
	// var tabPanel=new Ext.TabPanel({
		// activeTab: 0,
		// region: 'center',
		// items: panel   
		
	// });
	
	var viewPort=new Ext.Viewport({
		
		layout: 'border',
		items : panel,
		renderTo: 'viewPort'
	});
});