Ext.onReady(function(){
	Ext.QuickTips.init();                           
	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[autohisoutMain,autohisoutincomeMain]               
  });
	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel
  });
});