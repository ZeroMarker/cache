// ����: �û�KPIȨ�޽�������
// ����: �����û�KPIȨ�޽����Ԫ��
// ��д�ߣ�wang ying
// ��д����:2010-07-29
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[KPIAuditMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});