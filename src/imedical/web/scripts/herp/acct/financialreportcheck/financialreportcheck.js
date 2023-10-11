
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.Panel({
  	region: 'center',
	layout: 'border',
  	items:[itemGrid,queryPanel]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});
