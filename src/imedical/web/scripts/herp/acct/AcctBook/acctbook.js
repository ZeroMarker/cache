
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

  var uPanel = new Ext.Panel({
		region: 'center',
		layout: 'border',
		items: [itemGrid]
	});
	
	var uViewPort = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'uViewPort'
  });
});