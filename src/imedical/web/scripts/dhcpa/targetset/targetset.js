// ����: �б༭Ŀ��ֵ��������ҳ��
// ����: ����Ŀ��ֵ����
// ��д�ߣ�wang ying
// ��д����:2011-02-22
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[targetSetMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});