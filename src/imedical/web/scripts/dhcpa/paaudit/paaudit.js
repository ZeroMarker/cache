// 名称: 绩效审核
// 描述: 绩效审核
// 编写者：李明忠
// 编写日期:2010-9-8
//--------------------------------------------------------------
			
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,deptTree,kpiTree]
	});
});