Ext.onReady(function(){
	Ext.QuickTips.init();  
	//初始化所有Tips
	var acctCheckPanel = new Ext.Panel({
    title : '会计核算维护',
    layout : 'border',
	region:'center',
    items:[acctCheckTypeGrid]   // acctCheckTypeGrid,acctCheckItemGrid     
	});
	
	var tabPanel = new Ext.TabPanel({
  	activeTab:0,
  	region:'center',
  	items:[acctCheckPanel]                                 //添加Tabs
  });
 
	var MainViewPort = new Ext.Viewport({
      layout:'border',
      items : tabPanel,
      renderTo: 'MainViewPort'
  });
});