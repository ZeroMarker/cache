/**
 * 名称:   门诊配液系统-配伍审核
 * 编写人:  yunhaibao
 * 编写日期: 2019-06-20
 */
PHA_COM.App.Csp = 'pha.opivas.v4.oeaudit.csp';
var OEAUDIT_INTERVAL;
// 定时器时间间隔
var OEAUDIT_INTERVAL_TIME = 30000;
var OEAUDIT_DEFAULT = [
    {
        conStDate: 't',
        conEdDate: 't',
        conAuditStatus: 'YSSS,WSH'
    }
];
var FormulaId = '';
var OEAUDIT_ADMID = '';
var PIVASWAYCODE = tkMakeServerCall('web.DHCSTPIVAS.Common', 'PivasWayCode');
$(function () {
    var isTabMenu = PHA_COM.IsTabsMenu ? PHA_COM.IsTabsMenu() : false;
    $('#panelOeAudit').panel({
        title: isTabMenu !== true ? '配伍审核' : '',
        headerCls: 'panel-header-gray',
        iconCls: 'icon-pivas-oeaudit',
        bodyCls: 'panel-body-gray',
        fit: true
    });

    InitDict();
    InitGridOeAudit();
    InitTreeGridReason();
    InitTabEMRView();
    $('#btnFind').on('click', Query);
    $('#btnClean').on('click', Clean);
    $('#btnStart').on('click', function () {
        PHA_OPIVAS_UX.AutoGif('Show');
        clearInterval(OEAUDIT_INTERVAL); // 说不准连续点击会不会重复计时器,不测了,清了
        OEAUDIT_INTERVAL = setInterval(function () {
            var rows = $('#gridOeAudit').datagrid('getRows');
            if (rows.length == 0) {
                Query();
            }
        }, OEAUDIT_INTERVAL_TIME);
    });
    $('#btnStop').on('click', function () {
        PHA_OPIVAS_UX.AutoGif('Hide');
        clearInterval(OEAUDIT_INTERVAL);
    });
    $('#btnPass').on('click', function () {
        SaveHandler('SHTG');
    });
    $('#btnRefuse').on('click', function () {
        SaveHandler('SHJJ');
    });
    $('#btnCancel').on('click', function () {
        SaveHandler('CANCEL');
    });
    $('#btnRecord').on('click', ShowAuditRecord);
    $('#btnViewEMR').on('click', ShowEMRView);
    PHA_OPIVAS_COM.Bind.KeyDown.PatNo('conPatNo', Query);
    PHA.SetVals(OEAUDIT_DEFAULT);
    setTimeout(function () {
        Query();
    }, 500);
    InitPivasSettings();
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
    PHA.ComboBox('conAuditStatus', {
        editable: false,
        url: PHA_OPIVAS_STORE.OeAuditStatus().url,
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

function InitGridOeAudit() {
    var columns = [
        [
            {
                field: 'pid',
                title: '进程号',
                width: 75,
                hidden: true
            },
            {
                field: 'phaOrdId',
                title: 'phaOrdId',
                width: 75,
                hidden: true
            },
            {
                field: 'admId',
                title: '就诊Id',
                width: 75,
                hidden: true
            },
            {
                field: 'mOeori',
                title: 'mOeori',
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
                field: 'auditStatusDesc',
                title: '审核状态',
                width: 75,
                align: 'center',
                styler: PHA_OPIVAS_COM.Grid.Styler.PassStatus
            },
            {
                field: 'oeoriDateTime',
                title: '医嘱时间',
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
                title: '年龄　'
            },
            {
                field: 'pivaCatDesc',
                title: '类型',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    return '<a class="pha-grid-a">' + value + '</a>';
                }
            },
            {
                field: 'oeoriSign',
                title: '组',
                width: 30,
                formatter: PHA_OPIVAS_COM.Grid.Formatter.OeoriSign
            },
            {
                field: 'oeoriDesc',
                title: '医嘱名称',
                width: 250
            },
            {
                field: 'dosage',
                title: '剂量　　'
            },
            {
                field: 'instrucDesc',
                title: '用法',
                width: 75
            },
            {
                field: 'freqDesc',
                title: '频次　　'
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
                field: 'oeori',
                title: '医嘱ID',
                width: 100,
                formatter: function (value, row, index) {
                    return PHA_OPIVAS_COM.Grid.Formatter.OrderDetail(value, row, index, 'oeori');
                }
            }
        ]
    ];
    var dataGridOption = {
        exportXls: false,
        url: 'pha.opivas.v4.broker.csp',
        queryParams: {
            ClassName: 'PHA.OPIVAS.OeAudit.Query',
            QueryName: 'OeAudit',
            GrpField: 'mOeori',
            LogonStr: PHA_COM.Session.ALL
        },
        pagination: true,
        columns: columns,
        nowrap: true,
        singleSelect: false,
        toolbar: '#gridOeAuditBar',
        onCheck: function (rowIndex, rowData) {
            PHA_OPIVAS_COM.Grid.LinkCheck.Do({
                CurRowIndex: rowIndex,
                GridId: 'gridOeAudit',
                Field: 'mOeori',
                Check: true,
                Value: rowData.mOeori
            });
        },
        onUncheck: function (rowIndex, rowData) {
            PHA_OPIVAS_COM.Grid.LinkCheck.Do({
                CurRowIndex: rowIndex,
                GridId: 'gridOeAudit',
                Field: 'mOeori',
                Check: false,
                Value: rowData.mOeori
            });
        },
        onLoadSuccess: function (data) {
            var row0Data = data.rows[0];
            if (row0Data) {
                $(this).datagrid('options').queryParams.Pid = row0Data.pid;
            }
            $('#gridOeAudit').datagrid('uncheckAll');
        },
        rowStyler: function (index, rowData) {
            return PHA_OPIVAS_COM.Grid.RowStyler.Person(index, rowData, 'patNo');
        },
        onClickCell: function (rowIndex, field, value) {
            if (field == 'pivaCatDesc') {
                if (FormulaId != '') {
                    var mOeori = $(this).datagrid('getRows')[rowIndex].mOeori;
                    PIVASPASSTPN.Init({
                        Params: mOeori + '^' + FormulaId,
                        Field: 'pivaCatDesc',
                        ClickField: field
                    });
                } else {
                    $.messager.alert('提示', $g('获取不到审核指标公式') + '</br>' + $g('请于审核指标公式查看是否维护公式') + '</br>' + $g('请于参数设置查看是否维护需要使用的指标公式'), 'warning');
                }
            }
        },
        onLoadError: function (response) {
            clearInterval(OEAUDIT_INTERVAL);
            if (response.statusText == 'abort') {
                return;
            }
            var resText = response.responseText;
            $.messager.alert('提示', resText, 'error');
        }
    };
    PHA.Grid('gridOeAudit', dataGridOption);
}

/*****************************************************************/
function Query() {
    var valsStr = PHA_OPIVAS_COM.DomData('#qCondition', {
        doType: 'query',
        needId: 'Y'
    });
    KillTmpGloal();
    $('#gridOeAudit').datagrid('query', {
        InputStr: valsStr,
        Pid: ''
    });
}

/**
 *
 * @param {String} type 操作类型(SHTG,SGJJ,CANCELs)
 */
function SaveHandler(type) {
    var chkDatas = $('#gridOeAudit').datagrid('getChecked');
    if (chkDatas == '') {
        PHA.Popover({
            msg: '请先选择记录', // @translate
            type: 'alert'
        });
        return;
    }
    var conInfo = '';
    if (type == 'SHTG') {
        conInfo = '您确认审核通过吗?'; // @translate
    } else if (type == 'SHJJ') {
        conInfo = '您确认审核拒绝吗?'; // @translate
    } else if (type == 'CANCEL') {
        conInfo = '您确认取消审核吗?'; // @translate
    }
    PHA.Confirm('操作提示', conInfo, function () {
        var mOeoriArr = [];
        var dataLen = chkDatas.length;
        for (var i = 0; i < dataLen; i++) {
            var rowData = chkDatas[i];
            var mOeori = rowData.mOeori;
            if (mOeoriArr.indexOf(mOeori) >= 0) {
                continue;
            }
            mOeoriArr.push(mOeori);
        }
        var mOeoriStr = mOeoriArr.join('^');
        var saveOpt = {
            mOeoriStr: mOeoriStr,
            type: type,
            phNote: '',
            reasonIdStr: '',
            conInfo: conInfo
        };
        if (type == 'SHTG') {
            Save(saveOpt);
        } else if (type == 'SHJJ') {
            $('#reasonSelectDiv').window({
                title: '审核拒绝原因选择'
            });
            $('#reasonSelectDiv').dialog('open');
            $('#txtReasonNotes').val('');
            $('#treeGridReason').treegrid('clearChecked');
            $('#btnRefuseOK')
                .unbind('click')
                .on('click', function () {
                    var checkedNodes = $('#treeGridReason').treegrid('getCheckedNodes');
                    if (checkedNodes == '') {
                        PHA.Popover({
                            msg: '请选择拒绝原因', // @translate
                            type: 'info'
                        });
                        return '';
                    }
                    var reasonStr = '';
                    for (var nI = 0; nI < checkedNodes.length; nI++) {
                        var reasonId = checkedNodes[nI].reasonId;
                        if (reasonId == 0) {
                            continue;
                        }
                        // 只需叶子结点
                        if ($('#treeGridReason').treegrid('getChildren', reasonId) == '') {
                            reasonStr = reasonStr == '' ? reasonId : reasonStr + '^' + reasonId;
                        }
                    }
                    saveOpt.reasonIdStr = reasonStr;
                    saveOpt.phNote = $('#txtReasonNotes').val().trim();
                    Save(saveOpt);
                    $('#reasonSelectDiv').dialog('close');
                });
        } else if (type == 'CANCEL') {
            Save(saveOpt);
        }
    });
}

function Save(saveOpt) {
    PHA.Loading('Show');
    $.cm(
        {
            ClassName: 'PHA.OPIVAS.OeAudit.Save',
            MethodName: 'SaveMulti',
            MOeoriStr: saveOpt.mOeoriStr,
            Type: saveOpt.type,
            LogonStr: PHA_COM.Session.ALL,
            PhNote: saveOpt.phNote,
            ReasonIdStr: saveOpt.reasonIdStr,
            dataType: 'text'
        },
        function (saveRet) {
            PHA.Loading('Hide');
            var saveArr = saveRet.split('^');
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal < 0) {
                PHA.Alert('提示', $got(saveInfo), 'warning');
            } else {
                PHA.Popover({
                    msg: '处理成功', // @translate
                    type: 'success'
                });
            }
            Query();
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
    $('#gridOeAudit').datagrid('clear');
    PHA.SetVals(OEAUDIT_DEFAULT);
}

function KillTmpGloal() {
    PHA_OPIVAS_COM.Kill('gridOeAudit', 'PHA.OPIVAS.OeAudit.Query', 'KillOeAudit');
}
window.onbeforeunload = function () {
    KillTmpGloal();
};

function InitTreeGridReason() {
    var treeColumns = [
        [
            {
                field: 'reasonId',
                title: 'reasonId',
                width: 250,
                hidden: true
            },
            {
                field: 'reasonDesc',
                title: '原因',
                width: 250
            },
            {
                field: '_parentId',
                title: 'parentId',
                hidden: true
            }
        ]
    ];
    $('#treeGridReason').treegrid({
        animate: true,
        noheader: true,
        border: false,
        fit: true,
        showHeader: false,
        checkbox: true,
        nowrap: true,
        fitColumns: true,
        singleSelect: true,
        checkOnSelect: false,
        selectOnCheck: false,
        idField: 'reasonId',
        treeField: 'reasonDesc',
        pagination: false,
        columns: treeColumns,
        url: 'DHCST.PIVAS.ACTION.csp' + '?action=JsGetAuditReason',
        queryParams: {
            params: PIVASWAYCODE + '^1',
            hosp: session['LOGON.HOSPID']
        }
    });
}

function ShowAuditRecord() {
    var msg = '';
    var gridSelect = $('#gridOeAudit').datagrid('getSelected');
    if (gridSelect == null) {
        msg = '请先选择记录';
    } else {
        msg = ValidateGridSelect();
    }
    if (msg !== '') {
        PHA.Popover({
            msg: msg,
            type: 'alert'
        });
        return;
    }
    PHA_OPIVAS_UX.AuditRecord(gridSelect.mOeori);
}

function ShowEMRView() {
    var msg = '';
    var gridSelect = $('#gridOeAudit').datagrid('getSelected');
    if (gridSelect == null) {
        msg = '请先选择记录'; // @translate
    } else {
        msg = ValidateGridSelect();
    }
    if (msg !== '') {
        PHA.Popover({
            msg: msg,
            type: 'alert'
        });
        return;
    }
    OEAUDIT_ADMID = gridSelect.admId;

    /* MaYuqiang 20220706 将患者信息传至头菜单，避免引用界面串患者 */
    var menuWin = websys_getMenuWin(); // 获得头菜单Window对象
    if (menuWin) {
        var EpisodeId = gridSelect.admId;
        var admData = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetAdmInfo', EpisodeId);
        var patId = admData.toString().split('^')[0] || '';
        var frm = dhcsys_getmenuform(); //menuWin.document.forms['fEPRMENU'];
        if (frm && frm.EpisodeID.value != EpisodeId) {
            if (menuWin.MainClearEpisodeDetails) menuWin.MainClearEpisodeDetails(); //清除头菜单上所有病人相关信息
            frm.EpisodeID.value = EpisodeId;
            frm.PatientID.value = patId;
        }
    }
    PHA_UX.EMRView(OEAUDIT_ADMID);
    return;
    // var wWidth = document.body.clientWidth * 0.9;
    // var wHeight = document.body.clientHeight * 0.9;

    $('#viewEMRDiv')
        .dialog({
            width: $('body').width() * 0.9,
            height: $('body').height() * 0.9
        })
        .dialog('open');
    $('#viewEMRDiv iframe').attr('src', '');
    $('#tabsEMR').tabs('select', '病历浏览');
    $('#ifrmEMR').attr('src', 'emr.browse.csp' + '?EpisodeID=' + OEAUDIT_ADMID);
}

function InitTabEMRView() {
    $('#tabsEMR').tabs({
        onSelect: function (title) {
            var EpisodeId = OEAUDIT_ADMID;
            var admData = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetAdmInfo', EpisodeId);
            var patId = admData.toString().split('^')[0] || '';
            if (title == '病历浏览') {
                if ($('#ifrmEMR').attr('src') == '') {
                    $('#ifrmEMR').attr('src', 'emr.browse.manage.csp' + '?EpisodeID=' + EpisodeId);
                }
            } else if (title == '过敏记录') {
                if ($('#ifrmAllergy').attr('src') == '') {
                    $('#ifrmAllergy').attr('src', 'dhcem.allergyenter.csp' + '?EpisodeID=' + EpisodeId + '&PatientID=' + patId);
                }
            } else if (title == '检查记录') {
                if ($('#ifrmRisQuery').attr('src') == '') {
                    $('#ifrmRisQuery').attr('src', 'dhcapp.inspectrs.csp' + '?EpisodeID=' + EpisodeId + '&PatientID=' + patId);
                }
            } else if (title == '检验记录') {
                if ($('#ifrmLisQuery').attr('src') == '') {
                    $('#ifrmLisQuery').attr('src', 'dhcapp.seepatlis.csp' + '?EpisodeID=' + EpisodeId + '&NoReaded=' + '1' + '&PatientID=' + patId);
                }
            } else if (title == '本次医嘱') {
                if ($('#ifrmOrdQuery').attr('src') == '') {
                    // 住院
                    //$('#ifrmOrdQuery').attr('src', 'ipdoc.patorderview.csp' + '?EpisodeID=' + EpisodeId + '&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');
                    $('#ifrmOrdQuery').attr('src', 'oeorder.opbillinfo.csp' + '?EpisodeID=' + EpisodeId);
                }
            }
        }
    });
}
function InitPivasSettings() {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'GetAppProp',
            userId: session['LOGON.USERID'],
            locId: session['LOGON.CTLOCID'],
            appCode: 'OeAudit'
        },
        function (jsonData) {
            PIVAS.VAR.PASS = jsonData.Pass;
            var FormulaDesc = jsonData.Formula;
            FormulaId = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetDIIIdByDesc', FormulaDesc);
        }
    );
}

function ValidateGridSelect() {
    var mOeoriArr = [];
    var chkDatas = $('#gridOeAudit').datagrid('getChecked');
    var dataLen = chkDatas.length;
    for (var i = 0; i < dataLen; i++) {
        var rowData = chkDatas[i];
        var mOeori = rowData.mOeori;
        if (mOeoriArr.indexOf(mOeori) >= 0) {
            continue;
        }
        mOeoriArr.push(mOeori);
        if (mOeoriArr.length > 1) {
            return $g('请只选择一条记录'); // @translate
        }
    }
    return '';
}
