// ����: �������ݷֽ�
// ����: �����������ݷֽ�����Ԫ��
// ��д�ߣ�limingzhong
// ��д����:2011-06-23
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[IncomeDataAssignmentMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});