// ����: �ӿڲ�����ά����������
// ����: ����ӿڲ�����ά�������Ԫ��
// ��д�ߣ�����
// ��д����:2009-10-13
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[InDeptSetsMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});