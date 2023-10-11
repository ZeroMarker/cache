
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips
	
	var wincount=0,
	tipw=[];
	//加一个方法调用弹出
	tipw[wincount] = new Ext.ux.TipsWindow(
	{
	title: "专利申请获批提示",
	autoHide: 5,
	count:wincount+1,//设置弹出的是第几个
	//5秒自动关闭
	html: "请注意对已获批专利按时缴费！"
	});
	tipw[wincount].show();
	
	var tPanel =  new Ext.Panel({
		title:'专利院内证明申请',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[queryPanel,itemGrid]                                 //添加Tabs
  });
	
	var tabPanel = new Ext.TabPanel({
		activeTab:0,
		region:'center',
		items:tPanel
	});
	
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : tPanel,
		renderTo: 'mainPanel'
  });
});