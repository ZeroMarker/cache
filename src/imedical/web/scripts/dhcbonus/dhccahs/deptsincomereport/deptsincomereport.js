
// 名称:
// 描述: 
// 编写者：wy
// 编写日期:2009-12-27
Ext.onReady(function(){
      Ext.BLANK_IMAGE_URL = "../scripts/ext2/resources/images/default/s.gif";
      Ext.QuickTips.init();
	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		region:'center',
		items:[detailReport]
	});

	var mainPanel = new Ext.Viewport({
		
		layout: 'border',
		items : [tabPanel],
		renderTo: 'mainPanel'
	});
     
});