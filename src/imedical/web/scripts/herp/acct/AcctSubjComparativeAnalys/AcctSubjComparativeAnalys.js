Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips


			
    //============================�鿴=========================================//
	var viewpanel=new Ext.Viewport({
		layout:"border",
		renderTo:'viewpanel',
		items:[{
			region:'north',
			// title:'��Ŀ�Աȷ���',
			height:45,
			items:formPanel
			
		},{
			region:'center',
			layout:'fit',
			items:reportPanel
		}]
	});
});	
	
