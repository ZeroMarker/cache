// ����: �������
// ����: �������
// ��д�ߣ�humiao
// ��д����:2015-05-20
//--------------------------------------------------------------
			
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
    
	var uPanel = new Ext.Panel({
		id :'uPanel',
	    //title:'���м�����㼰��ѯ',
		region: 'center',
		layout: 'border',
		items: [calcuPanel,itemGrid]
	});
	
	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		region:'center',
		items:uPanel                           
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : uPanel,
		renderTo: 'mainPanel'
	});
});