// ����: ��Ч����������ҷ������ý�������
// ����: ���뼨Ч���ҷ������ý����Ԫ��
// ��д�ߣ���С��
// ��д����:2015-06-15
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[JXQMConditionMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});