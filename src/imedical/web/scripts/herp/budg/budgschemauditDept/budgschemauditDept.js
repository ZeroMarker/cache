﻿Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
		title: '全院预算归口',
		region: 'center',
		layout: 'border',
		//items: [budgschemauditmain,scheme02Main]
		items: [budgschemauditmainDept,schemeaudititemMainDept]
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                           
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});