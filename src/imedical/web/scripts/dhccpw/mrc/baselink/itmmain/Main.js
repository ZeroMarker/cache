//�� �� �ߣ� ���
//����ʱ�䣺 2012-02-08
//����˵��:  �ٴ�·��������Ŀ�ֵ�ά���������
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