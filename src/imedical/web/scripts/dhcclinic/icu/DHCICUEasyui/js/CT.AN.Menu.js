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
            { field: "Description", title: "名称", width: 240 }
        ]
    ];
    
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        //gridTitle: "菜单",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.Menu,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindMenus",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    dataForm.initDataForm();
    dataForm.datagrid.datagrid({
        //headerCls: 'panel-header-gray',
        border:false,
        onLoadSuccess: function(data) {
          
            $("a[id='btnremove']").linkbutton({plain:true,iconCls:'icon-cancel'}); 
        },
    });
});
function CancelRefusedOper(dataForm,index) {
    $.messager.confirm("确认", "是否删除该数据记录？", function(result) {
    if (result) {
        ////alert(dataForm.datamodel.type);
             var msg = dhccl.removeData(ANCLS.Code.Menu, index);
          dhccl.showMessage(msg, "删除", null, null, function() {
            $("#dataBox").datagrid('reload');
            });
      }
    });
 }