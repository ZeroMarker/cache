// JavaScript Document
// 名称: 计量单位信息界面启动
// 描述: 显示计量单位信息
// 编写者：胡克平
// 编写日期:2013-08-27
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.Panel({
	layout: 'border',	
  	activeTab: 0,
  	region:'center',
  	items:[acctSummaryMain]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});