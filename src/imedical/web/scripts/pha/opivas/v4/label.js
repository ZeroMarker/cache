/**
 * 名称:	 门诊配液系统-配液打签
 * 编写人:	 yunhaibao
 * 编写日期: 2019-06-25
 */
PHA_COM.App.Csp = 'pha.opivas.v4.label.csp';
LABEL_PARAMS = $.cm(
    {
        ClassName: 'PHA.OPIVAS.COM.Param',
        MethodName: 'GetPropValJson',
        AppCode: 'OPIVAS.LABEL',
        LogonStr: PHA_COM.Session.ALL,
        dataType: 'json'
    },
    false
);
var LABEL_INTERVAL;
// 定时器时间间隔
var LABEL_INTERVAL_TIME = 30000;
// 打印任务进行中true,false
var LABEL_PRINTTING = '';
var LABEL_DEFAULT = [
    {
        conStDate: 't',
        conEdDate: 't',
        conPack: {
            RowId: '',
            Select: false
        }
    }
];

$(function () {
    var isTabMenu = PHA_COM.IsTabsMenu ? PHA_COM.IsTabsMenu() : false;
    $('#panelLabel').panel({
        title: isTabMenu !== true ? '配液打签' : '',
        headerCls: 'panel-header-gray',
        iconCls: 'icon-print-label',
        bodyCls: 'panel-body-gray',
        fit: true
    });

    InitDict();
    InitGridLabel();
    $('#btnFind').on('click', Query);
    $('#btnClean').on('click', Clean);
    $('#btnStart').on('click', function () {
        PHA_OPIVAS_UX.AutoGif('Show');
        clearInterval(LABEL_INTERVAL);
        LABEL_INTERVAL = setInterval(function () {
            var autoPrtFlag = $('#chkAutoPrint').checkbox('getValue');
            if (LABEL_PRINTTING == true) {
                return;
            }
            var rows = $('#gridLabel').datagrid('getRows');
            if (rows.length == 0 || autoPrtFlag == true) {
                Query();
            }
        }, LABEL_INTERVAL_TIME);
    });
    $('#btnStop').on('click', function () {
        PHA_OPIVAS_UX.AutoGif('Hide');
        clearInterval(LABEL_INTERVAL);
    });
    $('#btnPrint').on('click', function () {
        SaveHandler();
    });

    $('#btnAllSelect').on('click', function () {
        CheckRowsGlobal('', 'Y', 'Y');
    });
    $('#btnAllUnSelect').on('click', function () {
        CheckRowsGlobal('', 'N', 'Y');
    });
    PHA_OPIVAS_COM.Bind.KeyDown.PatNo('conPatNo', Query);
    PHA.SetVals(LABEL_DEFAULT);
});

function InitDict() {
    PHA.ComboBox('conPivasLoc', {
        url: PHA_STORE.Pharmacy('OPIVAS').url,
        editable: false,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            $(this).combobox('select', data[0].RowId);
        }
    });
    PHA.ComboBox('conDocLoc', {
        url: PHA_STORE.DocLoc().url
    });
    PHA.ComboBox('conEMLGLoc', {
        url: PHA_STORE.EMLGLoc().url
    });
    PHA.DateBox('conStDate', {
        width: 150
    });
    PHA.DateBox('conEdDate', {
        width: 150
    });
    PHA.ComboBox('pogUser30', {
        url: PHA_STORE.SSUser(session['LOGON.CTLOCID'], '').url
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
}

function InitGridLabel() {
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
                field: 'disId',
                title: 'disId',
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
                width: 100,
                hidden: true
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
            ClassName: 'PHA.OPIVAS.Label.Query',
            QueryName: 'Label',
            GrpField: 'disId',
            LogonStr: PHA_COM.Session.ALL
        },
        pagination: true,
        columns: columns,
        nowrap: true,
        singleSelect: false,
        toolbar: '#gridLabelBar',
        onCheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            $(this).datagrid('options').checking = true;
            PHA_OPIVAS_COM.Grid.LinkCheck.Do({
                CurRowIndex: rowIndex,
                GridId: 'gridLabel',
                Field: 'disId',
                Check: true,
                Value: rowData.disId
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
                GridId: 'gridLabel',
                Field: 'disId',
                Check: false,
                Value: rowData.disId
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
            AutoPrint();
        },
        rowStyler: function (index, rowData) {
            return PHA_OPIVAS_COM.Grid.RowStyler.Person(index, rowData, 'patNo');
        },
        onLoadError: function (response) {
            clearInterval(LABEL_INTERVAL);
            if (response.statusText == 'abort') {
                return;
            }
            var resText = response.responseText;
            $.messager.alert('提示', resText, 'error');
        }
    };
    PHA.Grid('gridLabel', dataGridOption);
}

/*****************************************************************/
function Query() {
    var valsStr = PHA_OPIVAS_COM.DomData('#qCondition', {
        doType: 'query',
        needId: 'Y'
    });
    KillTmpGloal();
    $('#gridLabel').datagrid('query', {
        InputStr: valsStr,
        Pid: ''
    });
}

/**
 *
 * @param {String} type 操作类型(REC,REF)
 */
function SaveHandler() {
    var chkDatas = $('#gridLabel').datagrid('getChecked');
    if (chkDatas == '') {
        PHA.Popover({
            msg: '请先选择记录',
            type: 'alert'
        });
        return;
    }
    var conInfo = '打印';
    if (LABEL_PARAMS.NEED30USER == 'Y') {
        $('#pogUser30').combobox('reset');
        $('#diagUser').dialog('open'); // 保存事件在csp
        $('#diagUser').find('.dialog-button').css('padding-top', '0px');
    } else {
        PHA.Confirm('操作提示', '您确认打印吗?', ToSave); // @translate
    }
}
function ToSave(winFlag) {
    var pogUser30 = '';
    if (winFlag == 'Y') {
        pogUser30 = $('#pogUser30').combobox('getValue');
        if (pogUser30 == '') {
            PHA.Popover({
                msg: '请先选择排药人', // @translate
                type: 'alert'
            });
            return;
        } else {
            $('#diagUser').window('close');
        }
    }
    var mDspIdStr = GetCheckMDspStr();
    var saveOpt = {
        mDspIdStr: mDspIdStr,
        pogUser30: pogUser30
    };
    Save(saveOpt);
}

function Save(saveOpt, autoFlag) {
    autoFlag = autoFlag || '';
    PHA.Loading('Show');
    $.cm(
        {
            ClassName: 'PHA.OPIVAS.COM.Save',
            MethodName: 'ExecuteMulti',
            MDspIdStr: saveOpt.mDspIdStr,
            LogonStr: PHA_COM.Session.ALL,
            PSNumber: '10',
            POGSUserStr: saveOpt.pogUser30,
            dataType: 'text'
        },
        function (saveRet) {
            PHA.Loading('Hide');
            var saveArr = saveRet.split('^');
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            var saveNo = saveArr[2] || '';
            if (saveVal < 0) {
                if (autoFlag == '') {
                    PHA.Alert('提示', $got(saveInfo), 'warning');
                }
            } else {
                PHA.Popover({
                    msg: $got(saveNo),
                    type: 'success'
                });
            }
            if (autoFlag == '') {
                PIVASPRINT.CallBack = Query;
            }
            // 根据界面的打印就行了
            var pogIdStr = $.cm(
                {
                    ClassName: 'PHA.PIVAS.PRT.Label',
                    MethodName: 'GetPOGIdStrByPOGSNo',
                    POGSNo: saveNo,
                    dataType: 'text'
                },
                false
            );
            if (pogIdStr != '') {
                PIVASPRINT.LabelsJsonByPogStr({
                    pogStr: pogIdStr,
                    rePrintFlag: 'N'
                });
            }
            // PIVASPRINT.LabelsJsonByPogsNo({
            // 	pogsNo: saveNo,
            // 	sortWay: ""
            // });

            if (autoFlag == '') {
                // 同时处理排药单数据
                SaveArrange(saveOpt);
            }
        }
    );
}
/**
 * 打印排药单并执行
 */
function SaveArrange(saveOpt) {
    // LABEL_PARAMS.PRTWITH30="Y"
    if (LABEL_PARAMS.PRTWITHPS30 == 'Y') {
        var logonStr = PHA_COM.Session.ALL;
        if (saveOpt.pogUser30 != '') {
            var logonArr = logonStr.split('^');
            logonArr[0] = saveOpt.pogUser30;
            logonStr = logonArr.join('^');
        }
        PHA.Loading('Show');
        var saveRet = $.cm(
            {
                ClassName: 'PHA.OPIVAS.COM.Save',
                MethodName: 'ExecuteMulti',
                MDspIdStr: saveOpt.mDspIdStr,
                LogonStr: logonStr,
                PSNumber: '30',
                dataType: 'text'
            },
            false
        );
        PHA.Loading('Hide');
        var saveArr = saveRet.split('^');
        var saveVal = saveArr[0];
        var saveInfo = saveArr[1];
        var saveNo = saveArr[2] || '';
        if (saveVal < 0) {
            PHA.Alert('提示', $got(saveInfo), 'warning');
        } else {
            PHA.Popover({
                msg: saveNo,
                type: 'success'
            });
        }
        PIVASPRINT.Arrange(saveNo, '', '');
    }
}
/**
 *  清屏
 */
function Clean() {
    PHA.DomData('#qCondition', {
        doType: 'clear'
    });
    KillTmpGloal();
    $('#gridLabel').datagrid('clear');
    PHA.SetVals(LABEL_DEFAULT);
}

function KillTmpGloal() {
    PHA_OPIVAS_COM.Kill('gridLabel', 'PHA.OPIVAS.Label.Query', 'KillLabel');
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
            ClassName: 'PHA.OPIVAS.Label.Query',
            MethodName: 'CheckRows',
            MDspIdStr: mDspIdStr,
            Flag: flag,
            Pid: $('#gridLabel').datagrid('options').queryParams.Pid || '',
            All: all || '',
            dataType: 'text'
        },
        false
    );
    if (all == 'Y') {
        $('#gridLabel').datagrid('reload');
    }
}

function GetCheckMDspStr(allFlag) {
    var mDspIdStr = $.cm(
        {
            ClassName: 'PHA.OPIVAS.Label.Query',
            MethodName: 'GetCheckMDspStr',
            Pid: $('#gridLabel').datagrid('options').queryParams.Pid || '',
            All: allFlag || '',
            dataType: 'text'
        },
        false
    );
    return mDspIdStr;
}

function AutoPrint() {
    if ($('#chkAutoPrint').checkbox('getValue') == true) {
        // 如果自动打签,那么应该是连续的过程
        // 及时遇到界面存在库存不足记录,也应该继续打印
        var mDspIdStr = GetCheckMDspStr('ALL');
        var saveOpt = {
            mDspIdStr: mDspIdStr
        };
        Save(saveOpt, 'AutoPrint');
    }
}
window.onbeforeunload = function () {
    KillTmpGloal();
};
