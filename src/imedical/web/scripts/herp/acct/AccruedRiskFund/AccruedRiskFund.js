
Ext.onReady(function(){
	Ext.QuickTips.init();
	var uPanel = new Ext.Panel({
		//title: '����ҽ�Ʒ��ջ���',
		region: 'center',
		layout: 'border',
		items: [queryPanel,riskfundGrid]
	});
	// var uTabPanel = new Ext.TabPanel({
		// activeTab : 0,
		// region: 'center',
		// items: uPanel                           
	// });
	var umainPanel = new Ext.Viewport({
		layout: 'border',
		items : uPanel,
		renderTo: 'umainPanel'
	});
});