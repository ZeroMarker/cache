
Ext.onReady(function () {
	Ext.QuickTips.init(); //��ʼ������Tips
	
	var tabPanel = new Ext.Panel({
			title: 'ƾ֤�ӿ�����ά��',
			iconCls:'maintain',
			layout:'border',
			region: 'center',
			items: [queryPanel,itemGrid]//���Tabs
		});

	var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: tabPanel,
			renderTo: 'mainPanel'
		});
});
