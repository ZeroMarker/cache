// ����:�ӿڷ���������ά��
// ����: �ӿڷ���������ά��
// ��д�ߣ�zhaoliguo
// ��д����:2011-04-26
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

var uPanel = new Ext.Panel({
		title: '�������ݲɼ��ӿ�ά��',
		region: 'center',
		layout: 'border',
		tbar: ['�ӿ������:',locSetTypeField,'�ӿ���:',interLocSetField],
		items: [InterMethodMain]  //,InterParamMain
	});
	
	
var methodPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[uPanel]                                 //���Tabs
  });
  

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : methodPanel,
  	renderTo: 'mainPanel'
  });
});