// ����: ������ά����������
// ����: ����������ά�������Ԫ��
// ��д�ߣ�����
// ��д����:2010-03-25
var userCode = session['LOGON.USERCODE'];
var userDr = "";
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.Ajax.request({
        url: 'dhc.ca.unitpersonsexe.csp?action=checkUser&code=' + userCode,
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

                var uPanel = new Ext.Panel({
                    title: '���ɱ�ά��',
                    region: 'center',
                    layout: 'border',
                    items: [largCostMain, largCostDetailGrid]
                });
                var tabPanel = new Ext.TabPanel({
                    activeTab: 0,
                    region: 'center',
                    items: uPanel                                 //���Tabs
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