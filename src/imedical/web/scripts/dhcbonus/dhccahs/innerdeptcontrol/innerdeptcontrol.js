// ����: �ڲ�����ת�����������
// ����: �����ڲ�����ת��������Ԫ��
// ��д�ߣ�����
// ��д����:2010-01-28
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