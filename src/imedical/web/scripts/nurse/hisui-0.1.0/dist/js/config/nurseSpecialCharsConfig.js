/*
 * @author: yaojining
 * @discription: �����������ַ�����
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
    $HUI.datagrid('#specialCharsGrid', {
        url: $URL,
        queryParams: {
            ClassName: GV.ClassName,
            QueryName: "CRItem",
            HospitalID: session['LOGON.HOSPID']
        },
        toolbar: toolbar,
        columns: [[
            { field: 'desc', title: '����', width: 100, editor: 'validatebox' },
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
        $.messager.confirm("ɾ��", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
            if (r) {              
                $cm({
                    ClassName: "NurMp.Service.Refer.Chars",
                    MethodName: "deleteChar",
                    id: rec.rw
                }, function (txtData) {
                    if (txtData == '0') {
                        endEditing();
                        $.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 1000 });
                        $('#specialCharsGrid').datagrid('reload')
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
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 1000 });
            $('#specialCharsGrid').datagrid('reload');
        }
        else {
            $.messager.popover({ msg: txtData, type: 'alert', timeout: 1000 });
            $('#specialCharsGrid').datagrid('reload');
        }
    });
}