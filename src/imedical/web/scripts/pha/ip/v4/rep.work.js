/**
 * 模块: 	 住院药房 - 工作量统计
 * 编写日期: 2020-11-11
 * 编写人:   yunhaibao
 */

$(function () {
    $('.js-help').popover({ placement: 'bottom', title: '计算规则', content: $('.pha-help-content').html() });
    InitDict();
    $('#btnFind').on('click', Find);
    $('#btnClean').on('click', Clean);
    PHA_EVENT.Key([
        ['btnClean', 'alt+c'],
        ['btnFind', 'alt+f'],
        ['btnFind', 'ctrl+enter']
    ]);
});

function InitDict() {
    var conWidth = 253;
    $('#conStartDate, #conEndDate').datebox('setValue', 't');
    // PHA.ComboBox('conPhaLoc', {
    //     url: PHA_STORE.Pharmacy('IP').url,
    //     panelHeight: 'auto',
    //     width: conWidth,
    //     onLoadSuccess: function (data) {
    //         $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
    //     },
    //     onSelect: function () {}
    // });

    var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: 253
    });
    PHA.LookUp('conInci', opts);

    PHA.ComboBox('conPhcForm', {
        url: PHA_STORE.PHCForm().url,
        width: conWidth
    });
    PHA.ComboBox('conPoison', {
        url: PHA_STORE.PHCPoison().url,
        width: conWidth,
        multiple: true
    });
    PHA.ComboBox('conPriority', {
        url: PHA_STORE.OECPriority().url,
        width: conWidth
    });
    PHA.ComboBox('conCatGrp', {
        url: PHA_STORE.DHCStkCatGroup().url,
        width: conWidth
    });
    PHA.ComboBox('conWay', {
        data: [
            { RowId: 'collectUser', Description: '按发药人、退药人' },
            { RowId: 'operateUser', Description: '按配药人、退药人' },
            { RowId: 'collateUser', Description: '按核对人、退药人' },
            { RowId: 'printUser', Description: '按操作人' },
            { RowId: 'wardLoc', Description: '按病区' }
        ],
        panelHeight: 'auto',
        width: conWidth,
        editable: false,
        onSelect: function () {}
    });
    $('#conWay').combobox('setValue', 'collectUser');
}
function Find() {
    var curTabOpts = $('#tabsReport').tabs('getSelected').panel('options');
    var groupType = curTabOpts.groupType;
    var pJson = GetParamsJson();
    var pJsonStr = JSON.stringify(pJson);
    var raqName = 'PHA_IP_Work_Com.rpx';
    /*if (groupType === 'HERB') {
        raqName = 'PHA_IP_Work_Com_Herb.rpx';
    }*/
    var raqUrl = 'dhccpmrunqianreport.csp?reportName=' + raqName + '&pJsonStr=' + pJsonStr + '&groupType=' + groupType;
    if (typeof websys_writeMWToken !== 'undefined') {
        raqUrl = websys_writeMWToken(raqUrl);
    }

    $('[groupType=' + groupType + ']').attr('src', raqUrl);
}
function GetParamsJson() {
    return {
        phaLoc: PHA_COM.Session.CTLOCID, //245
        startDate: $('#conStartDate').datebox('getValue') || '',
        endDate: $('#conEndDate').datebox('getValue') || '',
        startTime: $('#conStartTime').timespinner('getValue') || '',
        endTime: $('#conEndTime').timespinner('getValue') || '',
        printUser: PHA_COM.Session.USERID,
        way: $('#conWay').combobox('getValue'),
        poisonStr: $('#conPoison').combobox('getValues').join(','),
        priority: $('#conPriority').combobox('getValue'),
        inci: $('#conInci').lookup('getValue'),
        phcForm: $('#conPhcForm').combobox('getValue')
    };
}
function Clean() {
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('getValue', 't');
    $('#conStartTime').timespinner('clear');
    $('#conEndTime').timespinner('clear');
    $('#conWay').combobox('setValue', 'collectUser');
    $('#conPoison').combobox('clear');
    $('#conPriority').combobox('clear');
    $('#conInci').lookup('clear'), $('#conPhcForm').combobox('clear');
    $('iframe').attr('src', 'dhcst.blank.backgroud.csp');
}
