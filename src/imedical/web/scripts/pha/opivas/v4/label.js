/**
 * ����:	 ������Һϵͳ-��Һ��ǩ
 * ��д��:	 yunhaibao
 * ��д����: 2019-06-25
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
// ��ʱ��ʱ����
var LABEL_INTERVAL_TIME = 30000;
// ��ӡ���������true,false
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
        title: isTabMenu !== true ? '��Һ��ǩ' : '',
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
                title: '���̺�',
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
                title: '����',
                width: 75,
                styler: PHA_OPIVAS_COM.Grid.Styler.Warn
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
                field: 'oeoriStatus',
                title: 'ҽ��״̬',
                width: 70,
                align: 'center'
            },
            {
                field: 'oeoreStatus',
                title: 'ִ�м�¼״̬',
                width: 100,
                hidden: true
            },
            {
                field: 'oeori',
                title: 'ҽ��ID',
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
                    // ѡ��
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
            $.messager.alert('��ʾ', resText, 'error');
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
 * @param {String} type ��������(REC,REF)
 */
function SaveHandler() {
    var chkDatas = $('#gridLabel').datagrid('getChecked');
    if (chkDatas == '') {
        PHA.Popover({
            msg: '����ѡ���¼',
            type: 'alert'
        });
        return;
    }
    var conInfo = '��ӡ';
    if (LABEL_PARAMS.NEED30USER == 'Y') {
        $('#pogUser30').combobox('reset');
        $('#diagUser').dialog('open'); // �����¼���csp
        $('#diagUser').find('.dialog-button').css('padding-top', '0px');
    } else {
        PHA.Confirm('������ʾ', '��ȷ�ϴ�ӡ��?', ToSave); // @translate
    }
}
function ToSave(winFlag) {
    var pogUser30 = '';
    if (winFlag == 'Y') {
        pogUser30 = $('#pogUser30').combobox('getValue');
        if (pogUser30 == '') {
            PHA.Popover({
                msg: '����ѡ����ҩ��', // @translate
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
                    PHA.Alert('��ʾ', $got(saveInfo), 'warning');
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
            // ���ݽ���Ĵ�ӡ������
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
                // ͬʱ������ҩ������
                SaveArrange(saveOpt);
            }
        }
    );
}
/**
 * ��ӡ��ҩ����ִ��
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
            PHA.Alert('��ʾ', $got(saveInfo), 'warning');
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
 *  ����
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
        // ����Զ���ǩ,��ôӦ���������Ĺ���
        // ��ʱ����������ڿ�治���¼,ҲӦ�ü�����ӡ
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
