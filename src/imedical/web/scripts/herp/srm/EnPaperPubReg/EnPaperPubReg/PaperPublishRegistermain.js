
Ext.onReady(function(){
	
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tPanel =  new Ext.Panel({
		title:'���ı����뽱������',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[queryPanel,itemGrid]                                 //���Tabs
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