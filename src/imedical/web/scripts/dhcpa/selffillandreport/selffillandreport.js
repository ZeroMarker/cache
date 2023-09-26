// 名称: 自查填报
// 描述: 自查填报
// 编写者：刘小明
// 编写日期:2015-05-21
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips
 
	var mainPanel = new Ext.Panel({
		layout: 'border',
		id :'mainPanel',
		title:'科室自查',
		items :[autohisoutmedvouchForm,editGrid]
	});
	
	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: [mainPanel]                           
	});
	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
	

});