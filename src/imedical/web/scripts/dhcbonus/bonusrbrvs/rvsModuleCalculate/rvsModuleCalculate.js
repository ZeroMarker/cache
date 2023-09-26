﻿/**
  *name:targettypecs
  *author:guojing
  *Date:2016-5-30
 */

/*
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var tabPanel = new Ext.TabPanel({
		activeTab:0,
		region:'center',
		items:[ModuleCalTab]
		});
		
		var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: tabPanel,
			renderTo: 'mainPanel'
			});
	});

*/
/*
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var tabPanel = new Ext.TabPanel({
		activeTab:0,
		region:'center',
		items:[ModuleCalcDetailTab]
		});
		
		var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: tabPanel,
			renderTo: 'mainPanel'
			});
	});
*/
Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	
	var uPanel = new Ext.Panel({
		title: '模型测算',
		region: 'center',
		autoScroll:true,
		layout: 'border',
		items: [ModuleCalTab,ModuleCalcDetailTab]
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