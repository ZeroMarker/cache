var reportPanel;                               
var reportTabPanel;   
var inItemSel;       
var outItemsDs;  
var initemrowid="";                 

Ext.onReady(function(){
	Ext.QuickTips.init();                  
	
	reportPanel = new Ext.Panel({
    title : '�ӿں�����Ŀ��',
    layout : 'border',
		region:'center',
    items : [outItemsGrid,inItemsGrid]            
	});
	reportTabPanel = new Ext.TabPanel({
   		activeTab: 0,
		region: 'center',
   		items:reportPanel         //���Tabs
 		});
	var mainPanel = new Ext.Viewport({
     	layout:'border',
     	items : reportTabPanel,
     	renderTo: 'mainPanel'
 	})
});