Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	
	var uPanel = new Ext.Panel({
		title: '科室信息维护',
		region: 'center',
		layout: 'border',
		//items: [itemGrid,combos]
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

