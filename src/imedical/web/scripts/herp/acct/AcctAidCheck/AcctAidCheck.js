Ext.onReady(function(){
	Ext.QuickTips.init();
	var uPanel = new Ext.Panel({
		//title: '��ƺ�����ά��',
		region: 'center',
		layout: 'border',
		items: [AcctCheckTypeBookGrid,AcctCheckItemGrid]
		
	});
	/* var uTabPanel = new Ext.TabPanel({
		activeTab : 0,
		region: 'center',
		items: uPanel                           
	}); */
	var umainPanel = new Ext.Viewport({
		layout: 'border',
		items : uPanel,
		renderTo: 'umainPanel'
	});
});
