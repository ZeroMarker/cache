
Ext.onReady(function(){
	
	Ext.QuickTips.init();                             //初始化所有Tips
   
	var tabPanel =  new Ext.Panel({
	//title: '坏账计提设置',	
  	//activeTab: 0,
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