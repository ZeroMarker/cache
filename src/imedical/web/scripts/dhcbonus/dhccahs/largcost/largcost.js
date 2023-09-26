// 名称: 数据项维护界面启动
// 描述: 引入数据项维护界面各元素
// 编写者：杨旭
// 编写日期:2010-03-25
var userCode = session['LOGON.USERCODE'];
var userDr = "";
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.Ajax.request({
        url: 'dhc.ca.unitpersonsexe.csp?action=checkUser&code=' + userCode,
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

                var uPanel = new Ext.Panel({
                    title: '大额成本维护',
                    region: 'center',
                    layout: 'border',
                    items: [largCostMain, largCostDetailGrid]
                });
                var tabPanel = new Ext.TabPanel({
                    activeTab: 0,
                    region: 'center',
                    items: uPanel                                 //添加Tabs
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