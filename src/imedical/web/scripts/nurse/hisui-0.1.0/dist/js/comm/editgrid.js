/*
 * @Descripttion: ���༭����js
 * @Author: yaojining
 * @Date: 2021-12-10 09:21:07
 */
var editIndex = undefined;
/**
 * @description: �����༭
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
 * @description: �����б༭
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
 * @description: ������
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
 * @description: ɾ����
 */
function removeit() {
    if (editIndex == undefined) { return }
    $(GLOBAL.EditGrid).datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
    editIndex = undefined;
}
/**
 * @description: ����
 */
function accept() {
    if (endEditing()) {
        $(GLOBAL.EditGrid).datagrid('acceptChanges');
    }
}
/**
 * @description: ����
 */
function reject() {
    $(GLOBAL.EditGrid).datagrid('rejectChanges');
    editIndex = undefined;
}
/**
 * @description: �༭������
 */
function getChanges() {
    var rows = {};
    if (endEditing()) {
        rows = $(GLOBAL.EditGrid).datagrid('getChanges');
    }
    return rows;
}
