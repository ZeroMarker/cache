
Ext.onReady(function () {
	Ext.QuickTips.init(); //��ʼ������Tips

	var tabPanel = new Ext.Panel({
			title: 'ҵ��ϵͳά��',
			iconCls: 'maintain',
			region: 'center',
			layout: 'border',
			items: [itemGrid]//���Tabs
		});

	var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: tabPanel,
			renderTo: 'mainPanel'
		});
});
