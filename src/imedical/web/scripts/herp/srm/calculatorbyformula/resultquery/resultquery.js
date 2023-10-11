// 名称: 计算结果查询
// 描述: 计算结果查询
// 编写者：李明忠
// 编写日期:2010-9-6
//--------------------------------------------------------------
			
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items :[autohisoutmedvouchForm,deptTree,kpiTree]
	});
});