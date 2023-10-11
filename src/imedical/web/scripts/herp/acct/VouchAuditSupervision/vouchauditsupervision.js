
Ext.onReady(function () {
	Ext.QuickTips.init(); //初始化所有Tips

	var uPanel = new Ext.Panel({
			title: '凭证监管和审计查询',
			iconCls:'find',
			layout: 'border',
			region: 'center',
			items: [queryPanel,itemGrid]//添加Tabs
		});

	var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: uPanel,
			renderTo: 'mainPanel'
		});
});
