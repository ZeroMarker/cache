/**
 * 模块:   配液中心病区交接单
 * 编写日期: 2018-03-27
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
    PIVAS.Session.More(session['LOGON.CTLOCID']);
    InitDict();
    $('#btnFind').on('click', Query);
    // 流程单号
    $('#txtPogsNo').searchbox({
        searcher: function (value, name) {
            if (event.keyCode == 13) {
                Query();
                return;
            }
            var pivaLocId = $('#cmbPivaLoc').combobox('getValue');
            var psNumber = $('#cmbPivaStat').combobox('getValue');
            PIVAS.PogsNoWindow({
                TargetId: 'txtPogsNo',
                PivaLocId: pivaLocId,
                PsNumber: psNumber
            });
        }
    });
    $('#txtPatNo').on('keypress', function (event) {
        if (event.keyCode == '13') {
            var patNo = $('#txtPatNo').val();
            if (patNo == '') {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
        }
    });
    InitPivasSettings();
    $('iframe').attr('src', PIVAS.RunQianBG);
    $('#tabsWardBat').tabs({
        onSelect: function (title) {
            // IE切换Tab需要重设宽度
            $('#tabWardBatGrp').width('1000px');
            $('#tabWardBatTbl').width('1000px');
            $('#tabWardBatIncTbl').width('1000px');
            $('#tabWardBatOrdDetail').width('1000px');
        }
    });
    setTimeout(function () {
        var scrollWidth = PIVAS.GetScrollBarWidth();
        $('.js-pha-layout-fit')
            .layout('panel', 'west')
            .panel('resize', { width: $('.pha-con-table').outerWidth() + 12 + scrollWidth }); // 10(split宽度) + 2(border宽度和)
        $('.js-pha-layout-fit').layout('resize');
        $('.hisui-tabs').tabs('scrollBy', 0);
        $('.dhcpha-win-mask').hide();
    }, 100);
});

function InitDict() {
    var comboWidth = 230;
    // 日期
    // 配液中心
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'PivaLoc' },
        {
            editable: false,
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('setValue', datas[i].RowId);
                        break;
                    }
                }
            },
            onSelect: function (data) {},
            width: comboWidth
        }
    );
    // 科室组
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, { width: comboWidth });
    // 病区
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, { width: comboWidth });
    // 医嘱优先级
    PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, { width: comboWidth });
    // 集中配制
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, { width: comboWidth });
    // 药品
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { width: comboWidth });
    // 批次
    PIVAS.ComboBox.Init({ Id: 'cmbBatNo', Type: 'Batch' }, { width: comboWidth, multiple: true });
    // 配液状态
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaStat', Type: 'PIVAState' },
        {
            editable: true,
            onLoadSuccess: function () {
                //$(this).combobox('showPanel');
            },
            width: comboWidth
        }
    );
    // 用法
    PIVAS.ComboBox.Init({ Id: 'cmbInstruc', Type: 'Instruc' }, { width: comboWidth });
    // 执行记录状态
    PIVAS.ComboBox.Init({ Id: 'cmbOeoreStat', Type: 'OrdStatus' }, { width: comboWidth, panelHeight: 'auto' });
    // 打包
    PIVAS.ComboBox.Init({ Id: 'cmbPack', Type: 'PackType' }, { width: comboWidth, panelHeight: 'auto' });
    // 配伍审核
    PIVAS.ComboBox.Init({ Id: 'cmbPassResult', Type: 'PassResult' }, { width: comboWidth, panelHeight: 'auto', editable: false });
    // 配液拒绝
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaRefuse',
            Type: 'YesOrNo',
            data: {
                data: [
                    { RowId: 'Y', Description: $g('已配液拒绝') },
                    { RowId: 'N', Description: $g('未配液拒绝') }
                ]
            }
        },
        {
            width: comboWidth,
            panelHeight: 'auto',
            editable: true
        }
    );
    // 楼层
    PIVAS.ComboBox.Init({ Id: 'cmbFloor', Type: 'Floor' }, { width: comboWidth });
}

/// 查询
function Query() {
    var params = GetParams();
    if (params == '') {
        return;
    }
    var pogsNo = $('#txtPogsNo').searchbox('getValue');
    if (pogsNo == '') {
        pogsNo = '　';
    }
    var tabTitleCode = $('#tabsWardBat').tabs('getSelected').panel('options').code;

    if (tabTitleCode == '病区交接单') {
        var raqObj = {
            raqName: 'DHCST_PIVAS_病区交接单.raq',
            raqParams: {
                startDate: $('#dateOrdStart').datebox('getValue'),
                endDate: $('#dateOrdEnd').datebox('getValue'),
                userName: session['LOGON.USERNAME'],
                pivaLoc: session['LOGON.CTLOCID'],
                hospDesc: PIVAS.Session.HOSPDESC,
                locDesc: $('#cmbPivaLoc').combobox('getText'),
                pogsNo: pogsNo,
                inputStr: params,
                pid: ''
            },
            isPreview: 1,
            isPath: 1
        };
        var raqSrc = PIVASPRINT.RaqPrint(raqObj);
        $('#tabWardBatGrp iframe').attr('src', raqSrc);
    } else if (tabTitleCode == '病区交接明细单') {
        var raqObj = {
            raqName: 'DHCST_PIVAS_病区交接明细单.raq',
            raqParams: {
                startDate: $('#dateOrdStart').datebox('getValue'),
                endDate: $('#dateOrdEnd').datebox('getValue'),
                userName: session['LOGON.USERNAME'],
                pivaLoc: session['LOGON.CTLOCID'],
                hospDesc: PIVAS.Session.HOSPDESC,
                locDesc: $('#cmbPivaLoc').combobox('getText'),
                pogsNo: pogsNo,
                inputStr: params,
                pid: ''
            },
            isPreview: 1,
            isPath: 1
        };
        var raqSrc = PIVASPRINT.RaqPrint(raqObj);
        $('#tabWardBatOrdDetail iframe').attr('src', raqSrc);
    } else if (tabTitleCode == '病区批次汇总') {
        var raqObj = {
            raqName: 'DHCST_PIVAS_病区批次汇总.raq',
            raqParams: {
                startDate: $('#dateOrdStart').datebox('getValue'),
                endDate: $('#dateOrdEnd').datebox('getValue'),
                userName: session['LOGON.USERNAME'],
                pivaLoc: session['LOGON.CTLOCID'],
                hospDesc: PIVAS.Session.HOSPDESC,
                locDesc: $('#cmbPivaLoc').combobox('getText'),
                inputStr: params,
                pogsNo: pogsNo
            },
            isPreview: 1,
            isPath: 1
        };
        var raqSrc = PIVASPRINT.RaqPrint(raqObj);
        $('#tabWardBatTbl iframe').attr('src', raqSrc);
    } else if (tabTitleCode == '病区批次药品汇总') {
        var raqObj = {
            raqName: 'DHCST_PIVAS_病区批次药品汇总.raq',
            raqParams: {
                startDate: $('#dateOrdStart').datebox('getValue'),
                endDate: $('#dateOrdEnd').datebox('getValue'),
                userName: session['LOGON.USERNAME'],
                pivaLoc: session['LOGON.CTLOCID'],
                hospDesc: PIVAS.Session.HOSPDESC,
                locDesc: $('#cmbPivaLoc').combobox('getText'),
                inputStr: params,
                pogsNo: pogsNo
            },
            isPreview: 1,
            isPath: 1
        };
        var raqSrc = PIVASPRINT.RaqPrint(raqObj);
        $('#tabWardBatIncTbl iframe').attr('src', raqSrc);
    }
}

// 获取参数
function GetParams() {
    var paramsArr = [];
    var pivaLocId = $('#cmbPivaLoc').combobox('getValue') || ''; // 配液中心
    var dateOrdStart = $('#dateOrdStart').datebox('getValue'); // 起始日期
    var dateOrdEnd = $('#dateOrdEnd').datebox('getValue'); // 截止日期
    var locGrpId = $('#cmbLocGrp').combobox('getValue'); // 科室组
    var wardId = $('#cmbWard').combobox('getValue') || ''; // 病区
    var priority = $('#cmbPriority').combobox('getValue') || ''; // 医嘱优先级
    var passResult = $('#cmbPassResult').combobox('getValue') || ''; // 医嘱审核状态
    var pivaStat = $('#cmbPivaStat').combobox('getValue') || ''; // 配液状态
    var oeoreStat = $('#cmbOeoreStat').combobox('getValue') || ''; // 医嘱状态
    var patNo = $.trim($('#txtPatNo').val()); // 登记号
    var pogsNo = $('#txtPogsNo').searchbox('getValue'); // 单号
    var prtPNo = ''; // 打签序号
    var batNoStr = $('#cmbBatNo').combobox('getValues'); // 批号
    var printStop = ''; // 是否已打印停止标签
    var barCode = ''; // 条码号
    var instruc = $('#cmbInstruc').combobox('getValue') || ''; // 用法
    var freq = ''; // 频次
    var datePrtStart = $('#datePrtStart').datebox('getValue'); // 打签起始日期
    var datePrtEnd = $('#datePrtEnd').datebox('getValue'); // 打签截止日期
    var incId = $('#cmgIncItm').combobox('getValue') || ''; // 药品
    var pivaCat = ''; //$("#cmbPivaCat").combobox("getValue");  // 配液分类-yunhaibao20180328暂不用
    var timePrtStart = $('#timePrtStart').timespinner('getValue'); // 打签开始时间
    var timePrtEnd = $('#timePrtEnd').timespinner('getValue'); // 打签结束时间
    var pivaRefuse = $('#cmbPivaRefuse').combobox('getValue') || ''; // 配液拒绝
    var timeOrdStart = $('#timeOrdStart').timespinner('getValue'); // 用药开始时间
    var timeOrdEnd = $('#timeOrdEnd').timespinner('getValue'); // 用药结束时间
    var workTypeId = $('#cmbWorkType').combobox('getValue') || ''; // 工作组
    var packFlag = $('#cmbPack').combobox('getValues') || ''; // 打包类型
    var floor = $('#cmbFloor').combobox('getValue') || ''; // 楼层
    paramsArr[0] = pivaLocId;
    paramsArr[1] = dateOrdStart;
    paramsArr[2] = dateOrdEnd;
    paramsArr[3] = wardId;
    paramsArr[4] = locGrpId;
    paramsArr[5] = priority;
    paramsArr[6] = passResult;
    paramsArr[7] = pivaStat;
    paramsArr[8] = oeoreStat;
    paramsArr[9] = batNoStr;
    paramsArr[10] = printStop;
    paramsArr[11] = barCode;
    paramsArr[12] = instruc;
    paramsArr[13] = freq;
    paramsArr[14] = incId;
    paramsArr[15] = datePrtStart;
    paramsArr[16] = datePrtEnd;
    paramsArr[17] = pivaCat;
    paramsArr[18] = timePrtStart;
    paramsArr[19] = timePrtEnd;
    paramsArr[20] = pogsNo;
    paramsArr[21] = pivaRefuse;
    paramsArr[22] = patNo;
    paramsArr[23] = prtPNo;
    paramsArr[24] = timeOrdStart;
    paramsArr[25] = timeOrdEnd;
    paramsArr[26] = workTypeId;
    paramsArr[27] = packFlag;
    paramsArr[28] = floor;

    return paramsArr.join('^');
}

// 初始化默认条件
function InitPivasSettings() {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'GetAppProp',
            userId: session['LOGON.USERID'],
            locId: session['LOGON.CTLOCID'],
            appCode: 'Report_WardBat'
        },
        function (jsonData) {
            $('#dateOrdStart').datebox('setValue', jsonData.OrdStDate);
            $('#dateOrdEnd').datebox('setValue', jsonData.OrdEdDate);
            $('#datePrtStart').datebox('setValue', jsonData.PrtStDate);
            $('#datePrtEnd').datebox('setValue', jsonData.PrtEdDate);
        }
    );
}
