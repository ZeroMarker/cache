Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips


			
    //============================�鿴=========================================//
    var viewPanel = new Ext.Viewport({
    	layout: 'border',
    	renderTo:'mainPanel',
		items : [{
			region:'north',
			//title:'��Ŀ����-��ҽ��ʽ',						
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