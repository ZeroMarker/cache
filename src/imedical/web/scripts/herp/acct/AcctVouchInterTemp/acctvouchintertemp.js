
Ext.onReady(function () {
	Ext.QuickTips.init(); //初始化所有Tips
	
	var tabPanel = new Ext.Panel({
			title: '凭证接口配置维护',
			iconCls:'maintain',
			layout:'border',
			region: 'center',
			items: [queryPanel,itemGrid]//添加Tabs
		});

	var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: tabPanel,
			renderTo: 'mainPanel'
		});
});
