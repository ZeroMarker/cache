// ����: KPIָ���������ý�������
// ����: ����KPIָ���������ø�Ԫ��
// ��д�ߣ�wang ying
// ��д����:2010-09-14
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[SchemUnitDetailGrid1]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});