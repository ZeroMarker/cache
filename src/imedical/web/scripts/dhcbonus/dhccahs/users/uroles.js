// ��д�ߣ�����
// ��д����:2009-10-7
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
		title: '��ɫ���',
		region: 'center',
		layout: 'border',
		items: [usersGrid,rolesGrid]
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                                 //���Tabs
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});