/**
 * ����:	 ������Һϵͳ-��Һ״ִ̬��
 * ��д��:	 yunhaibao
 * ��д����: 2019-06-26
 */
PHA_COM.App.Csp = 'pha.opivas.v4.exe.csp';
// ��̬��Ϣ
var EXE_INTERVAL;
var EXE_IFPIVAS = tkMakeServerCall('PHA.OPIVAS.COM.Method', 'IsPIVASLoc', session['LOGON.CTLOCID']); // ��ʱ��ʱ����
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
        title: isTabMenu !== true ? '��Һ״ִ̬��' : '',
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
        // 		msg: 'ִ��״̬��Ϊ��ҩ���޷���ӡ��ҩ��',
        // 		type: 'alert'
        // 	});
        // 	return;
        // }
        var geneNo = $('#geneNo').val().trim();
        if (geneNo == '') {
            PHA.Popover({
                msg: '����Ϊ��,�޷���ӡ', // @translate
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
                width: 100
            },
            {
                field: 'barCode',
                title: '����',
                width: 100
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
            msg: '����ѡ��ִ��״̬', // @translate
            type: 'alert'
        });
        return;
    }
    var valsStr = PHA_OPIVAS_COM.DomData('#qCondition', {
        doType: 'query',
        needId: 'Y'
    });
    var tabTitle = 'ҽ����ϸ'; // $('#tabsExecute').tabs('getSelected').panel('options').title;
    if (tabTitle == 'ҽ����ϸ') {
        KillTmpGloal();
        $('#gridExe').datagrid('query', {
            InputStr: valsStr,
            Pid: ''
        });
    } else if (tabTitle == 'ɨ��ִ��') {
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
            msg: '����ѡ���¼', // @translate
            type: 'alert'
        });
        return;
    }
    var conPSText = $('#conPS').combobox('getText');
    var conInfo = $g('��ȷ�ϲ���{{status}}��?').replace(/{{status}}/g, conPSText); // @translate
    PHA.Confirm('������ʾ', $got(conInfo), function () {
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
                PHA.Alert('��ʾ', saveInfo, 'warning');
            } else {
                PHA.Popover({
                    msg: saveNo,
                    type: 'success',
                    timeout: 1500
                });
            }
            if (PSNumber == 30) {
                PHA.Confirm(
                    '������ʾ',
                    '�Ƿ��ӡ��ҩ��?', // @translate
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
 *  ����
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
            msg: '����ѡ����Ҫִ�е���Һ״̬', // @translate
            type: 'info'
        });
        return;
    }
    var pivaLocId = $('#conPivasLoc').combobox('getValue');
    if (pivaLocId == '') {
        PHA.Popover({
            msg: '����ѡ����Һ����', // @translate
            type: 'info'
        });
        return;
    }
    $.messager.confirm('��ʾ', '��ȷ������ <b>' + $('#conPS').combobox('getText') + ' </b>������?', function (r) {
        if (r) {
            var geneNoRet = tkMakeServerCall('PHA.OPIVAS.COM.Method', 'GetAppNo', psNumber, pivaLocId);
            var geneNoArr = geneNoRet.split('^');
            var geneNo = geneNoArr[0];
            if (geneNo == '-1') {
                $.messager.alert('��ʾ', $got(geneNoArr[0]), 'error');
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
            msg: '����ѡ��ִ��״̬', // @translate
            type: 'alert'
        });
        $('#barCode').val('').focus();
        return;
    }
    var pogsNo = $('#geneNo').val();
    var pivaLocId = $('#conPivasLoc').combobox('getValue');
    if (pivaLocId == '') {
        PHA.Popover({
            msg: '����ѡ����Һ����', // @translate
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

