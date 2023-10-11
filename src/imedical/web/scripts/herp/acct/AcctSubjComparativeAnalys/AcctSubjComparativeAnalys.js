Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips


			
    //============================查看=========================================//
	var viewpanel=new Ext.Viewport({
		layout:"border",
		renderTo:'viewpanel',
		items:[{
			region:'north',
			// title:'科目对比分析',
			height:45,
			items:formPanel
			
		},{
			region:'center',
			layout:'fit',
			items:reportPanel
		}]
	});
});	
	
