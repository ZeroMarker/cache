// 名称:接口方法及参数维护
// 描述: 接口方法及参数维护
// 编写者：zhaoliguo
// 编写日期:2011-04-26
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

var uPanel = new Ext.Panel({
		title: '奖金数据采集接口维护',
		region: 'center',
		layout: 'border',
		tbar: ['接口套类别:',locSetTypeField,'接口套:',interLocSetField],
		items: [InterMethodMain]  //,InterParamMain
	});
	
	
var methodPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[uPanel]                                 //添加Tabs
  });
  

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : methodPanel,
  	renderTo: 'mainPanel'
  });
});