Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	var itemID;
	var uPanel = new Ext.Panel({
		title: '����ƾ֤���',
		region: 'center',
		layout: 'border',
		items: [ListTab]
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

/* Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
	
	var tabPanel = new Ext.Panel({
  	layout: 'border',
  	region:'center',
  	items:[itemGrid]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
}); */