Ext.onReady(function(){
	
	Ext.QuickTips.init();
	var panel=new Ext.Panel({
		//title:'ҩƷ���ҵ����ϸ',
		region:'center',
		layout:'border',
		items:[GridDetail,Title]
		
	});
	
	//var tabPanel=new Ext.TabPanel({
	//	activeTab: 0,
	//	region: 'center',
	//	items: panel   
		
	//});
	
	var viewPort=new Ext.Viewport({
		
		layout: 'border',
		items : panel,
		renderTo: 'viewPort'
	});
});