Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	
	var uPanel = new Ext.Panel({
		title: '项目信息管理',
		region: 'center',
		layout: 'border',
		items: [itemGrid,combos]
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