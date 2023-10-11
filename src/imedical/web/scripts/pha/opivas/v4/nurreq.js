/**
 * ����:	 ҩ������-ϵͳ����-������־��ѯ
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-15~
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
        clearInterval(NURREQ_INTERVAL); // ˵��׼��������᲻���ظ���ʱ��,������,����
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
                title: '���̺�',
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
                title: '����',
                width: 75,
                styler: PHA_OPIVAS_COM.Grid.Styler.Warn
            },
            {
                field: 'disOpStatusDesc',
                title: '����״̬',
                width: 75,
                align: 'center'
            },
            {
                field: 'packFlag',
                title: '���',
                width: 45,
                align: 'center',
                formatter: PHA_OPIVAS_COM.Grid.Formatter.YesNo,
                styler: PHA_OPIVAS_COM.Grid.Styler.Pack
            },
            {
                field: 'doseDateTime',
                title: '��ҩʱ��',
                width: 100
            },
            {
                field: 'patNo',
                title: '�ǼǺ�',
                width: 100,
                formatter: function (value, row, index) {
                    return PHA_OPIVAS_COM.Grid.Formatter.AdmDetail(value, row, index, 'oeori');
                }
            },
            {
                field: 'patName',
                title: '����',
                width: 100
            },
            {
                field: 'patSex',
                title: '�Ա�',
                width: 45,
                align: 'center'
            },
            {
                field: 'patAge',
                title: '����'
            },
            {
                field: 'oeoriSign',
                title: '��',
                width: 30,
                formatter: PHA_OPIVAS_COM.Grid.Formatter.OeoriSign
            },
            {
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 250
            },
            {
                field: 'dosage',
                title: '����'
            },
            {
                field: 'instrucDesc',
                title: '�÷�',
                width: 75
            },
            {
                field: 'freqDesc',
                title: 'Ƶ��'
            },
            {
                field: 'duraDesc',
                title: '�Ƴ�',
                width: 75
            },
            {
                field: 'oeoriRemark',
                title: 'ҽ����ע',
                width: 100
            },
            {
                field: 'ivgttSpeed',
                title: '����',
                width: 80
            },
            {
                field: 'docLocDesc',
                title: 'ҽ������',
                width: 100
            },
            {
                field: 'docName',
                title: 'ҽ��',
                width: 100
            },
            {
                field: 'exceedReason',
                title: '�Ƴ̳���ԭ��',
                width: 125
            },
            {
                field: 'prescNo',
                title: '������',
                width: 125
            },
            {
                field: 'disUserName',
                title: '������',
                width: 80
            },
            {
                field: 'disDateTime',
                title: '����ʱ��',
                width: 95
            },
            {
                field: 'disCUserName',
                title: 'ȡ����',
                width: 80
            },
            {
                field: 'disCDateTime',
                title: 'ȡ��ʱ��',
                width: 95
            },
            {
                field: 'disOpUserName',
                title: '���ղ�����',
                width: 95
            },
            {
                field: 'disOpDateTime',
                title: '���ղ���ʱ��',
                width: 100
            },
            {
                field: 'oeoriStatus',
                title: 'ҽ��״̬',
                width: 70,
                align: 'center'
            },
            {
                field: 'oeoreStatus',
                title: 'ִ�м�¼״̬',
                width: 100
            },
            {
                field: 'disRefRemark',
                title: '�ܾ�����ԭ��',
                width: 200
            },
            {
                field: 'oeori',
                title: 'ҽ��ID',
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
 * @param {String} type ��������(REQ,PACK,CANCEL)
 */
function SaveReqHandler(type) {
    var chkDatas = $('#gridNurReq').datagrid('getChecked');
    if (chkDatas == '') {
        PHA.Popover({
            msg: '����ѡ���¼', // @translate
            type: 'alert'
        });
        return;
    }
    var conInfo = '';
    if (type == 'REQ') {
        conInfo = '��ȷ��������Һ��?'; // @translate
    } else if (type == 'PACK') {
        conInfo = '��ȷ����������?'; // @translate
    } else if (type == 'CANCEL') {
        conInfo = '��ȷ��ȡ��������?'; // @translate
    }
    PHA.Confirm('������ʾ', conInfo, function () {
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
                    '��ʾ',
                    '���ھܾ����ռ�¼,����Ҫ¼���ٴ�����ԭ��', // @translate
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
                PHA.Alert('��ʾ', $got(saveInfo), 'warning');
            } else {
                PHA.Popover({
                    msg: '����ɹ�', // @translate
                    type: 'success'
                });
            }
            Query();
        }
    );
}
/**
 *  ����
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
            msg: '����ѡ���¼', // @translate
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
//����
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

