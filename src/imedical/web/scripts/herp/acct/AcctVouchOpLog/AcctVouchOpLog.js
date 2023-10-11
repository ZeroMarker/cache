Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

 	var uPanel = new Ext.Panel({
		title: '凭证处理记录查询',
		iconCls:'find',
		height:20,
		region: 'center',
		layout: 'border',
		items: [queryPanel,itemGrid]
	});

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'mainPanel'
  });
});