Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips


			
    //============================查看=========================================//
    var viewPanel = new Ext.Viewport({
    	layout: 'border',
    	renderTo:'mainPanel',
		items : [{
			region:'north',
			//title:'科目多栏明细账',						
			height:40,
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