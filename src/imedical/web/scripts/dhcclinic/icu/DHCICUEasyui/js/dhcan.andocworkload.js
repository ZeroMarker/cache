var stopQuery = true;
$(document).ready(function() {
    $("#OperStartDate").datebox("setValue", ((new Date()).addDays(-7)).format("yyyy-MM-dd"));
    $("#OperEndDate").datebox("setValue", ((new Date()).addDays(-1)).format("yyyy-MM-dd"));
    $("#AnDoctor").combobox({
        textField: 'Description',
        valueField: 'RowId'
    });
    var datagrid = $("#data_grid");
    datagrid.datagrid({
        idField: "RowId",
        fit: true,
        rownumbers: true,
        //sortName: "OperDate,OperTime,AppDeptAlias",
        //sortOrder: "asc,asc,asc",
        remoteSort: false,
        //multiSort: true,
        title: "",
        nowrap: true,
        toolbar: "",
        url: dhccl.csp.dataQuery,
        queryParams: {
            ClassName: "DHCAN.BLL.AnesthetistWorkload",
            QueryName: "FindOperScheduleList",
            ArgCnt: 3
        },
        columns: [
            [{
                    field: "OperDate",
                    title: "手术日期",
                    width: 100
                }, {
                    field: "OperTime",
                    title: "手术时间",
                    width: 80
                },
                {
                    field: "AppDeptDesc",
                    title: "申请科室",
                    width: 100
                },
                {
                    field: "Patient",
                    title: "患者",
                    width: 120
                },
                {
                    field: "WardBed",
                    title: "病区床位",
                    width: 120,
                    hidden: true
                },
                {
                    field: "AnaTime",
                    title: "麻醉时间",
                    width: 80
                },
                {
                    field: "AnaCareProv",
                    title: "麻醉医护",
                    width: 120
                },
                {
                    field: "OperDeptDesc",
                    title: "手术室",
                    width: 100,
                    hidden: true
                },
                {
                    field: "OperInfo",
                    title: "手术名称",
                    width: 160
                },
                {
                    field: "SurgeonDesc",
                    title: "手术医生",
                    width: 80
                },
                {
                    field: "SurgeonShortDesc",
                    title: "医生别名",
                    width: 80,
                    hidden: true
                },
                {
                    field: "AssistantDesc",
                    title: "手术助手",
                    width: 100
                },
                {
                    field: "SurCareProv",
                    title: "手术医护",
                    width: 120,
                    hidden: true
                },
                {
                    field: "AdmReason",
                    title: "费别",
                    width: 100
                },
                {
                    field: "MedcareNo",
                    title: "住院号",
                    width: 80
                },
                {
                    field: "SourceTypeDesc",
                    title: "类型",
                    width: 60,
                    hidden: true
                },
                {
                    field: "OperStatusDesc",
                    title: "手术状态",
                    width: 80,
                    hidden: true
                }
            ]
        ],
        onBeforeLoad: function(param) {
            param.Arg1 = $("#OperStartDate").datebox("getValue");
            param.Arg2 = $("#OperEndDate").datebox("getValue");
            param.Arg3 = $("#AnDoctor").combobox('getValue');
            if (!param.Arg3) param.Arg3 = "All";
            if (stopQuery) return false;
        },
        rowStyler: function(index, row) {
            return "";
            "background-color:" + row.StatusColor + ";";
        },
        onLoadSuccess: function(data) {},
        view: groupview,
        groupField: "AnesthesiologistDesc",
        groupFormatter: function(value, rows) {
            return value + " 共完成" + rows.length + "台手术";
        },
        pagination: true,
        pageList: [200, 500],
        pageSize: 500
    });

    $("#btnQuery").click(function() {
        stopQuery = false;
        datagrid.datagrid('reload');
        // dhccl.getDatas(dhccl.csp.dataQuery, {
        //     ClassName: ANCLS.BLL.OperSchedule,
        //     QueryName: "FindOperScheduleList",
        //     Arg1: $("#OperStartDate").datebox("getValue"),
        //     Arg2: $("#OperEndDate").datebox("getValue"),
        //     Arg3: $("#AnDoctor").combobox('getValue'),
        //     ArgCnt: 3
        // }, 'json', true, function(data) {
        //     datagrid.datagrid('loadData', data);
        // });
    })

    dhccl.getDatas(dhccl.csp.dataQuery, {
        ClassName: "DHCCL.BLL.Admission",
        QueryName: "FindCareProvByLoc",
        Arg1: "",
        Arg2: session.DeptID,
        ArgCnt: 2
    }, 'json', true, function(data) {
        $("#AnDoctor").combobox('loadData', data);
    });
});