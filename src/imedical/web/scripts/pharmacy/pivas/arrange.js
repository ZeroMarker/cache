/**
 * 模块: 	 配液中心排药统计
 * 编写日期: 2018-04-08
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var PIVAS_ARRANGE = {
    Setting: $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'GetAppProp',
            userId: session['LOGON.USERID'],
            locId: session['LOGON.CTLOCID'],
            appCode: 'Arrange'
        },
        false
    )
};

$(function () {
    // $('.newScroll').mCustomScrollbar({
    //     theme: 'inset-2-dark',
    //     scrollInertia: 100
    // });
    $('#btnFind').parent().parent().css('box-shadow', 'rgb(238, 238, 238) 0px -5px 10px');

    PIVAS.Session.More(session['LOGON.CTLOCID']);
    InitDict();
    InitGridInc();
    $('#btnFind').on('click', Query);
    $('#btnPrint').on('click', Print);
    $('#btnGeneQR').on('click', GeneQR);
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
            var patNo = this.value;
            patNo = PIVAS.FmtPatNo(patNo);
            $(this).val(patNo);
            Query();
        }
    });
    InitPivasSettings();
    setTimeout(function () {
        var scrollWidth = PIVAS.GetScrollBarWidth();
        $('.js-pha-layout-fit')
            .layout('panel', 'west')
            .panel('resize', { width: $('.pha-con-table').outerWidth() + 12 + scrollWidth }); // 10(split宽度) + 2(border宽度和)
        $('.js-pha-layout-fit').layout('resize');
        $('.dhcpha-win-mask').hide();
    }, 100);
});

function InitDict() {
    var comboWidth = 220;
    // 配液中心
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'PivaLoc' },
        {
            panelHeight: 'auto',
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
    // 批次
    PIVAS.ComboBox.Init({ Id: 'cmbBatNo', Type: 'Batch' }, { width: comboWidth, multiple: true });
    // 配液状态
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaStat', Type: 'PIVAState' },
        {
            editable: false,
            onLoadSuccess: function (data) {
                var Ps30Single = PIVAS_ARRANGE.Setting.Single;
                if (Ps30Single == 'Y') {
                    $(this).combobox('disable');
                }
                for (var i = 0; i < data.length; i++) {
                    var rowId = data[i].RowId;
                    if (rowId == '30') {
                        $(this).combobox('setValue', rowId);
                    }
                }
            },
            width: comboWidth,
            loadFilter: function (data) {
                var sliceNum = 0;
                for (var i = 0; i < data.length; i++) {
                    var iData = data[i];
                    if (parseInt(iData.RowId) < 30) {
                        sliceNum++;
                    }
                }
                data.splice(0, sliceNum);
                return data;
            }
        }
    );
    // 用法
    PIVAS.ComboBox.Init({ Id: 'cmbInstruc', Type: 'Instruc' }, { width: comboWidth });
    // 配伍审核
    PIVAS.ComboBox.Init({ Id: 'cmbPassResult', Type: 'PassResult' }, { editable: false, width: comboWidth, panelHeight: 'auto' });
    $('#cmbPassResult').combobox('setValue', '');
    // 打包
    PIVAS.ComboBox.Init({ Id: 'cmbPack', Type: 'PackType' }, { width: comboWidth, panelHeight: 'auto' });
    // 是否已排药
    PIVAS.ComboBox.Init({ Id: 'cmbArranged', Type: 'YesOrNo' }, { editable: false, width: comboWidth, panelHeight: 'auto' });
    $('#cmbArranged').combobox('setValue', 'N');
}
/// 初始化药品信息表格
function InitGridInc() {
    //定义columns
    var columns = [
        [
            { field: 'incDesc', title: '药品名称', width: 300 },
            { field: 'incSpec', title: '规格', width: 100 },
            { field: 'phManfDesc', title: '生产企业', width: 130 },
            { field: 'qty', title: '数量', width: 50 },
            { field: 'bUomDesc', title: '单位', width: 50 },
            { field: 'stkBin', title: '货位', width: 100 },
            { field: 'batNoQty', title: '各批次数量', width: 200 },
            { field: 'pid', title: '进程号', width: 200, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Arrange',
            QueryName: 'QueryArrange'
        },
        fitColumns: true,
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        pageSize: 100,
        pageList: [100, 300, 500]
    };
    DHCPHA_HUI_COM.Grid.Init('gridInc', dataGridOption);
}
/// 查询
function Query() {
    var params = GetParams();
    if (params == '') {
        return;
    }
    $('#gridInc').datagrid('query', { inputStr: params });
}

// 获取参数
function GetParams() {
    var paramsArr = [];
    var pivaLocId = $('#cmbPivaLoc').combobox('getValue'); // 配液中心
    var dateOrdStart = $('#dateOrdStart').datebox('getValue'); // 起始日期
    var dateOrdEnd = $('#dateOrdEnd').datebox('getValue'); // 截止日期
    var locGrpId = $('#cmbLocGrp').combobox('getValue') || ''; // 科室组
    var wardId = $('#cmbWard').combobox('getValue') || ''; // 病区
    var priority = $('#cmbPriority').combobox('getValue') || ''; // 医嘱优先级
    var passResult = $('#cmbPassResult').combobox('getValue') || ''; // 医嘱审核状态
    var pivaStat = $('#cmbPivaStat').combobox('getValue') || ''; // 配液状态
    var oeoreStat = ''; // 医嘱状态-不用
    var patNo = $.trim($('#txtPatNo').val()); // 登记号
    var pogsNo = $('#txtPogsNo').searchbox('getValue') || ''; // 单号
    var prtPNo = ''; // 打签序号
    var batNoStr = $('#cmbBatNo').combobox('getValues') || ''; // 批号
    var printStop = ''; // 是否已打印停止标签
    var barCode = ''; // 条码号
    var instruc = $('#cmbInstruc').combobox('getValue') || ''; // 用法
    var freq = ''; // 频次
    var datePrtStart = $('#datePrtStart').datebox('getValue'); // 打签起始日期
    var datePrtEnd = $('#datePrtEnd').datebox('getValue'); // 打签截止日期
    var incId = ''; // 药品-不用
    var pivaCat = ''; //; 	// 配液分类-不用
    var timePrtStart = $('#timePrtStart').timespinner('getValue'); // 打签开始时间
    var timePrtEnd = $('#timePrtEnd').timespinner('getValue'); // 打签结束时间
    var pivaRefuse = ''; // 配液拒绝
    var timeOrdStart = $('#timeOrdStart').timespinner('getValue'); // 用药开始时间
    var timeOrdEnd = $('#timeOrdEnd').timespinner('getValue'); // 用药结束时间
    var workTypeId = $('#cmbWorkType').combobox('getValue') || ''; // 集中配置
    var packFlag = $('#cmbPack').combobox('getValues') || ''; // 打包类型
    var arranged = $('#cmbArranged').combobox('getValue') || ''; // 是否已排药
    var timeArrStart = $('#timeArrStart').timespinner('getValue'); // 排药开始时间
    var timeArrEnd = $('#timeArrEnd').timespinner('getValue'); // 排药结束时间
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
    paramsArr[28] = arranged;
    paramsArr[29] = timeArrStart;
    paramsArr[30] = timeArrEnd;
    return paramsArr.join('^');
}
// 打印排药单
function Print() {
    var gridRows = $('#gridInc').datagrid('getRows');
    if (gridRows == '') {
        $.messager.alert($g('提示'), $g('无明细数据'), 'warning');
        return;
    }
    var pid = gridRows[0].pid;
    if (pid == '') {
        $.messager.alert($g('提示'), $g('获取不到进程Id'), 'warning');
        return;
    }
    $.messager.confirm($g('确认对话框'), $g('确定打印吗？'), function (r) {
        if (r) {
            var pivaLocId = $('#cmbPivaLoc').combobox('getValue');
            var arranged = $('#cmbArranged').combobox('getValue');
            var saveRet = tkMakeServerCall('web.DHCSTPIVAS.Arrange', 'SaveData', pid, SessionUser, pivaLocId, arranged);
            var saveArr = saveRet.split('^');
            if (saveArr[0] < 0) {
                $.messager.alert($g('提示'), saveArr[1], 'warning');
                return;
            }
            var prtPid = saveRet;
            PIVASPRINT.Arrange('', '', prtPid);
            Query();
        }
    });
}
function GeneQR() {
    var gridRows = $('#gridInc').datagrid('getRows');
    if (gridRows == '') {
        $.messager.alert($g('提示'), $g('无明细数据'), 'warning');
        return;
    }
    var pid = gridRows[0].pid;
    if (pid == '') {
        $.messager.alert($g('提示'), $g('获取不到进程Id'), 'warning');
        return;
    }
    // 不能在用临时Global, 需暂存到非临时数据, pda和pc可能连不同的ecp
    tkMakeServerCall('web.DHCSTPIVAS.Arrange', 'SetTmpData4Mob', pid);
    PIVAS.GeneQRCodeWindow({
        barCode: pid,
        onClose: function () {
            tkMakeServerCall('web.DHCSTPIVAS.Arrange', 'KillTmpData4Mob', pid);
        }
    });
}
// 初始化默认条件
function InitPivasSettings() {
    var settingJson = PIVAS_ARRANGE.Setting;
    $('#dateOrdStart').datebox('setValue', settingJson.OrdStDate);
    $('#dateOrdEnd').datebox('setValue', settingJson.OrdEdDate);
    $('#datePrtStart').datebox('setValue', settingJson.PrtStDate);
    $('#datePrtEnd').datebox('setValue', settingJson.PrtEdDate);
}
