Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	

	
	var uPanel = new Ext.Panel({
		title: '��ĿԤ���ѯ',
		region: 'center',
		layout: 'border',
		items: [itemSW,itemNW,itemNE,itemSE] //, itemNE,,itemNE,itemNE,itemSE,itemSW
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                           
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});