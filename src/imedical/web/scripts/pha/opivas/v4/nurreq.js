/**
 * 名称:	 药房公共-系统管理-错误日志查询
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-15~
 */
PHA_COM.App.Csp = 'pha.opivas.v4.nurreq.csp';

var NURREQ = {
    Default: [
        {
            conStDate: 't',
            conEdDate: 't',
            conPack: {
                RowId: '',
                Select: false
            },
            conOpStatus: {
                RowId: '',
                Select: false
            }
        }
    ],
    IntervelTime: 30000
};
var NURREQ_INTERVAL_TIME = NURREQ.IntervelTime;
var NURREQ_DEFAULT = NURREQ.Default;
var NURREQ_INTERVAL;
$(function () {
    InitDict();
    InitGridNurReq();
    $('#btnFind').on('click', Query);
    $('#btnClean').on('click', Clean);
    $('#btnStart').on('click', function () {
        PHA_OPIVAS_UX.AutoGif('Show');
        clearInterval(NURREQ_INTERVAL); // 说不准连续点击会不会重复计时器,不测了,清了
        NURREQ_INTERVAL = setInterval(function () {
            var rows = $('#gridNurReq').datagrid('getRows');
            if (rows.length == 0) {
                Query();
            }
        }, NURREQ_INTERVAL_TIME);
    });
    $('#btnStop').on('click', function () {
        PHA_OPIVAS_UX.AutoGif('Hide');
        clearInterval(NURREQ_INTERVAL);
    });
    $('#btnReqPivas').on('click', function () {
        SaveReqHandler('REQ');
    });
    $('#btnReqPack').on('click', function () {
        SaveReqHandler('PACK');
    });
    $('#btnCancel').on('click', function () {
        SaveReqHandler('CANCEL');
    });
    $('#btnRecord').on('click', ShowAuditRecord);

    $('#conCardNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var cardNo = $.trim($('#conCardNo').val());
            if (cardNo !== '') {
                ReadCardHandler();
            }
        }
    });

    $('#btnReadCard').on('click', ReadCardHandler);
    PHA.SetVals(NURREQ_DEFAULT);
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

    PHA.ComboBox('conPack', {
        editable: false,
        url: PHA_OPIVAS_STORE.PIVADISPackFlag().url,
        panelHeight: 'auto',
        onSelect: function () {
            Query();
        }
    });
    PHA.ComboBox('conOpStatus', {
        editable: false,
        url: PHA_OPIVAS_STORE.PIVADISOpStatus().url,
        panelHeight: 'auto',
        onSelect: function () {
            Query();
        }
    });
    PHA_OPIVAS_COM.Bind.KeyDown.PatNo('conPatNo', Query);
}

function InitGridNurReq() {
    var columns = [
        [
            {
                field: 'pid',
                title: '进程号',
                width: 75,
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
                field: 'disOpStatusDesc',
                title: '申请状态',
                width: 75,
                align: 'center'
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
                field: 'disUserName',
                title: '申请人',
                width: 80
            },
            {
                field: 'disDateTime',
                title: '申请时间',
                width: 95
            },
            {
                field: 'disCUserName',
                title: '取消人',
                width: 80
            },
            {
                field: 'disCDateTime',
                title: '取消时间',
                width: 95
            },
            {
                field: 'disOpUserName',
                title: '接收操作人',
                width: 95
            },
            {
                field: 'disOpDateTime',
                title: '接收操作时间',
                width: 100
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
                field: 'disRefRemark',
                title: '拒绝接收原因',
                width: 200
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
            ClassName: 'PHA.OPIVAS.NurReq.Query',
            QueryName: 'NurReq',
            GrpField: 'mDspId'
        },
        pagination: true,
        pageSize: 100,
        columns: columns,
        nowrap: true,
        singleSelect: false,
        striped: false,
        toolbar: '#gridNurReqBar',
        onCheck: function (rowIndex, rowData) {
            PHA_OPIVAS_COM.Grid.LinkCheck.Do({
                CurRowIndex: rowIndex,
                GridId: 'gridNurReq',
                Field: 'mDspId',
                Check: true,
                Value: rowData.mDspId
            });
        },
        onUncheck: function (rowIndex, rowData) {
            PHA_OPIVAS_COM.Grid.LinkCheck.Do({
                CurRowIndex: rowIndex,
                GridId: 'gridNurReq',
                Field: 'mDspId',
                Check: false,
                Value: rowData.mDspId
            });
        },
        onLoadSuccess: function (data) {
            var row0Data = data.rows[0];
            if (row0Data) {
                $(this).datagrid('options').queryParams.Pid = row0Data.pid;
            }
            $('#gridNurReq').datagrid('uncheckAll');
        },
        rowStyler: function (index, rowData) {
            return PHA_OPIVAS_COM.Grid.RowStyler.Person(index, rowData, 'patNo');
        }
    };
    PHA.Grid('gridNurReq', dataGridOption);
}

/*****************************************************************/
function Query() {
    var valsStr = PHA_OPIVAS_COM.DomData('#qCondition', {
        doType: 'query',
        needId: 'Y'
    });
    KillTmpGloal();
    $('#gridNurReq').datagrid('query', {
        InputStr: valsStr,
        Pid: ''
    });
}
/**
 *
 * @param {String} type 操作类型(REQ,PACK,CANCEL)
 */
function SaveReqHandler(type) {
    var chkDatas = $('#gridNurReq').datagrid('getChecked');
    if (chkDatas == '') {
        PHA.Popover({
            msg: '请先选择记录', // @translate
            type: 'alert'
        });
        return;
    }
    var conInfo = '';
    if (type == 'REQ') {
        conInfo = '您确认申请配液吗?'; // @translate
    } else if (type == 'PACK') {
        conInfo = '您确认申请打包吗?'; // @translate
    } else if (type == 'CANCEL') {
        conInfo = '您确认取消申请吗?'; // @translate
    }
    PHA.Confirm('操作提示', conInfo, function () {
        var hasRefuseArr = [];
        var mDspIdArr = [];
        var dataLen = chkDatas.length;
        for (var i = 0; i < dataLen; i++) {
            var rowData = chkDatas[i];
            var mDspId = rowData.mDspId;
            if (mDspIdArr.indexOf(mDspId) >= 0) {
                continue;
            }
            mDspIdArr.push(mDspId);
            if (rowData.disRefRemark != '') {
                hasRefuseArr.push(mDspId);
            }
        }
        var hasRefLen = hasRefuseArr.length;
        var mDspLen = mDspIdArr.length;
        var mDspIdStr = mDspIdArr.join('^');
        var saveOpt = {
            mDspIdStr: mDspIdStr,
            type: type,
            remark: '',
            conInfo: conInfo
        };
        if (hasRefLen == 0 || type == 'CANCEL') {
            Save(saveOpt);
        } else {
            if (hasRefLen == mDspLen) {
                PHA_OPIVAS_UX.DisRemark(saveOpt, Save);
            } else {
                PHA.Alert(
                    '提示',
                    '存在拒绝接收记录,您需要录入再次申请原因', // @translate
                    'info',
                    function () {
                        PHA_OPIVAS_UX.DisRemark(saveOpt, Save);
                    }
                );
            }
        }
    });
}

function Save(saveOpt) {
    PHA.Loading('Show');
    $.cm(
        {
            ClassName: 'PHA.OPIVAS.NurReq.Save',
            MethodName: 'SaveMulti',
            MDspIdStr: saveOpt.mDspIdStr,
            Type: saveOpt.type,
            LogonStr: PHA_COM.Session.ALL,
            Remark: saveOpt.remark,
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
    $('#gridNurReq').datagrid('clear');
    PHA.SetVals(NURREQ_DEFAULT);
}

function ShowAuditRecord() {
    var gridSelect = $('#gridNurReq').datagrid('getSelected');
    if (gridSelect == null) {
        PHA.Popover({
            msg: '请先选择记录', // @translate
            type: 'alert'
        });
    }
    PHA_OPIVAS_UX.AuditRecord('', gridSelect.mDspId);
}

function KillTmpGloal() {
    PHA_OPIVAS_COM.Kill('gridNurReq', 'PHA.OPIVAS.NurReq.Query', 'KillNurReq');
}
window.onbeforeunload = function () {
    KillTmpGloal();
};
//读卡
function ReadCardHandler() {
    PHA_COM.ReadCard(
        {
            CardTypeId: '',
            CardNoId: 'conCardNo',
            PatNoId: 'conPatNo'
        },
        Query
    );
}

