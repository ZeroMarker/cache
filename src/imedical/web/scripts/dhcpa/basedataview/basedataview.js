// ����: �������ݲ�ѯ
// ����: �������ݲ�ѯ
// ��д�ߣ�������
// ��д����:2010-08-5
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,autohisoutmedvouchMain]
	});
});