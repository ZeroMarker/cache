Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
	var tabPanel =  new Ext.Panel({
  	layout: 'border',
  	region:'center',
  	items:[ListTab,reportPanel]                                 //���Tabs,main������дqueryPanel
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });

		// ҳ�沼��
		// var mainPanel = new Ext.Viewport({
					// layout : 'border',
					// renderTo:'mainPanel',
					// items : [{
						// region:'north',
						// title:"��ʼ���˶Ա�",
						// height:70,
						// split:true,
						// collapsible:true,
						// layout:'fit',
						// items:ListTab
					// },{
						// region:'center',
						// layout:'fit',
						// items:reportPanel
					// }]
				// });
});