
/**
*@name nur.bedchartmenuset.js
*@description 床位图右键菜单配置
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
    $HUI.datagrid('#menuGrid', {
        url: $URL,
        queryParams: {
            ClassName: GV.ClassName,
            MethodName: "getBedMenu",
            Filter: 'false'
        },
        toolbar: toolbar,
        frozenColumns: [[{ field: 'serialId', title: '序号', width: 40, editor: 'numberbox' },
        { field: 'menuDesc', title: '菜单名称', width: 100, editor: 'validatebox' },
        { field: 'menuUrl', title: '链接CSP', width: 200, editor: 'validatebox' },
        { field: 'urlPara', title: '菜单参数', width: 200, editor: 'validatebox' },
        { field: 'babyUrlPara', title: '婴儿菜单参数', width: 200, editor: 'validatebox' }]],
        columns: [[
            { field: 'top', title: '上边距', width: 50, editor: 'numberbox' },
            { field: 'left', title: '左边距', width: 50, editor: 'numberbox' },
            { field: 'width', title: '宽度', width: 40, editor: 'numberbox' },
            { field: 'height', title: '高度', width: 40, editor: 'numberbox' },
            {
                field: 'ifShow', title: '是否启用', width: 70, formatter: function (value, row) {
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
                            { value: "Y", desc: "是" },
                            { value: "N", desc: "否" }
                        ]
                    }
                }
            },
            {
                field: 'wardID', title: '病区', width: 150, formatter: function (value, row) {
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
                field: 'groupID', title: '安全组', width: 100, formatter: function (value, row) {
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
        title: '右键菜单',
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
		$.messager.confirm("删除", "确定删除选中的记录吗?", function (r) {
			if (r) {			  
				$cm({
					ClassName: GV.ClassName,
					MethodName: "deleteBedMenu",
					ID: rec.id
				}, function (txtData) {
					if (txtData == '1') {
						endEditing();
						$.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
						$('#menuGrid').datagrid('reload')
					}
					else {
						$.messager.popover({ msg: '删除失败:' + txtData, type: 'alert', timeout: 1000 });
					}
				});
			}
		});
	  }else{
		  $.messager.popover({ msg: '请选中需要删除的记录', type: 'alert', timeout: 1000 });
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
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
            $('#menuGrid').datagrid('reload');
        }
        else {
	        if (txtData=='5808') txtData="序号已存在！";
            $.messager.popover({ msg: '保存失败:' + txtData, type: 'alert', timeout: 1000 });
        }
    });
}