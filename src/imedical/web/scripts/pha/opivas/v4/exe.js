/**
 * 名称:	 门诊配液系统-配液状态执行
 * 编写人:	 yunhaibao
 * 编写日期: 2019-06-26
 */
PHA_COM.App.Csp = 'pha.opivas.v4.exe.csp';
// 动态消息
var EXE_INTERVAL;
var EXE_IFPIVAS = tkMakeServerCall('PHA.OPIVAS.COM.Method', 'IsPIVASLoc', session['LOGON.CTLOCID']); // 定时器时间间隔
var EXE_DEFAULT = [
    {
        conStDate: 't',
        conEdDate: 't',
        conStTime: '',
        conEdTime: '',
        conPack: {
            RowId: '',
            Select: false
        }
    }
];

$(function () {
    var isTabMenu = PHA_COM.IsTabsMenu ? PHA_COM.IsTabsMenu() : false;
    $('#panelExe').panel({
        title: isTabMenu !== true ? '配液状态执行' : '',
        headerCls: 'panel-header-gray',
        iconCls: 'icon-pivas-exe',
        bodyCls: 'panel-body-gray',
        fit: true
    });

    InitDict();
    InitGridExe();
    $('#btnFind').on('click', Query);
    $('#btnClean').on('click', Clean);
    $('#btnPrtArrange').on('click', function () {
        var psNumber = $('#conPS').combobox('getValue');
        // if (psNumber!="30"){
        // 	PHA.Popover({
        // 		msg: '执行状态不为排药，无法打印排药单',
        // 		type: 'alert'
        // 	});
        // 	return;
        // }
        var geneNo = $('#geneNo').val().trim();
        if (geneNo == '') {
            PHA.Popover({
                msg: '单号为空,无法打印', // @translate
                type: 'alert'
            });
            return;
        }
        PIVASPRINT.Arrange(geneNo, '');
    });
    $('#btnExecute').on('click', function () {
        SaveHandler();
    });
    $('#btnAllSelect').on('click', function () {
        CheckRowsGlobal('', 'Y', 'Y');
    });
    $('#btnAllUnSelect').on('click', function () {
        CheckRowsGlobal('', 'N', 'Y');
    });
    $('#btnGeneNo').on('click', GenerateNo);
    PHA_OPIVAS_COM.Bind.KeyDown.PatNo('conPatNo', Query);
    $('#barCode').on('keypress', function (event) {
        if (event.keyCode == '13') {
            SaveByBarCode();
        }
    });
    PHA.SetVals(EXE_DEFAULT);
});

function InitDict() {
    PHA.ComboBox('conPivasLoc', {
        url: PHA_STORE.Pharmacy('OPIVAS').url,
        editable: false,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            $(this).combobox('select', data[0].RowId);
        },
        onSelect: function (data) {
            PHA.ComboBox('conPS', {
                editable: false,
                url: PHA_OPIVAS_STORE.PIVAState().url + '&InputStr=' + data.RowId + '^10^OPIVAS.EXE^' + EXE_IFPIVAS,
                panelHeight: 'auto',
                onSelect: function () {
                    $('#geneNo').val('');
                    Query();
                },
                onLoadSuccess: function (data) {
                    if (data) {
                        if (data.length == 1) {
                            $(this).combobox('select', data[0].RowId);
                        } else {
                            $(this).combobox('showPanel');
                        }
                    }
                }
            });
        }
    });

    PHA.DateBox('conStDate', {
        width: 125
    });
    PHA.DateBox('conEdDate', {
        width: 125
    });
    PHA.ComboBox('conPack', {
        editable: false,
        url: PHA_OPIVAS_STORE.PIVADISPackFlag().url,
        panelHeight: 'auto',
        onSelect: function () {
            Query();
        }
    });

    var opts = $.extend({}, PHA_STORE.ArcItmMast(), {
        width: typeof HISUIStyleCode == 'string' && HISUIStyleCode == 'lite' ? 297 : 305,
        panelWidth: 500,
        fitColumns: true
    });
    PHA.LookUp('conArcim', opts);
    PHA.TriggerBox('conPOGSNo', {
        handler: function (data) {
            PHA_OPIVAS_UX.POGSNo(
                {
                    locId: $('#conPivasLoc').combobox('getValue') || ''
                },
                function (data) {
                    $('#conPOGSNo').triggerbox('setValue', data.pogsNo).triggerbox('setValueId', data.pogsNo);
                    Query();
                }
            );
        },
        width: 305
    });
}

function InitGridExe() {
    var columns = [
        [
            {
                field: 'pid',
                title: '进程号',
                width: 100,
                hidden: true
            },
            {
                field: 'dspId',
                title: 'dspId',
                width: 75,
                hidden: true
            },
            {
                field: 'mDspId',
                title: 'mDspId',
                width: 95,
                hidden: true
            },
            {
                field: 'pogId',
                title: 'pogId',
                width: 95,
                hidden: true
            },
            {
                field: 'oeoreChk',
                checkbox: true
            },
            {
                field: 'warn',
                title: '提醒',
                width: 75,
                styler: PHA_OPIVAS_COM.Grid.Styler.Warn
            },
            {
                field: 'packFlag',
                title: '打包',
                width: 45,
                align: 'center',
                formatter: PHA_OPIVAS_COM.Grid.Formatter.YesNo,
                styler: PHA_OPIVAS_COM.Grid.Styler.Pack
            },
            {
                field: 'doseDateTime',
                title: '用药时间',
                width: 100
            },
            {
                field: 'patNo',
                title: '登记号',
                width: 100,
                formatter: function (value, row, index) {
                    return PHA_OPIVAS_COM.Grid.Formatter.AdmDetail(value, row, index, 'oeori');
                }
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100
            },
            {
                field: 'patSex',
                title: '性别',
                width: 45,
                align: 'center'
            },
            {
                field: 'patAge',
                title: '年龄'
            },
            {
                field: 'oeoriSign',
                title: '组',
                width: 30,
                formatter: PHA_OPIVAS_COM.Grid.Formatter.OeoriSign
            },
            {
                field: 'inciDesc',
                title: '药品名称',
                width: 250
            },
            {
                field: 'dosage',
                title: '剂量'
            },
            {
                field: 'instrucDesc',
                title: '用法',
                width: 75
            },
            {
                field: 'freqDesc',
                title: '频次'
            },
            {
                field: 'duraDesc',
                title: '疗程',
                width: 75
            },
            {
                field: 'oeoriRemark',
                title: '医嘱备注',
                width: 100
            },
            {
                field: 'ivgttSpeed',
                title: '滴速',
                width: 80
            },
            {
                field: 'docLocDesc',
                title: '医生科室',
                width: 100
            },
            {
                field: 'docName',
                title: '医生',
                width: 100
            },
            {
                field: 'exceedReason',
                title: '疗程超量原因',
                width: 125
            },
            {
                field: 'prescNo',
                title: '处方号',
                width: 125
            },
            {
                field: 'oeoriStatus',
                title: '医嘱状态',
                width: 70,
                align: 'center'
            },
            {
                field: 'oeoreStatus',
                title: '执行记录状态',
                width: 100
            },
            {
                field: 'barCode',
                title: '条码',
                width: 100
            },
            {
                field: 'oeori',
                title: '医嘱ID',
                width: 100,
                formatter: function (value, row, index) {
                    return PHA_OPIVAS_COM.Grid.Formatter.OrderDetail(value, row, index, 'oeori');
                }
            },
            {
                field: 'check',
                title: 'check',
                width: 100,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        exportXls: false,
        url: 'pha.opivas.v4.broker.csp',
        queryParams: {
            ClassName: 'PHA.OPIVAS.Exe.Query',
            QueryName: 'Exe',
            GrpField: 'mDspId',
            LogonStr: PHA_COM.Session.ALL
        },
        pagination: true,
        columns: columns,
        nowrap: true,
        singleSelect: false,
        toolbar: '#gridExeBar',
        onCheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            $(this).datagrid('options').checking = true;
            PHA_OPIVAS_COM.Grid.LinkCheck.Do({
                CurRowIndex: rowIndex,
                GridId: 'gridExe',
                Field: 'mDspId',
                Check: true,
                Value: rowData.mDspId
            });
            CheckRowsGlobal(rowData.mDspId, 'Y');
            $(this).datagrid('options').checking = '';
        },
        onUncheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            $(this).datagrid('options').checking = true;
            PHA_OPIVAS_COM.Grid.LinkCheck.Do({
                CurRowIndex: rowIndex,
                GridId: 'gridExe',
                Field: 'mDspId',
                Check: false,
                Value: rowData.mDspId
            });
            CheckRowsGlobal(rowData.mDspId, 'N');
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
        },
        onLoadSuccess: function (data) {
            $(this).datagrid('options').checking = true;
            var row0Data = data.rows[0];
            if (row0Data) {
                $(this).datagrid('checkAll');
                var pid = row0Data.pid;
                $(this).datagrid('options').queryParams.Pid = pid;
                var rows = $(this).datagrid('getRows');
                var rowsLen = rows.length;
                for (var index = rowsLen - 1; index >= 0; index--) {
                    // 选择
                    var rowData = rows[index];
                    var check = rowData.check;
                    if (check != 'Y') {
                        $(this).datagrid('uncheckRow', index);
                    }
                }
            } else {
                $(this).datagrid('uncheckAll');
            }
            $(this).datagrid('options').checking = '';
            $(this).datagrid('scrollTo', 0);
        },
        rowStyler: function (index, rowData) {
            return PHA_OPIVAS_COM.Grid.RowStyler.Person(index, rowData, 'patNo');
        }
    };
    PHA.Grid('gridExe', dataGridOption);
}

/*****************************************************************/
function Query() {
    if ($('#conPS').combobox('getValue') == '') {
        PHA.Popover({
            msg: '请先选择执行状态', // @translate
            type: 'alert'
        });
        return;
    }
    var valsStr = PHA_OPIVAS_COM.DomData('#qCondition', {
        doType: 'query',
        needId: 'Y'
    });
    var tabTitle = '医嘱明细'; // $('#tabsExecute').tabs('getSelected').panel('options').title;
    if (tabTitle == '医嘱明细') {
        KillTmpGloal();
        $('#gridExe').datagrid('query', {
            InputStr: valsStr,
            Pid: ''
        });
    } else if (tabTitle == '扫描执行') {
        $.cm(
            {
                ClassName: 'PHA.OPIVAS.Exe.Query',
                MethodName: 'CalcuScan',
                InputStr: valsStr
            },
            function (data) {
                $('#scan-total').text(data.total || 0);
                $('#unscan-total').text(data.unscaned || 0);
                $('#scaned-total').text(data.scaned || 0);
            }
        );
    }
}

/**
 *
 * @param {String} type
 */
function SaveHandler() {
    var chkDatas = $('#gridExe').datagrid('getChecked');
    if (chkDatas == '') {
        PHA.Popover({
            msg: '请先选择记录', // @translate
            type: 'alert'
        });
        return;
    }
    var conPSText = $('#conPS').combobox('getText');
    var conInfo = $g('您确认操作{{status}}吗?').replace(/{{status}}/g, conPSText); // @translate
    PHA.Confirm('操作提示', $got(conInfo), function () {
        var mDspIdStr = $.cm(
            {
                ClassName: 'PHA.OPIVAS.Exe.Query',
                MethodName: 'GetSaveDspStr',
                Pid: $('#gridExe').datagrid('options').queryParams.Pid || '',
                dataType: 'text'
            },
            false
        );
        var saveOpt = {
            mDspIdStr: mDspIdStr
        };
        Save(saveOpt);
    });
}

function Save(saveOpt) {
    PHA.Loading('Show');
    var PSNumber = $('#conPS').combobox('getValue') || '';
    $.cm(
        {
            ClassName: 'PHA.OPIVAS.COM.Save',
            MethodName: 'ExecuteMulti',
            MDspIdStr: saveOpt.mDspIdStr,
            LogonStr: PHA_COM.Session.ALL,
            PSNumber: PSNumber,
            dataType: 'text'
        },
        function (saveRet) {
            PHA.Loading('Hide');
            var saveArr = saveRet.split('^');
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            var saveNo = saveArr[2] || '';
            if (saveVal < 0) {
                PHA.Alert('提示', saveInfo, 'warning');
            } else {
                PHA.Popover({
                    msg: saveNo,
                    type: 'success',
                    timeout: 1500
                });
            }
            if (PSNumber == 30) {
                PHA.Confirm(
                    '操作提示',
                    '是否打印排药单?', // @translate
                    function () {
                        PIVASPRINT.Arrange(saveNo, '');
                        Query();
                    },
                    function () {
                        Query();
                    }
                );
            } else {
                Query();
            }
        }
    );
}
/**
 *  清屏
 */
function Clean() {
    PHA.DomData('#qCondition', {
        doType: 'clear'
    });
    KillTmpGloal();
    $('#gridExe').datagrid('clear');
    PHA.SetVals(EXE_DEFAULT);
    $('#scan-total').text(0);
    $('#unscan-total').text(0);
    $('#scaned-total').text(0);
    $('#labelContent').html('');
    $('#conPOGSNo').triggerbox('setValue', '').triggerbox('setValueId', '');
}

function KillTmpGloal() {
    PHA_OPIVAS_COM.Kill('gridExe', 'PHA.OPIVAS.Exe.Query', 'KillExe');
}

function CheckPage(rows, flag) {
    if (rows == '') {
        return;
    }
    var mDspIdArr = [];
    var mDspId = '';
    for (var i in rows) {
        mDspId = rows[i].mDspId;
        if (mDspId == '') {
            continue;
        }
        if (mDspIdArr.indexOf(mDspId) >= 0) {
            continue;
        }
        mDspIdArr.push(mDspId);
    }
    var mDspIdStr = mDspIdArr.join('^');
    if (mDspIdStr == '') {
        return;
    }
    CheckRowsGlobal(mDspIdStr, flag);
}

function CheckRowsGlobal(mDspIdStr, flag, all) {
    $.cm(
        {
            ClassName: 'PHA.OPIVAS.Exe.Query',
            MethodName: 'CheckRows',
            MDspIdStr: mDspIdStr,
            Flag: flag,
            Pid: $('#gridExe').datagrid('options').queryParams.Pid || '',
            All: all || '',
            dataType: 'text'
        },
        false
    );
    if (all == 'Y') {
        $('#gridExe').datagrid('reload');
    }
}

function GenerateNo() {
    var psNumber = $('#conPS').combobox('getValue');
    if (psNumber == '') {
        PHA.Popover({
            msg: '请先选择需要执行的配液状态', // @translate
            type: 'info'
        });
        return;
    }
    var pivaLocId = $('#conPivasLoc').combobox('getValue');
    if (pivaLocId == '') {
        PHA.Popover({
            msg: '请先选择配液中心', // @translate
            type: 'info'
        });
        return;
    }
    $.messager.confirm('提示', '您确认生成 <b>' + $('#conPS').combobox('getText') + ' </b>单号吗?', function (r) {
        if (r) {
            var geneNoRet = tkMakeServerCall('PHA.OPIVAS.COM.Method', 'GetAppNo', psNumber, pivaLocId);
            var geneNoArr = geneNoRet.split('^');
            var geneNo = geneNoArr[0];
            if (geneNo == '-1') {
                $.messager.alert('提示', $got(geneNoArr[0]), 'error');
                return;
            }
            $('#geneNo').val(geneNo);
            $('#barCode').val('').focus();
        }
    });
}
window.onbeforeunload = function () {
    KillTmpGloal();
};

function SaveByBarCode() {
    var psNumber = $('#conPS').combobox('getValue');
    if (psNumber == '') {
        PHA.Popover({
            msg: '请先选择执行状态', // @translate
            type: 'alert'
        });
        $('#barCode').val('').focus();
        return;
    }
    var pogsNo = $('#geneNo').val();
    var pivaLocId = $('#conPivasLoc').combobox('getValue');
    if (pivaLocId == '') {
        PHA.Popover({
            msg: '请先选择配液中心', // @translate
            type: 'alert'
        });
        $('#barCode').val('').focus();
        return;
    }
    $.cm(
        {
            ClassName: 'PHA.OPIVAS.COM.Save',
            MethodName: 'ExecuteByBarCodeHtml',
            BarCode: $('#barCode').val().trim(),
            LogonStr: PHA_COM.Session.ALL,
            PSNumber: psNumber,
            POGSNo: pogsNo.trim(),
            dataType: 'text'
        },
        function (saveRet) {
            $('#barCode').val('').focus();
            var saveArr = saveRet.split('|$|');
            if (saveArr[0] < 0) {
                PHA.Popover({
                    msg: $got(saveArr[1]),
                    type: 'error'
                });
                $('#labelContent').html('');
                return;
            }
            var labelData = saveArr[1];
            PIVASLABEL.Init({
                labelData: labelData
            });
            Query();
        }
    );
    // var qParams=QueryParams("QueryScan");
    // PIVASSCAN.Execute(this.value, psNumber, pivaLocId, pogsNo,qParams);
    // $(this).val("");
}

