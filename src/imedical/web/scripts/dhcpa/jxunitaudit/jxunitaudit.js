// ����: ��Ч��ԪȨ�����ù���
// ����: ��Ч��ԪȨ�����ù���
// ��д�ߣ�������
// ��д����:2010-08-4
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[JXUnitAuditTab]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});