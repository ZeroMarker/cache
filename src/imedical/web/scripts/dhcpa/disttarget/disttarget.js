// ����: Ŀ��ֽ�
// ����: Ŀ��ֽ�
// ��д�ߣ�������
// ��д����:2010-08-1
//--------------------------------------------------------------
Ext.onReady(function(){
	//��ʼ������Tips
	Ext.QuickTips.init();                             

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,autohisoutmedvouchMain]
	});
});