/**
 * ģ��:     �ٹ�ҩƷ��Ȩ
 * ��д����: 2020-09-18
 * ��д��:   yangsj
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
var SessionGroup = session['LOGON.GROUPID'];
$(function () {
    InitGridDict();
    InitDict();
    InitGrid();
    InitBtnEvent();
    CheckTmpCycle();
});

function CheckTmpCycle() {
    var Params = '^^^' + SessionHosp;
    var TmpCycleFlag = tkMakeServerCall(
        'PHA.IN.TmpDrugPurAuth.Query',
        'CheckTmpDrugAndCycle',
        SessionHosp,
        "",
        ""
    );
    if (TmpCycleFlag != 'Y') {
        PHA.Popover({
            showType: 'show',
            msg: '�ٹ�ҩƷ�ջ�����δ����������ʹ����Ȩ����!',
            type: 'alert',
        });
        $('#btnAuth').addClass('l-btn-disabled');
        $('#btnAuth').css('pointer-events', 'none');
        $('#btnAuthMian').addClass('l-btn-disabled');
        $('#btnAuthMian').css('pointer-events', 'none');
        return;
    }
}

function InitBtnEvent() {
    $('#btnAuth').on('click', SaveAuth);
    $('#btnAuthMian').on('click', SaveAuthByMian);

    $('#btnFind').on('click', QuerygridTmpDrugMain);
    $('#btnClear').on('click', ClearDetail);
}

function ClearDetail() {
    $('#gridTmpDrugDetail').datagrid('clear');
}

function QuerygridTmpDrugMain() {
	ClearDetail();
    $('#gridTmpDrugMain').datagrid('query', {
        StDate: $('#dateStart').datebox('getValue'),
        EdDate: $('#dateEnd').datebox('getValue'),
        HospId: SessionHosp,
        AuthStatus: $('#cmbAuthStatus').combobox('getValue'),
    });
}

function QuerygridTmpDrugDetail() {
    var TDPRowIdStr = '';
    var gridChecked = $('#gridTmpDrugMain').datagrid('getChecked');
    for (var i = 0; i < gridChecked.length; i++) {
        TDPRowIdStr =
            TDPRowIdStr == '' ? gridChecked[i].TDP : TDPRowIdStr + '^' + gridChecked[i].TDP;
    }
    if (TDPRowIdStr == '') return;
    $('#gridTmpDrugDetail').datagrid('query', {
        TDPRowIdStr: TDPRowIdStr,
        IngdRecStatus: '',
    });
}

// ��ʼ��Ĭ������
function InitDict() {
    //����
    $.cm(
        {
            ClassName: 'PHA.IN.TmpDrugPurch.Query',
            MethodName: 'GetDefaultDate',
        },
        function (retData) {
            var DateArr = retData.split('^');
            $('#dateStart').datebox('setValue', DateArr[0]);
            $('#dateEnd').datebox('setValue', DateArr[1]);
        }
    );
    //��Ȩ״̬
    $('#cmbAuthStatus').combobox('setValue', 'δ��Ȩ');
}

function InitGridDict() {
    // ��Ȩ״̬
    PHA.ComboBox('cmbAuthStatus', {
        url: PHA_STORE.TmpDurgAuthStatus().url,
    });

    // ��Ȩҩ��
    PHA.ComboBox('cmbIngdLoc', {
        url: PHA_STORE.Pharmacy('').url,
    });

    // ��Ȩҩ��
    PHA.ComboBox('cmbIngdLocMain', {
        url: PHA_STORE.Pharmacy('').url,
    });

    
}

function InitGrid() {
    InitTmpDrugDetail();
    InitTmpDrugMian();
}

function InitTmpDrugDetail() {
    var columns = [
        [
            // TDPi,inci,inciDesc,tmpDesc,spec,qty,uom,uomDesc,manf,manfDesc
            { field: 'gridDetailSelect', checkbox: true },

            { field: 'TDPi', title: 'TDPi', hidden: true },
            { field: 'scgDesc', title: '����', align: 'center', width: 55 },
            {
                field: 'statusi',
                title: '��ϸ״̬',
                align: 'center',
                width: 80,
                //formatter: Statuiformatter,
                styler:StatuiStyler,
            },

            {
                field: 'inciDesc',
                title: $g('ҩƷ����<font color ="green">(��ά��)</font>'),
                width: 300,
            },
            {
                field: 'tmpDesc',
                title: $g('ҩƷ����<font color ="red">(δά��)</font>'),
                width: 232,
                sortable: 'true',
            },
            {
                field: 'spec',
                title: '���',
                width: 100,
            },
            { field: 'qty', title: '��������', align: 'right', width: 70 },
            { field: 'RecQty', title: '�������', align: 'right', width: 70 },
            { field: 'useQty', title: '��������', align: 'right', width: 70 },
            { field: 'uomDesc', title: '��λ', align: 'center', width: 80 },
            { field: 'manfDesc', title: '������ҵ', width: 225 },
            { field: 'scg', title: '����ID', width: 225, hidden: true },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        singleSelect: false,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurAuth.Query',
            QueryName: 'SelectTmpDrug',
            TDPRowIdStr: '',
            AuthStatus: '',
        },
        gridSave: false,
        columns: columns,
        toolbar: '#gridTmpDrugDetailBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'configCode',
                });
            }
        },
    };
    PHA.Grid('gridTmpDrugDetail', dataGridOption);
}

function Statuiformatter(value, rowData, rowIndex) {
    var statusi = rowData.statusi;
    if (statusi == '��Ᵽ��') return "<div style='background-color:yellow;'>" + statusi + '</div>';
    else if (statusi == 'δ���')
        return "<div style='background-color:yellow;'>" + statusi + '</div>';
    else if (statusi == '����Ȩ')
        return "<div style='background-color:red;color:white'>" + statusi + '</div>';
}

function StatuiStyler(value, row, index)
{
     switch (value) {
         case '����Ȩ':
             colorStyle = 'background:#ee4f38;color:white;';
             break;
         default:
             colorStyle = 'background:white;color:black;';
             break;
     }
     return colorStyle;
}

// ������
function AddNewRow() {
    $('#gridTmpDrugDetail').datagrid('addNewRow', {
        editField: 'inci',
    });
}

function InitTmpDrugMian() {
    var columns = [
        [
            { field: 'gridMainSelect', checkbox: true },
            //TDP,TDPNo,Date,Time,Creator,CreatorName,Type,TypeDese,TypeValue,TypeValueDesc,lastStateId,lastStateDesc
            { field: 'TDP', title: 'TDP', width: 225, hidden: true },
            { field: 'TDPNo', title: '����', width: 170 },
            { field: 'CreatorName', title: '������', width: 70 },
            { field: 'Date', title: '��������', width: 100 },
            { field: 'Time', title: '����ʱ��', width: 80 },
            { field: 'TypeDese', title: 'ʹ������', width: 80 },
            { field: 'TypeValueDesc', title: 'ʹ������ֵ', width: 150 },
            { field: 'lastStateDesc', title: '���״̬', width: 100 },
            { field: 'IngdStatus', title: '���״̬', width: 200 },
            { field: 'AuthStatus', title: '��Ȩ״̬', width: 100 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        singleSelect: false,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurAuth.Query',
            QueryName: 'QueryTmpDrug',
            StDate: $('#dateStart').datebox('getValue'),
            EdDate: $('#dateEnd').datebox('getValue'),
            HospId: '',
            Status: '',
        },
        columns: columns,
        toolbar: '#gridTmpDrugMainBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                //QuerygridTmpDrugDetail();
            }
        },
        onLoadSuccess: function (data) {},
        onCheck: function (rowIndex, rowData) {
            QuerygridTmpDrugDetail();
        },
        onUncheck: function (rowIndex, rowData) {
            QuerygridTmpDrugDetail();
        },
        onCheckAll: function () {
            QuerygridTmpDrugDetail();
        },
    };
    PHA.Grid('gridTmpDrugMain', dataGridOption);
}

function SaveAuth() {
    var AuthLoc = $('#cmbIngdLoc').combobox('getValue');
    var params = '',
        TDPiRowIdStr = '';
    var gridChecked = $('#gridTmpDrugDetail').datagrid('getChecked');
    var CheckedLen = gridChecked.length;
    if (CheckedLen == 0) {
        PHA.Popover({ showType: 'show', msg: '��ѡ����Ҫ��Ȩ����ϸ', type: 'alert' });
        return;
    }
    var NotAcorrdFlag = '';
    for (var i = 0; i < CheckedLen; i++) {
        var statusi = gridChecked[i].statusi;
        if (statusi != '') {
            NotAcorrdFlag = 1;
            continue;
        }
        var inci = gridChecked[i].inci;
        if (inci == '') {
            PHA.Popover({
                showType: 'show',
                msg: '��ѡ����δά����������ϸ������ά���ٽ�����Ȩ��',
                type: 'alert',
            });
            return;
        }
        TDPiRowIdStr =
            TDPiRowIdStr == '' ? gridChecked[i].TDPi : TDPiRowIdStr + '^' + gridChecked[i].TDPi;
    }
    if (TDPiRowIdStr == '') {
        PHA.Popover({
            showType: 'show',
            msg: '��ѡ���˲�����Ȩ����ϸ��������ϸ״̬',
            type: 'alert',
        });
        return;
    }

    var ret = tkMakeServerCall(
        'PHA.IN.TmpDrugPurAuth.Save',
        'TDPAuth',
        SessionHosp,
        AuthLoc,
        TDPiRowIdStr,
        SessionUser
    );
    var retArr = ret.split('^');
    if (retArr[0] == 0) {
        PHA.Popover({ showType: 'show', msg: '��Ȩ�ɹ�', type: 'success' });
        QuerygridTmpDrugMain();
    } else {
        PHA.Popover({ showType: 'show', msg: retArr[1], type: 'alert' });
    }
    
}

function SaveAuthByMian() {
    var AuthLoc = $('#cmbIngdLocMain').combobox('getValue');
    var TDPRowIdStr = '';
    var gridChecked = $('#gridTmpDrugMain').datagrid('getChecked');
    for (var i = 0; i < gridChecked.length; i++) {
        TDPRowIdStr =
            TDPRowIdStr == '' ? gridChecked[i].TDP : TDPRowIdStr + '^' + gridChecked[i].TDP;
    }
    if (TDPRowIdStr == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ�����뵥', type: 'alert' });
        return;
    }
    var ret = tkMakeServerCall(
        'PHA.IN.TmpDrugPurAuth.Save',
        'TDPAuthByMian',
        SessionHosp,
        AuthLoc,
        TDPRowIdStr,
        SessionUser
    );
    var retArr = ret.split('^');
    if (retArr[0] == 0) {
        PHA.Popover({ showType: 'show', msg: '��Ȩ�ɹ�', type: 'success' });
    } else {
        PHA.Popover({ showType: 'show', msg: retArr[1], type: 'alert' });
    }
    QuerygridTmpDrugMain();
    ClearDetail();
}
