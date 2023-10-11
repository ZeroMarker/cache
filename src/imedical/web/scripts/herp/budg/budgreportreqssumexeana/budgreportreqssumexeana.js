Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

  	var mainPanel = new Ext.Viewport({
  		layout : 'border',
					items : [{
						region:'north', //region:'north',
						//width:250,
						//split: true, 
						title : '全院收支预算累计执行分析',   
						height:182,
						collapsible : true,						
						layout:'fit',
						items: searchPanel
					},{
						region:'center',
						layout:'fit',
						items:reportPanel
					}],
  		renderTo: 'mainPanel'
  	});
  
  ShowReport();

});