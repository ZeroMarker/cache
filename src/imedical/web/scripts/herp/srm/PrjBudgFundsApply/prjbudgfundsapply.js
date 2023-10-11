Ext.onReady(function(){
	Ext.QuickTips.init();

	var usercode = session['LOGON.USERCODE'];
	
	var uPanel = new Ext.Panel({
		title: '科研项目经费编制',
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