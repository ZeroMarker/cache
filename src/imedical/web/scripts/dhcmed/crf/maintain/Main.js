
var objScreenViewPort = null;
Ext.onReady(
	function () {
		var objMainPane = new Ext.Panel({
			id : "crfMainTab"
			,title: "Main Window"
			,region: "center"
			,enableTabScroll : true
			,html: "<iframe id='crfFrame' height='100%' width='100%' src=''>"
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
		//objMainPane.setActiveTab(0);
	}
);