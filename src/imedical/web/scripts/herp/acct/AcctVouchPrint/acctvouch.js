
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
	title:"凭证打印管理",
	iconCls : 'find',
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,itemGrid]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});