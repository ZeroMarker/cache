
Ext.onReady(function () {
	Ext.QuickTips.init(); //��ʼ������Tips

	var tabPanel = new Ext.Panel({
			title: 'ҵ��ϵͳģ��ά��',
			iconCls: 'maintain',
			layout: 'border',
			region: 'center',
			items: [itemGrid]//���Tabs
		});

	var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: tabPanel,
			renderTo: 'mainPanel'
		});
});
