// ����: �ӿ���Ա��ά����������
// ����: ����ӿ���Ա��ά�������Ԫ��
// ��д�ߣ�����
// ��д����:2010-10-27
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[personSetsMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});