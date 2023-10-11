/**
 * ģ��: 	 ��Һ������Һҽ�����ͳ��
 * ��д����: 2018-04-03
 * ��д��:   yunhaibao
 */

$(function () {
    InitDict();
    $('#btnFind').on('click', Find);
});

function InitDict() {
    var conWidth = 253;
    $('#conStartDate,#conEndDate').datebox('setValue', 't');
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        width: conWidth,
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        },
        onSelect: function () {}
    });
    PHA.ComboBox('conWardLoc', {
        width: conWidth,
        url: PHA_STORE.WardLoc().url
    });
    PHA.ComboBox('conDocLoc', {
        width: conWidth,
        url: PHA_STORE.DocLoc().url
    });
    PHA.ComboBox('conPassStat', {
        data: [
            { RowId: 1, Description: 'ͨ��' },
            { RowId: 2, Description: '�ܾ�' },
            { RowId: 3, Description: '����' }
        ],
        panelHeight: 'auto',
        width: conWidth,
        onSelect: function () {}
    });
    PHA.ComboBox('conUser', {
        width: conWidth,
        url: PHA_STORE.SSUser().url
    });
    // ���״̬
    // ��ҩƷ
    var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: 253
    });
    PHA.LookUp('conInci', opts);
}
function Find() {
    var curTabOpts = $('#tabsReport').tabs('getSelected').panel('options');
    var groupType = curTabOpts.groupType;
    var pJson = GetParamsJson();
    var pJsonStr = JSON.stringify(pJson);
    var raqName = 'PHA_IP_OrdMonitor_Group.rpx';
    if (groupType === 'REASON') {
        raqName = 'PHA_IP_OrdMonitor_Reason.rpx';
    }
    if (groupType === 'ORDER') {
        raqName = 'PHA_IP_OrdMonitor_Order.rpx';
    }
    var raqUrl = 'dhccpmrunqianreport.csp?reportName=' + raqName + '&pJsonStr=' + pJsonStr + '&groupType=' + groupType;
    $('[groupType=' + groupType + ']').attr('src', raqUrl);
}
function GetParamsJson() {
    return {
        loc: $('#conPhaLoc').combobox('getValue') || '',
        startDate: $('#conStartDate').datebox('getValue') || '',
        endDate: $('#conEndDate').datebox('getValue') || '',
        startTime: $('#conStartTime').timespinner('getValue') || '',
        endTime: $('#conEndTime').timespinner('getValue') || '',
        passStat: $('#conPassStat').combobox('getValue') || '',
        wardLoc: $('#conWardLoc').combobox('getValue') || '',
        docLoc: $('#conDocLoc').combobox('getValue') || '',
        user: $('#conUser').combobox('getValue') || '',
        inci: $('#conInci').lookup('getValue') || '',
        reasonDesc: $('#conReason').val() || '',
        printUser: PHA_COM.Session.USERID
    };
}
