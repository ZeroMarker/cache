// ����: ��Ա���ʽ�������
// ����: ������Ա���ʽ����Ԫ��
// ��д�ߣ�����
// ��д����:2010-3-1
var userCode = session['LOGON.USERCODE'];
var userDr = "";
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.Ajax.request({
        url: encodeURI('dhc.ca.unitpersonsexe.csp?action=checkUser&code=' + userCode),
        waitMsg: '������...',
        failure: function(result, request) {
            Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
        },
        success: function(result, request) {
            userDr = Ext.util.JSON.decode(result.responseText);
            if (userDr == 0) {
                Ext.Msg.show({ title: '����', msg: '�����½�û���Ϣ!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                return;
            }
            else {
                var tabPanel = new Ext.TabPanel({
                    activeTab: 0,
                    region: 'center',
                    items: [salaryMain]                                 //���Tabs
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