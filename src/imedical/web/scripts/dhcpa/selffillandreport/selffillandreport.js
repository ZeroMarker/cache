// ����: �Բ��
// ����: �Բ��
// ��д�ߣ���С��
// ��д����:2015-05-21
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
 
	var mainPanel = new Ext.Panel({
		layout: 'border',
		id :'mainPanel',
		title:'�����Բ�',
		items :[autohisoutmedvouchForm,editGrid]
	});
	
	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: [mainPanel]                           
	});
	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
	

});