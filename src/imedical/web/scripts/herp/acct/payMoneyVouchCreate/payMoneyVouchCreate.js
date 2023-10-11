Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel =  new Ext.Panel({
	//var tabPanel = new Ext.TabPanel({
  	//activeTab: 0,
  	region:'center',
  	layout: 'border',
  	items:[mainGrid]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
   Ext.getCmp('DimensionCodeText').focus();
});