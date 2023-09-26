var reportPanel;                               
var reportTabPanel;   
var inItemSel;       
var outItemsDs;  
var initemrowid="";                 

Ext.onReady(function(){
	Ext.QuickTips.init();                  
	
	reportPanel = new Ext.Panel({
    title : '接口核算项目表',
    layout : 'border',
		region:'center',
    items : [outItemsGrid,inItemsGrid]            
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