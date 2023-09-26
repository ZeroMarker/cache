Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	
	var uPanel = new Ext.Panel({
		title: '质量管理信息维护',
		region: 'center',
		layout: 'border',
		//items: [itemGrid,combos]
		//items: [querypanel,reportpanel]
		items: [querypanel,itemGrid]
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

