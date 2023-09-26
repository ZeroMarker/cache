/**
  *author:liuyang
  *Date:2011-12-13
 */
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips
   
    var uPanel = new Ext.Panel({
		id :'uPanel',
	    title:'基层科室绩效考核计算',
		region: 'center',
		layout: 'border',
		items: [itemGrid,jxunitGrid,kpiGrid]
	});
	
	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:uPanel                                
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});