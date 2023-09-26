// 名称: 目标分解
// 描述: 目标分解
// 编写者：李明忠
// 编写日期:2010-08-1
//--------------------------------------------------------------
Ext.onReady(function(){
	//初始化所有Tips
	Ext.QuickTips.init();                             

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,autohisoutmedvouchMain]
	});
});