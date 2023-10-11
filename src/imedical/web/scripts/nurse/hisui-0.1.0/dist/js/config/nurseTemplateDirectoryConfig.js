/*
 * @author: yaojining
 * @discription: ������Ŀ¼ά������
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
* @description: ��ʼ����ѯ����
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
            { field: 'LocDesc', title: '����', width: 90 },
            { field: 'HospDesc', title: 'Ժ��', width: 90 },
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
        text: '����',
        iconCls: 'icon-add',
        handler: append
    }, '-', {
        text: 'ɾ��',
        iconCls: 'icon-remove',
        handler: removeit
    }, '-', {
        text: '����',
        iconCls: 'icon-save',
        handler: accept
    }, '-', {
        text: '����',
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
            { field: 'name', title: '����', width: 150, editor: 'validatebox' },
            { field: 'code', title: '����', width: 100, editor: 'validatebox' },
            { field: 'sortNo', title: '���', width: 45, editor: 'numberbox' },
            {
                field: 'ifOn', title: '����', width: 60, formatter: function (value, row) {
                    return value === 'Y' ? '��' : '��';
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
                            { value: "Y", desc: "��" },
                            { value: "N", desc: "��" }
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
        $.messager.popover({ msg: '��ѡ����ң�', type: 'alert', timeout: 1000 });
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
        $.messager.confirm("ɾ��", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
            if (r) {
                $m({
                    ClassName: GV.ClassName,
                    MethodName: "deleteDirect",
                    HospitalID: HospitalID,
                    ID: rec.id
                }, function (txtData) {
                    if (txtData == '0') {
                        endEditing();
                        $.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 1000 });
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
        $.messager.popover({ msg: '��ѡ����Ҫɾ���ļ�¼', type: 'alert', timeout: 1000 });
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
        $.messager.popover({ msg: 'û����Ҫ��������ݣ�', type: 'error', timeout: 1000 });
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
        $.messager.popover({ msg: '���ơ��������Ų���Ϊ��!', type: 'error', timeout: 1000 });
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
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 1000 });
            $('#rootDirectoryGrid').datagrid('reload');
            parent.refreshLeftTree();
        } else {
            $.messager.popover({ msg: '����ʧ��:' + txtData, type: 'alert', timeout: 1000 });
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