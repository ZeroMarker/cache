Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	

	
	var uPanel = new Ext.Panel({
		title: '全院年度预算编制',
		region: 'center',
		layout: 'border',
		items: [itemMain,itemDetail] //queryPanel,,itemDetail itemMain,
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                           
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});


//Ext.onReady(function(){
//Ext.QuickTips.init();                             //初始化所有Tips
//
//var tabPanel = new Ext.TabPanel({
//	activeTab: 0,
//	region:'center',
//	items:[itemGrid]                                 //添加Tabs
//});
//
//var mainPanel = new Ext.Viewport({
//	layout: 'border',
//	items : tabPanel,
//	renderTo: 'mainPanel'
//});
//});



