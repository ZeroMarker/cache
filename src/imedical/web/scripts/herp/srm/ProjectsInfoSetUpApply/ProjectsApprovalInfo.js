Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel =  new Ext.Panel({
	title:'项目立项',
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	//items:[itemGrid,DetailGrid]                       //添加Tabs
	items:itemGrid                  //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});