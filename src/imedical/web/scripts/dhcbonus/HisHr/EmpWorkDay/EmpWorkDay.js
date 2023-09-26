
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips new Ext.Panel
	
	var uPanel = new Ext.Panel({
		title: '人事考勤信息',
		region: 'center',
		layout: 'border',
		items: [queryPanel,itemGrid]
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