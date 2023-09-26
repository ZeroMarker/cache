// 名称:  绩效结果评价
// 描述:  绩效结果评价
// 编写者：杨旭
// 编写日期:2010-09-19
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,autohisoutmedvouchMain]
	});
});