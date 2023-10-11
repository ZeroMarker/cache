
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var uPanel =  new Ext.Panel({
		//title: '科目初始余额录入',
		layout: 'border',
		region:'center',
		items:[query,itemGrid]                                 //添加Tabs
    });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'mainPanel'
  });
});