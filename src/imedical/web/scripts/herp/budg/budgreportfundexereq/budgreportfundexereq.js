Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

  	var mainPanel = new Ext.Viewport({
  	layout : 'border',
					items : [{
						title:"一般支出资金执行情况统计",
						region:'north',
						height:70,
						layout:'fit',
						collapsible : true,
						items:searchPanel
					},{
						region:'center',
						layout:'fit',
						items:reportPanel
					}],
  	renderTo: 'mainPanel'
  });
  
  ShowReport();

});