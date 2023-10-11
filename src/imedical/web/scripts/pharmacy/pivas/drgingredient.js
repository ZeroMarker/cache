/**
 * 模块:     药品药学成分维护
 * 编写日期: 2018-02-23
 * 编写人:   yunhaibao
 */
var HospId = session['LOGON.HOSPID'];
var GridCmbIngredient;
var GridCmbCtUom;
$(function () {
    InitHospCombo();
    InitDict();
    InitGridDict();
    InitGridDrug();
    InitGridDrugIngred();
    $('#btnAdd').on('click', function () {
        AddNewRow();
    });
    $('#btnSave').on('click', function () {
        Save();
    });
    $('#btnFind').on('click', QueryGridDrug);
    $('#btnDelete').on('click', DeleteHandler);
    $('#txtAlias').on('keypress', function (event) {
        if (event.keyCode == '13') {
            QueryGridDrug();
        }
    });
    $('.dhcpha-win-mask').remove();
});

function InitDict() {
    // 类组
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbCatGrp',
            Type: 'LocStkCatGrp'
        },
        {
            editable: false,
            placeholder: $g('类组') + '...',
            width: 125,
            onSelect: function (data) {
                $('#cmbStkCat').combobox('reload', $URL + '?ResultSetType=array' + '&ClassName=web.DHCSTPIVAS.Dictionary&QueryName=INCSCStkGrp' + '&inputStr=' + data.RowId || '');
                $('#cmbStkCat').combobox('clear');
            },
            onBeforeLoad: function (param) {
                param.inputStr = $('#cmbCatGrp').combobox('getValue') || '';
                param.HospId = HospId;
            }
        }
    );
    // 库存分类
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbStkCat',
            Type: 'StkCat'
        },
        {
            placeholder: $g('库存分类') + '...',
            onSelect: function (e, value) {
                QueryGridDrug();
            },
            onBeforeLoad: function (param) {
                param.inputStr = $('#cmbCatGrp').combobox('getValue') || '';
                param.HospId = HospId;
            }
        }
    );
}
// 初始化表格内字典
function InitGridDict() {
    // 成分
    GridCmbIngredient = PIVAS.GridComboBox.Init(
        {
            Type: 'Ingredient'
        },
        {
            required: true,
            onBeforeLoad: function (param) {
                param.HospId = HospId;
            }
        }
    );
    // 含量单位
    GridCmbCtUom = PIVAS.GridComboBox.Init(
        {
            Type: 'DrugUom'
        },
        {
            panelHeight: 'auto',
            required: true,
            editable: false,
            onBeforeLoad: function (param) {
                var gridSelect = $('#gridDrug').datagrid('getSelected');
                var inputStr = '';
                if (gridSelect) {
                    inputStr = gridSelect.phcdfId || '';
                }
                param.inputStr = inputStr;
            }
        }
    );
}
/// 药品列表
function InitGridDrug() {
    //定义columns
    var columns = [
        [
            {
                field: 'phcdfId',
                title: '药学id',
                width: 50,
                hidden: true
            },
            {
                field: 'incId',
                title: '药品id',
                width: 50,
                hidden: true
            },
            {
                field: 'incCode',
                title: '药品代码',
                width: 100
            },
            {
                field: 'incDesc',
                title: '药品名称',
                width: 300
            },
            {
                field: 'incSpec',
                title: '规格',
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.DrgIngredient',
            QueryName: 'IncItm',
            inputStr: '^^'
        },
        pageNumber: 1,
        columns: columns,
        toolbar: '#gridDrugBar',
        fitColumns: true,
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                QueryGridDrugIngred();
            }
        },
        onLoadSuccess: function () {
            $('#gridDrugIngred').datagrid('clear');
        },
        onBeforeLoad: function (param) {
            param.HospId = HospId;
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridDrug', dataGridOption);
}

function InitGridDrugIngred() {
    //定义columns
    var columns = [
        [
            {
                field: 'drgIngredId',
                title: '药品成分id',
                width: 50,
                hidden: true
            },
            {
                field: 'ingredCode',
                title: '成分代码',
                width: 150
            },
            {
                field: 'ingredDesc',
                title: '成分名称描述',
                width: 150,
                hidden: true
            },
            {
                field: 'ingredId',
                title: '成分名称',
                width: 150,
                descField: 'ingredDesc',
                editor: GridCmbIngredient,
                formatter: function (value, row, index) {
                    return row.ingredDesc;
                }
            },
            {
                field: 'drgIngredQty',
                title: '成分量(每单位)',
                width: 125,
                align: 'right',
                editor: {
                    type: 'numberbox',
                    options: {
                        required: true,
                        precision: 8
                    }
                }
            },
            {
                field: 'ingredUomDesc',
                title: '成分单位',
                halign: 'right',
                align: 'right',
                width: 100,
                hidden: true
            },
            {
                field: 'eveFlag',
                halign: 'center',
                align: 'center',
                title: '/',
                width: 30
            },
            {
                field: 'drgIngredUomDesc',
                title: '含量单位描述',
                width: 150,
                hidden: true
            },
            {
                field: 'drgIngredUom',
                title: '每单位',
                width: 100,
                descField: 'drgIngredUomDesc',
                editor: GridCmbCtUom,
                formatter: function (value, row, index) {
                    return row.drgIngredUomDesc;
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.DrgIngredient',
            QueryName: 'PHCDrgIngredient'
        },
        columns: columns,
        toolbar: '#gridDrugIngredBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'ingredId'
                });
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridDrugIngred', dataGridOption);
}
/// 增加一行
function AddNewRow() {
    var drugSelect = $('#gridDrug').datagrid('getSelected');
    if (drugSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('请先选中需要增加成分药品记录'),
            type: 'alert'
        });
        return;
    }
    $('#gridDrugIngred').datagrid('addNewRow', {
        editField: 'ingredId'
    });
}

/// 查询药品列表
function QueryGridDrug() {
    var alias = $('#txtAlias').val();
    var catGrp = $('#cmbCatGrp').combobox('getValue');
    var stkCat = $('#cmbStkCat').combobox('getValue');
    var params = alias + '^' + catGrp + '^' + stkCat;
    $('#gridDrug').datagrid('query', {
        inputStr: params
    });
    $('#txtAlias').val('');
}

//获取成分列表
function QueryGridDrugIngred() {
    var gridSelect = $('#gridDrug').datagrid('getSelected');
    var phcdfId = gridSelect.phcdfId;
    $('#gridDrugIngred').datagrid('rejectChanges').datagrid('query', {
        inputStr: phcdfId
    });
}

function DeleteHandler() {
    var gridSelect = $('#gridDrugIngred').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('请先选中需要删除的记录'),
            type: 'alert'
        });
        return;
    }

    $.messager.confirm($g('确认对话框'), $g('您确定删除吗？'), function (r) {
        if (r) {
            var drgIngredId = gridSelect.drgIngredId;
            if (drgIngredId == undefined || drgIngredId == '') {
                var rowIndex = $('#gridDrugIngred').datagrid('getRowIndex', gridSelect);
                $('#gridDrugIngred').datagrid('deleteRow', rowIndex);
            } else {
                var ret = tkMakeServerCall('web.DHCSTPIVAS.DrgIngredient', 'DeleteDrgIngred', gridSelect.drgIngredId);
                QueryGridDrugIngred();
            }
        }
    });
}

function Save() {
    $('#gridDrugIngred').datagrid('endEditing');
    var gridChanges = $('#gridDrugIngred').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('没有需要保存的数据'),
            type: 'alert'
        });
        return;
    }
    var gridSelect = $('#gridDrug').datagrid('getSelected');
    var phcdfId = gridSelect.phcdfId;
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params = (iData.drgIngredId || '') + '^' + phcdfId + '^' + (iData.ingredId || '') + '^' + (iData.drgIngredQty || '') + '^' + (iData.drgIngredUom || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.DrgIngredient', 'Save', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert($g('提示'), saveInfo, 'warning');
    }
    QueryGridDrugIngred();
}
function InitHospCombo() {
    var genHospObj = PIVAS.AddHospCom({ tableName: 'PHC_DrgIngredient'},{width:296});
    if (typeof genHospObj === 'object') {
        //增加选择事件
        genHospObj.options().onSelect = function (index, record) {
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                $('#cmbCatGrp').combobox('setValue', '');
                $('#cmbStkCat').combobox('setValue', '');
                $('#cmbStkCat').combobox('reload');
                QueryGridDrug();
            }
        };
    }
}
