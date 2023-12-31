$(document).ready(function() {
    var columns = [
        [
            { field: "ConsumeDate", title: "日期", width: 160 },
            { field: "PatName", title: "患者姓名", width: 120 },
            { field: "MedcareNo", title: "住院号", width: 80 },
            { field: "SurgeonDesc", title: "手术医生", width: 100 },
            { field: "CircualNurseDesc", title: "巡回护士", width: 100 },
            { field: "MaterialCode", title: "材料编码", width: 120,hidden:true },
            { field: "MaterialDesc", title: "材料名称", width: 200 },
            { field: "Spec", title: "规格", width: 120 },
            { field: "Qty", title: "数量", width: 80 },
            { field: "UomDesc", title: "单位", width: 80 },
            { field: "ExpireDate", title: "效期", width: 160 },
            { field: "BatchNo", title: "批号", width: 120 },
            { field: "Price", title: "零价", width: 80 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#materialsBox"),
        gridColumns: columns,
        gridTitle: "一次性耗材使用记录",
        gridTool: "#materialsTools",
        form: $("#dataForm"),
        modelType: CLCLS.Model.StockConsume,
        queryType: CLCLS.BLL.StockManager,
        queryName: "FindStockConsumeByConditions",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: initDefaultValue,
        closeCallBack: null
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        headerCls: "panel-header",
        onBeforeLoad:function(param){
            param.Arg1=session.DeptID;
            param.Arg2=$("#startDate").datebox("getValue");
            param.Arg3=$("#endDate").datebox("getValue");
            param.Arg4=$("#queryType").combobox("getValue");
            param.Arg5=$("#medcareNo").val();
            param.Arg6=$("#stockItem").combobox("getValue");
            param.ArgCnt=6;
        }
    });

    initQueryConditions();
});

function initDefaultValue(dataForm) {

}

function initQueryConditions() {
    var today = (new Date()).format("yyyy-MM-dd");
    $("#startDate,#endDate").datebox("setValue", today);

    $("#stockItem").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindStockItem";
            param.Arg1 = param.q ? parm.q : "";
            param.ArgCnt = 1;
        }
    });
}