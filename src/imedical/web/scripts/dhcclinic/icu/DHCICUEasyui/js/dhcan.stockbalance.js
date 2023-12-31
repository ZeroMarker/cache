// 初始化材料月结数据表格
function initMonthBox(){
    // 自动生成月结报告
    // 月结数据表格设置
    $("#monthBox").datagrid({
        title: "材料月结",
        columns: [[
            {field:"FromDateDesc",title:"开始日期",width:140},
            {field:"ToDateDesc",title:"结束日期",width:140},
            {field:"StatusDesc",title:"审核状态",width:120},
        ]],
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageList: [10, 20, 30, 40, 50, 100, 200],
        pageSize: 20,
        toolbar: "#monthTool",
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.StockManager;
            param.QueryName="FindStockMonth";
            param.Arg1=session.DeptID;
            param.ArgCnt=1;
        },
        onSelect:function(rowIndex,rowData){
            $("#monthItemBox").datagrid("reload");
        }
    });

    $("#btnMonthSum").linkbutton({
        onClick:SumStock
    });
}

// 初始化材料月结项数据表格
// 列：名称、原始数量、入库数量、出库数量、月底数量
function initMonthItemBox(){
    $("#monthItemBox").datagrid({
        title: "材料月结明细",
        columns: [[
            {field:"StockMonthItemId",title:"StockMonthItemId",width:300,hidden:true},
            {field:"StockMonthId",title:"StockMonthId",width:300,hidden:true},
            {field:"StockItemDesc",title:"名称",width:300},
            {field:"Spec",title:"规格",width:120},
            {field:"OriginalQty",title:"原始数量",width:100},
            {field:"StockInQty",title:"入库数量",width:100},
            {field:"StockOutQty",title:"出库数量",width:100},
            {field:"MonthQty",title:"月底数量",width:100,editor: {type: 'numberbox'}}
        ]],
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageList: [10, 20, 30, 40, 50, 100, 200,1000],
        pageSize: 1000,
        toolbar: "#monthItemTool",
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            var selectedMonth=$("#monthBox").datagrid("getSelected");
            if(selectedMonth && selectedMonth.FromDateDesc && selectedMonth.ToDateDesc){
                param.ClassName=CLCLS.BLL.StockManager;
                param.QueryName="FindStockSum";
                param.Arg1=selectedMonth.RowId;
                param.Arg2=selectedMonth.FromDateDesc;
                param.Arg3=selectedMonth.ToDateDesc;
                param.ArgCnt=3;
            }
            
        },
        onBeginEdit:function(rowIndex,rowData){
            var selectedMonth=$("#monthBox").datagrid("getSelected");
            if(selectedMonth){
                if(selectedMonth.Status==="A"){
                    $("#monthBox").datagrid("cancelEdit",rowIndex);
                }
            }
        }
    });
    

    $("#btnAuditBalance").linkbutton({
        onClick:AuditBalance
    });

    $("#btnMonthSum").linkbutton({
        onClick:SumStock
    });

    $("#btnSaveMonthItem").linkbutton({
        onClick:saveMonthItem
    });
}

// 库存月结
function SumStock(){
    var fromDate=$("#FromDate").datebox("getValue");
    var toDate=$("#ToDate").datebox("getValue");
    var fromDateObj=new Date(fromDate);
    var toDateObj=new Date(toDate);
    if(!fromDateObj.isValidDate()){
        $.messager.alert("提示","月结开始日期不是有效日期。","warning");
        return;
    }
    if(!toDateObj.isValidDate()){
        $.messager.alert("提示","月结结束日期不是有效日期。","warning");
        return;
    }
    if(toDateObj<fromDateObj){
        $.messager.alert("提示","月结开始日期不能晚于结束日期。","warning");
        return;
    }
    var stockMonths=[];
    stockMonths.push({
        FromDate:$("#FromDate").datebox("getValue"),
        ToDate:$("#ToDate").datebox("getValue"),
        LocationDr:session.DeptID,
        CreatedUserDr:session.UserID,
        Status:"U",
        RowId:"",
        CreatedDate:"",
        CreatedTime:"",
        ClassName:CLCLS.Model.StockMonth
    });

    dhccl.saveDatas(ANCSP.DataListService,{
        jsonData:dhccl.formatObjects(stockMonths),
        ClassName:CLCLS.BLL.StockManager,
        MethodName:"SaveStockMonth"
    },function(data){
        var dataObj=dhccl.resultToJson(data);
        if(dataObj.success){
            $("#monthBox").datagrid("reload");
        }else{
            $.messager.alert("提示","库存月结失败，原因："+dataObj.result,"error");
        }
    });
}

function saveMonthItem(){
    var monthItems=$("#monthItemBox").datagrid("getRows");
    var selectedMonth=$("#monthBox").datagrid("getSelected");
    if(monthItems && monthItems.length>0){
        var saveMonthItems=[];
        for(var i=0;i<monthItems.length;i++){
            var monthItem=monthItems[i];
            saveMonthItems.push({
                StockMonthDr:selectedMonth.RowId,
                StockItemDr:monthItem.StockItemId,
                LocationDr:monthItem.LocId,
                Qty:monthItem.OriginalQty,
                Amount:monthItem.StockInQty,
                CostAmount:monthItem.StockOutQty,
                LastQty:monthItem.MonthQty,
                RowId:monthItem.StockMonthItemId?monthItem.StockMonthItemId:"",
                UpdateUser:session.UserID,
                ClassName:CLCLS.Model.StockMonthItem
            });
        }
        dhccl.saveDatas(ANCSP.DataListService,{
            jsonData:dhccl.formatObjects(saveMonthItems)
        },function(data){
            var dataObj=dhccl.resultToJson(data);
            if(dataObj.success){
                $("#monthItemBox").datagrid("reload");
            }else{
                $.messager.alert("提示","保存库存月结项目失败，原因："+dataObj.result,"error");
            }
        });
    }
}

// 审核库存
function AuditBalance(){
    if(dhccl.hasRowSelected($("#monthBox"),true,"请选择一条月结纪录，再进行审核。")){
        var selectedMonth=$("#monthBox").datagrid("getSelected");
        if(selectedMonth && selectedMonth.Status!=="A"){
            var monthData={
                RowId:selectedMonth.RowId,
                Status:"A",
                ClassName:CLCLS.Model.StockMonth
            };
            dhccl.saveDatas(ANCSP.DataListService,{
                jsonData:dhccl.formatObjects(monthData)
            },function(data){
                var dataObj=dhccl.resultToJson(data);
                if(dataObj.success){
                    $.messager.alert("提示","审核库存月结成功。","info");
                    $("#monthBox").datagrid("reload");
                }else{
                    $.messager.alert("提示","审核库存月结失败，原因："+dataObj.result,"error");
                }
            })
        }
    }
}

$(document).ready(function(){
    initMonthBox();
    initMonthItemBox();
});