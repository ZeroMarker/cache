// ����: ս�Ե�����������
// ����: ����ս�Ե��������Ԫ��
// ��д�ߣ�wang ying
// ��д����:2010-07-05
//--------------------------------------------------------------
Ext.onReady(function(){
	//��ʼ������Tips
	Ext.QuickTips.init();                             

	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		region:'center',
		items:[ParamMain]    //���Tabs                             
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : tabPanel,
		renderTo: 'mainPanel'
	});
});