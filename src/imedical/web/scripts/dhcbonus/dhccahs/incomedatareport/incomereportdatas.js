// ����: ��������ͳ�Ƹ�������
// ����: ������������ͳ�Ƹ�����Ԫ��
// ��д�ߣ�����
// ��д����:2010-1-31
var userCode = session['LOGON.USERCODE'];
var userDr = "";
Ext.onReady(function() {
    Ext.QuickTips.init();
    var vouchDatasPanel = new Ext.TabPanel({
        activeTab: 0,
        //region:'center',
        items: [vouchDatasMain, serveDeptMain, assItemDeptMain, serveItemDeptMain]                                 //���Tabs
    });
    var tabPanel = new Ext.Panel({
        title: '��������ͳ��',
        layout: 'fit',
        collapsible: false,
        plain: true,
        frame: true,
        region: 'center',
        items: vouchDatasPanel                 //���Tab���
    });
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: tabPanel,
        renderTo: 'mainPanel'
    });
});