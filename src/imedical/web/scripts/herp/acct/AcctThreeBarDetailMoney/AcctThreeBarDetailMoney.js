Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips


			
    //============================查看=========================================//
    var viewPanel = new Ext.Viewport({
    	layout: 'border',
    	renderTo:'mainPanel',
		items : [{
			region:'north',
			// title:'科目三栏明细账-金额式(多科目)',						
			height:45,
			// split:true,
			// collapsible:true,
			layout:'fit',
			items:formPanel
		},{
			region:'center',
			layout:'fit',
			items:reportPanel
		}]
    
    });
});