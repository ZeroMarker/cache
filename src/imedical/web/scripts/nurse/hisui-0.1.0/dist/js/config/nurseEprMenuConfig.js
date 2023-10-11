/*
 * @author: yaojining
 * @discription: ������Ŀ¼ά������
 * @date: 2019-12-29
 */
var GLOBAL = {
    ClassName: "NurMp.Service.Refer.Epr",
};
var init = function () {
    initPageDom();
}
$(init);

function initPageDom() {
    $HUI.datagrid('#eprMenuGrid', {
        url: $URL,
        queryParams: {
            ClassName: GLOBAL.ClassName,
            QueryName: 'getEprMenu',
            HospitalID: HospitalID,
        },
        toolbar: [{
			text: '����',
			iconCls: 'icon-add',
			handler: append
		}, {
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: removeit
		}, {
			text: '����',
			iconCls: 'icon-save',
			handler: accept
		}, {
			text: 'ˢ��',
			iconCls: 'icon-reload',
			handler: find
		}],
        columns: [[
            { field: 'name', title: '����', width: 200, editor: 'validatebox' },
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
	        { field: 'sortNo', title: '���', width: 45, editor: 'numberbox' },
	        { field: 'id', title: 'ID', width: 50 },
        ]],
        idField: 'id',
        rownumbers: true,
		singleSelect:true,
		onClickRow: findSub,
        onDblClickRow: onDblClickRow
    });
    $HUI.datagrid('#eprMenuSubGrid', {
        url: $URL,
        queryParams: {
            ClassName: GLOBAL.ClassName,
            QueryName: 'getEprMenuSub',
            HospitalID: HospitalID,
			ParentID: ''
        },
        toolbar: [{
			text: '����',
			iconCls: 'icon-add',
			handler: appendSub
		},{
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: removeitSub
		}, {
			text: '����',
			iconCls: 'icon-save',
			handler: acceptSub
		}, {
			text: 'ˢ��',
			iconCls: 'icon-reload',
			handler: findSub
		}],
        columns: [[
            { field: 'name', title: '����', width: 200, editor: 'validatebox' },
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
	        { field: 'sortNo', title: '���', width: 45, editor: 'numberbox' },
	        { field: 'id', title: 'ID', width: 50 },
        ]],
        idField: 'id',
        rownumbers: true,
		singleSelect:true,
        onDblClickRow: onDblClickRowSub
    });
}
var editIndex = undefined;
function endEditing() {
    if (editIndex == undefined) { return true }
    if ($('#eprMenuGrid').datagrid('validateRow', editIndex)) {
        var ed = $('#eprMenuGrid').datagrid('getEditor', { index: editIndex, field: 'ifOn' });
        var ifOnDesc = $(ed.target).combobox('getText');
        $('#eprMenuGrid').datagrid('getRows')[editIndex]['ifOnDesc'] = ifOnDesc;
        $('#eprMenuGrid').datagrid('endEdit', editIndex);
        editIndex = undefined;
		$('#eprMenuGrid').datagrid('clearSelections');
        return true;
    } else {
        return false;
    }
}
function onClickRow(index,rowData) {
    findSub();
}
function onDblClickRow(index) {
    if (editIndex != index) {
        if (endEditing()) {
            $('#eprMenuGrid').datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndex = index;
        } else {
            $('#eprMenuGrid').datagrid('selectRow', editIndex);
        }
    }
}
function append() {
    if (endEditing()) {
        $('#eprMenuGrid').datagrid('appendRow', { ifOn: 'Y' });
        editIndex = $('#eprMenuGrid').datagrid('getRows').length - 1;
        $('#eprMenuGrid').datagrid('selectRow', editIndex)
            .datagrid('beginEdit', editIndex);
    }
}
function removeit() {
	  var rec = $('#eprMenuGrid').datagrid('getSelected');
	  if(rec&&rec.id!=""){
		$.messager.confirm("ɾ��", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
			if (r) {			  
				$m({
					ClassName: GLOBAL.ClassName,
					MethodName: "deleteMenu",
					ID: rec.id
				}, function (txtData) {
					if (txtData == '0') {
						endEditing();
						$.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 1000 });
						$('#eprMenuGrid').datagrid('reload');
						$('#eprMenuGrid').datagrid('clearSelections');
						parent.$HUI.tree('#eprTree','reload');
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
        $('#eprMenuGrid').datagrid('acceptChanges');
    }
}
function reject() {
    $('#eprMenuGrid').datagrid('rejectChanges');
    editIndex = undefined;
}
function getChanges() {
    var rows = $('#eprMenuGrid').datagrid('getChanges');
    console.log(rows);
    alert(rows.length + ' rows are changed!');
}

function saveDirectory() {
    var rows = $('#eprMenuGrid').datagrid('getChanges');
    if (rows.length == 0) {
        $.messager.popover({ msg: 'û����Ҫ��������ݣ�', type: 'error', timeout: 1000 });
        return;
    }
    var para = "";
    var saveFlag = true;
    rows.forEach(function (row) {
        if (!row.name) {
	        saveFlag = false;
            $.messager.popover({ msg: '���Ʋ���Ϊ��!', type: 'error', timeout: 1000 });
            return;
        }
        para = row.id + "^" + row.name + "^" + row.sortNo + "^" + row.ifOn;
        var result = $m({
	        ClassName: GLOBAL.ClassName,
	        MethodName: "saveMenu",
			HospitalID: HospitalID,
	        Para: para,
	        UserID: session['LOGON.USERID']
	    },false);
	    if (result != 0) {
		    saveFlag = false;
			$.messager.popover({ msg: result, type: 'error', timeout: 1000 });
        	return;
		}
    });
    if (saveFlag) {
        $.messager.popover({ msg: '����ɹ�!', type: 'success', timeout: 1000 });
        $('#eprMenuGrid').datagrid('reload');
		parent.$HUI.tree('#eprTree','reload');
    }
}
function find() {
    $('#eprMenuGrid').datagrid('reload',{
    	ClassName: GLOBAL.ClassName,
        QueryName: "getEprMenu",
        HospitalID: HospitalID
    });
    editIndex = undefined;
	$('#eprMenuGrid').datagrid('clearSelections');
}

var editIndexSub = undefined;
function endEditingSub() {
    if (editIndexSub == undefined) { return true }
    if ($('#eprMenuSubGrid').datagrid('validateRow', editIndexSub)) {
        var ed = $('#eprMenuSubGrid').datagrid('getEditor', { index: editIndexSub, field: 'ifOn' });
        var ifOnDesc = $(ed.target).combobox('getText');
        $('#eprMenuSubGrid').datagrid('getRows')[editIndexSub]['ifOnDesc'] = ifOnDesc;
        $('#eprMenuSubGrid').datagrid('endEdit', editIndexSub);
        editIndexSub = undefined;
		$('#eprMenuSubGrid').datagrid('clearSelections');
        return true;
    } else {
        return false;
    }
}
function onDblClickRowSub(index) {
    if (editIndexSub != index) {
        if (endEditingSub()) {
            $('#eprMenuSubGrid').datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndexSub = index;
        } else {
            $('#eprMenuSubGrid').datagrid('selectRow', editIndexSub);
        }
    }
}
function appendSub() {
	var rows = $('#eprMenuGrid').datagrid('getSelections');
	if (rows.length == 0) {
		$.messager.popover({ msg: '��ѡ�񸸽ڵ㣡', type: 'error', timeout: 1000 });
		return;
	}
    if (endEditingSub()) {
        $('#eprMenuSubGrid').datagrid('appendRow', { ifOn: 'Y' });
        editIndexSub = $('#eprMenuSubGrid').datagrid('getRows').length - 1;
        $('#eprMenuSubGrid').datagrid('selectRow', editIndexSub)
            .datagrid('beginEdit', editIndexSub);
    }
}
function removeitSub() {
	  var rec = $('#eprMenuSubGrid').datagrid('getSelected');
	  if(rec&&rec.id!=""){
		$.messager.confirm("ɾ��", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
			if (r) {			  
				$m({
					ClassName: GLOBAL.ClassName,
					MethodName: "deleteSub",
					ID: rec.id
				}, function (txtData) {
					if (txtData == '0') {
						endEditing();
						$.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 1000 });
						$('#eprMenuSubGrid').datagrid('reload');
						$('#eprMenuSubGrid').datagrid('clearSelections');
						parent.$HUI.tree('#eprTree','reload');
						parent.$HUI.datagrid('#methodGrid','reload');
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
function acceptSub() {
    if (endEditingSub()) {
        saveDirectorySub();
        $('#eprMenuSubGrid').datagrid('acceptChanges');
    }
}
function rejectSub() {
    $('#eprMenuSubGrid').datagrid('rejectChanges');
    editIndexSub = undefined;
}

function saveDirectorySub() {
    var rows = $('#eprMenuSubGrid').datagrid('getChanges');
    if (rows.length == 0) {
        $.messager.popover({ msg: 'û����Ҫ��������ݣ�', type: 'error', timeout: 1000 });
        return;
    }
    var para = "";
    var saveFlag = true;
	var parentRow = $('#eprMenuGrid').datagrid('getSelected');
	if(!parentRow || parentRow.id==""){
		$.messager.popover({ msg: 'δѡ�и��ڵ㣡', type: 'error', timeout: 1000 });
        return;
	}
    rows.forEach(function (row) {
        if (!row.name) {
	        saveFlag = false;
            $.messager.popover({ msg: '���Ʋ���Ϊ��!', type: 'error', timeout: 1000 });
            return;
        }
        para = row.id + "^" + row.name + "^" + row.sortNo + "^" + row.ifOn;
        var result = $m({
	        ClassName: GLOBAL.ClassName,
	        MethodName: "saveSub",
			HospitalID: HospitalID,
			ParentID: parentRow.id,
	        Para: para,
	        UserID: session['LOGON.USERID']
	    },false);
	    if (result != 0) {
		    saveFlag = false;
			$.messager.popover({ msg: result, type: 'error', timeout: 1000 });
        	return;
		}
    });
    if (saveFlag) {
		$.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 1000 });
        $('#eprMenuSubGrid').datagrid('reload');
		parent.$HUI.tree('#eprTree','reload');
		parent.$HUI.datagrid('#methodGrid','reload');
	}
}
function findSub() {
	var row = $('#eprMenuGrid').datagrid('getSelected');
	if (!row) {
		$.messager.popover({ msg: '��ѡ�񸸽ڵ㣡', type: 'error', timeout: 1000 });
		return;
	}
    $('#eprMenuSubGrid').datagrid('reload',{
    	ClassName: GLOBAL.ClassName,
        QueryName: "getEprMenuSub",
        HospitalID: HospitalID,
		ParentID: row.id
    });
    editIndexSub = undefined;
	$('#eprMenuSubGrid').datagrid('clearSelections');
}