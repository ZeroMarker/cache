$(document).ready(function() {
    var columns = [
        [
            {field:'operate1',title:'删除',align:'center',width:50,
            formatter:function(value, row, index){ 
            var str = '<a href="#" id="btnremove" class="hisui-linkbutton" onClick="CancelRefusedOper(\''+dataForm+'\',\''+row.RowId+'\')" "></a>';
            return str;
            }
            },
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "原因", width: 480 },
            { field: "ReasonTypeDesc", title: "类型", width: 480 }
        ]
    ];
    $("#dataBox").datagrid({
        border:false,
        onLoadSuccess: function(data) {
          
            $("a[id='btnremove']").linkbutton({plain:true,iconCls:'icon-cancel'}); 
        }, 
    });
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        //gridTitle: "手术麻醉原因",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.Reason,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindReason",
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
function CancelRefusedOper(dataForm,index) {
    $.messager.confirm("确认", "是否删除该数据记录？", function(result) {
    if (result) {
        ////alert(dataForm.datamodel.type);
             var msg = dhccl.removeData(ANCLS.Code.Reason, index);
          dhccl.showMessage(msg, "删除", null, null, function() {
            $("#dataBox").datagrid('reload');
            });
      }
    });
 }