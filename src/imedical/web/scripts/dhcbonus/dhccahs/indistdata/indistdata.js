// ����: ����������ݱ��������
// ����: ��������������ݱ�����Ԫ��
// ��д�ߣ�����
// ��д����:2010-3-8
var userCode = session['LOGON.USERCODE'];
var userDr = "";
Ext.onReady(function() {
    Ext.QuickTips.init();
    var tabPanel = new Ext.TabPanel({
        activeTab: 0,
        region: 'center',
        items: [inDistDataMain]                                 //���Tabs
    });

    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: tabPanel,
        renderTo: 'mainPanel'
    });
});