
Ext.onReady(function(){
	Ext.QuickTips.init();                             //≥ı ºªØTips

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,itemGrid]                                 //ÃÌº”Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});