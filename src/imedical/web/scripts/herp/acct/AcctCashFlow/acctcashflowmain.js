
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
 
 	var uPanel = new Ext.Panel({
		//title: '�ֽ�������ѯ',
		region: 'center',
		layout: 'border',
		items: [itemGrid,query]
	});

	// var uTabPanel = new Ext.TabPanel({
		// activeTab: 0,
		// region: 'center',
		// items: uPanel                           
	// });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'mainPanel'
  });
});