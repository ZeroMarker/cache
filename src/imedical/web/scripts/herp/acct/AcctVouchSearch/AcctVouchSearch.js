
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var uPanel =  new Ext.Panel({
		//title: '凭证查询',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[queryPanel,itemGrid]                                 //添加Tabs
    });
/*
    var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                           
	});
	*/
	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'mainPanel'
  });

});