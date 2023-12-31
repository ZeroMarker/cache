$(document).ready(function() {
    var columns = [
        [{
                field: 'operate1',
                title: '删除',
                align: 'center',
                width: 50,
                formatter: function(value, row, index) {
                    var str = '<a href="#" id="btnremove" class="hisui-linkbutton" onClick="CancelRefusedOper(\'' + dataForm + '\',\'' + row.RowId + '\')" "></a>';
                    return str;
                }
            },
            { field: "TableName", title: "类名", width: 240 },
            { field: "Description", title: "描述", width: 240 },
            { field: "PermissionDesc", title: "权限类型", width: 120 }
        ]
    ]
    $("#dataBox").datagrid({
        border: false,
        onLoadSuccess: function(data) {

            $("a[id='btnremove']").linkbutton({ plain: true, iconCls: 'icon-cancel' });
        }
    });
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        //gridTitle: "手术物品",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: ANCLS.Code.TablePermission,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindTablePermission",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    dataForm.initDataForm();
});

function CancelRefusedOper(dataForm, index) {
    $.messager.confirm("确认", "是否删除该数据记录？", function(result) {
        if (result) {
            var msg = dhccl.removeData(ANCLS.Code.TablePermission, index);
            dhccl.showMessage(msg, "删除", null, null, function() {
                $("#dataBox").datagrid('reload');
            });
        }
    });
}