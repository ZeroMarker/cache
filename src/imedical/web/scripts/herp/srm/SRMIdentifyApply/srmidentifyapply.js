
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tPanel =  new Ext.Panel({
		//title:'科研鉴定申请',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[queryPanel,itemGrid]                                 //添加Tabs
  });
	/* 
	var tabPanel = new Ext.TabPanel({
		activeTab:0,
		region:'center',
		items:tPanel  、、tabPanel
	});
	 */
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : tPanel,
		renderTo: 'mainPanel'
  });
});