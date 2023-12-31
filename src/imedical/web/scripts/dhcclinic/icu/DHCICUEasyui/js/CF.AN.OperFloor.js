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
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "名称", width: 160 }
        ]
    ];

    $("#dataBox").datagrid({
        bodyCls: 'panel-body-gray',
        border: false,
        onLoadSuccess: function(data) {
            $("a[id='btnremove']").linkbutton({ plain: true, iconCls: 'icon-cancel' });
        },
        onBeforeLoad: function(param) {
            param.Arg1 = session.HospID;
            param.ArgCnt = 1;
        }
    });

    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Config.OperFloor,
        queryType: ANCLS.BLL.ConfigQueries,
        queryName: "FindOperFloor",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    dataForm.initDataForm();
});

function CancelRefusedOper(dataForm, index) {
    $.messager.confirm("确认", "是否删除该数据记录？", function(result) {
        if (result) {
            var msg = dhccl.removeData(ANCLS.Config.OperFloor, index);
            dhccl.showMessage(msg, "删除", null, null, function() {
                $("#dataBox").datagrid('reload');
            });
        }
    });
}