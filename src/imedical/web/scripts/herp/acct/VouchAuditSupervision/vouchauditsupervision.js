
Ext.onReady(function () {
	Ext.QuickTips.init(); //��ʼ������Tips

	var uPanel = new Ext.Panel({
			title: 'ƾ֤��ܺ���Ʋ�ѯ',
			iconCls:'find',
			layout: 'border',
			region: 'center',
			items: [queryPanel,itemGrid]//���Tabs
		});

	var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: uPanel,
			renderTo: 'mainPanel'
		});
});
