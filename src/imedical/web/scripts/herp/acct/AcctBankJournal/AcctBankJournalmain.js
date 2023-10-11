/**
*银行日记账维护页面
*/
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

 	var uPanel = new Ext.Panel({
		
		region: 'center',
		layout: 'border',
		items: [itemGrid,queryPanel]
	});

	// var uTabPanel = new Ext.TabPanel({
		// activeTab: 0,
		// region: 'center',
		// items: uPanel                           
	// });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'mainPanel'
  });
});