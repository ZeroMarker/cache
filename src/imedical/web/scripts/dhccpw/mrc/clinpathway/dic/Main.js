//�� �� �ߣ� wuqk
//����ʱ�䣺 2011-09-17
//����˵��:  �ٴ�·�������ֵ�ά��
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