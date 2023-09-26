/**
  *name:MainteDepWork
  *describe:科室工作量维护
  *author:lxw
  *Date:2015-04-17
 */

Ext.onReady(function(){
	Ext.QuickTips.init();                        
	var reportTabPanel = new Ext.TabPanel({
    	activeTab: 0,
    	frame:true,
    	items:[detailReport]         
  	});
	var reportPanel = new Ext.Panel({
		title:'Drgs项目维护',
      	layout:'fit',
      	collapsible: false,
      	plain:true,
      	frame:true,
	region:'center',
      	items:reportTabPanel,           
	tbar:menubar                             
	});
	var mainPanel = new Ext.Viewport({
      	layout:'border',
      	items : reportPanel,
      	renderTo: 'mainPanel'
  	})
});