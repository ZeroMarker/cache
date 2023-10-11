
Ext.onReady(function(){
	
	Ext.QuickTips.init();                             //初始化所有Tips

	var tPanel =  new Ext.Panel({
		//title:'科研获奖成果审批',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[queryPanel,itemGrid]                                 //添加Tabs
  });
	
	var tabPanel = new Ext.TabPanel({
		region:'center',
		activeTab:0,
		items:tPanel
	});
	
	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tPanel,
  	renderTo: 'mainPanel'
  });
});