// ����: ָ��ȼ���ָ�������ս�������
// ����: ����ȼ������Ԫ��
// ��д�ߣ�wang ying
// ��д����:2013-07-16
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[KPILvelMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});