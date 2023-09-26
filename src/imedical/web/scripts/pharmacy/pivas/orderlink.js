/**
 * ģ��:	��Һ������Һ����ά��
 * ��д����: 2018-03-13
 * ��д��:  QianHuanjuan
 */
var HospId = session['LOGON.HOSPID'];
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var ConfirmMsgInfoArr = [];
var GridCmbPivaCat;
var GridCmbInstruc;
$(function() {
    InitHospCombo();
    InitGridDict();
    InitGridOrderLink();
    InitGridPivasCat();
    InitGridInstruct();
    InitGridLiquid();
    //��Һ����
    $('#btnAdd').on('click', AddOrderLink);
    $('#btnSave').on('click', SaveOrderLink);
    $('#btnDelete').on('click', DeleteOrderLink);
    //��ҺС��
    $('#btnAddPoli').on('click', AddPoli);
    $('#btnSavePoli').on('click', SavePoli);
    $('#btnDelPoli').on('click', DeletePoli);
    //�÷�
    $('#btnAddPols').on('click', AddPols);
    $('#btnSavePols').on('click', SavePols);
    $('#btnDelPols').on('click', DeletePols);
    //Һ����
    $('#btnSaveLiquid').on('click', function() {
        SaveLiquid();
    });
    $('.dhcpha-win-mask').remove();
});

function InitGridDict() {
    GridCmbPivaCat = PIVAS.GridComboBox.Init(
        { Type: 'PHCPivaCat' },
        {
            required: true,
            onBeforeLoad: function(param) {
                param.hosp = HospId;
            }
        }
    );
    GridCmbInstruc = PIVAS.GridComboBox.Init({ Type: 'Instruc' }, { required: true });
}

/// ��ʼ����Һ������
function InitGridOrderLink() {
    var columns = [
        [
            { field: 'polId', title: 'polId', hidden: true, align: 'center' },
            {
                field: 'polDesc',
                title: '����',
                width: 200,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'polCode',
                title: '���',
                width: 75,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: false
                    }
                }
            },
            {
                field: 'polOrdNum',
                title: '���ȼ�',
                width: 60,
                align: 'center',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.OrderLink',
            QueryName: 'QueryOrderLink'
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        toolbar: '#gridOrderLinkBar',
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
            if ($(this).datagrid('options').editIndex == undefined) {
                QueryGridPivasCat();
                QueryGridInstruct();
                QueryGridLiquid();
            }
        },
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'polDesc'
            });
        },
        onLoadSuccess: function() {
            $('#gridPivasCat').datagrid('clear');
            $('#gridInstruct').datagrid('clear');
            $('#txtPolMinVol').val('');
            $('#txtPolMaxVol').val('');
        },
        onBeforeLoad: function(param) {
            param.HospId = HospId;
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridOrderLink', dataGridOption);
}

/// ������Һ����
function SaveOrderLink() {
    $('#gridOrderLink').datagrid('endEditing');
    var gridChanges = $('#gridOrderLink').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: 'û����Ҫ���������',
            type: 'alert'
        });
        return;
    }
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params =
            (iData.polId || '') +
            '^' +
            (iData.polDesc || '') +
            '^' +
            (iData.polOrdNum || '') +
            '^' +
            (iData.polCode || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall(
        'web.DHCSTPIVAS.OrderLink',
        'SaveOrderLinkMulti',
        paramsStr,
        HospId
    );
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'warning');
    }
    $('#gridOrderLink').datagrid('query', {});
}

/// ɾ����Һ����
function DeleteOrderLink() {
    var gridSelect = $('#gridOrderLink').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Ҫɾ���ļ�¼',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function(r) {
        if (r) {
            var polId = gridSelect.polId || '';
            if (polId == '') {
                var rowIndex = $('#gridOrderLink').datagrid('getRowIndex', gridSelect);
                $('#gridOrderLink').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall(
                    'web.DHCSTPIVAS.OrderLink',
                    'DeletePIVAOrderLink',
                    polId,
                    HospId
                );
                $('#gridOrderLink').datagrid('query', {});
            }
        }
    });
}

/// ��ʼ����ҺС����
function InitGridPivasCat() {
    var columns = [
        [
            { field: 'poliId', title: 'poliId', hidden: true },
            { field: 'pivasCatDesc', title: '��ҺС������', hidden: true },
            {
                field: 'pivasCatId',
                title: '��ҺС��',
                width: 200,
                descField: 'pivasCatDesc',
                editor: GridCmbPivaCat,
                formatter: function(value, rowData, rowIndex) {
                    return rowData.pivasCatDesc;
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.OrderLink',
            QueryName: 'QueryPivasCat'
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        toolbar: '#gridPivasCatBar',
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
        },
        onLoadSuccess: function() {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridPivasCat', dataGridOption);
}

/// ������ҺС��
function SavePoli() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    var polId = gridPOLSelect.polId;
    if (polId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ�������Һ����',
            type: 'alert'
        });
        return;
    }
    $('#gridPivasCat').datagrid('endEditing');
    var gridChanges = $('#gridPivasCat').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: 'û����Ҫ���������',
            type: 'alert'
        });
        return;
    }
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params = (iData.poliId || '') + '^' + polId + '^' + (iData.pivasCatId || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.OrderLink', 'SavePivasCatMulti', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'warning');
    }
    $('#gridPivasCat').datagrid('query', {});
}
//��ȡ��ҺС���б�
function QueryGridPivasCat() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    var polId = gridPOLSelect.polId || '';
    $('#gridPivasCat').datagrid('query', {
        inputStr: polId
    });
}

/// ɾ����ҺС��
function DeletePoli() {
    var gridSelect = $('#gridPivasCat').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Ҫɾ���ļ�¼',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function(r) {
        if (r) {
            var poliId = gridSelect.poliId || '';
            if (poliId == '') {
                var rowIndex = $('#gridPivasCat').datagrid('getRowIndex', gridSelect);
                $('#gridPivasCat').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.OrderLink', 'DeletePoli', poliId);
                $('#gridPivasCat').datagrid('query', {});
            }
        }
    });
}

/// ��ʼ���÷����
function InitGridInstruct() {
    var columns = [
        [
            { field: 'polsId', title: 'polsId', hidden: true },
            { field: 'instrucDesc', title: 'instrucId', hidden: true },
            {
                field: 'instrucId',
                title: '�÷�',
                width: 200,
                descField: 'instrucDesc',
                editor: GridCmbInstruc,
                formatter: function(value, rowData, rowIndex) {
                    return rowData.instrucDesc;
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.OrderLink',
            QueryName: 'QueryInstruct'
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        toolbar: '#gridInstructBar',
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
        },
        onLoadSuccess: function() {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridInstruct', dataGridOption);
}

/// �����÷�
function SavePols() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    var polId = gridPOLSelect.polId || '';
    if (polId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ�������Һ����',
            type: 'alert'
        });
        return;
    }
    $('#gridInstruct').datagrid('endEditing');
    var gridChanges = $('#gridInstruct').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: 'û����Ҫ���������',
            type: 'alert'
        });
        return;
    }
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params = (iData.polsId || '') + '^' + polId + '^' + (iData.instrucId || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.OrderLink', 'SaveInstructMulti', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'warning');
    }
    $('#gridInstruct').datagrid('query', {});
}
/// ��ȡ�÷��б�
function QueryGridInstruct() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    var polId = gridPOLSelect.polId;
    $('#gridInstruct').datagrid('query', {
        inputStr: polId
    });
}

/// ɾ���÷�
function DeletePols() {
    var gridSelect = $('#gridInstruct').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Ҫɾ���ļ�¼',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function(r) {
        if (r) {
            var polsId = gridSelect.polsId || '';
            if (polsId == '') {
                var rowIndex = $('#gridInstruct').datagrid('getRowIndex', gridSelect);
                $('#gridInstruct').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.OrderLink', 'DeletePols', polsId);
                $('#gridInstruct').datagrid('query', {});
            }
        }
    });
}

/// ��ʼ��Һ����
function InitGridLiquid() {
    var columns = [
        [{ field: 'liquidQty', title: 'Һ����(ml)', width: 200, halign: 'left', align: 'left' }]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        toolbar: '#gridLiquidBar',
        onClickRow: function(rowIndex, rowData) {},
        onLoadSuccess: function() {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridLiquid', dataGridOption);
}

/// ����Һ����
function SaveLiquid() {
    var polId = GetSelectPolId();
    if (polId == '') {
        return;
    }
    var PolMinVol = $('#txtPolMinVol').val();
    var PolMaxVol = $('#txtPolMaxVol').val();
    if (PolMinVol != '' && PolMaxVol != '' && PolMinVol > PolMaxVol) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��С������' + PolMinVol + '���ܴ������������' + PolMaxVol,
            type: 'alert'
        });
        return false;
    }
    PolMinVol = isNaN(PolMinVol) || PolMinVol == '' ? '' : parseInt(PolMinVol);
    PolMaxVol = isNaN(PolMaxVol) || PolMaxVol == '' ? '' : parseInt(PolMaxVol);
    var params = polId + '^' + PolMinVol + '^' + PolMaxVol;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.OrderLink', 'SaveLiquid', params);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'warning');
        return;
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: saveInfo,
            type: 'success'
        });
    }
    QueryGridLiquid();
}
//��ȡҺ�����б�
function QueryGridLiquid() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    var polId = gridPOLSelect.polId;
    var result = tkMakeServerCall('web.DHCSTPIVAS.OrderLink', 'GetLiquidInfo', polId);
    $('#txtPolMinVol').val(result.split('^')[0] || '');
    $('#txtPolMaxVol').val(result.split('^')[1] || '');
}
/// ��Һ��������
function AddOrderLink() {
    $('#gridOrderLink').datagrid('addNewRow', {
        editField: 'polDesc'
    });
    $('#gridPivasCat').datagrid('clear');
    $('#gridInstruct').datagrid('clear');
    $('#txtPolMinVol').val('');
    $('#txtPolMaxVol').val('');
}

/// ��ҺС������
function AddPoli() {
    var polId = GetSelectPolId();
    if (polId == '') {
        return;
    }
    $('#gridPivasCat').datagrid('addNewRow', {
        editField: 'pivasCatId'
    });
}
/// �÷�����
function AddPols() {
    var polId = GetSelectPolId();
    if (polId == '') {
        return;
    }
    $('#gridInstruct').datagrid('addNewRow', {
        editField: 'instrucId'
    });
}

function GetSelectPolId() {
    var gridSelect = $('#gridOrderLink').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '����ѡ����Ҫ���ӹ������Һ�����¼',
            type: 'alert'
        });
        return '';
    }
    var polId = gridSelect.polId || '';
    if (polId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '���ȱ�����Һ����',
            type: 'alert'
        });
        return '';
    }
    return polId;
}

function InitHospCombo() {
	var genHospObj=PIVAS.AddHospCom({tableName:'PIVA_OrderLink'});
	if (typeof genHospObj ==='object'){
        //����ѡ���¼�
        genHospObj.options().onSelect =  function(index, record) {
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                $('#gridOrderLink').datagrid('load');
            }
        };
    }
}
