$(document).ready(function() {
    var columns = [
        [
            {field:'operate1',title:'删除',align:'center',width:50,
            formatter:function(value, row, index){ 
            var str = '<a href="#" id="btnremove" class="hisui-linkbutton" onClick="CancelRefusedOper(\''+dataForm+'\',\''+row.RowId+'\')" "></a>';
            return str;
            }
            },
            { field: "Code", title: "代码", width: 320 },
            { field: "Description", title: "名称", width: 320 },
            { field: "Uom", title: "单位", width: 320 },
            { field: "OptsType", title: "选项类型", width: 320 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        //gridTitle: "数据选项",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.DataOptions,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindDataOptions",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        onSubmitCallBack: initParam,
        submitCallBack: null,
        openCallBack: null,
        border:false,
        closeCallBack: null
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = "";
            param.ArgCnt = 1;
        },
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
             var msg = dhccl.removeData(ANCLS.Code.DataOptions, index);
          dhccl.showMessage(msg, "删除", null, null, function() {
            $("#dataBox").datagrid('reload');
            });
      }
    });
 }
function initParam(param) {}