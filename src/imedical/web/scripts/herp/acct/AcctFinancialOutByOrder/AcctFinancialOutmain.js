Ext.onReady(function(){
	
	Ext.QuickTips.init();
	var panel=new Ext.Panel({
		//title:'×Ê²úÕÛ¾ÉÆ¾Ö¤',
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