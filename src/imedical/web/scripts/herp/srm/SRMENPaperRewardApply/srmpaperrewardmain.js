
Ext.onReady(function(){
	
	Ext.QuickTips.init();                             //åˆå§‹åŒ–æ‰€æœ‰Tips

	var tPanel =  new Ext.Panel({
		title:'Ó¢ÎÄÂÛÎÄ½±ÀøÉêÇë',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[queryPanel,itemGrid]                                 //æ·»åŠ Tabs
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