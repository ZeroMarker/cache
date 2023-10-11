/*
 * @author: yaojining
 * @discription: 护理病历特殊字符配置
 * @date: 2019-12-29
 */
var GV = {
    ClassName: "NurMp.Service.Refer.Chars",
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
    $HUI.datagrid('#specialCharsGrid', {
        url: $URL,
        queryParams: {
            ClassName: GV.ClassName,
            QueryName: "CRItem",
            HospitalID: session['LOGON.HOSPID']
        },
        toolbar: toolbar,
        columns: [[
            { field: 'desc', title: '符号', width: 100, editor: 'validatebox' },
            { field: 'rw', title: 'ID', width: 50 },
        ]],
        idField: 'id',
        rownumbers: true,
        pagination: true,
		pageSize: 15,
		pageList: [15,30,50,100],
        singleSelect:true,
        onDblClickRow: onDblClickRow,
    })
}
var editIndex = undefined;
function endEditing() {
    if (editIndex == undefined) { return true }
    if ($('#specialCharsGrid').datagrid('validateRow', editIndex)) {
        $('#specialCharsGrid').datagrid('endEdit', editIndex);
        editIndex = undefined;
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}
function onDblClickRow(index) {
    if (editIndex != index) {
        if (endEditing()) {
            $('#specialCharsGrid').datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndex = index;
        } else {
            $('#specialCharsGrid').datagrid('selectRow', editIndex);
        }
    }
}
function append() {
    if (endEditing()) {
        $('#specialCharsGrid').datagrid('appendRow', { desc: '' });
        editIndex = $('#specialCharsGrid').datagrid('getRows').length - 1;
        $('#specialCharsGrid').datagrid('selectRow', editIndex)
            .datagrid('beginEdit', editIndex);
    }
}
function removeit() {
      var rec = $('#specialCharsGrid').datagrid('getSelected');
      if(rec&&rec.id!=""){
        $.messager.confirm("删除", "确定删除选中的记录吗?", function (r) {
            if (r) {              
                $cm({
                    ClassName: "NurMp.Service.Refer.Chars",
                    MethodName: "deleteChar",
                    id: rec.rw
                }, function (txtData) {
                    if (txtData == '0') {
                        endEditing();
                        $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                        $('#specialCharsGrid').datagrid('reload')
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
        saveSpecialChars();
        $('#specialCharsGrid').datagrid('acceptChanges');
    }
}
function reject() {
    $('#specialCharsGrid').datagrid('rejectChanges');
    editIndex = undefined;
}
function getChanges() {
    var rows = $('#specialCharsGrid').datagrid('getChanges');
    console.log(rows);
    alert(rows.length + ' rows are changed!');
}

function saveSpecialChars() {
    var rows = $('#specialCharsGrid').datagrid('getChanges');
    var para = "";
    rows.forEach(function (row) {
        if (typeof row.rw == "undefined") {
            para += "V" + row.desc + "Q";
        }else{
            para += row.rw + "V" + row.desc + "Q";
        }
    });
    $m({
        ClassName: "NurMp.Service.Refer.Chars",
        MethodName: "saveChars",
        para: para,
        HospitalID: session['LOGON.HOSPID']
    }, function (txtData) {
        if (txtData == '0') {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
            $('#specialCharsGrid').datagrid('reload');
        }
        else {
            $.messager.popover({ msg: txtData, type: 'alert', timeout: 1000 });
            $('#specialCharsGrid').datagrid('reload');
        }
    });
}