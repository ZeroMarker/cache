$(document).ready(function() {
    var columns = [
        [
            { field: "RowId", title: "RowId", width: 120,hidden: true },
            { field: "DataModuleDesc", title: "数据模块", width: 120 },
            { field: "ErrorMsg", title: "错误信息", width: 240 ,
            formatter: function (value, row, index) {
                return '<a href="#" onclick="ErrorMessage(\''+"ErrorMsg"+'\',\''+ row.RowId +'\')">错误信息</a>';
            }},
            { field: "ClientIP", title: "客户端IP", width: 120 },
            { field: "LogDate", title: "日志日期", width: 120 },
            { field: "LogTime", title: "日志时间", width: 120 },
            { field: "UserDesc", title: "用户", width: 120 },
            { field: "GroupDesc", title: "安全组", width: 120 },
            { field: "RequestData", title: "请求数据", width: 240,
            formatter: function (value, row, index) {
                return '<a href="#" onclick="ErrorMessage(\''+"RequestData"+'\',\''+ row.RowId +'\')">请求数据</a>';
            }},
            { field: "CTLOCDesc", title: "科室", width: 120 }
        ]
    ]

    $("#DateModule").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataModule";
            param.Arg1 = "";
            param.Arg2 = "";
            param.ArgCnt = 2;
        }
    });

    var today = new Date();
    var todayStr = today.format("yyyy-MM-dd");
    $("#sDate").datebox("setValue", todayStr);
    $("#eDate").datebox("setValue", todayStr);

    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        //gridTitle: "手术物品",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: ANCLS.Code.SurMaterials,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindANErrorLog",
        dialog: null,
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    dataForm.initDataForm();
    
    dataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = $("#sDate").datebox("getValue");
            param.Arg2 = $("#eDate").datebox("getValue");
            param.Arg3 = $("#DateModule").combobox("getValue");
            param.ArgCnt = 3
        }
    });

    $("#btnSch").linkbutton({
        onClick: function() {
            $("#dataBox").datagrid("reload")
        }
     })
});
function ErrorMessage(field,RowId)
{
    var Message = dhccl.runServerMethodNormal(ANCLS.BLL.CodeQueries, "GetErrotLogInfo", field,RowId);
    Message=character(Message);
    //$.messager.alert("简单提示",Message);    width: 380,
    $.messager.alert('提示', Message, '').window({ width: 500 });
}

function character(str) {
    return str.replace(/\u0000|\u0001|\u0002|\u0003|\u0004|\u0005|\u0006|\u0007|\u0008|\u0009|\u000a|\u000b|\u000c|\u000d|\u000e|\u000f|\u0010|\u0011|\u0012|\u0013|\u0014|\u0015|\u0016|\u0017|\u0018|\u0019|\u001a|\u001a|\u001b|\u001c|\u001d|\u001e|\u001f|\u007F/g, "");
}
