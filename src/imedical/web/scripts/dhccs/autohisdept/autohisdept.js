// ����: ��λ�������������
// ����: ���뵥λ����������Ԫ��
// ��д�ߣ���ӮӮ
// ��д����:2009-9-23
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[unittypesMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});