// 名称: 收入分配数据表界面启动
// 描述: 引入收入分配数据表界面各元素
// 编写者：杨旭
// 编写日期:2010-3-8
var userCode = session['LOGON.USERCODE'];
var userDr = "";
Ext.onReady(function() {
    Ext.QuickTips.init();
    var tabPanel = new Ext.TabPanel({
        activeTab: 0,
        region: 'center',
        items: [inDistDataMain]                                 //添加Tabs
    });

    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: tabPanel,
        renderTo: 'mainPanel'
    });
});