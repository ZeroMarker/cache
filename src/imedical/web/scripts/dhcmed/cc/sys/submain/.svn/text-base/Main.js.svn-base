//创 建 者： 朱飞
//创建时间： 2011-03-17
//功能说明:  监控中心维护主界面程序
var objScreenViewPort = null;
Ext.onReady(
	function () {
		var objMainPane = new Ext.TabPanel({
			id : "medCCMainTab"
			,title: "Main Window"
			,region: "center"
			,enableTabScroll : true
			,autoDestroy : true
		});
		var objLeftPane = new LeftMaintainPane();
		objScreenViewPort = new Ext.Viewport({
			layout: 'border'
			,items: [
				objLeftPane
				,objMainPane
			]
		});
		objMainPane.setActiveTab(0);
	}
);