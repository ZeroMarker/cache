Ext.onReady(function () {
	Ext.QuickTips.init(); //初始化所有Tips

	var tabPanel = new Ext.Panel({
			// title: '往来账账龄区间管理',
			layout: 'border',
			region: 'center',
			items: [AcctAgeareamain]//添加Tabs
		});

	var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: tabPanel,
			renderTo: 'mainPanel'
		});
});
