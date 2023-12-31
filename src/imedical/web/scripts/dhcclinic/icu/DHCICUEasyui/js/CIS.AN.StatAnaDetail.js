var stat={
    init:function(){
        var _this=stat;
        var report=new Report({
            url:ANCSP.DataQuery,
            queryParams:{},
            onBeforeLoad:function(param){
                param.ClassName=ANCLS.BLL.OperScheduleList;
                param.QueryName="FindOperScheduleList";
                param.Arg1=$("#startDate").datebox("getValue");
                param.Arg2=$("#endDate").datebox("getValue");
                param.Arg3=session.DeptID;
                param.ArgCnt=3;
            },
            title:"手术麻醉记录明细",
            columns:[[
                {field:"OperDate",title:"手术日期",width:100},
                {field:"PatName",title:"患者姓名",width:80},
                {field:"PatGender",title:"性别",width:80},
                {field:"PatAge",title:"年龄",width:80},
                {field:"PatDeptDesc",title:"科室",width:80},
                {field:"PatBedCode",title:"床号",width:80}
            ]],
            toolbar:null,
            dateRange:"Week",
            enableDateRange:true
        });

        report.init();
    },

    getDatas:function(){
        var datas=dhccl.getDatas(ANCSP.DataQuery,{
            ClassName:ANCLS.BLL.OperScheduleList,
            QueryName:"FindOperScheduleList",
            Arg1:$("#startDate").datebox("getValue"),
            Arg2:$("#endDate").datebox("getValue"),
            Arg3:session.DeptID,
            ArgCnt:3
        },"json");
    }
}

$(document).ready(stat.init);