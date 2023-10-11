Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips


  var uPanel = new Ext.Panel({
		title: '未采集数据查询',
		region: 'center',
		layout: 'border',
  	    items: [itemGrid]
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