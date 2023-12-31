var groupOperActions = null;
$(document).ready(function () {
    operDataManager.initFormData();
    var dataBox = $("#operlistBox"),
        tomorrow = (new Date()),
        defaultDate = tomorrow.format("yyyy-MM-dd"),
        operStatusList = getOperStatus();
    $("#OperStartDate").datebox("setValue", defaultDate);
    $("#OperEndDate").datebox("setValue", defaultDate);
    // $("#operlistTool").hide();
    if (!groupOperActions) {
        loadGroupOperActions();
        loadCommonActions();
    }

    dataBox.datagrid({
        fit: true,
        // singleSelect: true,
        // nowrap: false,
        rownumbers: true,
        pagination: false,
        pageSize: 200,
        pageList: [50, 100, 200],
        toolbar: "#operlistTool",
        url: ANCSP.DataQuery,
        sortName: "OperDate,RoomInfo,OperSeqInfo",
        sortOrder: "asc,asc,asc",
        remoteSort: false,
        checkbox: true,
        frozenColumns: [
            [{
                    field: "CheckStatus",
                    checkbox: true
                }
                // {
                //     field: "Operate",
                //     title: "操作",
                //     width: 160,
                //     formatter: function (value, row, index) {
                //         var commonActionList = getCommonActions();
                //         var statusActionList = getStatusActions(row.Status);
                //         statusActionList = statusActionList.concat(commonActionList);
                //         var html = "";
                //         if (statusActionList && statusActionList.length > 0) {
                //             $.each(statusActionList, function (index, item) {
                //                 itemStr = JSON.stringify(item);
                //                 rowStr = JSON.stringify(row);
                //                 html += "<a href='#' class='status-permission' iconCls='" + item.Icon + "'";
                //                 html += "data-desc='" + item.OperActionDesc + "'";
                //                 html += "data-row='" + rowStr + "'";
                //                 html += "data-opsid='" + row.RowId + "'";
                //                 html += "data-item='" + itemStr + "'>";
                //                 html += "</a>";
                //             });
                //         }
                //         return html;
                //     }
                // }
            ]
        ],
        columns: [
            [

                {
                    field: "OperDate",
                    title: "手术日期",
                    width: 90,
                    sortable: true
                },
                {
                    field: "RoomInfo",
                    title: "手术间",
                    width: 80,
                    sortable: true,
                    hidden:true
                },
                {
                    field: "RoomDesc",
                    title: "手术间",
                    width: 80,
                    sortable: true
                },
                {
                    field: "OperSeq",
                    title: "台次",
                    width: 60
                },
                {
                    field: "OperSeqInfo",
                    title: "台次信息",
                    width: 60,
                    sortable: true,
                    order: "asc",
                    hidden: true
                },
                {
                    field: "PatName",
                    title: "姓名",
                    width: 80
                },
                {
                    field: "PatGender",
                    title: "性别",
                    width: 60
                },
                {
                    field: "PatAge",
                    title: "年龄",
                    width: 60
                },
                {
                    field: "AppDeptDesc",
                    title: "申请科室",
                    width: 100
                },
                {
                    field: "OperDeptDesc",
                    title: "手术室",
                    width: 100,
                    hidden: true
                },
                {
                    field: "PrevDiagnosisDesc",
                    title: "术前诊断",
                    width: 100,
                    formatter: function (value, row, index) {
                        return "<span title='" + value + "'>" + value + "</span>";
                    }
                },
                {
                    field: "OperInfo",
                    title: "手术名称",
                    width: 160,
                    formatter: function (value, row, index) {
                        return "<span title='" + value + "'>" + value + "</span>";
                    }
                },
                {
                    field: "SourceTypeDesc",
                    title: "类型",
                    width: 80,
                    formatter: function (value, row, index) {
                        if (row.SourceType) {
                            switch (row.SourceType) {
                                case "B":
                                    return "<span class='sourcetype-text sourcetype-book'>" + value + "</span>";
                                case "E":
                                    return "<span class='sourcetype-text sourcetype-em'>" + value + "</span>";
                            }
                        }
                    }
                },
                {
                    field: "SurgeonDesc",
                    title: "手术医生",
                    width: 80
                },
                {
                    field: "AssistantDesc",
                    title: "手术助手",
                    width: 100
                },
                {
                    field: "AnaExpertDesc",
                    title: "麻醉指导",
                    width: 80
                },
                {
                    field: "AnesthesiologistDesc",
                    title: "麻醉医生",
                    width: 80
                },
                {
                    field: "AnaAssistantDesc",
                    title: "麻醉助手",
                    width: 100
                },
                {
                    field: "PrevAnaMethodDesc",
                    title: "麻醉方法",
                    width: 100
                },
                {
                    field: "ScrubNurseDesc",
                    title: "器械护士",
                    width: 80
                },
                {
                    field: "CircualNurseDesc",
                    title: "巡回护士",
                    width: 80
                },
                {
                    field: "OperRequirementDesc",
                    title: "手术要求",
                    width: 120,
                    hidden:true,
                    formatter: function (value, row, index) {
                        return "<span title='" + value + "'>" + value + "</span>";
                    }
                },
                {
                    field: "LabInfo",
                    title: "检验信息",
                    width: 120,
                    hidden:true,
                    formatter: function (value, row, index) {
                        return "<span title='" + value + "'>" + value + "</span>";
                    }
                },
                {
                    field: "InfectionOper",
                    title: "感染手术",
                    width: 80
                },
                {
                    field: "OperStatusDesc",
                    title: "手术状态",
                    width: 80
                },
                {
                    field: "MedcareNo",
                    title: "住院号",
                    width: 100
                },
                {
                    field: "RegNo",
                    title: "登记号",
                    width: 100,
                    hidden:false
                },
                {
                    field: "AdmReason",
                    title: "费别",
                    width: 100
                }
            ]
        ],
        rowStyler: function (index, row) {
            return "background-color:" + row.StatusColor + ";";
        },
        onBeforeLoad: function (param) {
            var status=$("#OperStatus").combobox("getValue");
            if (status==="" || $("#OperStatus").combobox("getText")===""){
                status="Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut";
            }
            param.ClassName = ANCLS.BLL.OperSchedule;
            param.QueryName = "FindOperScheduleList";
            param.Arg1 = $("#OperStartDate").datebox("getValue");
            param.Arg2 = $("#OperEndDate").datebox("getValue");
            param.Arg3 = session.DeptID;
            param.Arg4 = "";
            param.Arg5 = ($("#AppDept").combobox("getText")==="")?"":($("#AppDept").combobox("getValue"));
            param.Arg6 = ($("#PatWard").combobox("getText")==="")?"":($("#PatWard").combobox("getValue"));
            param.Arg7 = status;
            param.Arg8 = ($("#OperRoom").combobox("getText")==="")?"":($("#OperRoom").combobox("getValue"));
            param.Arg9 = $("#RegNo").val() || '';
            param.Arg10 = $("#MedcareNo").val() || '';
            param.Arg11 = "N";
            param.Arg12 = "N";
            param.Arg13 = "N";
            param.Arg14="";
            param.Arg15="";
            param.Arg16="";
            param.Arg17="";
            param.Arg18=($("#OperFloor").combobox("getText")==="")?"":($("#OperFloor").combobox("getValue"));
            param.ArgCnt = 18;
        },
        onSelect: function (index, row) {
            selectPatient(row);
        },
        onLoadSuccess: function (data) {
            $(".status-permission").linkbutton({
                plain: true
            });

            $(".status-permission").each(function () {
                var tooltip = $(this).attr("data-desc");
                $(this).tooltip({
                    content: tooltip
                });
                var execFunction = eval($(this).attr("data-function"));
                $(this).linkbutton({
                    onClick: function () {
                        var dataItem = $(this).attr("data-item"),
                            dataRow = $(this).attr("data-row"),
                            dataRowObj = JSON.parse(dataRow),
                            dataItemObj = JSON.parse(dataItem);
                        if (dataItemObj && dataItemObj.ExecFunc) {
                            var execFunc = eval(dataItemObj.ExecFunc);
                            execFunc(dataRowObj, dataItemObj);
                        }
                    }
                });
            });

            if(data && data.rows){
                var EMOperCount=0,totalOperCount=data.rows.length,BookedOperCount=0;
                for(var i=0;i<data.rows.length;i++){
                    var row=data.rows[i];
                    if(row.SourceType==="E"){
                        EMOperCount+=1;
                    }else if(row.SourceType==="B"){
                        BookedOperCount+=1;
                    }
                }
                var panel=$("body").layout("panel",'center');
                $(panel).panel("setTitle","手术列表(共"+data.rows.length+"台手术，其中 择期："+BookedOperCount+"台，急诊："+EMOperCount+"台)");
            }
        },
        onDblClickRow:function(rowIndex,rowData){
            var csp=getDBClickUrl(session.DeptID);
            window.location=csp+"?opsId="+rowData.RowId+"&PatientID="+rowData.PatientID+"&EpisodeID="+rowData.EpisodeID+"&EpisodeLocID="+rowData.PatDeptID+"&AnaesthesiaID="+rowData.ExtAnaestID;
            // var url=csp+"?opsId="+rowData.RowId+"&PatientID="+rowData.PatientID+"&EpisodeID="+rowData.EpisodeID+"&EpisodeLocID="+rowData.PatDeptID+"&AnaesthesiaID="+rowData.ExtAnaestID;
            // if(window.screen){
            //     var height=window.screen.availHeight-30;
            //     var width=window.screen.availWidth-10;
            //     window.open(url,"","top=0,left=0,width="+width+",height="+height+",menubar=0,location=0,toolbar=0,titlebar=0,resizable=1");
            // }else{
            //     window.open(url,"","menubar=0,location=0,toolbar=0,titlebar=0,resizable=1");
            // }
            
        }
    });

    $("#AppDept").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: CLCLS.BLL.Admission,
        //     QueryName: "FindLocation",
        //     Arg1: "QueryFilter",
        //     Arg2: "INOPDEPT^OUTOPDEPT^EMOPDEPT",
        //     ArgCnt: 2
        // },
        onBeforeLoad: function (param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = "INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt = 2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        onLoadSuccess: function () {
            var dataList = $(this).combobox("getData");
            if (dataList && dataList.length > 0) {
                for (var i = 0; i < dataList.length; i++) {
                    var element = dataList[i];
                    if (element.RowId == session.DeptID) {
                        $(this).combobox("setValue", session.DeptID);
                        $(this).combobox("disable");
                        dataBox.datagrid("reload");
                    }
                }
            }
        }
    });

    $("#OperStatus").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: ANCLS.BLL.CodeQueries,
        //     QueryName: "FindOperStatus",
        //     ArgCnt: 0
        // }
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperStatus";
            param.ArgCnt = 0;
        }
    });

    $("#PatWard").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: CLCLS.BLL.Admission,
        //     QueryName: "FindWard",
        //     ArgCnt: 0
        // }
        onBeforeLoad: function (param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindWard";
            param.ArgCnt = 0;
        }
    });

    $("#OperRoom").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: ANCLS.BLL.CodeQueries,
        //     QueryName: "FindOperRoom",
        //     Arg1: "",
        //     ArgCnt: 0
        // }
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindOperRoom";
            param.Arg1 = "";
            param.Arg2="R";
            param.ArgCnt = 2;
        }
    });

    $("#OperFloor").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperFloor";
            param.ArgCnt = 0;
        }
    });

    $("#btnQuery").linkbutton({
        onClick: function () {
            dataBox.datagrid("reload");
        }
    });

    $("#btnBatAudit").linkbutton({
        onClick: auditApplications
    });

    $("#moduleDialog").dialog({
        onClose: function () {
            $("#operlistBox").datagrid("reload");
        }
    });

    $("#btnPrint").linkbutton({
        onClick:function(){
            var printDatas = dataBox.datagrid("getSelections");
            if (printDatas && printDatas.length > 0) {
                // printList(printDatas, "arrange");
                var LODOP=getLodop();
                printListNew(printDatas, "arrange",LODOP);
                LODOP.PREVIEW();
            } else {
                $.messager.alert("提示", "列表无数据可打印", "warning");
            }
        }
    });

    $("#btnExport").linkbutton({
        onClick:function(){
            exportExcel();
        }
    });

    $("#btnExportShift").linkbutton({
        onClick:function(){
            exportShift();
        }
    });

    $("#btnGenMatReg").linkbutton({
        onClick:function(){
            exportHVM();
        }
    });

    $("#btnDel").linkbutton({
        onClick:cancelOperList
    });

    initOperCancelReason();

});

function cancelOperList(){
	var selectionRows=$("#operlistBox").datagrid("getChecked");
	if(!selectionRows || selectionRows.length<=0)
	{
		$.messager.alert("提示","请先选择需要删除的手术，再进行操作！","warning");
		return;
	}
    $.messager.confirm("提示","是否删除所有勾选的手术，删除后将不能手术查询列表查询到这些手术？",function(r){
        if(r){
			var opsIdArr=[];
            for(var i=0;i<selectionRows.length;i++){
				var row=selectionRows[i];
				opsIdArr.push(row.RowId);
			}
            var result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"CancelArrange",opsIdArr.join("^"),session.UserID);
            if(result.success){
                $("#operlistBox").datagrid("reload");
            }else{
                $.messager.alert("提示","删除手术失败，原因："+result.result,"error");
            }
        }
    });
}

function exportExcel(){
    var printData = $("#operlistBox").datagrid("getData");
    if(printData && printData.rows && printData.rows.length>0){
        var dataRows=printData.rows;
        printList(dataRows,"arrange");
    }
}

function exportShift(){
    var printData = $("#operlistBox").datagrid("getData");
    if(printData && printData.rows && printData.rows.length>0){
        var dataRows=printData.rows;
        printShiftList(dataRows,"opshift");
    }
}

function exportHVM(){
    var printData = $("#operlistBox").datagrid("getData");
    if(printData && printData.rows && printData.rows.length>0){
        var dataRows=printData.rows;
        printHVMList(dataRows,"HVM");
    }
}

function auditApplications() {
    var selectedRows = $("#operlistBox").datagrid("getSelections"),
        applicationDatas = [];
    for (var i = 0; i < selectedRows.length; i++) {
        var selectedRow = selectedRows[i];
        if (selectedRow.OperStatusCode === dhcan.status.application) {
            applicationDatas.push(selectedRow);
        }
    }
    if (applicationDatas.length < 1) {
        $.messager.alert("提示", "当前选择的手术中，没有申请状态的手术！", "warning");
        return;
    }
    var message = (applicationDatas.length > 1) ? "当前选择了多条申请状态的手术，是否批量审核手术申请？" : "是否审核该手术？";
    $.messager.confirm("确认", message, function (result) {
        if (result) {
            var dataList = [];
            for (var i = 0; i < applicationDatas.length; i++) {
                var selectedRow = applicationDatas[i];
                dataList.push({
                    RowId: selectedRow.RowId,
                    ClassName: ANCLS.Model.OperSchedule,
                    Status: "",
                    StatusCode: dhcan.status.audit
                });
            }
            var jsonData = dhccl.formatObjects(dataList);
            $.post(dhccl.csp.dataListService, {
                MethodName: "SaveOperArrange",
                ClassName: ANCLS.BLL.OperArrange,
                jsonData: jsonData
            }, function (data) {
                dhccl.showMessage(data, "审核");
                $("#operlistBox").datagrid("reload");
            });
        }
    });
}

function sendMessage() {

}

function addApplication() {
    var href = "<iframe scrolling='yes' frameborder='0' src='dhcan.operapplication.csp?opsId=&EpisodeID=&moduleId=' style='width:100%;height:100%;'></iframe>",
        title = "手术申请";
    $("#moduleDialog").dialog({
        content: href,
        width: 1280
    });
    $("#moduleDialog").dialog("setTitle", title);
    $("#moduleDialog").dialog("open");
}

function cancelApplication() {
    $("#OperScheduleID").val($(this).attr("data-opsid"));
    $("#operCancelReason").dialog("open");
}

function getOperStatus() {
    var result = null;
    $.ajax({
        url: ANCSP.DataQuery,
        async: false,
        data: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindOperStatus",
            ArgCnt: 0
        },
        type: "post",
        success: function (data) {
            result = data;
        }
    });
    return result;
}

/**
 * 加载安全组的操作功能
 * @author chenchangqing 20170823
 */
function loadGroupOperActions() {
    var moduleID = dhccl.getQueryString("moduleId");
    $.ajax({
        url: ANCSP.DataQuery,
        async: false,
        data: {
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindActionPermission",
            Arg1: session.GroupID,
            Arg2: moduleID,
            Arg3: "Y",
            ArgCnt: 3
        },
        type: "post",
        dataType: "json",
        success: function (data) {
            groupOperActions = data;
        }
    });
}

function loadCommonActions() {
    if (!groupOperActions) {
        loadGroupOperActions();
    }
    var commonActions = getCommonActions();
    if (commonActions && commonActions.length > 0) {
        for (var i = 0; i < commonActions.length; i++) {
            var action = commonActions[i];
            if (!action.ElementID || action.ElementID === "") continue;
            var selector = "#" + action.ElementID;
            if ($(selector).length < 1) continue;
            var html = "<a href='#' class='common-action hisui-linkbutton' iconCls='" + action.Icon + "' ";
            html += "data-options='onClick:" + action.ExecFunc + "'>" + action.OperActionDesc + "</a>";
            $(selector).append(html);
        }
        $(".common-action").linkbutton({
            plain: true
        });
    }
}

/**
 * 获取关联手术状态的操作功能
 * @param {string} operStatusID 
 * @return {array} 手术状态对应操作功能数组
 * @author chenchangqing 20170823
 */
function getStatusActions(operStatusID) {
    var result = [];
    if (groupOperActions && groupOperActions) {
        for (var i = 0; i < groupOperActions.length; i++) {
            var element = groupOperActions[i];
            if (element.OperStatus != "") {
                var operStatusArray = element.OperStatus.split(splitchar.comma);
                if (operStatusArray.indexOf(operStatusID) >= 0) {
                    result.push(element);
                }
            }
        }
    }
    return result;
}

/**
 * 获取未关联手术状态的操作功能
 * @return {array} 未关联手术状态的操作功能数组
 * @author chenchangqing 20170823
 */
function getCommonActions() {
    var result = [];
    if (groupOperActions && groupOperActions) {
        for (var i = 0; i < groupOperActions.length; i++) {
            var element = groupOperActions[i];
            if (!element.OperStatus || element.OperStatus === "") {
                result.push(element);
            }
        }
    }
    return result;
}

function initOperCancelReason() {

    $("#reasonForm").form({
        url: ANCSP.DataService,
        onSubmit: function () {
            var isValid = $(this).form("validate");
            return isValid;
        },
        queryParams: {
            ClassName: ANCLS.Model.OperSchedule,
            Status: "",
            StatusCode: "Cancel"
        },
        success: function (data) {
            dhccl.showMessage(data, "保存", null, null, function () {
                $("#reasonForm").form("clear");
                var dataDialog = $("#operCancelReason");
                if (dataDialog && dataDialog.length > 0) {
                    dataDialog.dialog("close");
                }
                $("dataBox").datagrid("reload");
            });
        }
    });

    $("#ReasonOptions").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindReason";
            param.Arg1 = "C";
            param.ArgCnt = 1;
        },
        onChange: function (newValue, oldValue) {
            var reasonDesc = $("#CancelReason").val(),
                currentOption = $(this).combobox("getText");
            if (currentOption == "") return;
            if ($.trim(reasonDesc) != "") {
                reasonDesc += "；";
            }
            reasonDesc += currentOption;
            $("#CancelReason").val(reasonDesc);
            $("#ReasonOptions").combobox("clear");
        }
    })

    $("#btnExitReason").linkbutton({
        onClick: function () {
            $("#reasonForm").form("clear");
            $("#operCancelReason").dialog("close");
        }
    });

    $("#btnSaveReason").linkbutton({
        onClick: function () {
            var formData = $("#reasonForm").serializeJson();
            if (formData) {
                var operSchedule = {
                    ClassName: ANCLS.Model.OperSchedule,
                    RowId: formData.OperScheduleID,
                    Status: "",
                    StatusCode: "Cancel",
                    OriginalStatusCode: "^Application^Audit^",
                    CancelReason: formData.CancelReason
                };
                var result = dhccl.saveDatas(ANCSP.DataListService, {
                    jsonData: dhccl.formatObjects(operSchedule),
                    MethodName: "CancelApplications",
                    ClassName: ANCLS.BLL.OperSchedule
                });
                dhccl.showMessage(result, "保存", null, null, function () {
                    $("#operCancelReason").dialog("close");
                    $("#operlistBox").datagrid("reload");
                });
            }
        }
    });
}

function defaultHandler(dataRow, dataItem) {
    if (dataRow && dataItem) {
        var href = "<iframe scrolling='yes' frameborder='0' src='" + dataItem.LinkModuleUrl + "?opsId=" + dataRow.RowId + "&EpisodeID=" + dataRow.EpisodeID + "&moduleId=" + dataItem.LinkModule + "' style='width:100%;height:100%;'></iframe>",
            title = dataRow.PatName + "的" + dataItem.LinkModuleDesc;
        $("#moduleDialog").dialog({
            content: href
        });
        $("#moduleDialog").dialog("setTitle", title);
        $("#moduleDialog").dialog("open");
    }
}

function revokeApplication(dataRow, dataItem) {
    $("#reasonForm").form({
        queryParams: {
            ClassName: ANCLS.Model.OperSchedule,
            Status: "",
            StatusCode: dhcan.status.revoke,
            RowId: dataRow.RowId
        }
    });

    $("#OperScheduleID").val(dataRow.RowId);
    $("#operCancelReason").dialog("setTitle", "撤消手术申请原因");
    $("#operCancelReason").dialog("open");
}

function declineApplication(dataRow, dataItem) {
    $("#reasonForm").form({
        queryParams: {
            ClassName: ANCLS.Model.OperSchedule,
            Status: "",
            StatusCode: dhcan.status.decline,
            RowId: dataRow.RowId
        }
    });

    $("#OperScheduleID").val(dataRow.RowId);
    $("#operCancelReason").dialog("setTitle", "拒绝手术申请原因");
    $("#operCancelReason").dialog("open");
}

function cancelOperation(dataRow, dataItem) {
    $("#reasonForm").form({
        queryParams: {
            ClassName: ANCLS.Model.OperSchedule,
            Status: "",
            StatusCode: "Cancel",
            RowId: dataRow.RowId
        }
    });

    $("#OperScheduleID").val(dataRow.RowId);
    $("#operCancelReason").dialog("setTitle", "取消手术原因");
    $("#operCancelReason").dialog("open");
}

function auditApplication(dataRow, dataItem) {
    var selectedRows = $("#operlistBox").datagrid("getSelections");
    var message = (selectedRows && selectedRows.length > 0) ? "当前选择了多条手术，是否批量审核手术申请？" : "是否审核该手术？";
    $.messager.confirm("确认", message, function (result) {
        if (result) {
            var dataList = [];
            if (selectedRows && selectedRows.length) {
                for (var i = 0; i < selectedRows.length; i++) {
                    var selectedRow = selectedRows[i];
                    if (selectedRow.OperStatusCode != dhcan.status.application) continue;
                    dataList.push({
                        RowId: selectedRow.RowId,
                        ClassName: ANCLS.Model.OperSchedule,
                        Status: "",
                        StatusCode: dhcan.status.audit
                    });
                }
            } else {
                dataList.push({
                    RowId: dataRow.RowId,
                    ClassName: ANCLS.Model.OperSchedule,
                    Status: "",
                    StatusCode: dhcan.status.audit
                });
            }


            var jsonData = dhccl.formatObjects(dataList);
            $.post(dhccl.csp.dataListService, {
                MethodName: "SaveOperArrange",
                ClassName: ANCLS.BLL.OperArrange,
                jsonData: jsonData
            }, function (data) {
                dhccl.showMessage(data, "审核");
                $("#operlistBox").datagrid("reload");
            })
        }
    });
}

function printApplication(dataRow, dataItem) {
    var lodop = getLodop();
    var appData = dataRow;
    lodop.PRINT_INIT("打印术前访视记录单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");

    lodop.ADD_PRINT_HTM(20, 0, "100%", 30, "<h2 style='text-align:center'>揭阳市人民医院手术通知单</h2>");
    // lodop.ADD_PRINT_HTML(0, 0, "100%", "100%", html);

    var html = "<style>* {font-size:14px;} .headerItem {margin-right:40px;}</style><div style='padding:0 45px;font-size:14px'>";
    html += "<span class='headerItem'>手术申请日期：" + appData.AppDateTime + "</span>";
    html += "<span class='headerItem'>手术日期：" + appData.OperDateTime + "</span>";
    html += "<span class='headerItem' style='font-size:36px'>" + appData.SourceTypeDesc + "</span>";
    html += "<span>住院号：" + appData.MedcareNo + "</span>";
    html += "</div>";
    lodop.ADD_PRINT_HTM(60, 0, "100%", 40, html);

    //打印表格
    html = "<style> * {font-size:14px;}  table {margin:0 40px;font-size:14px;} table,td,th {border-width: 1px;border-style: solid;border-collapse: collapse} td {text-align:center;width:10%;padding:10px 0;} .alignleft {text-align:left}</style>";
    // 第1行
    html += "<table class='print-table'><tbody><tr>";
    html += "<td>登记号</td><td>" + appData.RegNo + "</td>";
    html += "<td>姓名</td><td>" + appData.PatName + "</td>";
    html += "<td>性别</td><td>" + appData.PatGender + "</td>";
    html += "<td>年龄</td><td>" + appData.PatAge + "</td></tr>";
    // 第2行
    html += "<tr><td>科室</td><td colspan='2'>" + appData.PatDeptDesc + "</td>";
    html += "<td>病区</td><td colspan='2'>" + appData.PatWardDesc + "</td>";
    html += "<td>床号</td><td>" + appData.PatBedCode + "</td></tr>";
    // 第3行
    html += "<tr><td>术前诊断</td><td colspan='7' class='alignleft'>" + appData.PrevDiagnosisDesc + "</td></tr>";
    // 第4行
    html += "<tr><td>诊断备注</td><td colspan='7' class='alignleft'></td></tr>";
    // 第5行
    html += "<tr><td>拟行手术名称</td><td colspan='7' class='alignleft'>" + appData.OperationDesc + "</td></tr>";
    // 第6行
    html += "<tr><td>手术备注</td><td colspan='7' class='alignleft'>" + appData.OperNote + "</td></tr>";
    // 第7行
    html += "<tr><td>手术医师</td><td>" + appData.SurgeonDesc + "</td>";
    html += "<td>手术助手</td><td colspan='3' class='alignleft'>" + appData.AssistantDesc + "</td>";
    html += "<td>体位</td><td>" + appData.OperPosDesc + "</td></tr>";
    // 第8行
    html += "<tr><td>麻醉医生</td><td colspan='3' class='alignleft'>" + appData.AnesthesiologistDesc + "</td>";
    html += "<td>麻醉方式</td><td colspan='3' class='alignleft'>" + appData.PrevAnaMethodDesc + "</td></tr>";
    // 第9行
    html += "<tr><td>手术间</td><td>" + appData.RoomDesc + "</td>";
    html += "<td>手术台号</td><td>" + appData.OperSeq + "</td>";
    html += "<td>洗手护士</td><td>" + appData.ScrubNurseDesc + "</td>";
    html += "<td>巡回护士</td><td>" + appData.CircualNurseDesc + "</td></tr>";
    // 第10行
    html += "<tr><td>手术物品</td><td colspan='7' class='alignleft'>" + appData.SurgicalMaterials + "</td></tr>";
    // 第11行
    html += "<tr><td>特殊情况</td><td colspan='7' class='alignleft'>" + appData.SpecialConditions + "</td></tr>";
    // 第12行
    html += "<tr><td>医生签名</td><td colspan='3'></td>";
    html += "<td>科主任签名</td><td colspan='3'></td></tr>";
    html += "</tbody></table></div>"

    // lodop.ADD_PRINT_HTM(20, 0, "100%", 50, html);
    lodop.ADD_PRINT_TABLE(110, 0, "100%", "620", html);
    lodop.PREVIEW();
}

function selectPatient(patOperData) {
    if (patOperData) {
        //var eprmenu = window.parent.top.frames["eprmenu"];
        var isSet = false;
        // if (eprmenu) {
        var frm = window.parent.parent.document.forms['fEPRMENU'];
        if (frm) {
            frm.PatientID.value = patOperData.PatientID;
            frm.EpisodeID.value = patOperData.EpisodeID;
            frm.mradm.value = patOperData.MRAdmID;
            if (frm.AnaesthesiaID)
                frm.AnaesthesiaID.value = patOperData.ExtAnaestID;
            isSet = true;
        }
        if (isSet == false) {
            var frm = dhcsys_getmenuform();
            if (frm) {
                frm.PatientID.value = patOperData.PatientID;
                frm.EpisodeID.value = patOperData.EpisodeID;
                frm.mradm.value = patOperData.MRAdmID;
                if (frm.AnaesthesiaID)
                    frm.AnaesthesiaID.value = patOperData.ExtAnaestID;
            }
        }
        //}
    }
}

function getDBClickUrl(deptId){
    var ret="";
    if(workstation && workstation.length>0){
        for(var i=0;i<workstation.length;i++){
            var config=workstation[i];
            if(config.id===deptId){
                ret=config.url;
            }
        }
    }
    return ret;
}

function selectAllApplication() {
    $("#operlistBox").datagrid("selectAll");
}

function unselectAllApplication() {
    $("#operlistBox").datagrid("unselectAll");
}

function printListNew(printDatas, configCode,LODOP) {
    var arrangeConfig = getArrangeConfig();
    if (!arrangeConfig) {
        $.messager.alert("提示", "排班配置不存在，请联系系统管理员！", "warning");
        return;
    }
    var printConfig = getPrintConfig(arrangeConfig, configCode);
    if (!printConfig) {
        $.messager.alert("提示", "打印配置不存在，请联系系统管理员！", "warning");
        return;
    }
    // 标题信息(手术日期、手术室)
    var titleInfo = {
        OperationDate: $("#OperStartDate").datebox("getValue"),
        OperDeptDesc: session.DeptDesc
    };

    // var LODOP = getLodop();
    var printSetting=operListConfig.print;
    LODOP.PRINT_INIT(printSetting.title);
    // LODOP.SET_PRINT_PAGESIZE(printSetting.direction, printSetting.paperSize.width, printSetting.paperSize.height, "SSS");
    LODOP.SET_PRINT_PAGESIZE(printSetting.direction, "", "", "SSS");
    LODOP.ADD_PRINT_TEXT(15, 250, 500, 40, printSetting.title);
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 18);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
    LODOP.ADD_PRINT_TEXT(55, 20, "100%", 28, "科室：" + titleInfo.OperDeptDesc);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 400, "100%", 28, "日期：" + titleInfo.OperationDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 700, "100%", 28, "总计：" + printDatas.length+"台手术");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(55, 900, "100%", 28, "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    var totalWidth=operListConfig.print.paperSize.rect.width;
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-left:none;border-right:none;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;}</style><table style='"+totalWidth+"pt'><thead><tr>";
    //var totalWidth=0;
    for (var i = 0; i < printConfig.columns.length; i++) {
        var column = printConfig.columns[i];
        //totalWidth+=column.width;
        html += "<th style='width:" + column.width + "pt'>" + column.title + "</th>";
    }
    html += "</tr></thead><tbody>";
    var curRoom="",preRoom="";
    for (var i = 0; i < printDatas.length; i++) {
        var printData = printDatas[i];
        curRoom=printData.RoomDesc;
        html += "<tr>";
        for (var j = 0; j < printConfig.columns.length; j++) {
            var column = printConfig.columns[j];
            var printValue=printData[column.field];
            if(column.field==="RoomDesc" && curRoom===preRoom){
                printValue="";
            }
            html += "<td style='" + (column.style ? column.style : "") + "'>" + printValue + "</td>";
        }
        html += "</tr>";
        preRoom=printData.RoomDesc;
    }
    html += "</tbody></table>";

    
    LODOP.ADD_PRINT_TABLE(80, 10, totalWidth+"pt", "100%", html);
    
}

function printList(printDatas, configCode) {
    var excel = null;
    try {
        excel = new ExcelHelper();
        var arrangeConfig = getArrangeConfig();
        var printConfig = getPrintConfig(arrangeConfig, configCode);
        // var templateUrl = window.location.protocol + "//" + window.location.host + printConfig.templateUrl;
        var templateUrl="D:\\DHCClinic\\arrangeList.xls";
        excel.open(templateUrl);

        // 标题信息(手术日期、手术室)
        var titleInfo = {
            OperationDate: $("#OperStartDate").datebox("getValue"),
            OperDeptDesc: session.DeptDesc
        };
        for (var key in titleInfo) {
            var printLoc = getTitlePrintLoc(printConfig.titles, key);
            excel.range(printLoc).Value = titleInfo[key];
        }

        // 未安排手术列表(按科室排序)
        var currentRow = printConfig.startRow;
        for (var i = 0; i < printDatas.length; i++) {
            var printData = printDatas[i];
            for (var field in printData) {
                var printColumn = getPrintColumn(printConfig.columns, field);
                if (printColumn && printColumn != null) {
                    var printLoc = printColumn + "" + currentRow;
                    excel.range(printLoc).Value = printData[field];
                }
            }
            currentRow++;
        }

        // 设置单元格边框线
        var endRow = (printConfig.startRow + printDatas.length - 1);
        var rangeStr = printConfig.startColumn + printConfig.startRow + ":" + printConfig.endColumn + endRow;
        excel.range(rangeStr).Borders.LineStyle = 1;

        // 设置行高度自适应
        var rowStr = printConfig.startRow + ":" + endRow;
        excel.autoFit(rowStr);

        // 如果行高小于配置的最小行高，那么将行高设置成最小行高
        excel.setMinRowHeight(rowStr, printConfig.minRowHeight);

        excel.visible(true);
        //excel.printPreview();
        excel.saveAs("手术列表.xls")
    } catch (error) {
        alert(error.message);
    } finally {
        if (excel) {
            excel.visible(false);
            excel.quit();
        }
    }

}

function printHVMList(printDatas, configCode) {
    var excel = null;
    try {
        excel = new ExcelHelper();
        var arrangeConfig = getArrangeConfig();
        var printConfig = getPrintConfig(arrangeConfig, configCode);
        var templateUrl = window.location.protocol + "//" + window.location.host + printConfig.templateUrl;
        excel.open(templateUrl);

        // 标题信息(手术日期、手术室)
        excel.range("V1").Value=$("#OperStartDate").combobox("getValue");

        // 未安排手术列表(按科室排序)
        var currentRow = 3,startRow=3;
        for (var i = 0; i < printDatas.length; i++) {
            var printData = printDatas[i];
            var printLoc="A"+currentRow;
            excel.range(printLoc).Value=printData.PatName;
            printLoc="B"+currentRow;
            excel.range(printLoc).Value=printData.MedcareNo;
            printLoc="C"+currentRow;
            excel.range(printLoc).Value=printData.SurgeonDesc+(printData.AssistantDesc!=""?(","+printData.AssistantDesc):"");
            printLoc="D"+currentRow;
            excel.range(printLoc).Value=printData.ScrubNurseDesc;
            currentRow++;
        }

        // 设置单元格边框线
        var endRow = (startRow + printDatas.length - 1);
        var rangeStr = "A" + startRow + ":" + "AA" + endRow;
        excel.range(rangeStr).Borders.LineStyle = 1;

        // 设置行高度自适应
        var rowStr = startRow + ":" + endRow;
        excel.autoFit(rowStr);

        // 如果行高小于配置的最小行高，那么将行高设置成最小行高
        var minRowHeight=33;
        excel.setMinRowHeight(rowStr, minRowHeight);

        excel.visible(true);
        //excel.printPreview();
        excel.saveAs("山西省肿瘤医院一次性高值耗材登记表.xls")
    } catch (error) {
        alert(error.message);
    } finally {
        if (excel) {
            excel.visible(false);
            excel.quit();
        }
    }

}

function printShiftList(printDatas, configCode) {
    var excel = null;
    try {
        excel = new ExcelHelper();
        var arrangeConfig = getArrangeConfig();
        var printConfig = getPrintConfig(arrangeConfig, configCode);
        var templateUrl = window.location.protocol + "//" + window.location.host + printConfig.templateUrl;
        excel.open(templateUrl);

        // 标题信息(手术日期、手术室)
        excel.range("V1").Value=$("#OperStartDate").combobox("getValue");

        // 未安排手术列表(按科室排序)
        var currentRow = 3,startRow=3;
        for (var i = 0; i < printDatas.length; i++) {
            var printData = printDatas[i];
            var printLoc="A"+currentRow;
            excel.range(printLoc).Value=printData.OperDate;
            printLoc="B"+currentRow;
            excel.range(printLoc).Value=printData.RoomDesc;
            printLoc="C"+currentRow;
            excel.range(printLoc).Value=printData.PatName;
            printLoc="D"+currentRow;
            excel.range(printLoc).Value=printData.MedcareNo;
            printLoc="E"+currentRow;
            excel.range(printLoc).Value=printData.PatGender;
            printLoc="F"+currentRow;
            excel.range(printLoc).Value=printData.PatAge;
            printLoc="G"+currentRow;
            excel.range(printLoc).Value=printData.PatDeptDesc;
            printLoc="H"+currentRow;
            excel.range(printLoc).Value=printData.PatBedCode;
            printLoc="I"+currentRow;
            excel.range(printLoc).Value=printData.BodySiteDesc;
            printLoc="J"+currentRow;
            excel.range(printLoc).Value=printData.SurgeonDesc;
            currentRow++;
        }

        // 设置单元格边框线
        var endRow = (startRow + printDatas.length - 1);
        var rangeStr = "A" + startRow + ":" + "X" + endRow;
        excel.range(rangeStr).Borders.LineStyle = 1;

        // 设置行高度自适应
        var rowStr = startRow + ":" + endRow;
        excel.autoFit(rowStr);

        // 如果行高小于配置的最小行高，那么将行高设置成最小行高
        var minRowHeight=33;
        excel.setMinRowHeight(rowStr, minRowHeight);

        excel.visible(true);
        //excel.printPreview();
        excel.saveAs("山西省肿瘤医院手术病人交接纪录.xls")
    } catch (error) {
        alert(error.message);
    } finally {
        if (excel) {
            excel.visible(false);
            excel.quit();
        }
    }

}

function getArrangeConfig() {
    var result = null;
    $.ajaxSettings.async = false;
    $.getJSON("../service/dhcanop/data/operarrange.json?random=" + Math.random(), function (data) {
        result = data;
    }).error(function (message) {
        alert(message);
    });
    $.ajaxSettings.async = true;
    return result;
}

function getPrintConfig(arrangeConfig, configCode) {
    var result = null;
    if (arrangeConfig && arrangeConfig.print && arrangeConfig.print.length > 0) {
        for (var i = 0; i < arrangeConfig.print.length; i++) {
            var element = arrangeConfig.print[i];
            if (element.code == configCode) {
                result = element;
            }
        }
    }
    return result;
}

function getPrintColumn(printConfigList, fieldName) {
    var result = null;
    for (var i = 0; i < printConfigList.length; i++) {
        var element = printConfigList[i];
        if (element.field == fieldName) {
            result = element.column;
        }
    }
    return result;
}

function getTitlePrintLoc(titles, fieldName) {
    var result = null;
    for (var i = 0; i < titles.length; i++) {
        var title = titles[i];
        if (title.field == fieldName) {
            result = title.location;
        }
    }
    return result;
}