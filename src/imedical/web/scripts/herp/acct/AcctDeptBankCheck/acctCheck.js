Ext.onReady(function(){
	Ext.QuickTips.init();  

	//初始化所有Tips
	var acctCheckPanel = new Ext.Panel({
    //title : '单位银行对账',
    layout : 'border',
	region:'center',
    items:[queryPanel,Detail,itemGrid]   // acctCheckTypeGrid,acctCheckItemGrid     
	});
	
	// var tabPanel = new Ext.TabPanel({
  	// activeTab:0,
  	// region:'center',
  	// items:[acctCheckPanel]                                 //添加Tabs
  // });
 
	var MainViewPort = new Ext.Viewport({
      layout:'border',
      items : acctCheckPanel,
      renderTo: 'MainViewPort'
  });
});

