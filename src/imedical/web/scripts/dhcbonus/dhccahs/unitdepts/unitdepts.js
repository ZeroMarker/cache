// ����: ��λ��������������
// ����: ���뵥λ�������ά�������Ԫ��
// ��д�ߣ���ӮӮ
// ��д����:2009-9-25
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[unitDeptsMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});