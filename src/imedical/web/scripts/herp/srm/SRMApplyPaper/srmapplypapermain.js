
Ext.onReady(function(){
	
	Ext.QuickTips.init();                             //论文申请管理

	var tPanel =  new Ext.Panel({
		title:'论文投稿申请',
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