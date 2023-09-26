// 名称: 内部部门转换表界面启动
// 描述: 引入内部部门转换表界面各元素
// 编写者：杨旭
// 编写日期:2010-01-28
var userCode = session['LOGON.USERCODE'];
var userDr = "";
Ext.onReady(function() {
    Ext.QuickTips.init();
    var vouchDatasPanel = new Ext.TabPanel({
        activeTab: 0,
        region: 'center',
        items: [innerDeptControlMain]
    });

    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: vouchDatasPanel,
        renderTo: 'mainPanel'
    });
});