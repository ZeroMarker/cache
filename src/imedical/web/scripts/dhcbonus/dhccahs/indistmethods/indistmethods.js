// ����: ������䷽����������
// ����: ����������䷽����Ԫ��
// ��д�ߣ�����
// ��д����:2010-3-12
Ext.onReady(function() {
    Ext.QuickTips.init();                             //��ʼ������Tips

    var tabPanel = new Ext.TabPanel({
        activeTab: 0,
        region: 'center',
        items: [inDistMethodsMain]                                 //���Tabs
    });

    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: tabPanel,
        renderTo: 'mainPanel'
    });
});