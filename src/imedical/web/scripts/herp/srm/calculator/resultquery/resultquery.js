// ����: ��������ѯ
// ����: ��������ѯ
// ��д�ߣ�������
// ��д����:2010-9-6
//--------------------------------------------------------------
			
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,deptTree,kpiTree]
	});
});