
Ext.onReady(function(){
	
	Ext.QuickTips.init();                             //初始化所有Tips

	var tPanel =  new Ext.Panel({
		title:'论文报销与奖励申请',
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
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});