// ����: �ɱ��ֲ��׽�������
// ����: ����ɱ��ֲ��׽����Ԫ��
// ��д�ߣ�������
// ��д����:2010-6-28
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
		title: rooText,
		region: 'center',
		layout: 'border',
		items: [detailReport,deptSetGrid]
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