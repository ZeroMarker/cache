//创 建 者： 李阳
//创建时间： 2010-12-11
//功能说明:  临床路径维护主界面程序
var objScreenViewPort = null;
Ext.onReady(
	function () {
		var objMainPane = new Ext.TabPanel({
			id : "cpwMainTab"
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