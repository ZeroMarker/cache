// Ãû³Æ: ½ÇÉ«±í
Ext.onReady(function(){
	Ext.QuickTips.init();                             

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[mainPanel]                     
  });

	new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});