Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
	
	var tabPanel = new Ext.Panel({
  	layout: 'border',
  	region:'center',
  	items:[itemGrid,queryPanel]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});