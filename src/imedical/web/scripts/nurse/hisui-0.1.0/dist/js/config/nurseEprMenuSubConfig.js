/*
 * @author: yaojining
 * @discription: ������Ŀ¼ά������
 * @date: 2019-12-29
 */
var GV = {
    ClassName: "NurMp.NurseEprMenuSub",
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
    }, '-', {
        text: '��ѯ',
        iconCls: 'icon-search',
        handler: find
    }];
    $HUI.datagrid('#eprMenuSubGrid', {
        url: $URL,
        queryParams: {
            ClassName: GV.ClassName,
            QueryName: 'getEprMenuSub',
            HospitalID: '',
        },
        toolbar: toolbar,
        columns: [[
            { field: 'name', title: '����', width: 100, editor: 'validatebox' },
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
	             		editable:false,
	            		enterNullValueClear:false,
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
		singleSelect:true,
        onDblClickRow: onDblClickRow,
    })
}
var editIndex = undefined;
function endEditing() {
    if (editIndex == undefined) { return true }
    if ($('#eprMenuSubGrid').datagrid('validateRow', editIndex)) {
        var ed = $('#eprMenuSubGrid').datagrid('getEditor', { index: editIndex, field: 'ifOn' });
        var ifOnDesc = $(ed.target).combobox('getText');
        $('#eprMenuSubGrid').datagrid('getRows')[editIndex]['ifOnDesc'] = ifOnDesc;
        $('#eprMenuSubGrid').datagrid('endEdit', editIndex);
        editIndex = undefined;
		$('#eprMenuSubGrid').datagrid('clearSelections');
        return true;
    } else {
        return false;
    }
}
function onDblClickRow(index) {
    if (editIndex != index) {
        if (endEditing()) {
            $('#eprMenuSubGrid').datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndex = index;
        } else {
            $('#eprMenuSubGrid').datagrid('selectRow', editIndex);
        }
    }
}
function append() {
    if (endEditing()) {
        $('#eprMenuSubGrid').datagrid('appendRow', { ifOn: 'Y' });
        editIndex = $('#eprMenuSubGrid').datagrid('getRows').length - 1;
        $('#eprMenuSubGrid').datagrid('selectRow', editIndex)
            .datagrid('beginEdit', editIndex);
    }
}
function removeit() {
	  var rec = $('#eprMenuSubGrid').datagrid('getSelected');
	  if(rec&&rec.id!=""){
		$.messager.confirm("ɾ��", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
			if (r) {			  
				$m({
					ClassName: GV.ClassName,
					MethodName: "delete",
					ID: rec.id
				}, function (txtData) {
					if (txtData == '0') {
						endEditing();
						$.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 1000 });
						$('#eprMenuSubGrid').datagrid('reload');
						$('#eprMenuSubGrid').datagrid('clearSelections');
						parent.refreshLeftTree();
					}
					else {
						$.messager.popover({ msg: txtData, type: 'alert', timeout: 1000 });
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
        saveDirectory();
        $('#eprMenuSubGrid').datagrid('acceptChanges');
    }
}
function reject() {
    $('#eprMenuSubGrid').datagrid('rejectChanges');
    editIndex = undefined;
}
function getChanges() {
    var rows = $('#eprMenuSubGrid').datagrid('getChanges');
    console.log(rows);
    alert(rows.length + ' rows are changed!');
}

function saveDirectory() {
    var rows = $('#eprMenuSubGrid').datagrid('getChanges');
    if (rows.length == 0) {
        $.messager.popover({ msg: 'û����Ҫ��������ݣ�', type: 'error', timeout: 1000 });
        return;
    }
    var para = "";
    var saveFlag = true;
    rows.forEach(function (row) {
        if ((!row.name)||(!row.code)||(!row.sortNo)) {
            saveFlag = false;
            return;
        }
        para += row.id + "^" + row.name + "^" + row.code + "^" + row.sortNo + "^" + row.ifOn + "#";
    });
    if (!saveFlag) {
        $.messager.popover({ msg: '���ơ��������Ų���Ϊ��!', type: 'error', timeout: 1000 });
        return;
    }
    $cm({
        ClassName: GV.ClassName,
        MethodName: "save",
		HospitalID: '',
        Para: para,
        UserID: session['LOGON.USERID']
    }, function (txtData) {
        if (txtData == '0') {
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 1000 });
            $('#eprMenuSubGrid').datagrid('reload');
        }
        else if (txtData == '1'){
			$.messager.popover({ msg: '���벻���ظ���', type: 'alert', timeout: 1000 });
			$('#eprMenuSubGrid').datagrid('reload');
		}else{
            $.messager.popover({ msg: '����ʧ��:' + txtData, type: 'alert', timeout: 1000 });
        }
    });
}
function find() {
    $('#eprMenuSubGrid').datagrid('reload',{
    	ClassName: GV.ClassName,
        QueryName: "getEprMenuSub",
        HospitalID: ''
    });
    editIndex = undefined;
	$('#eprMenuSubGrid').datagrid('clearSelections');
}