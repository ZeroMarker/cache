Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	

	
	var uPanel = new Ext.Panel({
		title: '项目到位经费登记',
		region: 'center',
		layout: 'border',
		items: [itemGrid,DetailGrid]
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