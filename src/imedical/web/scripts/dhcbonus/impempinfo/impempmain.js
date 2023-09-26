/**
  *name:deptbonuscalc
  *author:zhaoliguo
  *Date:2011-1-11
 */
 
 /*
 方案性质SchemeType
	1：科室核算方案
	2：干部核算方案
*/
var p_SchemeType = 1
Ext.onReady(function(){
	Ext.QuickTips.init();
	 
	
	var uPanel = new Ext.Panel({
		title: '人员信息导入',
		region: 'center',
		layout: 'border',
		items: [SchemGrid,bonusitemgrid]
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