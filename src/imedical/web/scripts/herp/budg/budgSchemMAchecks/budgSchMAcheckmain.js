
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
	    title:'科室年度预算审核',
		region: 'center',
		layout: 'border',
		//MAitemGrid，DitemGrid
		items: [itemGrid,detailitemGrid]
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel            
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});
/**

Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel =  new Ext.Panel({
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
*/