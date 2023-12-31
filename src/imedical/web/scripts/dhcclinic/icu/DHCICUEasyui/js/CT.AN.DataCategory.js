$(document).ready(function() {
    $("#dataBox").treegrid({
        //headerCls: 'panel-header-gray',
        //iconCls: "icon-template",
        border:false,
        onLoadSuccess: function(data) {
          
            $("a[id='btnremove']").linkbutton({plain:true,iconCls:'icon-cancel'}); 
        },
    });
    var columns = [
        [
            {field:'operate1',title:'删除',align:'center',width:50,
            formatter:function(value, row, index){ 
            var str = '<a href="#" id="btnremove" class="hisui-linkbutton" onClick="CancelRefusedOper(\''+dataForm+'\',\''+row.RowId+'\')" "></a>';
            return str;
            }
            },
            { field: "Description", title: "名称", width: 240 },
            { field: "Code", title: "代码", width: 240 },
            { field: "MainCategoryDesc", title: "主分类", width: 240 }
        ]
    ];
    var dataForm = new TreeForm({
        treegrid: $("#dataBox"),
        treefield: {
            id: "RowId",
            tree: "Description"
        },
        border:false,
        gridColumns: columns,
        //gridTitle: "数据项分类",
        //iconCls:"icon-template",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.DataCategory,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindDataCategory",
        dialog: "",
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        submitCallBack: initQuery,
        openCallBack: null,
        closeCallBack: null,
        delCallBack: initQuery
    });
    dataForm.initDataForm();

    $("#MainCategory").combobox({
        valueField: "RowId",
        textField: "DescCode",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindDataCategory"
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataCategory";
        }
    });
});
function CancelRefusedOper(dataForm,index) {
    $.messager.confirm("确认", "是否删除该数据记录？", function(result) {
    if (result) {
        ////alert(dataForm.datamodel.type);
             var msg = dhccl.removeData(ANCLS.Code.DataCategory, index);
          dhccl.showMessage(msg, "删除", null, null, function() {
            $("#dataBox").treegrid('reload');
            });
      }
    });
 }
function initQuery() {
    $("#MainCategory").combobox("reload");
}