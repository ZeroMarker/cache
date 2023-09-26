// 名称: 收入数据统计各界启动
// 描述: 引用收入数据统计各界面元素
// 编写者：杨旭
// 编写日期:2010-1-31
var userCode = session['LOGON.USERCODE'];
var userDr = "";
Ext.onReady(function() {
    Ext.QuickTips.init();
    var vouchDatasPanel = new Ext.TabPanel({
        activeTab: 0,
        //region:'center',
        items: [vouchDatasMain, serveDeptMain, assItemDeptMain, serveItemDeptMain]                                 //添加Tabs
    });
    var tabPanel = new Ext.Panel({
        title: '收入数据统计',
        layout: 'fit',
        collapsible: false,
        plain: true,
        frame: true,
        region: 'center',
        items: vouchDatasPanel                 //添加Tab面板
    });
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: tabPanel,
        renderTo: 'mainPanel'
    });
});