/**
  *name:MainteDepWork
  *describe:���ҹ�����ά��
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
		title:'Drgs��Ŀά��',
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