// ����: ��Ч���
// ����: ��Ч���
// ��д�ߣ�������
// ��д����:2010-9-8
//--------------------------------------------------------------
			
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,deptTree,kpiTree]
	});
});