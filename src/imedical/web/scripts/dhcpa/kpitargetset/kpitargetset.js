// ����: KPIĿ������
// ����: KPIĿ������
// ��д�ߣ�������
// ��д����:2010-08-23
//--------------------------------------------------------------
			
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		region:'center',
		items:[deptMain]            //ȥ����Ŀ��ֽ�ִ�� autohisoutmedvouchForm                
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : tabPanel,
		renderTo: 'mainPanel'
	});
});