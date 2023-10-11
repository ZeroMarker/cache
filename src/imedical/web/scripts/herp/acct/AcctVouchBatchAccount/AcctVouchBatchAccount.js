
Ext.onReady(function(){
	Ext.QuickTips.init();	
	var toppanel=new Ext.Panel({
		title:"ф╬ж╓╪гук",
		iconCls:'find',
		region:"center",
		layout:"border",
		items:[queryPanel,VouchBatchGrid]
	});
	
/* 	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: toppanel                           
	}); */

	var viewpanel=new Ext.Viewport({
		layout:"border",
		items:toppanel,
		renderTo:'viewpanel'		
	});
});	
	
