
Ext.onReady(function(){
	Ext.QuickTips.init();	


	var viewpanel=new Ext.Viewport({
		layout:"border",
		renderTo:'viewpanel',
		items:[{
			region:'north',
			// title:'��Ŀ��������',
			height:45,
			layout:'fit',
			items:formPanel
			
		},{
			region:'center',
			layout:'fit',
			items:reportPanel
		}]
	});
});	
	
