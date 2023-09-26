// 名称: 调查问卷明细
// 描述: 调查问卷明细
// 编写者：李明忠
// 编写日期:2011-05-31
//--------------------------------------------------------------
Ext.onReady(function(){
	//初始化所有Tips
	Ext.QuickTips.init();                             
	
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,autohisoutmedvouchMain]
	});
	
});