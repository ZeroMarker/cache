/*
 * @author: yaojining
 * @discription: 护理病历目录维护配置
 * @date: 2019-12-29
 */
var GV = {
    ClassName: "NurMp.Service.Template.Directory",
};
var init = function () {
    initSearchCondition();
    initPageDom();
}
$(init)
/**
* @description: 初始化查询条件
*/
function initSearchCondition() {
    $HUI.radio("[name='radioType']", {
        onChecked: function (e, value) {
            if ('ALL,IP,OP'.indexOf(e.target.id) > -1) {
                $('#comboLocs').combobox('clear');
                $('#comboLocs').combobox('disable');
            } else {
                $('#comboLocs').combobox('enable');
                $('#comboLocs').combogrid('grid').datagrid('reload', {
                    ClassName: "NurMp.Common.Base.Hosp",
                    QueryName: "FindHospLocs",
                    HospitalID: HospitalID,
                    ConfigTableName: "Nur_IP_TemplateFilter",
                    SearchDesc: ""
                });
                $('#comboLocs').combogrid('grid').datagrid('selectRow', 0);
            }
            find();
        }
    });
}
function initPageDom() {
    $HUI.combogrid("#comboLocs", {
        url: $URL,
        queryParams: {
            ClassName: "NurMp.Common.Base.Hosp",
            QueryName: "FindHospLocs"
        },
        mode: 'remote',
        idField: 'LocId',
        textField: 'LocDesc',
        columns: [[
            { field: 'LocDesc', title: '名称', width: 90 },
            { field: 'HospDesc', title: '院区', width: 90 },
            { field: 'LocId', title: 'ID', width: 10 }
        ]],
        fitColumns: true,
        panelWidth: 450,
        panelHeight: 420,
        delay: 500,
        pagination: true,
        enterNullValueClear: true,
        disabled: true,
        onBeforeLoad: function (param) {
            var desc = "";
            if (param['q']) {
                desc = param['q'];
            }
            param = $.extend(param, { HospitalID: HospitalID, ConfigTableName: "Nur_IP_TemplateFilter", SearchDesc: desc });
            return true;
        },
        onLoadSuccess: function () {
        },
        onSelect: function (record) {
            find();
        },
    });
    var toolbar = [{
        text: '增加',
        iconCls: 'icon-add',
        handler: append
    }, '-', {
        text: '删除',
        iconCls: 'icon-remove',
        handler: removeit
    }, '-', {
        text: '保存',
        iconCls: 'icon-save',
        handler: accept
    }, '-', {
        text: '重置',
        iconCls: 'icon-reload',
        handler: find
    }];
    $HUI.datagrid('#rootDirectoryGrid', {
        url: $URL,
        queryParams: {
            ClassName: GV.ClassName,
            QueryName: "getRootDirectory",
            HospitalID: HospitalID,
            TypeCode: $("input[name='radioType']:checked").val(),
            LocID: $('#comboLocs').combobox('getValue')
        },
        toolbar: toolbar,
        columns: [[
            { field: 'name', title: '名称', width: 150, editor: 'validatebox' },
            { field: 'code', title: '代码', width: 100, editor: 'validatebox' },
            { field: 'sortNo', title: '序号', width: 45, editor: 'numberbox' },
            {
                field: 'ifOn', title: '启用', width: 60, formatter: function (value, row) {
                    return value === 'Y' ? '是' : '否';
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: true,
                        editable: false,
                        enterNullValueClear: false,
                        data: [
                            { value: "Y", desc: "是" },
                            { value: "N", desc: "否" }
                        ]
                    }
                }
            },
            { field: 'id', title: 'ID', width: 50 },
        ]],
        idField: 'id',
        rownumbers: true,
        singleSelect: true,
        onDblClickRow: onDblClickRow,
    })
}
var editIndex = undefined;
function endEditing() {
    if (editIndex == undefined) { return true }
    if ($('#rootDirectoryGrid').datagrid('validateRow', editIndex)) {
        var ed = $('#rootDirectoryGrid').datagrid('getEditor', { index: editIndex, field: 'ifOn' });
        var ifOnDesc = $(ed.target).combobox('getText');
        $('#rootDirectoryGrid').datagrid('getRows')[editIndex]['ifOnDesc'] = ifOnDesc;
        $('#rootDirectoryGrid').datagrid('endEdit', editIndex);
        editIndex = undefined;
        $('#rootDirectoryGrid').datagrid('clearSelections');
        return true;
    } else {
        return false;
    }
}
function onDblClickRow(index) {
    if (editIndex != index) {
        if (endEditing()) {
            $('#rootDirectoryGrid').datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndex = index;
        } else {
            $('#rootDirectoryGrid').datagrid('selectRow', editIndex);
        }
    }
}
function append() {
    var type = $("input[name='radioType']:checked").val();
    var locID = $('#comboLocs').combobox('getValue');
    if ((type == "LOC") && (!locID)) {
        $.messager.popover({ msg: '请选择科室！', type: 'alert', timeout: 1000 });
        return;
    }
    if (endEditing()) {
        $('#rootDirectoryGrid').datagrid('appendRow', { ifOn: 'Y' });
        editIndex = $('#rootDirectoryGrid').datagrid('getRows').length - 1;
        $('#rootDirectoryGrid').datagrid('selectRow', editIndex)
            .datagrid('beginEdit', editIndex);
    }
}
function removeit() {
    var rec = $('#rootDirectoryGrid').datagrid('getSelected');
    if (rec && rec.id != "") {
        $.messager.confirm("删除", "确定删除选中的记录吗?", function (r) {
            if (r) {
                $m({
                    ClassName: GV.ClassName,
                    MethodName: "deleteDirect",
                    HospitalID: HospitalID,
                    ID: rec.id
                }, function (txtData) {
                    if (txtData == '0') {
                        endEditing();
                        $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                        $('#rootDirectoryGrid').datagrid('reload');
                        $('#rootDirectoryGrid').datagrid('clearSelections');
                        parent.refreshLeftTree();
                    }
                    else {
                        $.messager.popover({ msg: txtData, type: 'alert', timeout: 1000 });
                    }
                });
            }
        });
    } else {
        $.messager.popover({ msg: '请选中需要删除的记录', type: 'alert', timeout: 1000 });
    }
}
function accept() {
    if (endEditing()) {
        saveDirectory();
        $('#rootDirectoryGrid').datagrid('acceptChanges');
    }
}
function reject() {
    $('#rootDirectoryGrid').datagrid('rejectChanges');
    editIndex = undefined;
}
function getChanges() {
    var rows = $('#rootDirectoryGrid').datagrid('getChanges');
    console.log(rows);
    alert(rows.length + ' rows are changed!');
}

function saveDirectory() {
    var rows = $('#rootDirectoryGrid').datagrid('getChanges');
    if (rows.length == 0) {
        $.messager.popover({ msg: '没有需要保存的内容！', type: 'error', timeout: 1000 });
        return;
    }
    var para = "";
    var saveFlag = true;
    rows.forEach(function (row) {
        if ((!row.name) || (!row.code) || (!row.sortNo)) {
            saveFlag = false;
            return;
        }
        para += row.id + "^" + row.name + "^" + row.code + "^" + row.sortNo + "^" + row.ifOn + "#";
    });
    if (!saveFlag) {
        $.messager.popover({ msg: '名称、代码和序号不能为空!', type: 'error', timeout: 1000 });
        return;
    }
    $m({
        ClassName: GV.ClassName,
        MethodName: "saveDirect",
        Para: para,
        HospitalID: HospitalID,
        TypeCode: $("input[name='radioType']:checked").val(),
        LocID: $('#comboLocs').combobox('getValue'),
        UserID: session['LOGON.USERID']
    }, function (txtData) {
        if (txtData == '0') {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
            $('#rootDirectoryGrid').datagrid('reload');
            parent.refreshLeftTree();
        } else {
            $.messager.popover({ msg: '保存失败:' + txtData, type: 'alert', timeout: 1000 });
        }
    });
}
function find() {
    $('#rootDirectoryGrid').datagrid('reload', {
        ClassName: GV.ClassName,
        QueryName: "getRootDirectory",
        TypeCode: $("input[name='radioType']:checked").val(),
        HospitalID: HospitalID,
        LocID: $('#comboLocs').combobox('getValue')
    });
    editIndex = undefined;
    $('#rootDirectoryGrid').datagrid('clearSelections');
}