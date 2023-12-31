function initPage(){
    initForm();
    initGrid();
}

function initForm(){
    $("#ArcimID").combobox({
        valueField: "ArcimId",
        textField: "ArcimDesc",
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.OEOrder;
            param.MethodName = "GetArcimJSON";
            param.Arg1=param.q?param.q:"";
            param.Arg2=session.GroupID;
            param.Arg3=session.DeptID;
            param.Arg4="";
            param.ArgCnt = 4;
        },
        onSelect:function(record){
            $("#Uom").combobox("setValue",record.BaseUomId)
        },
        mode:"remote"
    });

    $("#Uom").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindUom";
            param.Arg1=param.q?param.q:"";
            param.ArgCnt = 1;
        },
        mode:"remote"
    });
}

function initGrid(){
    var columns = [
        [
            { field: "ArcimDesc", title: "医嘱项", width: 280 },
            { field: "Description", title: "名称", width: 120 },
            { field: "ArticleTypeDesc", title: "物品类型", width: 100 },
            { field: "ActiveDate", title: "生效日期", width: 160 },
            { field: "ExpiredDate", title: "失效日期", width: 160 },
            { field: "ReservationDesc", title: "预约物品", width: 80 },
            { field: "UomDesc", title: "物品单位", width: 80 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#articleBox"),
        gridColumns: columns,
        gridTitle: "常用麻醉物品列表",
        gridTool: "#articleTools",
        form: $("#articleForm"),
        modelType: ANCLS.Config.NarcoticArticle,
        queryType: ANCLS.BLL.NarcoticArticle,
        queryName: "FindNarcoticArticle",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        clearButton:$("#btnClear"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack:selectArticle
    });
    dataForm.initDataForm();
    dataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterDesc").val();
            param.Arg2 = $("#filterArticleType").combobox("getValue");
            param.ArgCnt = 2;
        }
    })
}

function selectArticle(row){
    $("#ArcimID").combobox("setText",row.ArcimDesc);
}

$(document).ready(initPage);