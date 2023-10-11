
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

  	var mainPanel = new Ext.Viewport({
  	layout : 'border',
					items : [{
						region:'north',
						height:100,
						layout:'fit',
						items:searchPanel
					},{
						region:'center',
						layout:'fit',
						items:itemGrid
					}],
  	renderTo: 'mainPanel'
  });
  
});