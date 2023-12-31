function initPage(){
    initStatBox();
}

function initStatBox(){
    var columns=[[
        {field:"PatName",title:"患者姓名",width:70},
        {field:"PatGender",title:"性别",width:40},
        {field:"PatAge",title:"年龄",width:40},
        {field:"PatDeptDesc",title:"科室",width:80},
        {field:"PatBedCode",title:"床号",width:40},
        {field:"MedcareNo",title:"住院号",width:80},
        {field:"RegNo",title:"登记号",width:100},
        {field:"OperDate",title:"手术日期",width:100},
        {field:"SurgeonDesc",title:"手术医生",width:70},
        {field:"AnesthesiologistDesc",title:"麻醉医生",width:70},
        {field:"ScrubNurseDesc",title:"器械护士",width:70},
        {field:"CircualNurseDesc",title:"巡回护士",width:70},
        {field:"ChargeItemDesc",title:"医嘱名称",width:160},
        {field:"ChargeQty",title:"数量",width:40},
        {field:"ChargeUomDesc",title:"单位",width:40},
        {field:"Price",title:"单价",width:60},
        {field:"TotalPrice",title:"金额",width:50},
        {field:"InstrDesc",title:"用法",width:80},
        {field:"PrescNo",title:"处方号",width:130},
        {field:"BillStatus",title:"计费状态",width:70},
        {field:"StatusDesc",title:"医嘱状态",width:70},
        {field:"AuditUserDesc",title:"审核人",width:60}
    ]];

    $("#statBox").datagrid({
        title:"医嘱费用明细",
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
            var filterItemId=dhccl.getQueryString("filterItemId");
            var startDate=dhccl.getQueryString("startDate");
            var endDate=dhccl.getQueryString("endDate");
            var medcareNo=dhccl.getQueryString("medcareNo");

            param.ClassName=ANCLS.BLL.OperStatistics;
            param.QueryName="FindChargeDetails";
            param.Arg1=startDate;
            param.Arg2=endDate;
            param.Arg3=session.DeptID;
            param.Arg4=filterItemId;
            param.Arg5=medcareNo;
            param.ArgCnt=5;
        }
    });
}

$(document).ready(initPage);