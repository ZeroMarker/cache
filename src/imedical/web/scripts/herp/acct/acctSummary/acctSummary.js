// JavaScript Document
// ����: ������λ��Ϣ��������
// ����: ��ʾ������λ��Ϣ
// ��д�ߣ�����ƽ
// ��д����:2013-08-27
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.Panel({
	layout: 'border',	
  	activeTab: 0,
  	region:'center',
  	items:[acctSummaryMain]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});