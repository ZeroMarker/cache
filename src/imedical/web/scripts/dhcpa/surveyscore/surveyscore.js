// ����: �����ʾ���ϸ
// ����: �����ʾ���ϸ
// ��д�ߣ�������
// ��д����:2011-05-31
//--------------------------------------------------------------
Ext.onReady(function(){
	//��ʼ������Tips
	Ext.QuickTips.init();                             
	
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,autohisoutmedvouchMain]
	});
	
});