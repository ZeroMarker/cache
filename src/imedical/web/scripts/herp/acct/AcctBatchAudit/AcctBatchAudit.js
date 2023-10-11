Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.Panel({
	title:"凭证审核",
	iconCls:'find',
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,itemGrid]                                 //添加Tabs
  });

 /*  var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: tabPanel                           
	}); */
	
	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});