// ����: �ļ�����
// ��д�ߣ�������
// ��д����:2012-2-13
//--------------------------------------------------------------
			
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		region:'center',
		items:[FileManagerTab]                            
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : tabPanel,
		renderTo: 'mainPanel'
	});
});