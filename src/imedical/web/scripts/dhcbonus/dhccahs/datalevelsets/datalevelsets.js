var reportPanel;                                 //总面板
var reportTabPanel;                              //Tab面板

Ext.onReady(function(){
	Ext.QuickTips.init();                        //初始化所有Tips
	
	reportPanel = new Ext.Panel({
     	title : '数据分层表',
     	layout : 'border',
			region:'center',
     	items : [detailReport,deptLevelSetsGrid]                  //添加Tab面板
	});
	reportTabPanel = new Ext.TabPanel({
   		activeTab: 0,
			region: 'center',
   		items:reportPanel         //添加Tabs
 		});
	var mainPanel = new Ext.Viewport({
     	layout:'border',
     	items : reportTabPanel,
     	renderTo: 'mainPanel'
 	})
});