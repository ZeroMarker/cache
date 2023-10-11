
Ext.onReady(function () {
	Ext.QuickTips.init(); //初始化所有Tips

	var uPanel = new Ext.Panel({
			title: '辅助账初始化维护',
			iconCls: 'maintain',
			region: 'center',
			layout: 'border',
			items: [queryPanel,itemGrid]
		});

	var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: uPanel,
			renderTo: 'mainPanel'
		});
});
