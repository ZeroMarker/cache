var stat={
    selectedOrderCat:null,
    totalPrice:0,
    orderCatSum:[],
    chargeStatList:[],
    summaryText:""
};

function initPage(){
    initStatBox();
    initQueryForm();
    initDefaultValue();
}

function initStatBox(){
    var columns=[[
        {field:"OrderCatDesc",title:"医嘱分类",width:80},
        {field:"ChargeItemDesc",title:"医嘱项",width:400},
        {field:"TotalQty",title:"数量",width:60},
        {field:"ChargeUomDesc",title:"单位",width:100},
        {field:"TotalPrice",title:"金额",width:120},
        {field:"Operator",title:"明细",width:80,formatter:function(value,row,index){
            var startDate=$("#startDate").datebox("getValue"),
                endDate=$("#endDate").datebox("getValue"),
                filterItemId=row.ArcimID,
                medcareNo=$("#medcareNo").val();
            var url="dhcan.anchargedetailstat.xdxa.csp?startDate="+startDate+"&endDate="+endDate+"&filterItemId="+filterItemId+"&medcareNo="+medcareNo;
            return "<a href='"+url+"' target='_blank' class='btn-details' style='color:#FF99CC'>明细</a>";
        }}
    ]];

    $("#statBox").datagrid({
        title:"医嘱费用汇总统计",
        headerCls:"panel-header-gray",
        fit:true,
        rownumbers: true,
        // pagination: true,
        // pageSize: 20,
        // pageList: [10,20,50, 100, 200],
        toolbar:"#statTools",
        url:ANCSP.DataQuery,
        columns:columns,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.OperStatistics;
            param.QueryName="FindChargeSum";
            param.Arg1=$("#startDate").datebox("getValue");
            param.Arg2=$("#endDate").datebox("getValue");
            param.Arg3=session.DeptID;
            param.Arg4=$("#filterItemId").combogrid("getValue");
            param.Arg5=$("#medcareNo").val();
            param.Arg6=$("#orderCat").combobox("getText")?$("#orderCat").combobox("getValue"):"";
            param.Arg7=$("#itemCat").combobox("getText")?$("#itemCat").combobox("getValue"):"";
            param.ArgCnt=7;
            stat.chargeStatList.length=0;
            stat.orderCatSum.length=0;
            stat.totalPrice=0;
            stat.summaryText="";
        },
        onLoadSuccess:function(data){
            // $(".btn-chargedetails").linkbutton({
            //     onClick:openChargeDetails
            // });
            var html=[];
            $("#sumContainer").empty();
            if(stat.orderCatSum && stat.orderCatSum.length>0){
                for(var i=0;i<stat.orderCatSum.length;i++){
                    var curOrderCatSum=stat.orderCatSum[i];
                    html.push("<span style='font-weight:bold;margin:0 0 0 20px;'>"+curOrderCatSum.name+"：</span><span>"+curOrderCatSum.price+"</span>");
                }
                html.push("<span style='font-weight:bold;margin:0 0 0 20px;'>总金额：</span><span>"+stat.totalPrice.toFixed(3)+"</span>");
                $("#sumContainer").append(html.join(""));
                stat.summaryText=html.join("");
                
            }
        },
        view: groupview,
        groupField: "OrderCatDesc",
        groupFormatter: function (value, rows) {
            var totalPrice=0;
            if(rows && rows.length>0){
                for(var i=0;i<rows.length;i++){
                    var row=rows[i];
                    var price=Number(row.TotalPrice);
                    if(!isNaN(price)){
                        totalPrice+=price;
                    }
                }
            }
            stat.totalPrice+=totalPrice;
            stat.orderCatSum.push({
                name:value,
                price:totalPrice.toFixed(3)
            });
            stat.chargeStatList.push({
                name:value,
                price:totalPrice.toFixed(3)
            });
            return value+" 总金额："+totalPrice.toFixed(3);
        }
    });
}

function initQueryForm(){
    $("#filterItemId").combogrid({
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.OEOrder;
            param.MethodName = "GetArcimJSON";
            param.Arg1=param.page;
            param.Arg2=param.rows;
            param.Arg3 = param.q?param.q:"";
            param.Arg4 = session.GroupID;
            param.Arg5 = session.DeptID;
            param.Arg6=session.EpisodeID;
            param.ArgCnt = 6;
        },
        pagination:true,
        pageSize:10,
        panelWidth:450,
        panelHeight:400,
        delay:500,
        pageNumber:1,
        idField: "ArcimId",
        textField: "ArcimDesc",
        columns:[[
            {field:"ArcimId",title:"ID",hidden:true},
            {field:"ArcimDesc",title:"医嘱项目",width:330},
            {field:"BaseUomDesc",title:"单位",width:40},
            {field:"Price",title:"单价",width:60}
        ]],
        mode: "remote"
    });

    $("#orderCat").combobox({
        textField:"Description",
        valueField:"RowId",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.OEOrder;
            param.QueryName="FindOrderCategory";
            param.ArgCnt=0;
        },
        onSelect:function(record){
            stat.selectedOrderCat=record.RowId;
            $("#itemCat").combobox("reload");
        }
    });

    $("#itemCat").combobox({
        textField:"Description",
        valueField:"RowId",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.OEOrder;
            param.QueryName="FindARCItemCat";
            param.Arg1=stat.selectedOrderCat || '';
            param.ArgCnt=1;
        }
    });

    $("#btnQuery").linkbutton({
        onClick:function(){
            $("#statBox").datagrid("reload");
        }
    });

    $("#btnPrint").linkbutton({
        onClick:function(){
            printChargeStat();
        }
    })
}

function initDefaultValue(){
    var today=(new Date()).format("yyyy-MM-dd");
    $("#startDate,#endDate").datebox("setValue",today);
}

function openChargeDetails(){

}

function printChargeStat(){
    var lodop=getLodop();
    lodop.PRINT_INIT("医嘱费用汇总统计");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");

    var startPos={
        x:30,
        y:30
    };
    lodop.SET_PRINT_STYLE("FontSize", 12);
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 620, 30, "医嘱费用汇总统计");
    lodop.SET_PRINT_STYLEA(0, "FontName", sheetPrintConfig.title.font.name);
    lodop.SET_PRINT_STYLEA(0, "FontSize", sheetPrintConfig.title.font.size);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

    startPos.y+=35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 200, 15, "科室："+session.DeptDesc);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+160, 200, 15, "开始日期："+$("#startDate").datebox("getValue"));
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+360, 200, 15, "结束日期："+$("#endDate").datebox("getValue"));
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);
    lodop.ADD_PRINT_HTM(startPos.y, startPos.x+560, "100%", 15, "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

    var htmlArr=[
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size: 14px;}",
        "table {table-layout:fixed;}",
        "tr {height:24px;} td {padding:5px;}</style>",
        "<table style='width:530pt;'><thead><tr>",
        "<th style='width:60pt'>医嘱分类</th>",
        "<th style='width:330pt'>医嘱项</th>",
        "<th style='width:40pt'>数量</th>",
        "<th style='width:50pt'>单位</th>",
        "<th style='width:50pt'>金额</th></tr></thead><tbody>"
    ];
    var rows=$("#statBox").datagrid("getRows");
    if(rows && rows.length>0){
        for(var i=0;i<stat.chargeStatList.length;i++){
            var chargeStat=stat.chargeStatList[i];
            htmlArr.push("<tr><td colspan='5' style='font-weight:bold;'>"+chargeStat.name+"  总金额："+chargeStat.price+"</td></tr>");
            for(var j=0;j<rows.length;j++){
                var row=rows[j];
                if(row.OrderCatDesc!==chargeStat.name) continue;
                htmlArr.push("<tr><td>"+row.OrderCatDesc+"</td><td>"+row.ChargeItemDesc+"</td><td>"+row.TotalQty+"</td><td>"+row.ChargeUomDesc+"</td><td>"+row.TotalPrice+"</td></tr>");
            }
        }
        
    }
    htmlArr.push("<tr><td colspan='5'>"+stat.summaryText+"</td></tr>");
    htmlArr.push("</tbody></table>");
    lodop.ADD_PRINT_TABLE(100,30,"RightMargin:1cm","BottomMargin:1cm",htmlArr.join(""));
    
    lodop.PREVIEW();
}

$(document).ready(initPage);