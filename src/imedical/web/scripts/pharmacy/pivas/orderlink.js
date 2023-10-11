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
    $('#btnSaveLiquid').on('click', SaveSingle);
    PHA_UX.Translate({ buttonID: 'btnTranslate', gridID: 'gridOrderLink', idField: 'polId', sqlTableName: 'PIVA_OrderLink' });
    $('.dhcpha-win-mask').remove();
});

function InitGridDict() {
    GridCmbPivaCat = PIVAS.GridComboBox.Init(
        { Type: 'PHCPivaCat' },
        {
            required: true,
            multiple:true,
            panelHeight: 'auto',
            onBeforeLoad: function(param) {
                param.hosp = HospId;
            }
        }
    );
    GridCmbInstruc = PIVAS.GridComboBox.Init({ Type: 'Instruc' }, { required: true,tipPosition:'bottom' });
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
                QuerySingle();
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
            $('#txtPolMinVol,#txtPolMaxVol,#txtPolMinAge,#txtPolMaxAge').numberbox('setValue','');
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
        $.messager.alert($g('��ʾ'), saveInfo, 'warning');
    }
    $('#gridOrderLink').datagrid('query', {});
}

/// ɾ����Һ����
function DeleteOrderLink() {
    var gridSelect = $('#gridOrderLink').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('��ѡ����Ҫɾ���ļ�¼'),
            type: 'alert'
        });
        return;
    }
    $.messager.confirm($g('ȷ�϶Ի���'), $g('��ȷ��ɾ����'), function(r) {
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
    var polId = GetSelectPolId();
    if(polId === ''){
        return
    }

    $('#gridPivasCat').datagrid('endEditing');
    var gridChanges = $('#gridPivasCat').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('û����Ҫ���������'),
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
    debugger
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.OrderLink', 'SavePivasCatMulti', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert($g('��ʾ'), saveInfo, 'warning');
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
            msg: $g('��ѡ����Ҫɾ���ļ�¼'),
            type: 'alert'
        });
        return;
    }
    $.messager.confirm($g('ȷ�϶Ի���'), $g('��ȷ��ɾ����'), function(r) {
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
    var polId = GetSelectPolId();
    if(polId === ''){
        return
    }
    $('#gridInstruct').datagrid('endEditing');
    var gridChanges = $('#gridInstruct').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('û����Ҫ���������'),
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
        $.messager.alert($g('��ʾ'), saveInfo, 'warning');
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
            msg: $g('��ѡ����Ҫɾ���ļ�¼'),
            type: 'alert'
        });
        return;
    }
    $.messager.confirm($g('ȷ�϶Ի���'), $g('��ȷ��ɾ����'), function(r) {
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


/// ����Һ���������
function SaveSingle() {
    var polId = GetSelectPolId();
    if (polId == '') {
        return;
    }
    var PolMinVol = $('#txtPolMinVol').numberbox('getValue');
    var PolMaxVol = $('#txtPolMaxVol').numberbox('getValue');
    var PolMinAge = $('#txtPolMinAge').numberbox('getValue');
    var PolMaxAge = $('#txtPolMaxAge').numberbox('getValue');
    if (PolMinVol != '' && PolMaxVol != '' && parseFloat(PolMinVol) > parseFloat(PolMaxVol)) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('��СҺ����') + PolMinVol + $g('���ܴ������Һ����') + PolMaxVol,
            type: 'alert'
        });
        return false;
    }
    if (PolMinAge != '' && PolMaxAge != '' && parseFloat(PolMinAge) > parseFloat(PolMaxAge)) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('��С����') + PolMinAge + $g('���ܴ����������') + PolMaxAge,
            type: 'alert'
        });
        return false;
    }
    PolMinVol = isNaN(PolMinVol) || PolMinVol == '' ? '' : parseInt(PolMinVol);
    PolMaxVol = isNaN(PolMaxVol) || PolMaxVol == '' ? '' : parseInt(PolMaxVol);
    PolMinAge = isNaN(PolMinAge) || PolMinAge == '' ? '' : parseFloat(PolMinAge);
    PolMaxAge = isNaN(PolMaxAge) || PolMaxAge == '' ? '' : parseFloat(PolMaxAge);
    var params = polId + '^' + PolMinVol + '^' + PolMaxVol+ '^' + PolMinAge + '^' + PolMaxAge;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.OrderLink', 'SaveSingle', params);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert($g('��ʾ'), saveInfo, 'warning');
        return;
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: saveInfo,
            type: 'success'
        });
    }
    QuerySingle();
}
//��ȡҺ�����ȵ���ά����
function QuerySingle() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    var polId = gridPOLSelect.polId;
    $.cm({
        ClassName:'web.DHCSTPIVAS.OrderLink',
        MethodName:'GetLinkSingle',
        polId:polId,
    },function(data){
        $('#txtPolMinVol').numberbox('setValue',data.minVol);
        $('#txtPolMaxVol').numberbox('setValue',data.maxVol);
        $('#txtPolMinAge').numberbox('setValue',data.minAge);
        $('#txtPolMaxAge').numberbox('setValue',data.maxAge);
    });

}
/// ��Һ��������
function AddOrderLink() {
    $('#gridOrderLink').datagrid('addNewRow', {
        editField: 'polDesc'
    });
    $('#gridPivasCat').datagrid('clear');
    $('#gridInstruct').datagrid('clear');
    $('#txtPolMinVol,#txtPolMaxVol,#txtPolMinAge,#txtPolMaxAge').numberbox('setValue','');
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
            msg: $g('����ѡ����Ҫ���ӹ������Һ�����¼'),
            type: 'alert'
        });
        return '';
    }
    var polId = gridSelect.polId || '';
    if (polId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('���ȱ�����Һ����'),
            type: 'alert'
        });
        return '';
    }
    return polId;
}

function InitHospCombo() {
	var genHospObj=PIVAS.AddHospCom({tableName:'PIVA_OrderLink'},{width:315});
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
 	var defHosp = $.cm(
		{
		    dataType: 'text',
		    ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
		    MethodName: 'GetDefHospIdByTableName',
		    tableName: 'PIVA_OrderLink',
		    HospID: HospId
		},
		false
	);
	HospId = defHosp;  
}
