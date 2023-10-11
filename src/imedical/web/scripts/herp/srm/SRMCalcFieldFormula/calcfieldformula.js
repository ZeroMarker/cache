
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	/* var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[itemGrid]                                 //添加Tabs
  }); */

	var uPanel = new Ext.Panel({
		region: 'center',
		layout: 'border',
		items: [itemGrid]
	});

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'mainPanel'
  });
});