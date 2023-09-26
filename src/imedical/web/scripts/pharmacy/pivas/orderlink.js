/**
 * 模块:	配液中心配液大类维护
 * 编写日期: 2018-03-13
 * 编写人:  QianHuanjuan
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
    //配液大类
    $('#btnAdd').on('click', AddOrderLink);
    $('#btnSave').on('click', SaveOrderLink);
    $('#btnDelete').on('click', DeleteOrderLink);
    //配液小类
    $('#btnAddPoli').on('click', AddPoli);
    $('#btnSavePoli').on('click', SavePoli);
    $('#btnDelPoli').on('click', DeletePoli);
    //用法
    $('#btnAddPols').on('click', AddPols);
    $('#btnSavePols').on('click', SavePols);
    $('#btnDelPols').on('click', DeletePols);
    //液体量
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

/// 初始化配液大类表格
function InitGridOrderLink() {
    var columns = [
        [
            { field: 'polId', title: 'polId', hidden: true, align: 'center' },
            {
                field: 'polDesc',
                title: '名称',
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
                title: '简称',
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
                title: '优先级',
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

/// 保存配液大类
function SaveOrderLink() {
    $('#gridOrderLink').datagrid('endEditing');
    var gridChanges = $('#gridOrderLink').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '没有需要保存的数据',
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
        $.messager.alert('提示', saveInfo, 'warning');
    }
    $('#gridOrderLink').datagrid('query', {});
}

/// 删除配液大类
function DeleteOrderLink() {
    var gridSelect = $('#gridOrderLink').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function(r) {
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

/// 初始化配液小类表格
function InitGridPivasCat() {
    var columns = [
        [
            { field: 'poliId', title: 'poliId', hidden: true },
            { field: 'pivasCatDesc', title: '配液小类描述', hidden: true },
            {
                field: 'pivasCatId',
                title: '配液小类',
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

/// 保存配液小类
function SavePoli() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    var polId = gridPOLSelect.polId;
    if (polId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择左侧配液大类',
            type: 'alert'
        });
        return;
    }
    $('#gridPivasCat').datagrid('endEditing');
    var gridChanges = $('#gridPivasCat').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '没有需要保存的数据',
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
        $.messager.alert('提示', saveInfo, 'warning');
    }
    $('#gridPivasCat').datagrid('query', {});
}
//获取配液小类列表
function QueryGridPivasCat() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    var polId = gridPOLSelect.polId || '';
    $('#gridPivasCat').datagrid('query', {
        inputStr: polId
    });
}

/// 删除配液小类
function DeletePoli() {
    var gridSelect = $('#gridPivasCat').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function(r) {
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

/// 初始化用法表格
function InitGridInstruct() {
    var columns = [
        [
            { field: 'polsId', title: 'polsId', hidden: true },
            { field: 'instrucDesc', title: 'instrucId', hidden: true },
            {
                field: 'instrucId',
                title: '用法',
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

/// 保存用法
function SavePols() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    var polId = gridPOLSelect.polId || '';
    if (polId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择左侧配液大类',
            type: 'alert'
        });
        return;
    }
    $('#gridInstruct').datagrid('endEditing');
    var gridChanges = $('#gridInstruct').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '没有需要保存的数据',
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
        $.messager.alert('提示', saveInfo, 'warning');
    }
    $('#gridInstruct').datagrid('query', {});
}
/// 获取用法列表
function QueryGridInstruct() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    var polId = gridPOLSelect.polId;
    $('#gridInstruct').datagrid('query', {
        inputStr: polId
    });
}

/// 删除用法
function DeletePols() {
    var gridSelect = $('#gridInstruct').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function(r) {
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

/// 初始化液体量
function InitGridLiquid() {
    var columns = [
        [{ field: 'liquidQty', title: '液体量(ml)', width: 200, halign: 'left', align: 'left' }]
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

/// 保存液体量
function SaveLiquid() {
    var polId = GetSelectPolId();
    if (polId == '') {
        return;
    }
    var PolMinVol = $('#txtPolMinVol').val();
    var PolMaxVol = $('#txtPolMaxVol').val();
    if (PolMinVol != '' && PolMaxVol != '' && PolMinVol > PolMaxVol) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '最小下限量' + PolMinVol + '不能大于最大上限量' + PolMaxVol,
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
        $.messager.alert('提示', saveInfo, 'warning');
        return;
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: saveInfo,
            type: 'success'
        });
    }
    QueryGridLiquid();
}
//获取液体量列表
function QueryGridLiquid() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    var polId = gridPOLSelect.polId;
    var result = tkMakeServerCall('web.DHCSTPIVAS.OrderLink', 'GetLiquidInfo', polId);
    $('#txtPolMinVol').val(result.split('^')[0] || '');
    $('#txtPolMaxVol').val(result.split('^')[1] || '');
}
/// 配液大类增加
function AddOrderLink() {
    $('#gridOrderLink').datagrid('addNewRow', {
        editField: 'polDesc'
    });
    $('#gridPivasCat').datagrid('clear');
    $('#gridInstruct').datagrid('clear');
    $('#txtPolMinVol').val('');
    $('#txtPolMaxVol').val('');
}

/// 配液小类增加
function AddPoli() {
    var polId = GetSelectPolId();
    if (polId == '') {
        return;
    }
    $('#gridPivasCat').datagrid('addNewRow', {
        editField: 'pivasCatId'
    });
}
/// 用法增加
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
            msg: '请先选中需要增加规则的配液大类记录',
            type: 'alert'
        });
        return '';
    }
    var polId = gridSelect.polId || '';
    if (polId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先保存配液大类',
            type: 'alert'
        });
        return '';
    }
    return polId;
}

function InitHospCombo() {
	var genHospObj=PIVAS.AddHospCom({tableName:'PIVA_OrderLink'});
	if (typeof genHospObj ==='object'){
        //增加选择事件
        genHospObj.options().onSelect =  function(index, record) {
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                $('#gridOrderLink').datagrid('load');
            }
        };
    }
}
