Ext.onReady(function () {
	Ext.QuickTips.init(); //��ʼ������Tips

	var tabPanel = new Ext.Panel({
			// title: '�����������������',
			layout: 'border',
			region: 'center',
			items: [AcctAgeareamain]//���Tabs
		});

	var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: tabPanel,
			renderTo: 'mainPanel'
		});
});
