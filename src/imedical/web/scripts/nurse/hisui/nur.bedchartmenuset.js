
/**
*@name nur.bedchartmenuset.js
*@description ��λͼ�Ҽ��˵�����
*@author songchao
**/
var GV = {
    ClassName: "Nur.BedChartMenu",
};
var init = function () {
    initPageDom();
}
$(init)
function initPageDom() {
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
    $HUI.datagrid('#menuGrid', {
        url: $URL,
        queryParams: {
            ClassName: GV.ClassName,
            MethodName: "getBedMenu",
            Filter: 'false'
        },
        toolbar: toolbar,
        frozenColumns: [[{ field: 'serialId', title: '���', width: 40, editor: 'numberbox' },
        { field: 'menuDesc', title: '�˵�����', width: 100, editor: 'validatebox' },
        { field: 'menuUrl', title: '����CSP', width: 200, editor: 'validatebox' },
        { field: 'urlPara', title: '�˵�����', width: 200, editor: 'validatebox' },
        { field: 'babyUrlPara', title: 'Ӥ���˵�����', width: 200, editor: 'validatebox' }]],
        columns: [[
            { field: 'top', title: '�ϱ߾�', width: 50, editor: 'numberbox' },
            { field: 'left', title: '��߾�', width: 50, editor: 'numberbox' },
            { field: 'width', title: '���', width: 40, editor: 'numberbox' },
            { field: 'height', title: '�߶�', width: 40, editor: 'numberbox' },
            {
                field: 'ifShow', title: '�Ƿ�����', width: 70, formatter: function (value, row) {
                    return row.ifShowDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: true,
                 		editable:false,
                		enterNullValueClear:false,
                        data: [
                            { value: "Y", desc: "��" },
                            { value: "N", desc: "��" }
                        ]
                    }
                }
            },
            {
                field: 'wardID', title: '����', width: 150, formatter: function (value, row) {
                    return row.wardDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'wardID',
                        textField: 'desc',
                        defaultFilter:4,
                        url: $URL + "?1=1&ClassName=" + GV.ClassName + "&MethodName=getLocs" + "&LocType=W",
                    }
                }
            },
            {
                field: 'groupID', title: '��ȫ��', width: 100, formatter: function (value, row) {
                    return row.groupDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'ID',
                        textField: 'desc',
                        url: $URL + "?1=1&ClassName=" + GV.ClassName + "&MethodName=getGroups",
                    }
                }
            }
        ]],
        idField: 'serialId',
        rownumbers: true,
		singleSelect:true,
        title: '�Ҽ��˵�',
        onDblClickRow: onDblClickRow,
    })
}
var editIndex = undefined;
function endEditing() {
    if (editIndex == undefined) { return true }
    if ($('#menuGrid').datagrid('validateRow', editIndex)) {
        var ed = $('#menuGrid').datagrid('getEditor', { index: editIndex, field: 'ifShow' });
        var ifShowDesc = $(ed.target).combobox('getText');
        $('#menuGrid').datagrid('getRows')[editIndex]['ifShowDesc'] = ifShowDesc;
        var ed = $('#menuGrid').datagrid('getEditor', { index: editIndex, field: 'wardID' });
        var wardDesc = $(ed.target).combobox('getText');
        $('#menuGrid').datagrid('getRows')[editIndex]['wardDesc'] = wardDesc;
        var ed = $('#menuGrid').datagrid('getEditor', { index: editIndex, field: 'groupID' });
        var groupDesc = $(ed.target).combobox('getText');
        $('#menuGrid').datagrid('getRows')[editIndex]['groupDesc'] = groupDesc;
        $('#menuGrid').datagrid('endEdit', editIndex);
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}
function onDblClickRow(index) {
    if (editIndex != index) {
        if (endEditing()) {
            $('#menuGrid').datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndex = index;
        } else {
            $('#menuGrid').datagrid('selectRow', editIndex);
        }
    }
}
function append() {
    if (endEditing()) {
        $('#menuGrid').datagrid('appendRow', { status: 'P' });
        editIndex = $('#menuGrid').datagrid('getRows').length - 1;
        $('#menuGrid').datagrid('selectRow', editIndex)
            .datagrid('beginEdit', editIndex);
    }
}
function removeit() {
	  var rec = $('#menuGrid').datagrid('getSelected');
	  if(rec&&rec.id!=""){
		$.messager.confirm("ɾ��", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
			if (r) {			  
				$cm({
					ClassName: GV.ClassName,
					MethodName: "deleteBedMenu",
					ID: rec.id
				}, function (txtData) {
					if (txtData == '1') {
						endEditing();
						$.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 1000 });
						$('#menuGrid').datagrid('reload')
					}
					else {
						$.messager.popover({ msg: 'ɾ��ʧ��:' + txtData, type: 'alert', timeout: 1000 });
					}
				});
			}
		});
	  }else{
		  $.messager.popover({ msg: '��ѡ����Ҫɾ���ļ�¼', type: 'alert', timeout: 1000 });
	  }
}
function accept() {
    if (endEditing()) {
        saveMenu();
        $('#menuGrid').datagrid('acceptChanges');
    }
}
function reject() {
    $('#menuGrid').datagrid('rejectChanges');
    editIndex = undefined;
}
function getChanges() {
    var rows = $('#menuGrid').datagrid('getChanges');
    console.log(rows);
    alert(rows.length + ' rows are changed!');
}

function saveMenu() {
    var rows = $('#menuGrid').datagrid('getChanges');
    var para = "";
    rows.forEach(function (row) {
        para += row.id + "^" + row.serialId + "^" + row.menuDesc + "^" + row.menuUrl + "^" + row.urlPara + "^" + row.babyUrlPara + "^" + row.top + "^" + row.left + "^" + row.width + "^" + row.height + "^" + row.ifShow + "^" + row.wardID + "^" + row.groupID + "#";
    });
    $cm({
        ClassName: GV.ClassName,
        MethodName: "saveBedMenu",
        para: para
    }, function (txtData) {
        if (txtData == '0') {
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 1000 });
            $('#menuGrid').datagrid('reload');
        }
        else {
	        if (txtData=='5808') txtData="����Ѵ��ڣ�";
            $.messager.popover({ msg: '����ʧ��:' + txtData, type: 'alert', timeout: 1000 });
        }
    });
}