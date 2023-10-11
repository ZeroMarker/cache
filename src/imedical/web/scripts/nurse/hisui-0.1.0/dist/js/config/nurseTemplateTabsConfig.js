/*
 * @author: yaojining
 * @discription: ������ҳǩά������
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
            { field: 'name', title: '����', width: 120, editor: 'validatebox' },
            { field: 'code', title: '����', width: 80, editor: 'validatebox' },
            {
                field: 'showType', title: '����', width: 70, formatter: function (value, row) {
                    if (value == 'A') return 'ȫԺ';
                    else if (value == 'I') return 'סԺ';
                    else if (value == 'O') return '����';
                    else return '����';
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
                            { value: "A", desc: "ȫԺ" },
                            { value: "I", desc: "סԺ" },
                            { value: "O", desc: "����" },
                            { value: "L", desc: "����" }
                        ]
                    }
                }
            },
            { field: 'sortNo', title: '���', width: 45, editor: 'numberbox' },
            {
                field: 'ifOn', title: '����', width: 60, formatter: function (value, row) {
                    return value === 'N' ? '��' : '��';
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
        $.messager.popover({ msg: '����Ĭ��״̬�����������ã�:', type: 'alert', timeout: 1000 });
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
        $.messager.confirm("ɾ��", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
            if (r) {
                $cm({
                    ClassName: GV.ClassName,
                    MethodName: "deleteTab",
                    HospitalID: HospitalID,
                    ID: rec.id
                }, function (txtData) {
                    if (txtData == '0') {
                        endEditing();
                        $.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 1000 });
                        $('#tabsGrid').datagrid('reload');
                        parent.refreshLeftTree();
                    }
                    else {
                        $.messager.popover({ msg: 'ɾ��ʧ��:' + txtData, type: 'alert', timeout: 1000 });
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
        $.messager.popover({ msg: '���ƺʹ��벻��Ϊ��!', type: 'alert', timeout: 1000 });
        return;
    }
    $m({
        ClassName: GV.ClassName,
        MethodName: "saveTab",
        para: para
    }, function (txtData) {
        if (txtData == '0') {
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 1000 });
            $('#tabsGrid').datagrid('reload');
            parent.refreshLeftTree();
        }
        else {
            $.messager.popover({ msg: '����ʧ��:' + txtData, type: 'alert', timeout: 1000 });
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