// 名称: 基本数据查询
// 描述: 基本数据查询
// 编写者：李明忠
// 编写日期:2010-08-5
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,autohisoutmedvouchMain]
	});
});