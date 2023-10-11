Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	var itemID;
	var uPanel = new Ext.Panel({
		title: '单项凭证审核',
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
	Ext.QuickTips.init();                             //初始化所有Tips
	
	var tabPanel = new Ext.Panel({
  	layout: 'border',
  	region:'center',
  	items:[itemGrid]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
}); */