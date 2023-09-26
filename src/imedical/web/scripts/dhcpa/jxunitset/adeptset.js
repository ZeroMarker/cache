// 名称: 成本分层套界面启动
// 描述: 引入成本分层套界面各元素
// 编写者：李明忠
// 编写日期:2010-6-28
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
		title: rooText,
		region: 'center',
		layout: 'border',
		items: [detailReport,deptSetGrid]
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                                 //添加Tabs
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});