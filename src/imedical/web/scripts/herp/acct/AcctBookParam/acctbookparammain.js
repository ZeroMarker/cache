
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
	    title:'基础信息',  
		region: 'center',
		layout: 'border',
		tbar:[saveButton],
		items: queryPanel
	});
  var uPrjVoucherPanel = new Ext.Panel({
		//id :'uPrjVoucherPanel',
	    title:'凭证管理',
		region: 'center',
		layout: 'border',
		tbar:[saveButton1],
		items: queryPanel1
	});
	var uPrjCashBankPanel = new Ext.Panel({
		//id :'uPrjCashBankPanel',
	    title:'现金银行',
		region: 'center',
		layout: 'border',
		tbar:[saveButton2],
		items: queryPanel2
	});
	var uPrjTerminalPanel = new Ext.Panel({
		//id :'uPrjTerminalPanel',
	    title:'期末处理',
		region: 'center',
		layout: 'border',
		tbar:[saveButton3],
		items: queryPanel3
	});
	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: [uPanel,uPrjVoucherPanel,uPrjCashBankPanel,uPrjTerminalPanel]                          
	});

	var uViewPort = new Ext.Viewport({
		
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});


 
