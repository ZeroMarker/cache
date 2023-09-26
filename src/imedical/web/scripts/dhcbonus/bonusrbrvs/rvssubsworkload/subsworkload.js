﻿/**
  *name:targettypecs
  *author:guojing
  *Date:2016-2-24
 */


Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var tabPanel = new Ext.TabPanel({
		activeTab:0,
		region:'center',
		items:[RVSSubsWorkLoadTab]
		});
		
		var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: tabPanel,
			renderTo: 'mainPanel'
			});
	});




	