/**
  *name:targettype
  *author:liuyang
  *Date:2011-1-5
 */
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

  var uPanel = new Ext.Panel({
		region: 'center',
		layout: 'border',
		items: [TargetTypeTab]
	});
	
	var uViewPort = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'uViewPort'
  });
});