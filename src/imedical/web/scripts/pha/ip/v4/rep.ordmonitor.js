/**
 * 模块: 	 配液中心配液医嘱审核统计
 * 编写日期: 2018-04-03
 * 编写人:   yunhaibao
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
            { RowId: 1, Description: '通过' },
            { RowId: 2, Description: '拒绝' },
            { RowId: 3, Description: '接受' }
        ],
        panelHeight: 'auto',
        width: conWidth,
        onSelect: function () {}
    });
    PHA.ComboBox('conUser', {
        width: conWidth,
        url: PHA_STORE.SSUser().url
    });
    // 审核状态
    // 是药品
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
