// ����:  ��Ч�������
// ����:  ��Ч�������
// ��д�ߣ�����
// ��д����:2010-09-19
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,autohisoutmedvouchMain]
	});
});