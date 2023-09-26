//创 建 者： wuqk
//创建时间： 2011-09-17
//功能说明:  临床路径评估字典维护
var objScreenViewPort = null;
Ext.onReady(
	function () {
		var objMainPane = new Ext.TabPanel({
			id : "dicMain"
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