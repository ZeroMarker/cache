
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

  var tPanel =  new Ext.Panel({
		title:'',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[queryPanel,itemGrid]                                 //添加Tabs
  });
  
	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:tPanel                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tPanel,
  	renderTo: 'mainPanel'
  });
});