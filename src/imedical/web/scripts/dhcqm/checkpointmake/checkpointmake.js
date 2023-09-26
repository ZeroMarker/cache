Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	var itemID,importType;
	var uPanel = new Ext.Panel({
		title: '检查项目制定',
		region: 'center',
		layout: 'border',
		items: [itemGrid,personGrid]
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
