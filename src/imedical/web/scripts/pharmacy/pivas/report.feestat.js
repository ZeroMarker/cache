/**
 * 模块:     配置费用统计
 * 编写日期: 2018-05-29
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
$(function () {
    PIVAS.Session.More(session['LOGON.CTLOCID']);
    PIVAS.Date.Init({ Id: 'dateStart', LocId: '', Type: 'Start', QueryType: 'Data' });
    PIVAS.Date.Init({ Id: 'dateEnd', LocId: '', Type: 'End', QueryType: 'Data' });
    // 配液中心
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'PivaLoc' },
        {
            editable: false,
            width: 'auto',
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('setValue', datas[i].RowId);
                        break;
                    }
                }
            }
        }
    );
    $('#btnFind').on('click', Query);
    $('iframe').attr('src', PIVAS.RunQianBG);
    setTimeout(function () {
        $('.js-pha-layout-fit')
            .layout('panel', 'west')
            .panel('resize', { width: $('.pha-con-table').outerWidth() + 12 }); // 10(split宽度) + 2(border宽度和)
        $('.js-pha-layout-fit').layout('resize');
        $('.dhcpha-win-mask').hide();
    }, 100);
});

function Query() {
    var startDate = $('#dateStart').datebox('getValue');
    var endDate = $('#dateEnd').datebox('getValue');
    var chkRadioJObj = $("input[name='radioFee']:checked");
    var pivaLocId = $('#cmbPivaLoc').combobox('getValue');
    var labelName = chkRadioJObj.attr('label');
    var raqName = '';
    if (labelName == '' || labelName == undefined) {
        $.messager.alert('提示', '请先选中需要查询的报表类型', 'warning');
        return;
    }
    if (labelName == '按病区汇总') {
        raqName = 'DHCST_PIVAS_配置费用统计_按病区汇总.raq';
    }
    var raqObj = {
        raqName: raqName,
        raqParams: {
            startDate: startDate,
            endDate: endDate,
            userName: session['LOGON.USERNAME'],
            pivaLoc: pivaLocId,
            hospDesc: PIVAS.Session.HOSPDESC,
            locDesc: PIVAS.Session.CTLOCDESC
        },
        isPreview: 1,
        isPath: 1
    };
    var raqSrc = PIVASPRINT.RaqPrint(raqObj);
    $('iframe').attr('src', raqSrc);
}
