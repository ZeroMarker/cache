
Ext.onReady(function () {

	Ext.QuickTips.init(); //初始化所有Tips

	var tabPanel = new Ext.Panel({
			title: '试算平衡&启用账套',
			iconCls:'maintain',
			activeTab: 0,
			layout: 'border',
			region: 'center',
			items: [queryPanel, itemGrid]//添加Tabs
		});

	var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: tabPanel,
			renderTo: 'mainPanel'
		});
});
