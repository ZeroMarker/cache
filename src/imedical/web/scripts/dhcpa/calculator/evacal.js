// ����: ��������
// ����: ��������
// ��д�ߣ�������
// ��д����:2010-9-1
//--------------------------------------------------------------
			
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		region:'center',
		items:[autohisoutmedvouchForm]                            
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : tabPanel,
		renderTo: 'mainPanel'
	});
});