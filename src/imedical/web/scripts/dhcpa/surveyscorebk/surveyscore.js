// ����: �ȼ���������
// ����: ����ȼ������Ԫ��
// ��д�ߣ�wang ying
// ��д����:2011-04-28
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[SurveyScoreMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});