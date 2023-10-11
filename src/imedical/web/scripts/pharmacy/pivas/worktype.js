/**
 * 模块:     工作组维护
 * 编写日期: 2018-03-02
 * 编写人:   QianHuanjuan
 */
var GridCmbInstruc, GridCmbConfTab, GridCmbRelation;
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var PrtDictData = {
    rows: [
        {
            prtWayDesc: '病区'
        },
        {
            prtWayDesc: '批次'
        },
        {
            prtWayDesc: '床号'
        },
        {
            prtWayDesc: '登记号'
        },
        {
            prtWayDesc: '主药'
        },
        {
            prtWayDesc: '溶媒'
        },
        {
            prtWayDesc: '数量'
        },
        {
            prtWayDesc: '配液大类'
        }
    ]
};
var CanMultiAddData = ['主药', '溶媒', '药品', '辅药', '数量'];
var QtyNeedLinkData = ['主药', '溶媒', '药品', '辅药'];
$(function () {
    InitDict();
    InitGridDict();
    InitGridWorkType();
    InitGridWorkTypeItm();
    InitGridPrtDict();
    InitGridPrtWay();
    $('#btnAddWT,#btnEditWT').on('click', function () {
        ShowDiagWT(this);
    });
    $('#btnDeleteWT').on('click', DeleteWTHandler);
    $('#btnAdd').on('click', AddNewRow);
    $('#btnSave').on('click', SaveWorkTypeItm);
    $('#btnDelete').on('click', DeleteHandler);
    $('#btnFind').on('click', function () {
        $('#gridWorkType').datagrid('query', {
            inputStr: $('#cmbPivaLoc').combobox('getValue')
        });
    });
    PHA_UX.Translate({ buttonID: 'btnTranslate', gridID: 'gridWorkType', idField: 'wtId', sqlTableName: 'PIVA_WorkType' });

    $('.dhcpha-win-mask').remove();
});

function InitDict() {
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaLoc',
            Type: 'PivaLoc'
        },
        {
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('select', datas[i].RowId);
                    }
                }
            },
            onSelect: function (selData) {
                $('#gridWorkType').datagrid('query', {
                    inputStr: selData.RowId
                });
            },
            placeholder: '配液中心...',
            width: 200
        }
    );
}

function InitGridDict() {
    // 配液中心
    GridCmbPivaLoc = PIVAS.GridComboBox.Init(
        {
            Type: 'PivaLoc',
            QueryParams: {
                inputStr: SessionLoc
            }
        },
        {
            required: true
        }
    );

    // 用法
    GridCmbInstruc = PIVAS.GridComboBox.Init(
        {
            Type: 'Instruc'
        },
        {
            required: false,
            editable: true
        }
    );
    // 配置台
    GridCmbConfTab = PIVAS.GridComboBox.Init(
        {
            Type: 'PIVAConfigTable',
            QueryParams: {
                inputStr: SessionLoc
            }
        },
        {
            required: true,
            editable: false,
            onBeforeLoad: function (param) {
                param.inputStr = $('#cmbPivaLoc').combobox('getValue');
            }
        }
    );
    // 关系
    GridCmbRelation = PIVAS.GridComboBox.Init(
        {
            Type: 'MoreOrLess'
        },
        {
            required: false,
            editable: true,
            panelHeight: 'auto'
        }
    );
}
/// 工作组列表
function InitGridWorkType() {
    //定义columns
    var columns = [
        [
            {
                field: 'wtId',
                title: '工作组id',
                width: 50,
                hidden: true
            },
            {
                field: 'locDesc',
                title: '工作组科室',
                width: 150,
                sortable: 'true',
                hidden: true
            },
            {
                field: 'wtOrdNum',
                title: '优先级',
                width: 65,
                align: 'center',
                sortable: 'true'
            },
            {
                field: 'wtCode',
                title: '代码',
                width: 100,
                sortable: 'true'
            },
            {
                field: 'wtDesc',
                title: '名称',
                width: 100
            },
            {
                field: 'prtWayDesc',
                title: '打印方式',
                width: 300,
                sortable: 'true',
                formatter: function (value, row, index) {
                    // 不这么写 > 会显示为 <,原因待排查
                    return value;
                }
            },
            {
                field: 'wtUseFlag',
                title: '使用',
                width: 50,
                halign: 'center',
                align: 'center',
                sortable: true,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PIVAS.Grid.CSS.CHNYes;
                    } else {
                        return PIVAS.Grid.CSS.CHNNo;
                    }
                }
            },
            {
                field: 'wtDefault',
                title: '默认',
                width: 50,
                halign: 'center',
                align: 'center',
                sortable: true,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
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
            ClassName: 'web.DHCSTPIVAS.WorkType',
            QueryName: 'WorkType',
            inputStr: '^' + session['LOGON.HOSPID']
        },
        fitColumns: true,
        columns: columns,
        rownumbers: false,
        nowrap: true,
        toolbar: '#gridWorkTypeBar',
        onLoadSuccess: function (data) {
            $('#gridWorkTypeItm').datagrid('clear');
        },
        onClickRow: function (rowIndex, rowData) {
            QueryGridWorkTypeItm();
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridWorkType', dataGridOption);
}

/**
 * 保存工作组
 */
function SaveWorkType() {
    var title = $('#gridWorkTypeWin').panel('options').title;
    var ifAdd = $.data($('#gridWorkTypeWin')[0], 'oprateType') === 'add' ? true : false;
    var locId = $('#cmbPivaLoc').combobox('getValue') || '';
    if (locId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选择配液中心',
            type: 'alert'
        });
        return;
    }
    var wtId = '';
    if (ifAdd == false) {
        var gridSelect = $('#gridWorkType').datagrid('getSelected');
        wtId = gridSelect.wtId || '';
    }
    var wtCode = $('#wtCode').val() || '';
    var wtDesc = $('#wtDesc').val() || '';
    var wtDefault = $('#wtDefault').checkbox('getValue') == true ? 'Y' : 'N';
    var wtUse = $('#wtUse').checkbox('getValue') == true ? 'Y' : 'N';
    var wtOrdNum = $('#wtOrdNum').val() || '';
    if (wtCode == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '代码为空',
            type: 'alert'
        });
        return;
    }
    if (wtDesc == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '名称为空',
            type: 'alert'
        });
        return;
    }
    if (wtOrdNum == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '优先级为空',
            type: 'alert'
        });
        return;
    }
    var gridPrtWayRows = $('#gridPrtWay').datagrid('getRows');
    var gridLen = gridPrtWayRows.length;
    if (gridLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '标签打印顺序为空',
            type: 'alert'
        });
        return;
    }
    var prtWayArr = [];
    for (var i = 0; i < gridLen; i++) {
        var rowData = gridPrtWayRows[i];
        var prtWayDesc = rowData.prtWayDesc;
        if (prtWayDesc == '数量') {
            var chkPre = '';
            var chkNext = '';
            var preI = i - 1;
            var nextI = i + 1;
            if (preI >= 0) {
                var preWayDesc = gridPrtWayRows[preI].prtWayDesc;
                if (QtyNeedLinkData.indexOf(preWayDesc) >= 0) {
                    chkPre = 'Y';
                }
            }
            if (nextI < gridLen) {
                var nextWayDesc = gridPrtWayRows[nextI].prtWayDesc;
                if (QtyNeedLinkData.indexOf(nextWayDesc) >= 0) {
                    chkNext = 'Y';
                }
            }
            if (chkPre == '' && chkNext == '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '请核实第' + (i + 1) + '行,其数量的前或后必须为主药、溶媒的一种',
                    type: 'alert'
                });
                return;
            }
        }
        // 验证数量前或后必须有药品
        prtWayArr.push(prtWayDesc);
    }
    var prtWayStr = prtWayArr.join('>');

    var inputData = wtId + '^' + wtCode + '^' + wtDesc + '^' + locId + '^' + prtWayStr + '^' + wtUse + '^' + wtDefault + '^' + wtOrdNum;
    var saveRet = $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.WorkType',
            MethodName: 'Save',
            inputData: inputData,
            dataType: 'text'
        },
        false
    );
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'warning');
        return;
    }
    $('#gridWorkTypeWin').window('close');
    $('#gridWorkType').datagrid('reload');
}

function DeleteWTHandler() {
    var gridSelect = $('#gridWorkType').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var wtId = gridSelect.wtId || '';
            if (wtId == '') {
                var rowIndex = $('#gridWorkType').datagrid('getRowIndex', gridSelect);
                $('#gridWorkType').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.WorkType', 'DeleteWT', wtId);
                $('#gridWorkType').datagrid('query', {});
            }
        }
    });
}

function InitGridWorkTypeItm() {
    //定义columns
    var columns = [
        [
            {
                field: 'wtItmId',
                title: '工作组规则id',
                width: 80,
                align: 'left',
                hidden: true
            },
            {
                field: 'wtId',
                title: '工作组id',
                width: 80,
                align: 'left',
                hidden: true
            },
            {
                field: 'confTabDesc',
                title: '配置台名称',
                width: 80,
                halign: 'center',
                align: 'left',
                hidden: true
            },
            {
                field: 'confTabId',
                title: '配置台',
                width: 150,
                editor: GridCmbConfTab,
                descField: 'confTabDesc',
                formatter: function (value, rowData, rowIndex) {
                    return rowData.confTabDesc;
                }
            },
            {
                field: 'instrDesc',
                title: '用法名称',
                width: 80,
                align: 'center',
                hidden: true
            },
            {
                field: 'instrId',
                title: '用法',
                width: 150,
                editor: GridCmbInstruc,
                descField: 'instrDesc',
                formatter: function (value, rowData, rowIndex) {
                    return rowData.instrDesc;
                }
            },
            {
                field: 'wtRelation',
                title: '关系',
                width: 75,
                halign: 'left',
                align: 'left',
                editor: GridCmbRelation,
                descField: 'wtRelationDesc',
                formatter: function (value, rowData, rowIndex) {
                    return rowData.wtRelationDesc;
                }
            },
            {
                field: 'wtLiquid',
                title: '液体量(ml)',
                width: 80,
                halign: 'left',
                align: 'right',
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
            ClassName: 'web.DHCSTPIVAS.WorkType',
            QueryName: 'WorkTypeItm'
        },
        columns: columns,
        rownumbers: false,
        fitColumns: true,
        toolbar: '#gridWorkTypeItmBar',
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'confTabId'
            });
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridWorkTypeItm', dataGridOption);
}

function AddNewRow() {
    var gridWTSelect = $('#gridWorkType').datagrid('getSelected');
    if (gridWTSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选中需要增加规则的工作组记录',
            type: 'alert'
        });
        return;
    }
    var wtId = gridWTSelect.wtId || '';
    if (wtId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先保存工作组',
            type: 'alert'
        });
        return;
    }
    $('#gridWorkTypeItm').datagrid('addNewRow', {
        editField: 'confTabId'
    });
}

//获取工作组规则列表
function QueryGridWorkTypeItm() {
    var gridSelect = $('#gridWorkType').datagrid('getSelected');
    var wtId = gridSelect.wtId;
    $('#gridWorkTypeItm').datagrid('query', {
        inputStr: wtId
    });
}

function DeleteHandler() {
    var gridSelect = $('#gridWorkTypeItm').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选中需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var wtItmId = gridSelect.wtItmId || '';
            if (wtItmId == '') {
                var rowIndex = $('#gridWorkTypeItm').datagrid('getRowIndex', gridSelect);
                $('#gridWorkTypeItm').datagrid('deleteRow', rowIndex);
            } else {
                var ret = tkMakeServerCall('web.DHCSTPIVAS.WorkType', 'Delete', wtItmId);
                QueryGridWorkTypeItm();
            }
        }
    });
}

function SaveWorkTypeItm() {
    var gridWTSelect = $('#gridWorkType').datagrid('getSelected');
    if (gridWTSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    var wtId = gridWTSelect.wtId || '';
    if (wtId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选择工作组',
            type: 'alert'
        });
        return;
    }
    $('#gridWorkTypeItm').datagrid('endEditing');
    var gridChanges = $('#gridWorkTypeItm').datagrid('getChanges');
    var gridRows = $('#gridWorkTypeItm').datagrid('getRows');
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
        var wtRelation = iData.wtRelation || '';
        var wtLiquid = iData.wtLiquid || '';
        var instrId = iData.instrId || '';
        var instrDesc = iData.instrDesc || '';
        if (instrId != '' && instrId == instrDesc) {
            instrId = '';
        }
        var chkMsg = '';
        if (wtRelation != '' && wtLiquid == '') {
            chkMsg = '液体量为空';
        }
        if (wtLiquid != '' && wtRelation == '') {
            chkMsg = '关系为空';
        }
        if (chkMsg != '') {
            var rowIndex = gridRows.indexOf(iData);
            DHCPHA_HUI_COM.Msg.popover({
                msg: '第' + (rowIndex + 1) + '行,' + chkMsg,
                type: 'alert'
            });
            return;
        }
        var params = (iData.wtItmId || '') + '^' + wtId + '^' + (iData.confTabId || '') + '^' + instrId + '^' + wtRelation + '^' + wtLiquid;
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.WorkType', 'SaveItm', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'warning');
    }
    QueryGridWorkTypeItm();
}

/// 工作组列表
function InitGridPrtDict() {
    //定义columns
    var columns = [
        [
            {
                field: 'prtWayDesc',
                title: '标签顺序字典',
                width: 3,
                hidden: false
            },
            {
                field: 'dictOperate',
                title: '操作',
                width: 1,
                align: 'center',
                formatter: function (value, rowData, rowIndex) {
                    return '<span onclick="AddPrtWay()" class="icon pha-icon-blue icon-add js-a-add" style="cursor:pointer"></span>';
                    return '<img title="授权" onclick="AddPrtWay()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" style="border:0px;cursor:pointer">';
                }
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        data: PrtDictData,
        pagination: false,
        columns: columns,
        rownumbers: false,
        fitColumns: true
    };
    DHCPHA_HUI_COM.Grid.Init('gridPrtDict', dataGridOption);
}
/// 工作组列表
function InitGridPrtWay() {
    //定义columns
    var columns = [
        [
            {
                field: 'prtWayDesc',
                title: '标签打印顺序',
                width: 3,
                hidden: false
            },
            {
                field: 'wayOperate',
                title: '操作',
                width: 1,
                align: 'center',
                formatter: function (value, rowData, rowIndex) {
                    return '<span onclick="DeletePrtWay() "class="icon pha-icon-blue icon-cancel js-a-delete" style="cursor:pointer" ></span>';
                    return '<img title="删除" onclick="DeletePrtWay()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">';
                }
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        data: {
            rows: []
        },
        pagination: false,
        columns: columns,
        fitColumns: true,
        onLoadSuccess: function () {
            $('#gridPrtWay').datagrid('enableDnd');
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridPrtWay', dataGridOption);
}

function ShowDiagWT(btnOpt) {
    var ifAdd = btnOpt.id.indexOf('Add') >= 0 ? true : false;
    var locId = $('#cmbPivaLoc').combobox('getValue') || '';
    if (locId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选择配液中心',
            type: 'alert'
        });
        return;
    }
    var wtId = '';
    if (ifAdd == false) {
        var gridSelect = $('#gridWorkType').datagrid('getSelected') || '';
        if (gridSelect == '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: '请先选中需要修改的工作组',
                type: 'alert'
            });
            return;
        }
        wtId = gridSelect.wtId;
    } else {
    }

    $('#gridWorkTypeWin')
        .dialog({
            title: '工作组' + btnOpt.text,
            iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
            modal: true
        })
        .dialog('open');
    $.data($('#gridWorkTypeWin')[0], 'oprateType', ifAdd ? 'add' : 'edit');

    if (ifAdd == false) {
        var jsonData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.WorkType',
                MethodName: 'SelectWorkType',
                WTId: wtId
            },
            false
        );
    } else {
        var jsonData = {
            wtCode: '',
            wtDesc: '',
            wtPrtWay: '',
            wtUse: '',
            wtDefault: '',
            wtOrdNum: ''
        };
    }
    $('#wtCode').val(jsonData.wtCode);
    $('#wtDesc').val(jsonData.wtDesc);

    $('#wtOrdNum').val(jsonData.wtOrdNum);
    $('#wtDefault').checkbox('setValue', jsonData.wtDefault == 'Y' ? true : false);
    $('#wtUse').checkbox('setValue', jsonData.wtUse == 'Y' ? true : false);
    var wtPrtWayRowsData = [];
    var wtPrtWay = jsonData.wtPrtWay;
    if (wtPrtWay != '') {
        var wtPrtWayArr = wtPrtWay.split('>');
        for (var i = 0; i < wtPrtWayArr.length; i++) {
            wtPrtWayRowsData.push({
                prtWayDesc: wtPrtWayArr[i]
            });
        }
    }
    var wtPrtWayData = {
        rows: wtPrtWayRowsData
    };
    $('#gridPrtWay').datagrid('loadData', wtPrtWayData);
}

function AddPrtWay() {
    var $target = $(event.target);
    var rowIndex = $target.closest('tr[datagrid-row-index]').attr('datagrid-row-index');
    var rowData = $('#gridPrtDict').datagrid('getRows')[rowIndex];
    var prtWayDesc = rowData.prtWayDesc;
    var gridPrtWayRows = $('#gridPrtWay').datagrid('getRows');
    for (var i = 0; i < gridPrtWayRows.length; i++) {
        var tmpPrtWay = gridPrtWayRows[i].prtWayDesc;
        if (tmpPrtWay == prtWayDesc && CanMultiAddData.indexOf(prtWayDesc) < 0) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: '已存在该顺序,不需要再增加',
                type: 'alert'
            });
            return;
        }
    }
    var newData = {
        prtWayDesc: prtWayDesc
    };
    $('#gridPrtWay').datagrid('appendRow', newData);
    $('#gridPrtWay').datagrid('loadData', $('#gridPrtWay').datagrid('getRows'));
}

function DeletePrtWay() {
    var $target = $(event.target);
    var rowIndex = $target.closest('tr[datagrid-row-index]').attr('datagrid-row-index');
    // var rowData = $("#gridPrtWay").datagrid("getRows")[rowIndex];
    $('#gridPrtWay').datagrid('deleteRow', rowIndex);
    $('#gridPrtWay').datagrid('loadData', $('#gridPrtWay').datagrid('getRows'));
}

