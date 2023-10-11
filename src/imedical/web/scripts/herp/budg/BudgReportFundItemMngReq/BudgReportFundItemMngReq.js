Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

  	var mainPanel = new Ext.Viewport({
  	layout : 'border',
					items : [{
						region:'north',
						height:150,
						layout:'fit',
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