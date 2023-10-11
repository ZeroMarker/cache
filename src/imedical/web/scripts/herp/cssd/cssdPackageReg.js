// 名称:  消毒包登记
// 描述:  
// 编写者：why
// 编写日期:2017-06-28
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips
    testStringAjax()  ;
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,autohisoutmedvouchMain]
	});
});