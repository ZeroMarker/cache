Ext.onReady(function(){
	Ext.QuickTips.init();
	var uPanel = new Ext.Panel({
		// title: '��Ƹ����ʳ�ʼ��У��',
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
