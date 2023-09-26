/**
  *name:bonusunit
  *author:liuyang
  *Date:2011-1-19
 */

Ext.onReady(function(){
	Ext.QuickTips.init();                        
	var reportTabPanel = new Ext.TabPanel({
    	activeTab: 0,
    	frame:true,
    	items:[detailReport]         
  	});
	var reportPanel = new Ext.Panel({
		title:'奖金核算单元管理',
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