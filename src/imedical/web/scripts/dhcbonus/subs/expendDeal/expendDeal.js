// ����: �������ݲɼ�ҳ������
// ����: ����ָ�����ݲɼ������Ԫ��
// ��д�ߣ�zhao liguo
// ��д����:2011-06-10
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[IncomeCollectMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});