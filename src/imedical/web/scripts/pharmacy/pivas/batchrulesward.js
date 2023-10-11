/**
 * 模块:     病区规则维护
 * 编写日期: 2018-03-26
 * 编写人:   QianHuanjuan
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var PointerUrl = 'DHCST.QUERY.BROKER.csp?DataType=Array&ClassName=web.DHCSTPIVAS.BatchRules&QueryName=SortTypePointer';
var NeedSelRow = '';
var NeedSortSelRow = '';
var GridCmbPivaLoc;
var GridCmbWard;
var GridCmgInc;
var GridCmbBatNo;
var GridCmbInstruc;
var GridCmbOrdLink;
$(function () {
    $('#tabsBatchRulesWard').tabs('close', '药品顺序规则');
    InitDict();
    InitGridDict();
    /* 病区规则 */
    InitGridLocBat();
    $('#btnAdd').on('click', AddNewRowLocBat);
    $('#btnSave').on('click', SaveLocBat);
    $('#btnDelete').on('click', DeleteLocBat);
    $('#btnFind').on('click', QueryPIVALocBat);
    /* 病区规则 */

    /* 明细规则 */
    InitGridLocBatInc();
    InitGridLocBatSort();
    InitGridLocBatIncFix();
    InitGridLocBatInsFix();
    InitGridLocBatOrdLinkFix();
    InitGridLocBatCub();
    /* 明细规则 */

    $('#btnAddInc,#btnAddIncFix,#btnAddInsFix,#btnAddCub,#btnAddOrdLinkFix').on('click', AddNewRowLocBatItm);
    $('#btnDelInc,#btnDelIncFix,#btnDelInsFix,#btnDelOrdLinkFix').on('click', DeleteLocBatItm);
    $('#btnSaveInc,#btnSaveIncFix,#btnSaveInsFix,#btnSaveOrdLinkFix').on('click', SaveLocBatItm);

    /* 容积规则*/
    $('#btnDelCub').on('click', DeleteLocBatCub);
    $('#btnSaveCub').on('click', SaveLocBatCub);
    /* 容积规则*/

    $('#btnUpInc').on('click', function () {
        MoveInc(-1);
    });
    $('#btnDownInc').on('click', function () {
        MoveInc(1);
    });
    /* 顺序规则 */
    $('#btnAddSort').on('click', AddNewRowLocBatItm);
    $('#btnDelSort').on('click', DeleteLocBatSort);
    $('#btnSaveSort').on('click', SaveLocBatSort);
    $('#btnUpSort').on('click', function () {
        MoveSort(-1);
    });
    $('#btnDownSort').on('click', function () {
        MoveSort(1);
    });
    $('#menuInsertSort,#menuAddSort').on('click', AddNewRowLocBatSort);
    $('.dhcpha-win-mask').remove();
});

/// 初始化字典
function InitDict() {
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'PivaLoc' },
        {
            editable: false,
            placeholder: '配液中心...',
            width: 200,
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('select', datas[i].RowId);
                        break;
                    }
                }
            },
            onSelect: function () {
                QueryPIVALocBat();
            }
        }
    );
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, { width: 250, placeholder: '病区...' });
}

function InitGridDict() {
    GridCmbPivaLoc = PIVAS.GridComboBox.Init({ Type: 'PivaLoc', QueryParams: { inputStr: SessionLoc } }, { required: true });
    GridCmbWard = PIVAS.GridComboBox.Init({ Type: 'Ward' }, { required: true });
    GridCmbBatNo = PIVAS.GridComboBox.Init(
        { Type: 'PIVALocBatNo' },
        {
            required: true,
            valueField: 'batNo',
            textField: 'batNo',
            editable: false
        }
    );
    GridCmbInstruc = PIVAS.GridComboBox.Init({ Type: 'Instruc' }, { required: true, editable: false });
    GridCmbOrdLink = PIVAS.GridComboBox.Init({ Type: 'PivaCat' }, { required: true, editable: false });
    GridCmgInc = PIVAS.GridComboGrid.Init(
        { Type: 'IncItm' },
        {
            required: true,
            idField: 'incRowId',
            textField: 'incDesc',
            onHidePanel: function () {
                var val = $(this).combogrid('getValue') || '';
                var text = $(this).combogrid('getText') || '';
                if (val == text) {
                    $(this).combogrid('clear');
                }
            },
            onBeforeLoad: function (param) {
                param.filterText = param.q;
                param.loc = $('#cmbPivaLoc').combobox('getValue');
            }
        }
    );
}

///病区规则列表
function InitGridLocBat() {
    //定义columns
    var columns = [
        [
            { field: 'plbatId', title: '批次规则id', width: 80, hidden: true },
            { field: 'locDesc', title: '配液中心描述', width: 80, hidden: true },
            {
                field: 'locId',
                title: '配液中心',
                width: 200,
                descField: 'locDesc',
                editor: GridCmbPivaLoc,
                formatter: function (value, rowData, rowIndex) {
                    return rowData.locDesc;
                }
            },
            { field: 'wardDesc', title: '病区描述', width: 80, hidden: true },
            {
                field: 'wardId',
                title: '病区',
                width: 220,
                descField: 'wardDesc',
                editor: GridCmbWard,
                formatter: function (value, rowData, rowIndex) {
                    return rowData.wardDesc;
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryPIVALocBat',
            StrParams: SessionLoc
        },
        columns: columns,
        rownumbers: false,
        fitColumns: true,
        toolbar: '#gridLocBatBar',
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData.wardId == '' || rowData.wardId == undefined) {
                return false;
            }
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'wardId'
            });
        },
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
            QueryLocBatInc();
            QueryLocBatIncFix();
            QueryLocBatInsFix();
            QueryLocBatOrdLinkFix();
            QueryLocBatCub();
            QueryLocBatSort();
            GridCmbBatNo = PIVAS.GridComboBox.Init(
                { Type: 'PIVALocBatNo', QueryParams: { inputStr: rowData.locId } },
                {
                    required: true,
                    valueField: 'batNo',
                    textField: 'batNo',
                    editable: false
                }
            );
            var gridCol;
            gridCol = $('#gridLocBatIncFix').datagrid('getColumnOption', 'batNo');
            gridCol.editor = GridCmbBatNo;
            gridCol = $('#gridLocBatInsFix').datagrid('getColumnOption', 'batNo');
            gridCol.editor = GridCmbBatNo;
            gridCol = $('#gridLocBatOrdLinkFix').datagrid('getColumnOption', 'batNo');
            gridCol.editor = GridCmbBatNo;
            gridCol = $('#gridLocBatCub').datagrid('getColumnOption', 'batNo');
            gridCol.editor = GridCmbBatNo;
        },
        onLoadSuccess: function () {
            QueryLocBatInc();
            QueryLocBatIncFix();
            QueryLocBatInsFix();
            QueryLocBatOrdLinkFix();
            QueryLocBatCub();
            QueryLocBatSort();
        },
        onAfterEdit: function (rowIndex, rowData, changes) {
            // maybe todo
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridLocBat', dataGridOption);
}
// 增加病区规则
function AddNewRowLocBat() {
    $('#gridLocBat').datagrid('addNewRow', {
        editField: 'wardId',
        defaultRow: {
            locId: $('#cmbPivaLoc').combobox('getValue')
        }
    });
}

/// 查询病区规则
function QueryPIVALocBat() {
    var locId = $('#cmbPivaLoc').combobox('getValue') || '';
    var params = locId + '^' + '';
    $('#gridLocBat').datagrid('query', {
        inputStr: params
    });
}
/// 保存病区规则
function SaveLocBat() {
    $('#gridLocBat').datagrid('endEditing');
    var gridChanges = $('#gridLocBat').datagrid('getChanges');
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
        var params = (iData.plbatId || '') + '^' + (iData.wardId || '') + '^' + (iData.locId || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'SavePIVALocBatMulti', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal == '-1') {
        $.messager.alert('提示', saveInfo, 'warning');
    } else if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'error');
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '保存成功',
            type: 'success'
        });
    }
    setTimeout(function () {
        $('#gridLocBat').datagrid('query', {});
    }, 0);
}

/// 删除病区规则
function DeleteLocBat() {
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var plbatId = gridSelect.plbatId || '';
            if (plbatId == '') {
                var rowIndex = $('#gridLocBat').datagrid('getRowIndex', gridSelect);
                $('#gridLocBat').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'DeletePIVALocBat', plbatId);
                if (delRet.split('^')[0] < 0) {
                    $.messager.alert('提示', delRet.split('^')[1], 'warning');
                    return;
                } else {
                    DHCPHA_HUI_COM.Msg.popover({
                        msg: '删除成功',
                        type: 'success'
                    });
                    $('#gridLocBat').datagrid('query', {});
                }
            }
        }
    });
}

///药品顺序规则列表
function InitGridLocBatInc() {
    var columns = [
        [
            { field: 'plbatItmId', title: '药品顺序规则Id', width: 80, hidden: 'true' },
            {
                field: 'incRowId',
                title: '药品名称',
                width: 300,
                editor: GridCmgInc,
                descField: 'incDesc',
                formatter: function (value, row, index) {
                    return row.incDesc;
                }
            },
            { field: 'incDesc', title: '药品名称描述', width: 220, hidden: 'true', align: 'center' },
            { field: 'ordNum', title: '顺序', width: 220, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryLocBatItm'
        },
        columns: columns,
        rownumbers: true,
        pageSize: 100,
        toolbar: '#gridLocBatIncBar',
        onClickRow: function (rowIndex, rowData) {
            var editIndex = $(this).datagrid('options').editIndex;
            if (editIndex != undefined) {
                $(this).datagrid('selectRow', editIndex);
            }
        },
        onLoadSuccess: function () {
            $(this).datagrid('options').editIndex = undefined;
            if (NeedSelRow != '') {
                $(this).datagrid('selectRow', NeedSelRow);
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridLocBatInc', dataGridOption);
}

///药品固定规则列表
function InitGridLocBatIncFix() {
    //定义columns
    var columns = [
        [
            { field: 'plbatItmId', title: '病区规则子表Id', width: 80, hidden: true },
            { field: 'incDesc', title: '药品名称描述', width: 300, halign: 'center', align: 'left', hidden: true },
            {
                field: 'incRowId',
                title: '药品名称',
                width: 300,
                editor: GridCmgInc,
                descField: 'incDesc',
                formatter: function (value, row, index) {
                    return row.incDesc;
                }
            },
            {
                field: 'batNo',
                title: '批次',
                width: 100,
                editor: GridCmbBatNo
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryLocBatItm'
        },
        columns: columns,
        rownumbers: false,
        toolbar: '#gridLocBatIncFixBar',
        onClickRow: function (rowIndex, rowData) {
            var editIndex = $(this).datagrid('options').editIndex;
            if (editIndex != undefined) {
                $(this).datagrid('selectRow', editIndex);
            }
        },
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridLocBatIncFix', dataGridOption);
}
/// 用法固定规则列表
function InitGridLocBatInsFix() {
    var columns = [
        [
            { field: 'plbatItmId', title: '病区规则子表Id', width: 80, hidden: true },
            { field: 'instrucDesc', title: '用法描述', width: 80, align: 'left', hidden: true },
            {
                field: 'instrucId',
                title: '用法',
                width: 300,
                editor: GridCmbInstruc,
                descField: 'instrucDesc',
                formatter: function (value, row, index) {
                    return row.instrucDesc;
                }
            },
            {
                field: 'batNo',
                title: '批次',
                width: 100,
                editor: GridCmbBatNo
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryLocBatItm'
        },
        columns: columns,
        rownumbers: false,
        toolbar: '#gridLocBatInsFixBar',
        onClickRow: function (rowIndex, rowData) {
            var editIndex = $(this).datagrid('options').editIndex;
            if (editIndex != undefined) {
                $(this).datagrid('selectRow', editIndex);
            }
        },
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridLocBatInsFix', dataGridOption);
}
/// 配液大类固定规则列表
function InitGridLocBatOrdLinkFix() {
    var columns = [
        [
            { field: 'plbatItmId', title: '病区规则子表Id', width: 80, hidden: true },
            { field: 'ordLinkDesc', title: '配液大类描述', width: 80, align: 'left', hidden: true },
            {
                field: 'ordLink',
                title: '配液大类',
                width: 300,
                editor: GridCmbOrdLink,
                descField: 'ordLinkDesc',
                formatter: function (value, row, index) {
                    return row.ordLinkDesc;
                }
            },
            {
                field: 'batNo',
                title: '批次',
                width: 100,
                editor: GridCmbBatNo
            },
            {
                field: 'inLiquidFlag',
                title: '是否参与容积规则',
                width: 130,
                align: 'center',
                editor: {
                    type: 'icheckbox',
                    options: { on: '1', off: '0' }
                },
                formatter: function (value, row, index) {
                    if (value == '1') {
                        return PIVAS.Grid.CSS.CHNYes;
                    } else {
                        return PIVAS.Grid.CSS.CHNNo;
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryLocBatItm'
        },
        columns: columns,
        rownumbers: false,
        toolbar: '#gridLocBatOrdLinkFixBar',
        onClickRow: function (rowIndex, rowData) {
            var editIndex = $(this).datagrid('options').editIndex;
            if (editIndex != undefined) {
                $(this).datagrid('selectRow', editIndex);
            }
        },
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridLocBatOrdLinkFix', dataGridOption);
}

//容积规则列表
function InitGridLocBatCub() {
    var columns = [
        [
            { field: 'plbatCubId', title: '容积规则Id', width: 80, hidden: true },
            {
                field: 'batNo',
                title: '批次',
                width: 180,
                editor: GridCmbBatNo
            },
            {
                field: 'minCub',
                title: '下限(ml)',
                width: 120,
                align: 'right',
                halign: 'left',
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false
                    }
                }
            },
            {
                field: 'maxCub',
                title: '上限(ml)',
                width: 120,
                align: 'right',
                halign: 'left',
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryLocBatCub'
        },
        columns: columns,
        rownumbers: false,
        toolbar: '#gridLocBatCubBar',
        onClickRow: function (rowIndex, rowData) {
            var editIndex = $(this).datagrid('options').editIndex;
            if (editIndex != undefined) {
                $(this).datagrid('selectRow', editIndex);
            }
        },
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridLocBatCub', dataGridOption);
}
/// 顺序规则列表
function InitGridLocBatSort() {
    var columns = [
        [
            { field: 'rowID', title: '顺序规则Id', width: 80, hidden: true },
            {
                field: 'type',
                title: '类型',
                width: 150,
                editor: PIVAS.GridComboBox.Init(
                    {
                        data: {
                            data: [
                                {
                                    RowId: 'User.INCItm',
                                    Description: '药品'
                                },
                                {
                                    RowId: 'User.DHCPHCPivaCat',
                                    Description: '配液小类'
                                }
                            ]
                        }
                    },
                    {
                        required: true,
                        editable: false,
                        panelHeight: 'auto',
                        onSelect: function () {
                            ReloadSortPointer();
                        }
                    }
                ),
                descField: 'typeDesc',
                formatter: function (value, row, index) {
                    return row.typeDesc;
                }
            },
            {
                field: 'pointer',
                title: '类型值',
                width: 400,
                descField: 'pointerDesc',
                formatter: function (value, row, index) {
                    return row.pointerDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        selectOnNavigation: false,
                        valueField: 'RowId',
                        textField: 'Description',
                        required: true,
                        url: PointerUrl,
                        mode: 'remote',
                        onBeforeLoad: function (param) {
                            var $grid = $('#gridLocBatSort');
                            var gridSel = $grid.datagrid('getSelected');
                            if (gridSel) {
                                var editIndex = $grid.datagrid('options').editIndex;
                                if (editIndex === undefined) {
                                    param.type = gridSel.type;
                                    param.pointer = gridSel.pointer;
                                } else {
                                    var typeEd = $grid.datagrid('getEditor', {
                                        index: editIndex,
                                        field: 'type'
                                    });
                                    var pointerEd = $grid.datagrid('getEditor', {
                                        index: editIndex,
                                        field: 'pointer'
                                    });
                                    param.type = $(typeEd.target).combobox('getValue');
                                    param.pointer = $(pointerEd.target).combobox('getValue');
                                }
                            }
                            param.loc = $('#cmbPivaLoc').combobox('getValue');
                            console.log(param);
                        }
                    }
                }
            },
            { field: 'sortCode', title: '顺序', width: 75, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryLocBatSort'
        },
        columns: columns,
        rownumbers: true,
        pagination: false,
        toolbar: '#gridLocBatSortBar',
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
        },
        onDblClickCell: function (rowIndex, field, value) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex
            });
            var editIndex = $(this).datagrid('options').editIndex;
            if (editIndex == rowIndex) {
                ReloadSortPointer('Grid');
            }
        },
        onLoadSuccess: function () {
            $(this).datagrid('options').editIndex = undefined;
        },
        onRowContextMenu: function (e, rowIndex, rowData) {
            e.preventDefault(); //阻止向上冒泡
            $(this).datagrid('endEditing');

            if ($(this).datagrid('options').editIndex == undefined) {
                //var field = $(e.target).closest("td").attr("field");
                $(this).datagrid('selectRow', rowIndex);
                $('#gridLocBatSortMenu').menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridLocBatSort', dataGridOption);
}

/// 保存病区规则子表
function SaveLocBatItm() {
    var gridLocBatSel = $('#gridLocBat').datagrid('getSelected');
    if (gridLocBatSel == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选中左侧病区规则记录',
            type: 'alert'
        });
        return;
    }
    var gridId = '';
    var inputData = '';
    var incParams = '';
    var incFixParams = '';
    var insFixParams = '';
    var tabTitle = $('#tabsBatchRulesWard').tabs('getSelected').panel('options').title;
    switch (tabTitle) {
        case '药品顺序规则':
            gridId = 'gridLocBatInc';
            $('#gridLocBatInc').datagrid('endEditing');
            var gridChanges = $('#gridLocBatInc').datagrid('getChanges');
            var gridChangeLen = gridChanges.length;
            if (gridChangeLen == 0) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '没有需要保存的数据',
                    type: 'alert'
                });
                return;
            }
            var incParams = '';
            for (var i = 0; i < gridChangeLen; i++) {
                var iData = gridChanges[i];
                var params = iData.incRowId || '';
                params = params + '!!' + '' + '!!' + '';
                inputData = inputData == '' ? params : inputData + '|@|' + params;
            }
            break;
        case '药品固定规则':
            gridId = 'gridLocBatIncFix';

            if (ValidateGridEdit($('#' + gridId)) === false) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '请先完成录入必填信息',
                    type: 'alert'
                });
                return;
            }
            $('#gridLocBatIncFix').datagrid('endEditing');
            var gridChanges = $('#gridLocBatIncFix').datagrid('getChanges');
            var gridChangeLen = gridChanges.length;
            if (gridChangeLen == 0) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '没有需要保存的数据',
                    type: 'alert'
                });
                return;
            }
            var incParams = '';
            for (var i = 0; i < gridChangeLen; i++) {
                var iData = gridChanges[i];
                var params = (iData.incRowId || '') + '^' + (iData.batNo || '');
                params = '' + '!!' + params + '!!' + '';
                inputData = inputData == '' ? params : inputData + '|@|' + params;
            }
            break;
        case '用法固定规则':
            gridId = 'gridLocBatInsFix';
            if (ValidateGridEdit($('#' + gridId)) === false) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '请先完成录入必填信息',
                    type: 'alert'
                });
                return;
            }
            $('#gridLocBatInsFix').datagrid('endEditing');
            var gridChanges = $('#gridLocBatInsFix').datagrid('getChanges');
            var gridChangeLen = gridChanges.length;
            if (gridChangeLen == 0) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '没有需要保存的数据',
                    type: 'alert'
                });
                return;
            }
            var incParams = '';
            for (var i = 0; i < gridChangeLen; i++) {
                var iData = gridChanges[i];
                var params = (iData.instrucId || '') + '^' + (iData.batNo || '');
                params = '' + '!!' + '' + '!!' + params;
                inputData = inputData == '' ? params : inputData + '|@|' + params;
            }
            break;
        case '配液大类规则':
            gridId = 'gridLocBatOrdLinkFix';
            if (ValidateGridEdit($('#' + gridId)) === false) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '请先完成录入必填信息',
                    type: 'alert'
                });
                return;
            }
            $('#gridLocBatOrdLinkFix').datagrid('endEditing');
            var gridChanges = $('#gridLocBatOrdLinkFix').datagrid('getChanges');
            var gridChangeLen = gridChanges.length;
            if (gridChangeLen == 0) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '没有需要保存的数据',
                    type: 'alert'
                });
                return;
            }
            var incParams = '';
            for (var i = 0; i < gridChangeLen; i++) {
                var iData = gridChanges[i];
                var params = (iData.ordLink || '') + '^' + (iData.batNo || '') + '^' + (iData.inLiquidFlag || '');
                params = '' + '!!' + '' + '!!' + '' + '!!' + params;
                inputData = inputData == '' ? params : inputData + '|@|' + params;
            }
            break;
        default:
            break;
    }
    var plBatId = gridLocBatSel.plbatId;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'SavePIVALocBatItmMulti', plBatId, inputData);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'warning');
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '保存成功',
            type: 'success'
        });
    }
    $('#' + gridId).datagrid('query', {});
}

//获取药品顺序规则列表
function QueryLocBatInc() {
    NeedSelRow = '';
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    var plbatId = '';
    if (gridSelect) {
        plbatId = gridSelect.plbatId || '';
    }
    $('#gridLocBatInc').datagrid('query', {
        inputStr: 'Inc' + '^' + plbatId
    });
}
/// 删除病区规则子表
function DeleteLocBatItm() {
    var tabTitle = $('#tabsBatchRulesWard').tabs('getSelected').panel('options').title;
    var gridId = '';
    switch (tabTitle) {
        case '药品顺序规则':
            gridId = 'gridLocBatInc';
            break;
        case '药品固定规则':
            gridId = 'gridLocBatIncFix';
            break;
        case '用法固定规则':
            gridId = 'gridLocBatInsFix';
            break;
        case '配液大类规则':
            gridId = 'gridLocBatOrdLinkFix';
            break;
        default:
            break;
    }
    var gridSelect = $('#' + gridId).datagrid('getSelected');
    if (gridSelect == '' || gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var plbatItmId = gridSelect.plbatItmId || '';
            if (plbatItmId == '') {
                var rowIndex = $('#' + gridId).datagrid('getRowIndex', gridSelect);
                $('#' + gridId).datagrid('deleteRow', rowIndex);
                $('#' + gridId).datagrid('options').editIndex = undefined;
            } else {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'DeletePIVALocBatItm', plbatItmId);
                $('#' + gridId).datagrid('query', {});
            }
            DHCPHA_HUI_COM.Msg.popover({
                msg: '删除成功',
                type: 'success'
            });
        }
    });
}

/// 查询药品固定规则列表
function QueryLocBatIncFix() {
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    var plbatId = '';
    if (gridSelect) {
        plbatId = gridSelect.plbatId || '';
    }
    $('#gridLocBatIncFix').datagrid('query', {
        inputStr: 'IncFix' + '^' + plbatId
    });
}

function QueryLocBatInsFix() {
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    var plbatId = '';
    if (gridSelect) {
        plbatId = gridSelect.plbatId || '';
    }
    $('#gridLocBatInsFix').datagrid('query', {
        inputStr: 'InsFix' + '^' + plbatId
    });
}
function QueryLocBatOrdLinkFix() {
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    var plbatId = '';
    if (gridSelect) {
        plbatId = gridSelect.plbatId || '';
    }
    $('#gridLocBatOrdLinkFix').datagrid('query', {
        inputStr: 'OrdLinkFix' + '^' + plbatId
    });
}

/// 增加子表内容
function AddNewRowLocBatItm() {
    var tabTitle = $('#tabsBatchRulesWard').tabs('getSelected').panel('options').title;
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    if (gridSelect == '' || gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选中左侧病区规则记录',
            type: 'alert'
        });
        return;
    }
    var plbatId = gridSelect.plbatId || '';
    if (plbatId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选中左侧病区规则记录',
            type: 'alert'
        });
        return;
    }
    switch (tabTitle) {
        case '药品顺序规则':
            $('#gridLocBatInc').datagrid('addNewRow', {
                editField: 'incRowId'
            });
            break;
        case '药品固定规则':
            $('#gridLocBatIncFix').datagrid('addNewRow', {
                editField: 'incRowId'
            });
            break;
        case '用法固定规则':
            $('#gridLocBatInsFix').datagrid('addNewRow', {
                editField: 'instrucId'
            });
            break;
        case '配液大类规则':
            $('#gridLocBatOrdLinkFix').datagrid('addNewRow', {
                editField: 'ordLink'
            });
            break;
        case '容积规则':
            $('#gridLocBatCub').datagrid('addNewRow', {
                editField: 'batNo'
            });
            break;
        case '顺序规则':
            $('#gridLocBatSort').datagrid('addNewRow', {
                editField: 'type'
            });
            break;
        default:
            break;
    }
}
/// 查询容积规则
function QueryLocBatCub() {
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    var plbatId = '';
    if (gridSelect) {
        plbatId = gridSelect.plbatId || '';
    }
    $('#gridLocBatCub').datagrid('query', {
        inputStr: plbatId
    });
}
/// 保存容积规则
function SaveLocBatCub() {
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    if (gridSelect == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选中左侧病区规则记录',
            type: 'alert'
        });
        return;
    }
    var plbatId = gridSelect.plbatId;
    $('#gridLocBatCub').datagrid('endEditing');
    var gridChanges = $('#gridLocBatCub').datagrid('getChanges');
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
        var maxCub = iData.maxCub || '';
        var minCub = iData.minCub || '';
        var batNo = iData.batNo || '';
        if (batNo == '') {
            $.messager.alert('提示', '批次不能为空', 'warning');
            return;
        }
        var params = plbatId + '^' + minCub + '^' + maxCub + '^' + batNo;
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'SaveLocBatCubageMulti', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal == '-1') {
        $.messager.alert('提示', saveInfo, 'warning');
    } else if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'error');
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '保存成功',
            type: 'success'
        });
    }
    $('#gridLocBatCub').datagrid('query', {});
}

/// 删除容积规则
function DeleteLocBatCub() {
    var gridSelect = $('#gridLocBatCub').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var plbatCubId = gridSelect.plbatCubId || '';
            if (plbatCubId == '') {
                var rowIndex = $('#gridLocBatCub').datagrid('getRowIndex', gridSelect);
                $('#gridLocBatCub').datagrid('deleteRow', rowIndex);
                $('#gridLocBatCub').datagrid('options').editIndex = undefined;
            } else {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'DeleteLocBatCubage', plbatCubId);
                $('#gridLocBatCub').datagrid('query', {});
            }
            DHCPHA_HUI_COM.Msg.popover({
                msg: '删除成功',
                type: 'success'
            });
        }
    });
}

// 移动药品顺序
function MoveInc(moveFlag) {
    if ($('#gridLocBatInc').datagrid('options').editIndex != undefined) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先保存或者删除正在编辑的记录',
            type: 'alert'
        });
        return;
    }

    var gridSelect = $('#gridLocBatInc').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要移动的记录',
            type: 'alert'
        });
        return;
    }
    var rowCnt = $('#gridLocBatInc').datagrid('getRows').length;
    var origIndex = $('#gridLocBatInc').datagrid('getRowIndex', gridSelect);
    var index = parseInt(origIndex) + parseInt(moveFlag);
    if (index < 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '无法上移',
            type: 'alert'
        });
        return;
    } else if (index + 1 > rowCnt) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '无法下移',
            type: 'alert'
        });
        return;
    }
    var origPlbItm = $('#gridLocBatInc').datagrid('getData').rows[origIndex].plbatItmId;
    var plbItm = $('#gridLocBatInc').datagrid('getData').rows[index].plbatItmId;
    var inputStr = origPlbItm + '^' + plbItm;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'MovePIVALocBatItm', origPlbItm, plbItm);
    var saveArr = saveRet.split('^');
    if (saveArr[0] == -1) {
        $.messager.alert('提示', saveArr[1], 'warning');
    } else if (saveArr[0] < -1) {
        $.messager.alert('提示', saveArr[1], 'error');
    }
    NeedSelRow = index;
    $('#gridLocBatInc').datagrid('query', {});
}

// 移动药品顺序
function MoveSort(moveFlag) {
    var $grid = $('#gridLocBatSort');
    if ($grid.datagrid('options').editIndex != undefined) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先保存或者删除正在编辑的记录',
            type: 'alert'
        });
        return;
    }

    var gridSelect = $grid.datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要移动的记录',
            type: 'alert'
        });
        return;
    }
    var rowCnt = $grid.datagrid('getRows').length;
    var origIndex = $grid.datagrid('getRowIndex', gridSelect);
    var index = parseInt(origIndex) + parseInt(moveFlag);
    if (index < 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '无法上移',
            type: 'alert'
        });
        return;
    } else if (index + 1 > rowCnt) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '无法下移',
            type: 'alert'
        });
        return;
    }
    var origData = JSON.parse(JSON.stringify($grid.datagrid('getRows')[origIndex])); // 对象为引用, 需要深拷贝
    var newData = JSON.parse(JSON.stringify($grid.datagrid('getRows')[index]));
    if (!origData.rowID) {
        origData.rowID = '';
    }
    if (!newData.rowID) {
        newData.rowID = '';
    }
    $grid.datagrid('updateRow', {
        index: origIndex,
        row: newData
    });
    $grid.datagrid('updateRow', {
        index: index,
        row: origData
    });
    $grid.datagrid('selectRow', index);
}

function DeleteLocBatSort() {
    var $grid = $('#gridLocBatSort');
    var gridSelect = $grid.datagrid('getSelected');
    if (gridSelect == '' || gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var rowID = gridSelect.rowID || '';
            if (rowID !== '') {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'DeleteLocBatSort', rowID);
            }
            var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
            $grid.datagrid('deleteRow', rowIndex);
            $grid.datagrid('options').editIndex = undefined;
            DHCPHA_HUI_COM.Msg.popover({
                msg: '删除成功',
                type: 'success'
            });
        }
    });
}
function SaveLocBatSort() {
    var gridLocBatSel = $('#gridLocBat').datagrid('getSelected');
    if (gridLocBatSel == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选中左侧病区规则记录',
            type: 'alert'
        });
        return;
    }
    var palbat = gridLocBatSel.plbatId || '';
    if (palbat == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先保存左侧病区规则记录',
            type: 'alert'
        });
        return;
    }
    var $grid = $('#gridLocBatSort');
    if (ValidateGridEdit($grid) === false) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先完成录入必填信息',
            type: 'alert'
        });
        return;
    }
    $grid.datagrid('endEditing');
    var gridRows = $grid.datagrid('getRows');
    var length = gridRows.length;
    if (length === 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    var repeatObj = PHA_UTIL.Array.GetRepeat(gridRows, ['type', 'pointer']);

    if (typeof repeatObj.pos === 'number') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '第' + (repeatObj.pos + 1) + '、' + (repeatObj.repeatPos + 1) + '行数据重复',
            type: 'alert'
        });
        return;
    }
    var inputData = '';
    for (var i = 0; i < length; i++) {
        var iData = gridRows[i];
        var params = [palbat, iData.rowID, iData.type, iData.pointer, i].join('^');
        inputData = inputData == '' ? params : inputData + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'SaveLocBatSortMulti', inputData);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal == '-1') {
        $.messager.alert('提示', saveInfo, 'warning');
    } else if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'error');
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '保存成功',
            type: 'success'
        });
    }
    QueryLocBatSort();
}
function ReloadSortPointer(LoadType) {
    LoadType = LoadType || '';
    var $grid = $('#gridLocBatSort');
    // 此处以处于编辑
    var editIndex = $grid.datagrid('options').editIndex;
    var typeEd = $grid.datagrid('getEditor', {
        index: editIndex,
        field: 'type'
    });
    var pointerEd = $grid.datagrid('getEditor', {
        index: editIndex,
        field: 'pointer'
    });
    var $pointer = $(pointerEd.target);
    var $type = $(typeEd.target);
    var typeId = $type.combobox('getValue');
    var gridSelect = $grid.datagrid('getSelected');
    var pointerData = {
        RowId: gridSelect.pointer,
        Description: gridSelect.pointerDesc
    };

    $pointer.combobox('loadData', [pointerData]);
    console.log({ typeId: typeId });
    $pointer.combobox('options').url = PointerUrl + '&type=' + typeId + '&loc=' + $('#cmbPivaLoc').combobox('getValue');
    if (LoadType == '') {
        $pointer.combobox('reload');
        $pointer.combobox('clear');
    } else {
        // $autPointer.combobox("reload")
    }
}

function QueryLocBatSort() {
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    var plbatId = '';
    if (gridSelect) {
        plbatId = gridSelect.plbatId || '';
    }
    $('#gridLocBatSort').datagrid('query', {
        inputStr: plbatId
    });
}
function AddNewRowLocBatSort() {
    var id = this.id;
    var $grid = $('#gridLocBatSort');
    var selectRow = $grid.datagrid('getSelected');
    var rowIndex = $grid.datagrid('getRowIndex', selectRow);
    if (id == 'menuInsertSort') {
    } else {
        rowIndex++;
    }
    $grid
        .datagrid('insertRow', {
            index: rowIndex,
            row: {}
        })
        .datagrid('beginEditRow', {
            rowIndex: rowIndex
        });
}

function ValidateGridEdit($target) {
    var editRowIndex = $target.datagrid('options').editIndex;
    if (editRowIndex === undefined) {
        return true;
    }
    if ($target.datagrid('validateRow', editRowIndex) === false) {
        return false;
    }
    return true;
}
