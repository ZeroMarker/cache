/*
 * @Descripttion: 单位数量转换配置
 * @Author: yaojining
 * @Date: 2022-05-10
 */
var GLOBAL = {
    HospEnvironment: true,
    HospitalID: session['LOGON.HOSPID'],
    ConfigTableName: 'Nur_IP_UnitConversion',
    ClassName: 'NurMp.Service.InOut.Conversion',
    EditGrid: '#gridConversion'
};
var init = function () {
    initHosp(initGrid);
    initCondition();
    initGrid();
    listenEvent();
}

$(init);

/**
* @description: 查询条件
*/
function initCondition() {
    $('#cbName').combobox({
        url: $URL + '?ClassName=NurMp.Service.InOut.Conversion&QueryName=FindUnitConversion&ResultSetType=array&HospitalID=' + GLOBAL.HospitalID + '&Type=IO',
        valueField: 'Id',
        textField: 'UCDesc',
        defaultFilter: 4,
        onSelect: function (record) {
            $('#btnSearch').click();
        }
    });

}
/**
* @description: 获取类型
*/
function ckTypes() {
    var types = '';
    $("input[name='ckType']").each(function (index, obj) {
        if ($(obj).checkbox('getValue')) {
            types = !!types ? types + '^' + $(obj).val() : $(obj).val();
        }
    });
    return types;
}
/**
* @description: 初始化科室表格
*/
function initGrid() {
    var toolbar = [{
        id: 'add',
        iconCls: 'icon-add',
        text: '新增',
        handler: add
    }, {
        id: 'remove',
        iconCls: 'icon-cancel',
        text: '删除',
        handler: remove
    }, {
        id: 'save',
        iconCls: 'icon-save',
        text: '保存',
        handler: save
    }, {
        id: 'reset',
        iconCls: 'icon-reset',
        text: '刷新',
        handler: reloadGrid
    }];
    $(GLOBAL.EditGrid).datagrid({
        url: $URL,
        queryParams: {
            ClassName: GLOBAL.ClassName,
            QueryName: 'FindUnitConversion',
            HospitalID: GLOBAL.HospitalID,
            Type: ckTypes(),
            Filter: $('#cbName').combobox('getText')
        },
        columns: [[
            { field: 'UCDesc', title: '名称', align: 'left', width: 200, editor: 'text' },
            { field: 'UCCountFrom', title: '基本数量', width: 120, editor: { type: 'numberbox', options: { precision: 2 } } },
            {
                field: 'UCUnitFrom', title: '基本单位', width: 100,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: false,
                        blurValidValue: true,
                        data: [
                            { value: "mg", desc: "mg" },
                            { value: "g", desc: "g" },
                            { value: "kg", desc: "kg" },
                            { value: "ml", desc: "ml" },
                            { value: "l", desc: "l" }
                        ]
                    }
                }
            },
            { field: 'UCCountTo', title: '单位含水量', width: 120, editor: { type: 'numberbox', options: { precision: 2 } } },
            {
                field: 'UCUnitTo', title: '基本含水量单位', width: 120,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: false,
                        blurValidValue: true,
                        data: [
                            { value: "ml", desc: "ml" },
                            { value: "l", desc: "l" }
                        ]
                    }
                }
            },
            {
                field: 'UCType', title: '类型', width: 100,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: false,
                        blurValidValue: true,
                        data: [
                            { value: "I", desc: "入量" },
                            { value: "O", desc: "出量" }
                        ]
                    }
                },
                formatter: function (value, row, index) {
                    if (value == 'I') {
                        return '入量';
                    } else {
                        return '出量';
                    }
                }
            },
            { field: 'UCNote', title: '备注', width: 250, editor: 'text' },
            { field: 'Id', title: 'ID', width: 100, hidden: true }
        ]],
        toolbar: toolbar,
        nowrap: false,
        singleSelect: true,
        pagination: true,
        pageSize: 15,
        pageList: [15, 30, 50],
        onLoadSuccess: function(data) {
            initCondition();
        },
        onClickRow: singleClickRow,
        onDblClickRow: clickRow
    });
}
/**
* @description: 单击
*/
function singleClickRow(rowIndex, rowData) {
    $('#oriNum').val(rowData.UCCountFrom);
    $('#countNum').val('1');
    $('#unitName').html(rowData.UCDesc);
    var unitCount = parseFloat(rowData.UCCountTo) / parseFloat(rowData.UCCountFrom);
    $('#unitCount').html(parseFloat(unitCount));
    count();
}
/**
* @description: 新增
*/
function add() {
    append({ UCCountFrom: '100', UCUnitFrom: 'g', UCUnitTo: 'ml', UCType: 'I' });
}
/**
* @description: 删除
*/
function remove() {
    var rows = $(GLOBAL.EditGrid).datagrid('getSelections');
    if (rows.length < 1) {
        $.messager.alert("提示", "请选择要删除的数据！", "info");
        return;
    }
    var ids = null;
    $.each(rows, function (index, row) {
        ids = !!ids ? ids + '^' + row.Id : row.Id;
    });
    $.messager.confirm("提示", "确定删除选中的记录吗?", function (r) {
        if (r) {
            $cm({
                ClassName: 'NurMp.Common.Logic.Handler',
                MethodName: "Delete",
                ClsName: 'CF.NUR.EMR.UnitConversion',
                Ids: ids
            }, function (result) {
                if (result.status >= 0) {
                    $.messager.popover({ msg: result.msg, type: "success" });
                    reloadGrid();
                } else {
                    $.messager.popover({ msg: result.msg, type: "error" });
                    return;
                }
            });
        } else {
            return;
        }
    });
}
/**
* @description: 保存
*/
function save() {
    var addItems = getChanges();
    if (addItems.length == 0) {
        $.messager.alert("提示", "没有需要保存的数据！", "info");
        return;
    }
    var nullColumn = '';
    var arrItems = new Array();
    $.each(addItems, function (index, item) {
        var objItem = new Object();
        objItem['RowID'] = item.Id;
        if (item.UCDesc == '') {
            nullColumn = '名称';
            return false;
        }
        objItem['UCDesc'] = item.UCDesc;
        if (item.UCCountFrom == '') {
            nullColumn = '基本数量';
            return false;
        }
        objItem['UCCountFrom'] = item.UCCountFrom;
        if (item.UCUnitFrom == '') {
            nullColumn = '基本单位';
            return false;
        }
        objItem['UCUnitFrom'] = item.UCUnitFrom;
        if (item.UCCountTo == '') {
            nullColumn = '单位含水量';
            return false;
        }
        objItem['UCCountTo'] = item.UCCountTo;
        if (item.UCUnitTo == '') {
            nullColumn = '基本含水量单位';
            return false;
        }
        objItem['UCUnitTo'] = item.UCUnitTo;
        if (item.UCType == '') {
            nullColumn = '类型';
            return false;
        }
        objItem['UCType'] = item.UCType;
        objItem['UCNote'] = item.UCNote;
        objItem['UCHospDr'] = GLOBAL.HospitalID;
        arrItems.push(objItem);
    });
    if (!!nullColumn) {
        $.messager.alert("提示", nullColumn + "不能为空！", "info");
        return;
    }
    if (!verifyRecord('UCDesc')) {
        $.messager.alert("提示", "名称已经存在！", "info");
        return;
    }
    $cm({
        ClassName: 'NurMp.Common.Logic.Handler',
        MethodName: 'Save',
        ClsName: 'CF.NUR.EMR.UnitConversion',
        Param: JSON.stringify(arrItems)
    }, function (result) {
        if (result.status >= 0) {
            $.messager.popover({ msg: result.msg, type: "success" });
            reloadGrid();
        } else {
            $.messager.popover({ msg: result.msg, type: "error" });
            return;
        }
    });
    accept();
}
/**
* @description: 验证是否重复
*/
function verifyRecord(prop) {
    var objRows = [];
    var rows = $(GLOBAL.EditGrid).datagrid('getRows');
    $.each(rows, function (index, row) {
        var identity = row[prop];
        objRows[identity] = '';
    });
    if (rows.length != Object.keys(objRows).length) {
        return false;
    }
    return true;
}
/**
 * @description: 刷新
 */
function reloadGrid() {
    $(GLOBAL.EditGrid).datagrid('reload', {
        ClassName: GLOBAL.ClassName,
        QueryName: 'FindUnitConversion',
        HospitalID: GLOBAL.HospitalID,
        Type: ckTypes(),
        Filter: $('#cbName').combobox('getText')
    });
    $('#cbName').combobox('reload');
    clearCount();
}
/**
 * @description: 计算器
 */
function compute() {
    var rows = $(GLOBAL.EditGrid).datagrid('getSelections');
    if (rows.length != 1) {
        $.messager.alert("提示", "请选择一条数据！", "info");
        return;
    }
}
/**
 * @description: 计算
 */
function count() {
    var oriNum = parseFloat($('#oriNum').val());
    var countNum = parseFloat($('#countNum').val());
    var unitCount = parseFloat($('#unitCount').html());
    if ($.isNumeric(oriNum) && $.isNumeric(countNum) && $.isNumeric(unitCount)) {
        var total = oriNum * countNum * unitCount;
        $('#total').val(total);
    }
}
/**
 * @description: 清空计算器
 */
 function clearCount() {
    $('#unitName').html('计算器');
    $('#oriNum').val('');
    $('#countNum').val('');
    $('#unitCount').html('单位含水量');
    $('#total').val('');
}
/**
 * @description: 事件
 */
function listenEvent() {
    $('#btnSearch').bind('click', reloadGrid);
    $('#oriNum').bind('blur', count);
    $('#countNum').bind('blur', count);
    $('#total').bind('blur', count);
    $("input[name='ckType']").checkbox({
        onCheckChange: function (e, value) {
            reloadGrid();
        }
    });
}
