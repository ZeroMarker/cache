/**
 * 模块:     配液状态统计
 * 编写日期: 2018-01-14
 * 编写人:   yunhaibao
 */
$(function () {
    PIVAS.Session.More(session['LOGON.CTLOCID']);
    PIVAS.Date.Init({ Id: 'dateStart', LocId: '', Type: 'Start', QueryType: 'Data' });
    PIVAS.Date.Init({ Id: 'dateEnd', LocId: '', Type: 'End', QueryType: 'Data' });
    $('#btnFind').on('click', Query);
    $('iframe').attr('src', PIVAS.RunQianBG);
    $('.dhcpha-win-mask').remove();
});

function Query() {
    var startDate = $('#dateStart').datebox('getValue');
    var endDate = $('#dateEnd').datebox('getValue');
    var raqObj = {
        raqName: 'PHA_PIVAS_PSStat.rpx',
        raqParams: {
            startDate: startDate,
            endDate: endDate,
            userName: session['LOGON.USERNAME'],
            pivaLoc: session['LOGON.CTLOCID'],
            hospDesc: PIVAS.Session.HOSPDESC,
            locDesc: PIVAS.Session.CTLOCDESC
        },
        isPreview: 1,
        isPath: 1
    };
    var raqSrc = PIVASPRINT.RaqPrint(raqObj);
    $('iframe').attr('src', raqSrc);
}
