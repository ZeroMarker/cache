	var reportPanel=new Ext.Panel({
		autoScroll:true,                                   
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcbonus/common/logon_bg.jpg"/>'
	});
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[itemGrid]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : [{region:'north',height:300,collapsible:true,split:true,layout:'fit',items:tabPanel},{region:'center',
			layout:'fit',
			items:reportPanel}],
  	renderTo: 'mainPanel'
  });
  
});