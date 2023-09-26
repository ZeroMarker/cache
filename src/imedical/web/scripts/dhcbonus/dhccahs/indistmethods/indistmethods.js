// 名称: 收入分配方法界面启动
// 描述: 引入收入分配方法各元素
// 编写者：杨旭
// 编写日期:2010-3-12
Ext.onReady(function() {
    Ext.QuickTips.init();                             //初始化所有Tips

    var tabPanel = new Ext.TabPanel({
        activeTab: 0,
        region: 'center',
        items: [inDistMethodsMain]                                 //添加Tabs
    });

    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: tabPanel,
        renderTo: 'mainPanel'
    });
});