/*
 * @author: yaojining
 * @discription: 护理病历页签维护配置
 * @date: 2020-03-16
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
                    ConfigTableName: "Nur_IP_TemplatesFilter",
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
            param = $.extend(param, { HospitalID: HospitalID, ConfigTableName: "Nur_IP_TemplatesFilter", SearchDesc: desc });
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
    }];
    $HUI.datagrid('#tabsGrid', {
        url: $URL,
        queryParams: {
            ClassName: GV.ClassName,
            QueryName: "getTabs",
            HospitalID: HospitalID,
            TypeCode: $("input[name='radioType']:checked").val(),
            LocID: $('#comboLocs').combobox('getValue')
        },
        toolbar: toolbar,
        columns: [[
            { field: 'name', title: '名称', width: 120, editor: 'validatebox' },
            { field: 'code', title: '代码', width: 80, editor: 'validatebox' },
            {
                field: 'showType', title: '类型', width: 70, formatter: function (value, row) {
                    if (value == 'A') return '全院';
                    else if (value == 'I') return '住院';
                    else if (value == 'O') return '其它';
                    else return '科室';
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
                            { value: "A", desc: "全院" },
                            { value: "I", desc: "住院" },
                            { value: "O", desc: "其它" },
                            { value: "L", desc: "科室" }
                        ]
                    }
                }
            },
            { field: 'sortNo', title: '序号', width: 45, editor: 'numberbox' },
            {
                field: 'ifOn', title: '启用', width: 60, formatter: function (value, row) {
                    return value === 'N' ? '否' : '是';
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
    if ($('#tabsGrid').datagrid('validateRow', editIndex)) {
        var ed = $('#tabsGrid').datagrid('getEditor', { index: editIndex, field: 'showType' });
        var showType = $(ed.target).combobox('getText');
        $('#tabsGrid').datagrid('getRows')[editIndex]['showType'] = showType;
        ed = $('#tabsGrid').datagrid('getEditor', { index: editIndex, field: 'ifOn' });
        var ifOnDesc = $(ed.target).combobox('getText');
        $('#tabsGrid').datagrid('getRows')[editIndex]['ifOnDesc'] = ifOnDesc;
        $('#tabsGrid').datagrid('endEdit', editIndex);
        editIndex = undefined;
        $('#tabsGrid').datagrid('clearSelections');
        return true;
    } else {
        return false;
    }
}
function onDblClickRow(index) {
    if (editIndex != index) {
        if (endEditing()) {
            $('#tabsGrid').datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndex = index;
        } else {
            $('#tabsGrid').datagrid('selectRow', editIndex);
        }
    }
}
function append() {
    if (endEditing()) {
        $('#tabsGrid').datagrid('appendRow', { ifOn: 'Y' });
        editIndex = $('#tabsGrid').datagrid('getRows').length - 1;
        $('#tabsGrid').datagrid('selectRow', editIndex)
            .datagrid('beginEdit', editIndex);
    }
}
function resetit() {
    var recs = $('#tabsGrid').datagrid('getRows');
    if (!recs[0].id) {
        $.messager.popover({ msg: '已是默认状态，您无需重置！:', type: 'alert', timeout: 1000 });
        return;
    }
    for (var i = 0; i < recs.length; i++) {
        $m({
            ClassName: GV.ClassName,
            MethodName: "deleteTab",
            HospitalID: HospitalID,
            ID: recs[i].id
        }, function (txtData) {
            if (txtData == '0') {
                endEditing();
            }
            else {
                $.messager.popover({ msg: txtData, type: 'alert', timeout: 1000 });
                return;
            }
        });
    }
    $('#tabsGrid').datagrid('reload');
}
function removeit() {
    var rec = $('#tabsGrid').datagrid('getSelected');
    if (rec && rec.id != "") {
        $.messager.confirm("删除", "确定删除选中的记录吗?", function (r) {
            if (r) {
                $cm({
                    ClassName: GV.ClassName,
                    MethodName: "deleteTab",
                    HospitalID: HospitalID,
                    ID: rec.id
                }, function (txtData) {
                    if (txtData == '0') {
                        endEditing();
                        $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                        $('#tabsGrid').datagrid('reload');
                        parent.refreshLeftTree();
                    }
                    else {
                        $.messager.popover({ msg: '删除失败:' + txtData, type: 'alert', timeout: 1000 });
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
        saveTabs();
        $('#tabsGrid').datagrid('acceptChanges');
    }
}
function reject() {
    $('#tabsGrid').datagrid('rejectChanges');
    editIndex = undefined;
}
function getChanges() {
    var rows = $('#tabsGrid').datagrid('getChanges');
    console.log(rows);
    alert(rows.length + ' rows are changed!');
}

function saveTabs() {
    var rows = $('#tabsGrid').datagrid('getRows');
    var para = "";
    var nullName=false;
    rows.forEach(function (row) {
        if ((!!row.name) && (row.code)) {
            para += row.id + "^" + row.name + "^" + row.code + "^" + row.showType + "^" + row.ifOn + "^" + row.sortNo + "^" + HospitalID + "^" + $("input[name='radioType']:checked").val() + "^" + $('#comboLocs').combobox('getValue') + "^" + session['LOGON.USERID'] + "#";
        }else {
            nullName=true;
        }
    });
    if (nullName) {
        $.messager.popover({ msg: '名称和代码不能为空!', type: 'alert', timeout: 1000 });
        return;
    }
    $m({
        ClassName: GV.ClassName,
        MethodName: "saveTab",
        para: para
    }, function (txtData) {
        if (txtData == '0') {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
            $('#tabsGrid').datagrid('reload');
            parent.refreshLeftTree();
        }
        else {
            $.messager.popover({ msg: '保存失败:' + txtData, type: 'alert', timeout: 1000 });
        }
    });
}
function find() {
    $('#tabsGrid').datagrid('reload', {
        ClassName: GV.ClassName,
        QueryName: "getTabs",
        HospitalID: HospitalID,
        TypeCode: $("input[name='radioType']:checked").val(),
        LocID: $('#comboLocs').combobox('getValue')
    });
    editIndex = undefined;
    $('#tabsGrid').datagrid('clearSelections');
}