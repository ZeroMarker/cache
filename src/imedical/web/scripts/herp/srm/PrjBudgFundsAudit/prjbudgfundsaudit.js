Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';

	var usercode = session['LOGON.USERCODE'];
	
	var uPanel = new Ext.Panel({
		title: '������Ŀ���ѱ������',
		region: 'center',
		layout: 'border',
		items: [prjbudgfundsGrid,prjbudgfundsDetail]
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                           
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uPanel,
		renderTo: 'uViewPort'
	});
});