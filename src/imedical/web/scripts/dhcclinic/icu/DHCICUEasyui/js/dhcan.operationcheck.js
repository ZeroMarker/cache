var applicationInfo = null,
    patInfo = null,
    opsId = dhccl.getQueryString("opsId");
$(document).ready(function() {
    $("#operListBox").datagrid({
        title: "手术列表",
        height: 160,
        singleSelect: true,
        rownumbers: true,
        headerCls: 'panel-header-gray',
        toolbar: "#operListTools",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: dhcan.bll.operationList,
            QueryName: "FindOperationList",
            Arg1: opsId,
            ArgCnt: 1
        },
        onSelect: function(index, row) {

        },
        columns: [
            [{
                    field: "OperInfo",
                    title: "手术信息",
                    width: 240,
                    formatter: function(value, row, index) {
                        var result = row.OperationDesc,
                            addInfo = "";
                        if (row.OperClassDesc && row.OperClassDesc != "") {
                            addInfo += row.OperClassDesc;
                        }
                        if (row.BladeTypeDesc && row.BladeTypeDesc != "") {
                            if (addInfo != "") {
                                addInfo += "，";
                            }
                            addInfo += row.BladeTypeDesc + "切口";
                        }
                        if (row.BodySiteDesc && row.BodySiteDesc != "") {
                            if (addInfo != "") {
                                addInfo += "，";
                            }
                            addInfo += row.BodySiteDesc;
                        }
                        if (row.OperPosDesc && row.OperPosDesc != "") {
                            if (addInfo != "") {
                                addInfo += "，";
                            }
                            addInfo += row.OperPosDesc;
                        }
                        if (addInfo != "") {
                            result += "(" + addInfo + ")";
                        }
                        return result;
                    }
                },
                { field: "OperNote", title: "名称备注", width: 160 },
                {
                    field: "SurgeonInfo",
                    title: "手术医生",
                    width: 240,
                    formatter: function(value, row, index) {
                        var result = "";
                        if (row.SurgeonDesc && row.SurgeonDesc != "") {
                            result = row.SurgeonDesc;
                        }
                        if (row.AssistantDesc && row.AssistantDesc != "") {
                            if (result != "") {
                                result += ",";
                            }
                            result += row.AssistantDesc;
                        }
                        return result;
                    }
                },
                { field: "SurgeonDeptDesc", title: "医生科室", width: 120 },
                { field: "AddtionalStaff", title: "实习进修", width: 120 }

            ]
        ]
    });

    $("#operShiftBox").datagrid({
        title: "手术交接班列表",
        height: 160,
        singleSelect: true,
        rownumbers: true,
        headerCls: 'panel-header-gray',
        toolbar: "#operShiftTools",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: dhcan.bll.dataQuery,
            QueryName: "FindOperShift",
            Arg1: opsId,
            Arg2: "ON",
            ArgCnt: 2
        },
        columns: [
            [
                { field: "ShiftCareProvDesc", title: "交班护士", width: 120 },
                { field: "ReliefCareProvDesc", title: "接班护士", width: 120 },
                { field: "ShiftDT", title: "交接时间", width: 160 },
                { field: "ShiftNote", title: "交接说明", width: 240 }
            ]
        ]
    });

    $("#operDialog").dialog({
        buttons: [{
            text: "保存",
            iconCls: "icon-save",
            handler: function() {
                $("#operationForm").submit();
            }
        }, {
            text: "取消",
            iconCls: "icon-cancel",
            handler: function() {
                $("#operDialog").dialog("close");
            }
        }],
        onClose: function() {
            $("#operationForm").form("clear");
        }
    });

    $("#operationForm").form({
        url: dhccl.csp.dataService,
        onSubmit: function() {
            var isValid = $(this).form("validate");
            return isValid;
        },
        queryParams: {
            ClassName: dhcan.cls.operationList
        },
        success: function(data) {
            dhccl.showMessage(data, "保存", null, null, function() {
                $("#operationForm").form("clear");
                $("#operListBox").datagrid("reload");
                $("#operDialog").dialog("close");
            });
        }
    });

    $("#btnAddOperation").linkbutton({
        onClick: function() {
            initOperationForm();
            $("#operDialog").dialog("setTitle", "新增手术");
            $("#operDialog").dialog("open");
        }
    });

    $("#btnEditOperation").linkbutton({
        onClick: function() {
            if (hasRowSelected($("#operListBox"), true)) {
                var selectedOperation = $("#operListBox").datagrid("getSelected");
                $("#operationForm").form("load", selectedOperation);
                $("#Operation").combobox("setText", selectedOperation.OperationDesc);
                $("#operDialog").dialog("setTitle", "修改手术");
                $("#operDialog").dialog("open");
            }
        }
    });

    $("#btnDelOperation").linkbutton({
        onClick: function() {
            if (hasRowSelected($("#operListBox"), true)) {
                $.messager.confirm("确认", "是否删除该数据记录？", function(result) {
                    if (result) {
                        var selectedOperation = $("#operListBox").datagrid("getSelected");
                        var result = removeData("DHCAN.OperationList", selectedOperation.RowId);
                        dhccl.showMessage(result, "删除", null, null, function(data) {
                            $("#operListBox").datagrid("reload");
                        });
                    }
                });
            }
        }
    });

    $("#Operation").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.Arg2 = $("#Surgeon").combobox("getValue");
            param.Arg3 = $("#SurgeonDeptID").combobox("getValue");
        },
        queryParams: {
            ClassName: dhcan.bll.operation,
            QueryName: "FindOperation",
            Arg1: "QueryFilter",
            ArgCnt: 3
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        onSelect: function(record) {
            if (record.OperClass) {
                $("#OperClass").combobox("setValue", record.OperClass);
            }
            if (record.BladeType) {
                $("#BladeType").combobox("setValue", record.BladeType);
            }
            if (record.BodySite) {
                $("#BodySite").combobox("setValue", record.BodySite);
            }
            if (record.OperPos) {
                $("#OperPosition").combobox("setValue", record.OperPos);
            }
        }
    });

    $("#SurgeonDeptID").combobox({
        valueField: "RowId",
        textField: "Code",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhccl.bll.admission,
        //     QueryName: "FindLocation",
        //     Arg1: "",
        //     Arg2: "INOPDEPT^OUTOPDEPT^EMOPDEPT",
        //     ArgCnt: 2
        // }
        onBeforeLoad: function(param) {
                param.ClassName = dhccl.bll.admission;
                param.QueryName = "FindLocation";
                param.Arg1 = "";
                param.Arg2 = "INOPDEPT^OUTOPDEPT^EMOPDEPT";
                param.ArgCnt = 2;
            }
            // mode: "remote"
            // filter: function(q, row) {
            //     var upperQuery = q.toUpperCase();
            //     return row.Description.indexOf(upperQuery) >= 0;
            // }
    });

    $("#OperClass").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindOperClass",
        //     ArgCnt: 0
        // },
        onBeforeLoad: function(param) {
            param.ClassName = dhcan.bll.dataQuery;
            param.QueryName = "FindOperClass";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description"
    });

    $("#BladeType").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindBladeType",
        //     ArgCnt: 0
        // },
        onBeforeLoad: function(param) {
            param.ClassName = dhcan.bll.dataQuery;
            param.QueryName = "FindBladeType";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description"
    });

    $("#BodySite").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindBodySite",
        //     ArgCnt: 0
        // },
        onBeforeLoad: function(param) {
            param.ClassName = dhcan.bll.dataQuery;
            param.QueryName = "FindBodySite";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description"
    });

    $("#OperPos").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindOperPosition",
        //     ArgCnt: 0
        // },
        onBeforeLoad: function(param) {
            param.ClassName = dhcan.bll.dataQuery;
            param.QueryName = "FindOperPosition";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description"
    });

    $(".operinfo").combobox({
        onChange: function(newValue, oldValue) {
            var selector = "#" + $(this).attr("id") + "Desc",
                text = $(this).combobox("getText");
            $(selector).val(text);
            if ($(this).attr("id") == "SurgeonDeptID") {
                $("#Surgeon,.SurgeonAss").combobox("reload");
            }
        }
    });

    $("#Surgeon,.SurgeonAss").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = dhcan.bll.dataQuery;
            param.QueryName = "FindOperPosition";
            param.Arg1 = "QueryFilter";
            param.Arg2 = $("#SurgeonDeptID").combobox("getValue");
            param.ArgCnt = 2;
        },
        // queryParams: {
        //     ClassName: dhccl.bll.admission,
        //     QueryName: "FindCareProvByLoc",
        //     Arg1: "QueryFilter",
        //     ArgCnt: 2
        // },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });

    $(".SurgeonAss").combobox({
        onChange: function(newValue, oldValue) {
            var assistantIdArray = new Array(),
                assistantArray = new Array();
            $(".SurgeonAss").each(function() {
                var assistantId = $(this).combobox("getValue"),
                    assistant = $(this).combobox("getText");
                if (assistantId != "") {
                    assistantIdArray.push(assistantId);
                    assistantArray.push(assistant);
                }
            });
            $("#Assistant").val(assistantIdArray.join(","));
            $("#AssistantDesc").val(assistantArray.join(","));
        }
    });

    $("#shiftDialog").dialog({
        buttons: [{
            text: "保存",
            iconCls: "icon-save",
            handler: function() {
                var shiftDT = $("#ShiftDT").datetimebox("getValue"),
                    shiftDTArray = shiftDT.split(" ");
                $("#ShiftDate").val(shiftDTArray[0]);
                $("#ShiftTime").val(shiftDTArray[1]);
                $("#shiftForm").submit();
            }
        }, {
            text: "取消",
            iconCls: "icon-cancel",
            handler: function() {
                $("#shiftDialog").dialog("close");
            }
        }],
        onClose: function() {
            $("#shiftForm").form("clear");
        }
    });

    $("#shiftForm").form({
        url: dhccl.csp.dataService,
        onSubmit: function(param) {
            param.ClassName = "DHCAN.OperShift";
            var isValid = $(this).form("validate");
            return isValid;
        },
        //queryParams: {
        //    ClassName: "DHCAN.OperShift"
        //},
        success: function(data) {
            dhccl.showMessage(data, "保存", null, null, function() {
                $("#shiftForm").form("clear");
                $("#operShiftBox").datagrid("reload");
                $("#shiftDialog").dialog("close");
            });
        }
    });

    $("#btnAddShift").linkbutton({
        onClick: function() {
            initShiftForm();
            $("#shiftDialog").dialog("setTitle", "新增交接班信息");
            $("#shiftDialog").dialog("open");
        }
    });

    $("#btnEditShift").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected($("#operShiftBox"), true)) {
                var selectedShift = $("#operShiftBox").datagrid("getSelected");
                $("#shiftForm").form("load", selectedShift);
                $("#shiftDialog").dialog("setTitle", "修改交接班信息");
                $("#shiftDialog").dialog("open");
            }
        }
    });

    $("#btnDelShift").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected($("#operShiftBox"), true)) {
                $.messager.confirm("确认", "是否删除该数据记录？", function(result) {
                    if (result) {
                        var selectedShift = $("#operShiftBox").datagrid("getSelected");
                        var result = removeData("DHCAN.OperShift", selectedShift.RowId);
                        dhccl.showMessage(result, "删除", null, null, function(data) {
                            $("#operShiftBox").datagrid("reload");
                        });
                    }
                });
            }
        }
    });

    $("#ShiftCareProvID,#ReliefCareProvID,#ScrubNurse,#CircualNurse").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhccl.bll.admission,
        //     QueryName: "FindCareProvByLoc",
        //     Arg1: "QueryFilter",
        //     Arg2: session.DeptID,
        //     ArgCnt: 2
        // },
        onBeforeLoad: function(param) {
            param.ClassName = dhccl.bll.admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = "QueryFilter";
            param.Arg2 = session.DeptID;
            param.ArgCnt = 2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });

    $("#ScrubNurse,#CircualNurse").combobox({
        multiple: true
    });

    $("#OperRoom").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindOperRoom",
        //     Arg1: session.DeptID,
        //     ArgCnt: 1
        // },
        onBeforeLoad: function(param) {
            param.ClassName = dhcan.bll.dataQuery;
            param.QueryName = "FindOperRoom";
            param.Arg1 = session.DeptID;
            param.ArgCnt = 1;
        },
        valueField: "RowId",
        textField: "Description"
    });

    $("#btnSave").linkbutton({
        onClick: function() {
            var operSchedule = $("#operArrangeForm").serializeJson();
            // operSchedule.OperStartDT=(new Date(operSchedule.OperStartDT)).format('yyyy-MM-dd HH:mm:ss');
            // operSchedule.OperFinishDT=(new Date(operSchedule.OperFinishDT)).format('yyyy-MM-dd');
            // operSchedule.TheatreInDT=new Date(operSchedule.TheatreInDT).format('yyyy-MM-dd HH:mm:ss');
            // operSchedule.TheatreOutDT=new Date(operSchedule.TheatreOutDT).format('yyyy-MM-dd');
            var scrubNurses = $("#ScrubNurse").combobox("getValues");
            var scrubNurseStr = "";
            if (scrubNurses && scrubNurses.length > 0) {
                scrubNurseStr = scrubNurses.join(splitchar.comma);
            }
            var circualNurses = $("#CircualNurse").combobox("getValues");
            var circualNurseStr = "";
            if (circualNurses && circualNurses.length > 0) {
                circualNurseStr = circualNurses.join(splitchar.comma);
            }
            operSchedule.ScrubNurse = scrubNurseStr;
            operSchedule.CircualNurse = circualNurseStr;
            operSchedule.ClassName = "DHCAN.OperSchedule";
            operSchedule.Status = "";
            operSchedule.StatusCode = "Finish";
            var jsonData = dhccl.formatObjects(operSchedule)
            console.log(jsonData);
            var result = dhccl.saveDatas(dhccl.csp.dataListService, {
                ClassName: dhcan.bll.operSchedule,
                MethodName: "CheckApplication",
                jsonData: jsonData
            });
            dhccl.showMessage(result, "保存", null, null, function() {
                closeWindow();
            });
        }
    });

    loadApplicationInfo();
    loadPatInfo();
    $("#patInfoForm").form("load", patInfo);
    $("#operArrangeForm").form("load", applicationInfo);
    loadOperNurses();
});

function loadOperNurses() {
    if (applicationInfo) {
        if (applicationInfo.ScrubNurse && applicationInfo.ScrubNurse != "") {
            var scrubNurseArray = applicationInfo.ScrubNurse.split(splitchar.comma);
            $("#ScrubNurse").combobox("setValues", scrubNurseArray);
        }
        if (applicationInfo.CircualNurse && applicationInfo.CircualNurse != "") {
            var circualNurseArray = applicationInfo.CircualNurse.split(splitchar.comma);
            $("#CircualNurse").combobox("setValues", circualNurseArray);
        }
    }
}

function initOperationForm() {
    if (applicationInfo && applicationInfo.AppDeptID) {
        $("#SurgeonDeptID").combobox("setValue", applicationInfo.AppDeptID);
        $("#OperOperSchedule").val(opsId);
    }
}

function initShiftForm() {
    $("#ShiftOperSchedule").val(opsId);
    $("#ShiftType").val("ON");
}

function loadApplicationInfo() {
    var datas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: dhcan.bll.operSchedule,
        QueryName: "FindOperScheduleList",
        Arg1: "",
        Arg2: "",
        Arg3: session.DeptID,
        Arg4: opsId,
        ArgCnt: 4
    }, "json");
    if (datas && datas.length > 0) {
        applicationInfo = datas[0];
    }
}

function loadPatInfo() {
    if (applicationInfo && applicationInfo.EpisodeID && applicationInfo.EpisodeID != "") {
        var datas = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: dhccl.bll.admission,
            QueryName: "FindPatient",
            Arg1: applicationInfo.EpisodeID,
            ArgCnt: 1
        }, "json");
        if (datas && datas.length > 0) {
            patInfo = datas[0];
        }
    }
}

function closeWindow() {
    if (window.parent && window.parent.closeCurrentTab) {
        window.parent.closeCurrentTab();
    } else {
        top.window.opener = null;
        top.window.open("", "_self");
        top.window.close();
        // window.open("", "_self", "");
        // window.close();
    }
}