
Ext.onReady(function () {
	Ext.QuickTips.init(); //��ʼ������Tips

	var uPanel = new Ext.Panel({
			title: '�����˳�ʼ��ά��',
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
