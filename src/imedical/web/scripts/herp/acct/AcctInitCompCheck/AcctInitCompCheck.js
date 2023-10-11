Ext.onReady(function(){
	Ext.QuickTips.init();
	var uPanel = new Ext.Panel({
		// title: '会计辅助帐初始化校验',
		// iconCls:'maintain',
		region: 'center',
		layout: 'border',
		items: [AcctTypeTabGrid,AcctCheckGrid]
		//items: [AcctTypeGrid]
	});

	var umainPanel = new Ext.Viewport({
		layout: 'border',
		items : uPanel,
		renderTo: 'umainPanel'
	});
});
