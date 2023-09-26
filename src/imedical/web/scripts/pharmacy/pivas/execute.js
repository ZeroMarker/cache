/**
 * 模块: 	 配液状态执行
 * 编写日期: 2018-03-16
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionWard = session['LOGON.WARDID'] || '';
var ConfirmMsgInfoArr = [];
var NeedScroll = 'Y'; // 是否需要滚动到0行
var PrtWardBatPS = ''; // 打印交接单流程标识
$(function () {
    if (SessionWard != '') {
        PIVAStateNumber = '90';
        $('#btnExecuteWBPrt,#btnExecutePrt,#btnPrtWardBat,#btnRefuse').hide();
        $('#btnScanClean').css('width', '376px');
    }
    $('.newScroll').mCustomScrollbar({
        theme: 'inset-2-dark',
        scrollInertia: 100
    });
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridOrdExe();
    //InitGridWardBat(SessionLoc);
    $('#btnFind').on('click', Query);
    $('#btnExecute').on('click', function () {
        if (ValidCanDo('gridOrdExe') == false) {
            return;
        }
        $.messager.confirm('提示', '您确认' + $('#btnExecute').linkbutton('options').text + '吗?', function (r) {
            if (r) {
                Execute(1, '');
            }
        });
    });
    $('#btnExecutePrt').on('click', function () {
        if (ValidCanDo('gridOrdExe') == false) {
            return;
        }
        $.messager.confirm('提示', '您确认' + $('#btnExecutePrt').linkbutton('options').text + '吗?', function (r) {
            if (r) {
                ConfirmGrpWay(Execute);
            }
        });
    });

    $('#btnExecuteWB').on('click', function () {
        if (ValidCanDo('gridWardBat') == false) {
            return;
        }
        $.messager.confirm('提示', '您确认' + $('#btnExecuteWB').linkbutton('options').text + '吗?', function (r) {
            if (r) {
                ExecuteWB(1, '');
            }
        });
    });
    $('#btnExecuteWBPrt').on('click', function () {
        if (ValidCanDo('gridWardBat') == false) {
            return;
        }
        $.messager.confirm('提示', '您确认' + $('#btnExecuteWBPrt').linkbutton('options').text + '吗?', function (r) {
            if (r) {
                ConfirmGrpWay(ExecuteWB);
            }
        });
    });
    $('#btnRefuse').on('click', RefusePog);
    $('#btnScanClean').on('click', function (e) {
        $.messager.confirm('提示', '您确认清屏吗?', function (r) {
            if (r) {
                PIVASSCAN.Clean();
            }
        });
    });
    $('#btnPrtWardBat').on('click', function () {
        ConfirmGrpWay(ExePrtWardBat);
    });
    $('#txtPatNo').on('keypress', function (event) {
        if (event.keyCode == '13') {
            var patNo = this.value;
            patNo = PIVAS.FmtPatNo(patNo);
            $(this).val(patNo);
            Query();
        }
    });
    $('#txtBarCode').on('keypress', function (event) {
        if (event.keyCode == '13') {
            var barCode = this.value;
            if (barCode == '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '条码为空',
                    type: 'alert'
                });
                return;
            }
            var psNumber = $('#cmbPivaStat').combobox('getValue');
            if (psNumber == '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '请先选择执行状态',
                    type: 'alert'
                });
                $('#txtBarCode').val('');
                return;
            }
            var pivaLocId = $('#cmbPivaLoc').combobox('getValue');
            if (pivaLocId == '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '请先选择配液中心',
                    type: 'alert'
                });
                $('#txtBarCode').val('');
                return;
            }
            var pogsNo = $('#txtGeneNo').val().trim();
            if (barCode != '' && pogsNo == '') {
                GenerateNo(psNumber, pogsNo);
                pogsNo = $('#txtGeneNo').val().trim();
            }
            if (barCode != '' && pogsNo == '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '单号为空,您无法扫描执行',
                    type: 'alert'
                });
                return;
            }
            var qParams = QueryParams('QueryScan');
            PIVASSCAN.Execute(barCode, psNumber, pivaLocId, pogsNo, qParams);
            $(this).val('');
        }
    });
    $('#txtPrtNo').searchbox({
        searcher: function (value, name) {
            if (event.keyCode == 13) {
                Query();
                return;
            }
            var pivaLocId = $('#cmbPivaLoc').combobox('getValue');
            var psNumber = $('#cmbPivaStat').combobox('getValue');
            PIVAS.PogsNoWindow({
                TargetId: 'txtPrtNo',
                PivaLocId: pivaLocId,
                PsNumber: psNumber
            });
        }
    });
    $('#btnSelectAll').on('click', function () {
        CheckRowsGlobal('', 'Y', 'Y');
    });
    $('#btnUnSelectAll').on('click', function () {
        CheckRowsGlobal('', 'N', 'Y');
    });
    InitPivasSettings();
    PIVAS.Session.More(session['LOGON.CTLOCID']);
    if (ExecuteWay != '') {
        $('#tabsExecute').tabs('select', ExecuteWay);
    }
    $('#imgScaning').attr('src', '../scripts_lib/hisui-0.1.0/dist/css/icons/scanning.png');
    $('.dhcpha-win-mask').remove();
});
window.onbeforeunload = function () {
    ClearTmpGlobal();
};

function InitDict() {
    var locNotify = PIVAS.Notify();
    // 配液中心
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaLoc',
            Type: 'PivaLoc'
        },
        {
            editable: false,
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                if (datas.length == 1) {
                    $('#cmbPivaLoc').combobox('select', datas[0].RowId);
                } else {
                    for (var i = 0; i < datas.length; i++) {
                        if (datas[i].RowId == SessionLoc) {
                            $('#cmbPivaLoc').combobox('select', datas[i].RowId);
                            break;
                        }
                    }
                }
            },
            onSelect: function (data) {
                locNotify.trigger();
            }
        }
    );
    // 配液大类
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaCat',
            Type: 'PivaCat'
        },
        {}
    );
    // 科室组
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbLocGrp',
            Type: 'LocGrp'
        },
        {}
    );
    // 病区
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWard',
            Type: 'Ward'
        },
        {
            readonly: SessionWard != '' ? true : false,
            onLoadSuccess: function () {
                if (SessionWard != '') {
                    $('#cmbWard').combobox('setValue', SessionWard);
                }
            }
        }
    );
    // 医嘱优先级
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPriority',
            Type: 'Priority'
        },
        {}
    );
    // 工作组
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWorkType',
            Type: 'PIVAWorkType'
        },
        {
            onBeforeLoad: function (param) {
                param.inputStr = $('#cmbPivaLoc').combobox('getValue');
                param.filterText = param.q;
            }
        }
    );
    locNotify.listen(function () {
        $('#cmbWorkType').combobox('reload');
    });

    // 药品
    PIVAS.ComboGrid.Init(
        {
            Id: 'cmgIncItm',
            Type: 'IncItm'
        },
        {}
    );
    // 打包
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPack',
            Type: 'PackType'
        },
        {}
    );

    // 配液状态
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaStat',
            Type: 'PIVAState'
        },
        {
            editable: false,
            readonly: PIVAStateNumber != '' ? true : false,
            onLoadSuccess: function () {
                if (PIVAStateNumber != '') {
                    var datas = $(this).combobox('getData');
                    for (var i = 0; i < datas.length; i++) {
                        if (datas[i].RowId == PIVAStateNumber) {
                            $(this).combobox('setValue', datas[i].RowId);
                            break;
                        }
                    }
                } else {
                    $(this).combobox('showPanel');
                }
            },
            onSelect: function (data) {
                ClearDetailContent();
                $('#txtGeneNo').val('');
                ChangeDOMByPS();
            },
            onBeforeLoad: function (param) {
                var noPs = '3,10';
                if (SessionWard == '') {
                    noPs += ',90';
                }
                param.inputStr = $('#cmbPivaLoc').combobox('getValue') + '^' + noPs + '^' + 'execute';
                param.filterText = param.q;
            }
        }
    );
    locNotify.listen(function () {
        $('#cmbPivaStat').combobox('reload');
    });
    locNotify.listen(function () {
        var locId = $('#cmbPivaLoc').combobox('getValue');
        $('#DivBatNo').html('　　批次');
        PIVAS.BatchNoCheckList({
            Id: 'DivBatNo',
            LocId: locId,
            Check: true,
            Pack: false
        });
        InitGridWardBat(locId);
    });
}

//初始化明细列表
function InitGridOrdExe() {
    var columns = [
        [
            {
                field: 'ordExeSelect',
                checkbox: true
            },
            {
                field: 'warnInfo',
                title: '提醒',
                width: 50,
                hidden: false
            },
            {
                field: 'pid',
                title: 'pid',
                width: 150,
                hidden: true
            },
            {
                field: 'wardDesc',
                title: '病区',
                width: 150,
                hidden: false
            },
            {
                field: 'doseDateTime',
                title: '用药日期',
                width: 95
            },
            {
                field: 'bedNo',
                title: '床号',
                width: 75
            },
            {
                field: 'patNo',
                title: '登记号',
                width: 100
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100
            },
            {
                field: 'batNo',
                title: '批次',
                width: 50,
                styler: function (value, row, index) {
                    var colorStyle = '';
                    if (row.packFlag != '') {
                        colorStyle = PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'oeoriSign',
                title: '组',
                width: 30,
                halign: 'left',
                align: 'center',
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            {
                field: 'incDesc',
                title: '药品',
                width: 250,
                styler: PIVAS.Grid.Styler.IncDesc
            },
            {
                field: 'incSpec',
                title: '规格',
                width: 100
            },
            {
                field: 'dosage',
                title: '剂量',
                width: 75
            },
            {
                field: 'qty',
                title: '数量',
                width: 50,
                halign: 'left',
                align: 'right'
            },
            {
                field: 'freqDesc',
                title: '频次',
                width: 75
            },
            {
                field: 'instrucDesc',
                title: '用法',
                width: 80
            },
            {
                field: 'bUomDesc',
                title: '单位',
                width: 50
            },
            {
                field: 'docName',
                title: '医生',
                width: 75,
				hidden:true
            },
            {
                field: 'passResultDesc',
                title: '审核结果',
                width: 85
            },
            {
                field: 'priDesc',
                title: '优先级',
                width: 75
            },
            {
                field: 'packFlag',
                title: '打包',
                width: 85,
                hidden: true
            },
            {
                field: 'ordRemark',
                title: '备注',
                width: 75
            },
            {
                field: 'barCode',
                title: '条码',
                width: 125
            },
            {
                field: 'mDsp',
                title: 'mDsp',
                width: 70,
                hidden: true
            },
            {
                field: 'colColor',
                title: 'colColor',
                width: 50,
                hidden: true
            }, // 病人顺序\库存不足\超剂量\非整包装
            {
                field: 'pogId',
                title: 'pogId',
                width: 70,
                hidden: false
            },
            {
                field: 'incDescStyle',
                title: 'incDescStyle',
                width: 70,
                hidden: true
            },
            {
                field: 'check',
                title: 'check',
                width: 50,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: PIVAS.URL.COMMON + '?action=JsGetExecuteDetail',
        fit: true,
        toolbar: '#gridOrdExeBar',
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 200],
        pagination: true,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        rowStyler: function (index, rowData) {
            return PIVAS.Grid.RowStyler.Person(index, rowData, 'patNo');
        },
        onLoadSuccess: function (data) {
            $(this).datagrid('options').checking = true;
            var row0Data = data.rows[0];
            if (row0Data) {
                $(this).datagrid('checkAll');
                var pid = row0Data.pid;
                $('#gridOrdExe').datagrid('options').queryParams.pid = pid;
                var rows = $(this).datagrid('getRows');
                var rowsLen = rows.length;
                for (var index = rowsLen - 1; index >= 0; index--) {
                    var rowData = rows[index];
                    var check = rowData.check;
                    if (check != 'Y') {
                        $(this).datagrid('uncheckRow', index);
                    }
                }
            } else {
                $(this).datagrid('uncheckAll');
            }
            if (NeedScroll == 'Y') {
                $(this).datagrid('scrollTo', 0);
                NeedScroll = 'Y';
            }
            $(this).datagrid('options').checking = '';
        },
        onClickRow: function (rowIndex, rowData) {},
        /*
        onClickCell: function (rowIndex, field, value) {
            if ((field == "batNo") && (value != "")) {
                var mDsp = $('#gridOrdExe').datagrid('getData').rows[rowIndex].mDsp;
                PIVAS.UpdateBatNoWindow({
                    LocId: SessionLoc,
                    MDsp: mDsp,
                    GridId: "gridOrdExe",
                    Field: "batNo",
                    CurRowIndex: rowIndex
                })
            }
        },
        */
        onCheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            $(this).datagrid('options').checking = true;
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId
            });
            CheckRowsGlobal(rowData.pogId, 'Y');
            $(this).datagrid('options').checking = '';
        },
        onUncheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            $(this).datagrid('options').checking = true;
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: false,
                Value: rowData.pogId
            });
            CheckRowsGlobal(rowData.pogId, 'N');
            $(this).datagrid('options').checking = '';
        },
        onSelect: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId,
                Type: 'Select'
            });
            $(this).datagrid('options').checking = '';
        },
        onUnselect: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId,
                Type: 'Select'
            });
            $(this).datagrid('options').checking = '';
        },
        onCheckAll: function (rows) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            CheckPage(rows, 'Y');
        },
        onUncheckAll: function (rows) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            CheckPage(rows, 'N');
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridOrdExe', dataGridOption);
}

/// 初始化病区批次汇总
function InitGridWardBat(locId) {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Execute',
            MethodName: 'ColumnsWardBat',
            locId: locId
        },
        function (retJson) {
            var columnsArr = [
                {
                    field: 'ordExeSelect',
                    checkbox: true
                },
                {
                    field: 'pid',
                    title: 'pid',
                    width: 50,
                    hidden: true
                }
            ];
            for (var i = 0; i < retJson.length; i++) {
                var retJsonI = retJson[i];
                if (retJsonI.field.indexOf('batNo') >= 0) {
                    retJsonI.styler = function (value, row, index) {
                        if (parseInt(value) > 0) {
                            return 'font-weight:bold;';
                        }
                    };
                }
                columnsArr.push(retJsonI);
            }
            var columns = [columnsArr];
            var dataGridOption = {
                url: PIVAS.URL.COMMON + '?action=JsGetExecuteWardBat',
                fit: true,
                toolbar: '#gridWardBatBar',
                rownumbers: true,
                columns: columns,
                pagination: false,
                singleSelect: false,
                showFooter: true,
                onLoadSuccess: function (data) {
                    var row0Data = data.rows[0];
                    if (row0Data) {
                        var pid = row0Data.pid;
                        $('#gridWardBat').datagrid('options').queryParams.pid = pid;
                    }
                }
            };
            DHCPHA_HUI_COM.Grid.Init('gridWardBat', dataGridOption);
        }
    );
}

function Query() {
    var tabTitle = $('#tabsExecute').tabs('getSelected').panel('options').title;
    if (tabTitle == '医嘱明细') {
        QueryOrdExe();
    } else if (tabTitle == '病区汇总') {
        QueryWardBat();
    } else if (tabTitle == '扫描条码') {
        PIVASSCAN.Clean();
        PIVASSCAN.CalcuWard('');
    }
}
// 查询医嘱明细
function QueryOrdExe() {
    ClearTmpGlobal('gridOrdExe');
    var params = QueryParams('QueryOrdExe');
    if (params == '') {
        return;
    }
    $('#gridOrdExe').datagrid('load', {
        params: params,
        pid: ''
    });
}

// 查询病区批次汇总
function QueryWardBat() {
    ClearTmpGlobal('gridWardBat');
    var params = QueryParams('QueryWardBat');
    if (params == '') {
        return;
    }
    $('#gridWardBat').datagrid('load', {
        params: params,
        pid: ''
    });
}
// 获取查询参数
// flag==QueryOrdExe   flag==QueryScan flag=QueryWardBat
function QueryParams(flag) {
    var pivaLocId = $('#cmbPivaLoc').combobox('getValue') || ''; // 1-配液中心
    var wardId = $('#cmbWard').combobox('getValue') || ''; // 2-病区
    var prtStartDate = $('#datePrtStart').datebox('getValue'); // 3-打签开始日期
    var prtEndDate = $('#datePrtEnd').datebox('getValue'); // 4-打签结束日期
    var ordStartDate = $('#dateOrdStart').datebox('getValue'); // 5-用药开始日期
    var ordEndDate = $('#dateOrdEnd').datebox('getValue'); // 6-用药结束日期
    var psNumber = $('#cmbPivaStat').combobox('getValue') || ''; // 7-配液预执行状态
    var locGrpId = $('#cmbLocGrp').combobox('getValue') || ''; // 8-科室组
    var pivaCat = $('#cmbPivaCat').combobox('getValue') || ''; // 9-配液大类
    var workType = $('#cmbWorkType').combobox('getValue') || ''; // 10-集中配置
    var priority = $('#cmbPriority').combobox('getValue') || ''; // 11-医嘱优先级
    var incId = $('#cmgIncItm').combobox('getValue') || ''; // 12-药品
    var packFlag = $('#cmbPack').combobox('getValues') || ''; // 13-打包类型
    var patNo = $('#txtPatNo').val().trim(); // 14-登记号
    var prtNo = $('#txtPrtNo').searchbox('getValue'); // 15-打印标签单号
    var batNoStr = ''; // 16-批次
    $('input[type=checkbox][name=batbox]').each(function () {
        if ($('#' + this.id).is(':checked')) {
            if (batNoStr == '') {
                batNoStr = this.value;
            } else {
                batNoStr = batNoStr + ',' + this.value;
            }
        }
    });
    if (pivaLocId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择配液中心',
            type: 'alert'
        });
        return '';
    }
    if (psNumber == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择配液状态',
            type: 'alert'
        });
        return '';
    }
    if (batNoStr == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择批次',
            type: 'alert'
        });
        return '';
    }
    // tab title
    var tabTitle = $('#tabsExecute').tabs('getSelected').panel('options').title;
    var params =
        pivaLocId +
        '^' +
        wardId +
        '^' +
        prtStartDate +
        '^' +
        prtEndDate +
        '^' +
        ordStartDate +
        '^' +
        ordEndDate +
        '^' +
        psNumber +
        '^' +
        locGrpId +
        '^' +
        pivaCat +
        '^' +
        workType +
        '^' +
        priority +
        '^' +
        incId +
        '^' +
        packFlag +
        '^' +
        patNo +
        '^' +
        prtNo +
        '^' +
        batNoStr;
    return params;
}

function Execute(grpWay, printFlag) {
    grpWay = grpWay || '';
    printFlag = printFlag || '';
    var pogIdStr = GetCheckPOGIdStr('');
    if (pogIdStr == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请勾选需要确认执行的医嘱数据',
            type: 'alert'
        });
        return;
    }
    var psNumber = $('#cmbPivaStat').combobox('getValue');
    if (psNumber == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择执行状态',
            type: 'alert'
        });
        return;
    }
    PIVAS.Progress.Show({
        type: 'save',
        interval: 1000
    });
    $.m(
        {
            ClassName: 'web.DHCSTPIVAS.Execute',
            MethodName: 'SaveDataByPog',
            pogIdStr: pogIdStr,
            userId: SessionUser,
            psNumber: psNumber,
            grpWay: grpWay
        },
        function (retData) {
            PIVAS.Progress.Close();
            if (retData.indexOf('msg') >= 0) {
                $.messager.alert('提示', JSON.parse(retData).msg, 'error');
                return;
            }
            var retArr = retData.split('^');
            if (retArr[0] == -1) {
                $.messager.alert('提示', retArr[1], 'warning');
            } else if (retArr[0] < -1) {
                $.messager.alert('提示', retArr[1], 'error');
            } else {
                if (printFlag == 'Y') {
                    var pogsNoStr = retArr[1];
                    PrintWardBat(pogsNoStr);
                }
            }
            QueryOrdExe();
        }
    );
}

function ExecuteWB(grpWay, printFlag) {
    grpWay = grpWay || '';
    printFlag = printFlag || '';
    var wardIdStr = GetWardIdStr();
    if (wardIdStr == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请勾选需要确认执行的病区',
            type: 'alert'
        });
        return;
    }
    var pid = $('#gridWardBat').datagrid('getRows')[0].pid;
    if (pid == '') {
        $.messager.alert('提示', '获取不到进程,请查询后重试', 'warning');
        return;
    }
    var psNumber = $('#cmbPivaStat').combobox('getValue');
    if (psNumber == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择执行状态',
            type: 'alert'
        });
        return;
    }
    PIVAS.Progress.Show({
        type: 'save',
        interval: 1000
    });
    $.m(
        {
            ClassName: 'web.DHCSTPIVAS.Execute',
            MethodName: 'SaveDataByPid',
            pid: pid,
            wardIdStr: wardIdStr,
            userId: SessionUser,
            psNumber: psNumber,
            grpWay: grpWay
        },
        function (retData) {
            PIVAS.Progress.Close();
            if (retData.indexOf('msg') >= 0) {
                $.messager.alert('提示', JSON.parse(retData).msg, 'error');
                return;
            }
            var retArr = retData.split('^');
            if (retArr[0] == -1) {
                $.messager.alert('提示', retArr[1], 'warning');
            } else if (retArr[0] < -1) {
                $.messager.alert('提示', retArr[1], 'error');
            } else {
                if (printFlag == 'Y') {
                    var pogsNoStr = retArr[1];
                    PrintWardBat(pogsNoStr);
                }
            }
            QueryWardBat();
        }
    );
}

function RefusePog() {
    if (ValidCanDo('gridOrdExe') == false) {
        return;
    }
    $.messager.confirm('提示', '您确认配液拒绝吗?', function (r) {
        if (r) {
            var pogIdStr = GetPogIdStr('RefusePog');
            if (pogIdStr == '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '请勾选需要配液拒绝的医嘱数据',
                    type: 'alert'
                });
                return;
            }
            PIVAS.RefuseReasonWindow(
                {
                    pogIdStr: pogIdStr,
                    userId: SessionUser
                },
                QueryOrdExe
            );
        }
    });
}

// 清除本程序涉及的所有临时global
function ClearTmpGlobal(type) {
    type = type || '';
    if (type == 'gridOrdExe' || type == '') {
        var pid = $('#gridOrdExe').datagrid('options').queryParams.pid || '';
        tkMakeServerCall('web.DHCSTPIVAS.Execute', 'KillCollectExecuteData', pid);
    }
    if (type == 'gridWardBat' || type == '') {
        var pid = $('#gridWardBat').datagrid('options').queryParams.pid || '';
        tkMakeServerCall('web.DHCSTPIVAS.Execute', 'KillSaveData', pid);
    }
}

function ClearDetailContent() {
    ClearTmpGlobal('');
    $('#gridOrdExe').datagrid('clear');
    $('#gridWardBat').datagrid('clear');
    $('#scan-total').text(0);
    $('#unscan-total').text(0);
    $('#scaned-total').text(0);
    $('#scan-ward').text('');
}

// 获取选中的医嘱明细Pog串
function GetPogIdStr(getType) {
    var pogIdArr = [];
    var gridOrdExeChecked = $('#gridOrdExe').datagrid('getChecked');
    for (var i = 0; i < gridOrdExeChecked.length; i++) {
        var checkedData = gridOrdExeChecked[i];
        var pogId = checkedData.pogId;
        if (pogIdArr.indexOf(pogId) < 0) {
            pogIdArr.push(pogId);
        }
    }
    return pogIdArr.join('^');
}
// 获取选中的病区Id串
function GetWardIdStr() {
    var wardIdArr = [];
    var gridWardBatChecked = $('#gridWardBat').datagrid('getChecked');
    for (var i = 0; i < gridWardBatChecked.length; i++) {
        var checkedData = gridWardBatChecked[i];
        var wardId = checkedData.wardId;
        if (wardIdArr.indexOf(wardId) < 0) {
            wardIdArr.push(wardId);
        }
    }
    return wardIdArr.join('^');
}
// 生成单号
function ConfirmGenerateNo() {
    var psNumber = $('#cmbPivaStat').combobox('getValue');
    if (psNumber == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选择流程状态',
            type: 'alert'
        });
        return;
    }
    var pivaLocId = $('#cmbPivaLoc').combobox('getValue');
    if (pivaLocId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选择配液中心',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('提示', '您确认 <b>' + '清屏' + ' </b>吗?', function (r) {
        if (r) {
            $('#txtGeneNo').val('');
            // GenerateNo(psNumber, pivaLocId);
        }
    });
}

function GenerateNo(psNumber, pivaLocId) {
    var geneNoRet = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetAppNo', psNumber, pivaLocId);
    var geneNoArr = geneNoRet.split('^');
    var geneNo = geneNoArr[0];
    if (geneNo == '-1') {
        $.messager.alert('提示', geneNoArr[0], 'error');
        return;
    }
    $('#txtGeneNo').val(geneNo);
}

// 根据单号执行并打印交接单
function ExePrtWardBat(grpWay) {
    var geneNo = $('#txtGeneNo').val();
    if (geneNo == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '未查询到扫描记录,无法打印',
            type: 'alert'
        });
        return;
    }
    PIVAS.Progress.Show({
        type: 'save',
        interval: 1000
    });
    $.m(
        {
            ClassName: 'web.DHCSTPIVAS.Execute',
            MethodName: 'SaveDataByPOGSNo',
            pogsNo: geneNo,
            userId: SessionUser,
            psNumber: PrtWardBatPS
        },
        function (retData) {
            PIVAS.Progress.Close();
            if (retData.indexOf('msg') >= 0) {
                $.messager.alert('提示', JSON.parse(retData).msg, 'error');
                return;
            }
            var retArr = retData.split('^');
            if (retArr[0] == -1) {
                $.messager.alert('提示', retArr[1], 'warning');
            } else if (retArr[0] < -1) {
                $.messager.alert('提示', retArr[1], 'error');
            } else {
                PrintWardBat(retArr[1]);
            }

            //触发打印
        }
    );
}

function PrintWardBat(pogsNoStr) {
    var paramsArr = PIVASPRINT.DefaultParams.WardBat();
    paramsArr[0] = $('#cmbPivaLoc').combobox('getValue');
    paramsArr[20] = pogsNoStr;
    var raqObj = {
        raqName: 'DHCST_PIVAS_病区交接单.raq',
        raqParams: {
            startDate: $('#dateOrdStart').datebox('getValue'),
            endDate: $('#dateOrdEnd').datebox('getValue'),
            userName: session['LOGON.USERNAME'],
            pivaLoc: session['LOGON.CTLOCID'],
            hospDesc: PIVAS.Session.HOSPDESC,
            locDesc: $('#cmbPivaLoc').combobox('getText'),
            inputStr: paramsArr.join('^'),
            pid: ''
        },
        isPreview: 1
    };
    PIVASPRINT.RaqPrint(raqObj);
}
// 初始化默认条件
function InitPivasSettings() {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'GetAppProp',
            userId: session['LOGON.USERID'],
            locId: session['LOGON.CTLOCID'],
            appCode: 'Execute'
        },
        function (jsonData) {
            $('#dateOrdStart').datebox('setValue', jsonData.OrdStDate);
            $('#dateOrdEnd').datebox('setValue', jsonData.OrdEdDate);
            $('#datePrtStart').datebox('setValue', jsonData.PrtStDate);
            $('#datePrtEnd').datebox('setValue', jsonData.PrtEdDate);
            PrtWardBatPS = jsonData.PrtWardBatPS;
        }
    );
}

function CheckPage(rows, flag) {
    if (rows == '') {
        return;
    }
    var pogIdArr = [];
    var pogId = '';
    for (var i in rows) {
        pogId = rows[i].pogId;
        if (pogId == '') {
            continue;
        }
        if (pogIdArr.indexOf(pogId) >= 0) {
            continue;
        }
        pogIdArr.push(pogId);
    }
    var pogIdStr = pogIdArr.join('^');
    if (pogIdStr == '') {
        return;
    }
    CheckRowsGlobal(pogIdStr, flag);
}

function CheckRowsGlobal(pogIdStr, flag, all) {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Execute',
            MethodName: 'CheckRows',
            POGIdStr: pogIdStr,
            Flag: flag,
            Pid: $('#gridOrdExe').datagrid('options').queryParams.pid || '',
            All: all || '',
            dataType: 'text'
        },
        false
    );
    if (all == 'Y') {
        NeedScroll = '';
        $('#gridOrdExe').datagrid('reload');
    }
}

function GetCheckPOGIdStr(allFlag) {
    var pogIdStr = $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Execute',
            MethodName: 'GetSavePOGIdStr',
            Pid: $('#gridOrdExe').datagrid('options').queryParams.pid || '',
            dataType: 'text'
        },
        false
    );
    return pogIdStr;
}

function ConfirmGrpWay(callBack) {
    var winId = 'PIVAS_UX_ConfirmGrpWay';
    var html = '';
    html += '<div id=' + winId + ' style="padding:20px;text-align:center">';
    html += '   <div><a class="hisui-linkbutton" style="width:100%">按病区打印</a></div>';
    html += '   <div style="padding-top:20px"><a class="hisui-linkbutton" style="width:100%">按病区与批次打印</a></div>';
    html += '</div>';
    $('body').append(html);
    $('#' + winId)
        .window({
            title: ' 打印方式',
            collapsible: false,
            iconCls: 'icon-w-print',
            border: false,
            closed: false,
            modal: true,
            width: 300,
            height: 160,
            minimizable: false,
            maximizable: false,
            onClose: function () {
                $(this).window('destroy');
            }
        })
        .window('open');
    $('#' + winId + ' a').linkbutton({
        onClick: function () {
            $('#' + winId).window('close');
            if (this.text.indexOf('批次') >= 0) {
                callBack('2', 'Y');
            } else {
                callBack('1', 'Y');
            }
        }
    });
}

function ChangeDOMByPS() {
    var psNumber = $('#cmbPivaStat').combobox('getValue') || '';
    var psName = $('#cmbPivaStat').combobox('getText') || '';
    if (PrtWardBatPS != '' && PrtWardBatPS == psNumber) {
        $('#btnExecuteWBPrt,#btnExecutePrt').show();
    } else {
        $('#btnExecuteWBPrt,#btnExecutePrt').hide();
    }
    $('#btnExecuteWB .l-btn-text,#btnExecute .l-btn-text').text('执行' + psName);
    $('#btnExecuteWB,#btnExecute').linkbutton('options').text = '执行' + psName;
}

function ValidCanDo(gridId) {
    if ($('#' + gridId).datagrid('getRows') == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '界面内无数据',
            type: 'alert'
        });
        return false;
    }
    return true;
}
