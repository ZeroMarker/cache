// ����:  �������Ǽ�
// ����:  
// ��д�ߣ�why
// ��д����:2017-06-28
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
    testStringAjax()  ;
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,autohisoutmedvouchMain]
	});
});