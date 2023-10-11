/**
 * 模块:     配液工作量统计
 * 编写日期: 2918-03-30
 * 编写人:   yunhaibao
 */
$(function () {
    PIVAS.Session.More(session['LOGON.CTLOCID']);
    PIVAS.Date.Init({ Id: 'dateStart', LocId: '', Type: 'Start', QueryType: 'Data' });
    PIVAS.Date.Init({ Id: 'dateEnd', LocId: '', Type: 'End', QueryType: 'Data' });
    PIVAS.ComboBox.Init(
        { Id: 'cmbSysType', Type: 'SysType' },
        {
            width: 230,
            editable: false,
            panelHeight: 'auto'
        }
    );
    $('#cmbSysType').combobox('setValue', 'A');
    $('#btnFind').on('click', Query);
    $('iframe').attr('src', PIVAS.RunQianBG);
    setTimeout(function () {
        $('.js-pha-layout-fit')
            .layout('panel', 'west')
            .panel('resize', { width: $('.pha-con-table').outerWidth() + 12 }); // 10(split宽度) + 2(border宽度和)
        $('.js-pha-layout-fit').layout('resize');
        $('.hisui-tabs').tabs('scrollBy', 0);
        $('.dhcpha-win-mask').hide();
    }, 100);
});
function Query() {
    var startDate = $('#dateStart').datebox('getValue');
    var endDate = $('#dateEnd').datebox('getValue');
    var StartTime = $('#timeStart').timespinner('getValue');
    var EndTime = $('#timeEnd').timespinner('getValue');
    var sysType = $('#cmbSysType').combobox('getValue');
    var tabOptions = $('.hisui-tabs').tabs('getSelected').panel('options');
    var tabTitle = tabOptions.title;
    var tabId = tabOptions.id;
    var raqObj = {
        raqName: 'DHCST_PIVAS_WorkLoad.rpx',
        raqParams: {
            startDate: startDate,
            endDate: endDate,
            StartTime: StartTime,
            EndTime: EndTime,
            userName: session['LOGON.USERNAME'],
            pivaLoc: session['LOGON.CTLOCID'],
            hospDesc: PIVAS.Session.HOSPDESC,
            locDesc: PIVAS.Session.CTLOCDESC,
            sysType: sysType,
            calcType: tabId
        },
        isPreview: 1,
        isPath: 1
    };
    var raqSrc = PIVASPRINT.RaqPrint(raqObj);
    $('#' + tabId + ' iframe').attr('src', raqSrc);
}

