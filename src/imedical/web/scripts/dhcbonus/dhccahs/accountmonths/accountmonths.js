// ����: ������ά����������
// ����: ���������ά�������Ԫ��
// ��д�ߣ�������
// ��д����:2009-8-30
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[AccountMonthsMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});