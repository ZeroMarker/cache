/**
 * ģ��:     ��Һҽ����ѯ
 * ��д����: 2018-03-01
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionWard = session['LOGON.WARDID'] || '';
$(function () {
    PIVAS.VAR.MaxDrugCnt = 9999;
    InitDict();
    InitGridPat();
    InitGridOrdExe();
    $('#btnFind').bind('click', Query);
    $('#btnClear').bind('click', Clear);
    $('#txtPatNo').bind('keypress', function (event) {
        if (event.keyCode == '13') {
            var patNo = $('#txtPatNo').val();
            if (patNo == '') {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
            Query();
        }
    });
    $('.dhcpha-win-mask').remove();
});

function InitDict() {
    // ����
    PIVAS.Date.Init({ Id: 'dateOrdStart', LocId: '', Type: 'Start', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'dateOrdEnd', LocId: '', Type: 'End', QueryType: 'Query' });
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivasLoc', Type: 'PivaLoc' },
        {
            placeholder: $g('��Һ����') + '...',
            editable: false,
            onLoadSuccess: function () {
                var datas = $('#cmbPivasLoc').combobox('getData');
                if (datas.length == 1) {
                    $('#cmbPivasLoc').combobox('select', datas[0].RowId);
                } else {
                    for (var i = 0; i < datas.length; i++) {
                        if (datas[i].RowId == SessionLoc) {
                            $('#cmbPivasLoc').combobox('setValue', datas[i].RowId);
                            break;
                        }
                    }
                }
            }
        }
    );
    // ����
    PIVAS.ComboBox.Init(
        { Id: 'cmbWard', Type: 'Ward' },
        {
            placeholder: $g('����') + '...',
            readonly: SessionWard != '' ? true : false,
            onLoadSuccess: function () {
                if (SessionWard != '') {
                    $('#cmbWard').combobox('setValue', SessionWard);
                }
            }
        }
    );
}

// ҽ����ϸ�б�
function InitGridOrdExe() {
    var columns = [
        [
            {
                field: 'psDesc',
                title: '��Һ״̬',
                width: 75,
                styler: PIVAS.Grid.Styler.PivaState
            },
            {
                field: 'passResultDesc',
                title: '������',
                width: 85,
                styler: function (value, row, index) {
                    if (value.indexOf('ͨ��') >= 0) {
                        return { class: 'pha-pivas-state-pass' };
                    }
                    if (value.indexOf('�ܾ�') >= 0) {
                        return { class: 'pha-pivas-state-refuse' };
                    }
                    if (value.indexOf('����') >= 0) {
                        return { class: 'pha-pivas-state-appleal' };
                    }
                }
            },
            {
                field: 'doseDateTime',
                title: '��ҩ����',
                width: 100
            },
            {
                field: 'batNo',
                title: '����',
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
                field: 'drugsArr',
                title: 'ҩƷ��Ϣ',
                width: 300,
                formatter: PIVAS.Grid.Formatter.InciGroup
            },
            {
                field: 'dosage',
                title: '����',
                width: 75,
                align: 'right',
                formatter: PIVAS.Grid.Formatter.DosageGroup
            },
            {
                field: 'qtyUom',
                title: '����',
                width: 50,
                align: 'right',
                formatter: PIVAS.Grid.Formatter.QtyUomGroup
            },
            {
                field: 'ordRemark',
                title: '��ע',
                width: 75,
                formatter: PIVAS.Grid.Formatter.OrdRemarkGroup
            },
            {
                field: 'freqDesc',
                title: 'Ƶ��',
                width: 75
            },
            {
                field: 'instrucDesc',
                title: '�÷�',
                width: 80
            },

            {
                field: 'priDesc',
                title: '���ȼ�',
                width: 75
            },
            {
                field: 'barCode',
                title: '����',
                width: 150,
                formatter: function (value, row, index) {
                    var field = 'barCode';
                    return '<a class="pha-grid-a" onclick="PIVASTIMELINE.Init({Params:\'' + value + "',Field:'" + field + "',ClickField:'" + field + '\'} )">' + value + '</a>';
                }
            },
            { field: 'docName', title: 'ҽ��', width: 80, hidden: true },
            { field: 'oeoriStatDesc', title: 'ҽ��״̬', width: 100 },
            { field: 'oeoreStatDesc', title: 'ִ�м�¼״̬', width: 100 },
            { field: 'mOeore', title: 'mOeore', width: 100, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: '',
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.OeQuery',
            QueryName: 'OrdExeData'
        },
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 1000,
        pageList: [1000],
        pagination: true,
        toolbar: [],
        onClickCell: function (rowIndex, field, value) {
            if (field !== 'barCode') {
                if ($('#TimeLineWin')) {
                    $('#TimeLineWin').window('close');
                }
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridOrdExe', dataGridOption);
}

// �����б�
function InitGridPat() {
    var columns = [
        [
            { field: 'pat', title: 'pat', width: 80, halign: 'center', hidden: true },
            { field: 'bedNo', title: '����', width: 75 },
            { field: 'patName', title: '����', width: 80 },
            { field: 'patNo', title: '�ǼǺ�', width: 100 },
            { field: 'patSex', title: '�Ա�', width: 60 },
            { field: 'patAge', title: '����', width: 75 },
            { field: 'wardDesc', title: '����', width: 200 }
        ]
    ];

    var dataGridOption = {
        url: '',
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.OeQuery',
            QueryName: 'PatData'
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        toolbar: [],
        onSelect: function (rowIndex, rowData) {
            var pJson = QueryParams();
            pJson.patNo = rowData.patNo;
            $('#gridOrdExe').datagrid('options').url = $URL;
            $('#gridOrdExe').datagrid('query', {
                pJsonStr: JSON.stringify(pJson),
                rows: 9999
            });
        },
        onLoadSuccess: function (data) {
            $('#gridOrdExe').datagrid('clear');
            if (data.rows.length == 1) {
                $('#gridPat').datagrid('selectRow', 0);
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridPat', dataGridOption);
}

function Query() {
    var pJson = QueryParams();
    $('#gridPat').datagrid('options').url = $URL;
    $('#gridPat').datagrid('query', {
        pJsonStr: JSON.stringify(pJson),
        rows: 9999
    });
}
//���
function Clear() {
    InitDict();
    $('#txtPatNo').val('');
    $('#gridPat').datagrid('clear');
    $('#gridOrdExe').datagrid('clear');
}

function QueryParams() {
    return {
        startDate: $('#dateOrdStart').datebox('getValue'),
        endDate: $('#dateOrdEnd').datebox('getValue'),
        startTime: $('#timeOrdStart').timespinner('getValue'),
        endTime: $('#timeOrdEnd').timespinner('getValue'),
        patNo: $('#txtPatNo').val(),
        loc: $('#cmbPivasLoc').combobox('getValue'),
        ward: $('#cmbWard').combobox('getValue')
    };
}
