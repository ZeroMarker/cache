Ext.onReady(function () {
	Ext.QuickTips.init(); //��ʼ������Tips
	var tabPanel = new Ext.Panel({
			// activeTab : 0,
			//title:"Ԥ��֧������",
			layout:'border',
			region : 'center',
			items : [querypanel, itemGrid]//���Tabs
		});
	var mainPanel = new Ext.Viewport({
			layout : 'border',
			items : tabPanel,
			renderTo : 'mainPanel'
		});

});