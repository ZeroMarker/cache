// ����: �ɱ���̯�׳ɱ���̯�׶�
// ����: �ɱ���̯�׳ɱ���̯�����Ԫ��
// �ɱ���̯����
// ��д����:2009-10-13
Ext.onReady(function(){
	Ext.QuickTips.init();                             //�ɱ���̯��Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[costDistSetsMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});