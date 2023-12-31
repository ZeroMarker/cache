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
            { field: "Description", title: "描述", width: 240 },
            { field: "Order", title: "序号", width: 240 },
            { field: "Type", title: "类型", width: 240 }
        ]
    ]
    $("#dataBox").datagrid({
        border:false,
        onLoadSuccess: function(data) {
          
            $("a[id='btnremove']").linkbutton({plain:true,iconCls:'icon-cancel'}); 
        },
        onClick:function CancelRefusedOper(index) 
      {
      alert(index)
       var msg = dhccl.removeData(dataForm.datamodel.type, index)
        dhccl.showMessage(msg, "删除", null, null, function() {
        dataForm.form.form("clear");
        dataForm.datagrid.datagrid("reload");
        if (dataForm.options.delCallBack) {
            dataForm.options.delCallBack();
        }
     });
   }
    });
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: "CT.AN.PatTransLocation",
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindPatTransLocation",
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

    dataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = $("#Type").combobox("getValue");
            param.ArgCnt = 1;
        }
    });
});
function CancelRefusedOper(dataForm,index) {
    $.messager.confirm("确认", "是否删除该数据记录？", function(result) {
    if (result) {
        ////alert(dataForm.datamodel.type);
             var msg = dhccl.removeData("CT.AN.PatTransLocation", index);
          dhccl.showMessage(msg, "删除", null, null, function() {
            $("#dataBox").datagrid('reload');
            });
      }
    });
 }