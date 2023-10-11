Ext.onReady(function(){
	
	Ext.QuickTips.init();
	var panel=new Ext.Panel({
		//title:'人事工资凭证',
		region:'center',
		layout:'border',
		items:[queryPanel,itemGrid,wagesitemgrid]		
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
})
