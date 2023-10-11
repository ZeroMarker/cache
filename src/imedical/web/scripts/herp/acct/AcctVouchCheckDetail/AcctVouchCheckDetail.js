
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel =  new Ext.Panel({
  	layout: 'border',
  	region:'center',
  	items:[itemGrid,queryPanel]                                 //添加Tabs,main函数里写queryPanel
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});

