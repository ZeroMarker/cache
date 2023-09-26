// 名称: 人员工资界面启动
// 描述: 引入人员工资界面各元素
// 编写者：杨旭
// 编写日期:2010-3-1
var userCode = session['LOGON.USERCODE'];
var userDr = "";
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.Ajax.request({
        url: encodeURI('dhc.ca.unitpersonsexe.csp?action=checkUser&code=' + userCode),
        waitMsg: '保存中...',
        failure: function(result, request) {
            Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
        },
        success: function(result, request) {
            userDr = Ext.util.JSON.decode(result.responseText);
            if (userDr == 0) {
                Ext.Msg.show({ title: '错误', msg: '请检查登陆用户信息!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                return;
            }
            else {
                var tabPanel = new Ext.TabPanel({
                    activeTab: 0,
                    region: 'center',
                    items: [salaryMain]                                 //添加Tabs
                });

                var mainPanel = new Ext.Viewport({
                    layout: 'border',
                    items: tabPanel,
                    renderTo: 'mainPanel'
                });
            }
        },
        scope: this
    });
});