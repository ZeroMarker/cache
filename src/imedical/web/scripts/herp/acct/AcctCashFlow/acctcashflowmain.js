
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips
 
 	var uPanel = new Ext.Panel({
		//title: '现金流量查询',
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