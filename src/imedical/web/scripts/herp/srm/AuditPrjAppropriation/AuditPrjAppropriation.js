Ext.onReady(function(){
	Ext.QuickTips.init();   //��ʼ������Tips

	var tPanel =  new Ext.Panel({
		title:'',
		layout: 'border',
		region:'center',
		items:[queryPanel,itemGrid]    //���Tabs
  });
	
	var tabPanel = new Ext.TabPanel({
		activeTab:0,
		region:'center',
		items:tPanel
	});
	
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : tPanel,
		renderTo: 'mainPanel'
  });
});