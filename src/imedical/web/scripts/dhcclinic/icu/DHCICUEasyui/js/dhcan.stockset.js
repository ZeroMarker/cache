// 初始化耗材套餐数据表格
function initStockSet(){
    var columns=[[
        {field:"Code",title:"代码",width:120},
        {field:"Description",title:"名称",width:160}
    ]];

    var dataForm = new DataForm({
        datagrid: $("#stockSetBox"),
        gridColumns: columns,
        gridTitle: "耗材套餐",
        gridTool: "#stockSetTools",
        form: $("#stockSetForm"),
        modelType: CLCLS.Config.StockSet,
        queryType: CLCLS.BLL.StockManager,
        queryName: "FindStockSet",
        queryParams:{
            Arg1:session.DeptID,
            ArgCnt:1
        },
        dialog: null,
        addButton: $("#btnAddStockSet"),
        editButton: $("#btnEditStockSet"),
        delButton: $("#btnDelStockSet"),
        onSubmitCallBack:setStockSetParam,
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack:selectStockSet
    });
    dataForm.initDataForm();
}

function setStockSetParam(param){
    param.Dept=session.DeptID;
}

function selectStockSet(){
    $("#stockSetItemBox").datagrid("reload");
}

// 初始化耗材套餐项目数据表格
function initStockSetItem(){
    var columns=[[
        {field:"SetItemDesc",title:"通用名",width:160},
        {field:"DefaultQty",title:"默认数量",width:80},
        // {field:"Price",title:"单价",width:80},
        {field:"UomDesc",title:"单位",width:80},
        // {field:"StockItemDesc",title:"耗材名称",width:160},
        {field:"StockItemSpec",title:"规格",width:80},
        {field:"ActiveDate",title:"开始日期",width:120},
        {field:"ExpireDate",title:"结束日期",width:120}
    ]];

    var dataForm = new DataForm({
        datagrid: $("#stockSetItemBox"),
        gridColumns: columns,
        gridTitle: "耗材套餐明细项",
        gridTool: "#stockSetItemTools",
        form: $("#stockSetItemForm"),
        modelType: CLCLS.Config.StockSetItem,
        queryType: CLCLS.BLL.StockManager,
        queryName: "FindStockSetItem",
        dialog: null,
        addButton: $("#btnAddStockSetItem"),
        editButton: $("#btnEditStockSetItem"),
        delButton: $("#btnDelStockSetItem"),
        beforeAddCallBack:selectOrderSet,
        submitCallBack: null,
        onSubmitCallBack:changeStockSetItemParam,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack:selectStockSetItem
    });
    dataForm.initDataForm();
    dataForm.datagrid.datagrid({
        onBeforeLoad:function(param){
            var stockSetId="";
            var selectedStockSet=$("#stockSetBox").datagrid("getSelected");
            if (selectedStockSet){
                stockSetId=selectedStockSet.RowId;
            }
            param.Arg1=stockSetId;
            param.ArgCnt=1;
        }
    });

    $("#StockItem").combogrid({
        panelWidth:400,
        idField:'RowId',
        textField:'GeneralDesc',
        url:ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindStockItemNew";
            param.Arg1 = param.q ? param.q : "";
            param.ArgCnt = 1;
        },
        columns:[[
            {field:'GeneralDesc',title:'项目',width:200},
            // {field:'Price',title:'单价',width:80},
            {field:'UomDesc',title:'单位',width:60},
            {field:'Spec',title:'规格',width:80},
            {field:'Manufacturer',title:'制造商',width:60},
            {field:'Vendor',title:'供应商',width:60}
        ]],
        mode:"remote",
        onSelect:function(rowIndex,rowData){
            $("#Uom").combobox("setValue",rowData.UomDr);
            $("#DefaultQty").numberbox("setValue",1);
        }
    });

    $("#Uom").combobox({
        valueField: "RowId",
        textField: "LocalDesc",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindUom";
            param.ArgCnt = 0;
        }
    });
}

function selectOrderSet(){
    var result=dhccl.hasRowSelected($("#stockSetBox"),true,"耗材套餐未选择，请先选择！");
    return result;
}

function changeStockSetItemParam(param){
    var stockSetId=$("#StockSet").val();
    if(!stockSetId || stockSetId===splitchar.empty){
        var selectedOrderSet=$("#stockSetBox").datagrid("getSelected");
        $("#StockSet").val(selectedOrderSet.RowId);
    }
    param.SetItemDesc=$("#StockItem").combogrid("getText");
}

function selectStockSetItem(){
    var selectedRow=$("#stockSetItemBox").datagrid("getSelected");
    if(selectedRow){
        $("#StockItem").combogrid("setText",selectedRow.GeneralDesc);
    }
}

$(document).ready(function(){
    initStockSet();
    initStockSetItem();
});