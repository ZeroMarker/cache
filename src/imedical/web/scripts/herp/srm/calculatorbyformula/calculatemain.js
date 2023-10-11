// 名称: 绩点计算
// 描述: 绩点计算
// 编写者：humiao
// 编写日期:2015-05-20
//--------------------------------------------------------------
			
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips
    
	var uPanel = new Ext.Panel({
		id :'uPanel',
	    //title:'科研绩点计算及查询',
		region: 'center',
		layout: 'border',
		items: [calcuPanel,itemGrid]
	});
	
	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		region:'center',
		items:uPanel                           
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : uPanel,
		renderTo: 'mainPanel'
	});
});