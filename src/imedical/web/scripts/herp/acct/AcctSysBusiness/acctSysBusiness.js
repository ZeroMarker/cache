
Ext.onReady(function () {
	Ext.QuickTips.init(); //初始化所有Tips

	var tabPanel = new Ext.Panel({
			title: '业务系统维护',
			iconCls: 'maintain',
			region: 'center',
			layout: 'border',
			items: [itemGrid]//添加Tabs
		});

	var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: tabPanel,
			renderTo: 'mainPanel'
		});
});
