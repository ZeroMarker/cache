/*
 * @Descripttion: 表格编辑公共js
 * @Author: yaojining
 * @Date: 2021-12-10 09:21:07
 */
var editIndex = undefined;
/**
 * @description: 结束编辑
 */
function endEditing() {
    if (editIndex == undefined) { return true }
    if ($(GLOBAL.EditGrid).datagrid('validateRow', editIndex)) {
        $(GLOBAL.EditGrid).datagrid('endEdit', editIndex);
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}
/**
 * @description: 启用行编辑
 */
function clickRow(index) {
    if (editIndex != index) {
        if (endEditing()) {
            $(GLOBAL.EditGrid).datagrid('selectRow', index).datagrid('beginEdit', index);
            editIndex = index;
        } else {
            $(GLOBAL.EditGrid).datagrid('selectRow', editIndex);
        }
    }
}
/**
 * @description: 新增行
 */
function append() {
    if (endEditing()) {
        var colFields = arguments[0];
        $(GLOBAL.EditGrid).datagrid('appendRow', colFields);
        editIndex = $(GLOBAL.EditGrid).datagrid('getRows').length - 1;
        $(GLOBAL.EditGrid).datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
    }
}
/**
 * @description: 删除行
 */
function removeit() {
    if (editIndex == undefined) { return }
    $(GLOBAL.EditGrid).datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
    editIndex = undefined;
}
/**
 * @description: 保存
 */
function accept() {
    if (endEditing()) {
        $(GLOBAL.EditGrid).datagrid('acceptChanges');
    }
}
/**
 * @description: 重置
 */
function reject() {
    $(GLOBAL.EditGrid).datagrid('rejectChanges');
    editIndex = undefined;
}
/**
 * @description: 编辑过的行
 */
function getChanges() {
    var rows = {};
    if (endEditing()) {
        rows = $(GLOBAL.EditGrid).datagrid('getChanges');
    }
    return rows;
}
