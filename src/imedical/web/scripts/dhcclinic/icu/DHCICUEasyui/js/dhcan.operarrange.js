var selectedApplications = [];
var selectedArrangeList=[];
var relatedBox = null;
$(document).ready(function () {
    var unarrangeBox = $("#unarrangeBox"),
        arrangedBox = $("#arrangedBox"),
        operCancelBox = $("#operCancelBox");
    $("#AppDate").datebox("setValue", ((new Date()).addDays(1)).format("yyyy-MM-dd"));
    unarrangeBox.datagrid({
        idField: "RowId",
        fit: true,
        rownumbers: true,
        // sortName: "AppDeptAlias,SurgeonShortDesc,OperTime",
        // sortOrder: "asc,asc,asc",
        remoteSort: false,
        multiSort: true,
        title: "未排手术",
        // nowrap: false,
        toolbar: "#unarrangeTool",
        // url: ANCSP.DataQuery,
        columns: [
            [{
                    field: "OperTime",
                    title: "手术时间",
                    width: 80
                },
                {
                    field: "AppDeptDesc",
                    title: "申请科室",
                    width: 100,
                    hidden: true
                },
                {
                    field: "AppDeptAlias",
                    title: "科室别名",
                    width: 100,
                    hidden: true
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
                    field: "Infection",
                    title: "传染病",
                    width: 80,
                    formatter: function (value, row, index) {
                        var style = "color:#000;font-weight:bold;font-size:14px;";
                        if (value.indexOf("阳性") >= 0) {
                            style = "color:#FF0033;font-weight:bold;font-size:14px;";
                        }
                        var infectionLabData = "";
                        if (row.InfectionLabData && row.InfectionLabData != "") {
                            infectionLabData = row.InfectionLabData.replace(/#/g, "&#10;");
                        }
                        return "<span title='" + infectionLabData + "' style='" + style + "'>" + value + "</span>";
                    }
                },
                {
                    field: "PrevDiagnosisDesc",
                    title: "术前诊断",
                    width: 100
                },
                {
                    field: "BodySiteDesc",
                    title: "手术部位",
                    width: 60
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
                    field: "OperRequirementDesc",
                    title: "手术要求",
                    width: 120
                },

                {
                    field: "AnaCareProv",
                    title: "麻醉医护",
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
                    field: "EpisodeID",
                    title: "就诊ID",
                    width: 80
                },
                {
                    field: "RowId",
                    title: "手术ID",
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
        rowStyler: function (index, row) {
            return "background-color:" + row.StatusColor + ";";
        },
        // queryParams: {
        //     ClassName: ANCLS.BLL.OperSchedule,
        //     QueryName: "FindOperScheduleList",
        //     ArgCnt: 13
        // },
        // onBeforeLoad: function (param) {
        //     param.Arg1 = $("#AppDate").datebox("getValue");
        //     param.Arg2 = $("#AppDate").datebox("getValue");
        //     param.Arg3 = session.DeptID;
        //     param.Arg4 = "";
        //     param.Arg5 = "";
        //     param.Arg6 = "";
        //     param.Arg7 = "";
        //     param.Arg8 = "";
        //     param.Arg9 = "";
        //     param.Arg10 = "";
        //     param.Arg11 = "N";
        //     param.Arg12 = "N";
        //     param.Arg13 = "Y";
        // },
        onLoadSuccess: function (data) {
            clearOperSeq();
        },
        onSelect: function (index, row) {
            selectedApplications.push(row);
        },
        onUnselect: function (index, row) {
            
            if (selectedApplications && selectedApplications.length > 0) {
                var arrayIndex=-1;
                for(var i=0;i<selectedApplications.length;i++){
                    if(selectedApplications[i]===row){
                        arrayIndex=i;
                    }
                }
                if(arrayIndex>=0){
                    selectedApplications.splice(arrayIndex, 1);
                }
                
            }
        },
        view: groupview,
        groupField: "AppDeptDesc",
        groupFormatter: function (value, rows) {
            return value + " 共申请了" + rows.length + "台手术";
        },
        pagination: true,
        pageList: [200,500],
        pageSize: 500
    });

    arrangedBox.datagrid({
        idField: "RowId",
        fit: true,
        // nowrap: false,
        title: "已排手术",
        rownumbers: true,
        toolbar: "#arrangedTool",
        url: ANCSP.DataQuery,
        columns: [
            [{
                    field: "OperDate",
                    title: "手术日期",
                    width: 80,
                    hidden: true
                },
                {
                    field: "RoomDesc",
                    title: "手术间",
                    width: 80,
                    sortable: true,
                    hidden: true
                },
                {
                    field: "RoomInfo",
                    title: "手术间排序",
                    width: 80,
                    sortable: true,
                    hidden: true
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
                    field: "OperTime",
                    title: "开始时间",
                    width: 80
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
                    field: "Patient",
                    title: "患者",
                    width: 120
                    // formatter: function(value, row, index) {
                    //     return (row.PatName + "(" + row.PatGender + "," + row.PatAge + ")");
                    // }
                },
                {
                    field: "WardBed",
                    title: "病区床位",
                    width: 120,
                    // formatter: function(value, row, index) {
                    //     return (row.PatWardDesc + " " + row.PatBedCode);
                    // },
                    hidden: true
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
                    field: "PrevDiagnosisDesc",
                    title: "术前诊断",
                    width: 100
                },
                {
                    field: "BodySiteDesc",
                    title: "手术部位",
                    width: 60
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
                    // formatter: function(value, row, index) {
                    //     var result = row.SurgeonDesc;
                    //     if (row.AssistantDesc && row.AssistantDesc != "") {
                    //         result += "," + row.AssistantDesc;
                    //     }
                    //     return result;
                    // },
                    hidden: true
                },

                {
                    field: "OperRequirementDesc",
                    title: "手术要求",
                    width: 120
                },
                {
                    field: "AnaCareProv",
                    title: "麻醉医生",
                    width: 120
                    // formatter: function(value, row, index) {
                    //     var result = row.AnaExpertDesc;
                    //     if (row.AnesthesiologistDesc && row.AnesthesiologistDesc != "") {
                    //         if (result && result != "") {
                    //             result += "," + row.AnesthesiologistDesc;
                    //         } else {
                    //             result = row.AnesthesiologistDesc;
                    //         }
                    //     }
                    //     if (row.AnaAssistantDesc && row.AnaAssistantDesc != "") {
                    //         if (result && result != "") {
                    //             result += "," + row.AnaAssistantDesc;
                    //         } else {
                    //             result = row.AnaAssistantDesc;
                    //         }
                    //     }
                    //     return result;
                    // }
                },
                {
                    field: "LabInfo",
                    title: "检验信息",
                    width: 120
                },
                {
                    field: "AdmReason",
                    title: "费别",
                    width: 100
                },
                {
                    field: "SourceTypeDesc",
                    title: "类型",
                    width: 80
                },
                {
                    field: "OperStatusDesc",
                    title: "手术状态",
                    width: 80
                }
            ]
        ],
        rowStyler: function (index, row) {
            return "background-color:" + row.StatusColor + ";";
        },
        queryParams: {
            ClassName: ANCLS.BLL.OperSchedule,
            QueryName: "FindOperScheduleList",
            ArgCnt: 12
        },
        onBeforeLoad: function (param) {
            param.Arg1 = $("#AppDate").datebox("getValue");
            param.Arg2 = $("#AppDate").datebox("getValue");
            param.Arg3 = session.DeptID;
            param.Arg4 = "";
            param.Arg5 = "";
            param.Arg6 = "";
            param.Arg7 = OperStatus.Arrange;
            param.Arg8 = "";
            param.Arg9 = "";
            param.Arg10 = "";
            param.Arg11 = "N";
            param.Arg12 = "N";
        },
        // singleSelect: true,
        sortName: "RoomInfo,OperSeqInfo",
        sortOrder: "asc,asc",
        remoteSort: false,
        multiSort: true,
        view: groupview,
        groupField: "RoomDesc",
        groupFormatter: function (value, rows) {
            var roomDesc = value;
            if (!roomDesc || roomDesc == "") {
                roomDesc = "连台手术";
            }

            return roomDesc + " 共" + rows.length + "台手术";
        },
        onLoadSuccess: function (data) {
            clearArrangedOperSeq();
        },
        onSelect: function (index, row) {
            selectArrangedOperation(index, row);
            selectedArrangeList.push(row);

        },
        onUnselect: function (index, row) {
            
            if (selectedArrangeList && selectedArrangeList.length > 0) {
                var arrayIndex=-1;
                for(var i=0;i<selectedArrangeList.length;i++){
                    if(selectedArrangeList[i]===row){
                        arrayIndex=i;
                    }
                }
                if(arrayIndex>=0){
                    selectedArrangeList.splice(arrayIndex, 1);
                }
                
            }
        },
        onEndEdit: function (index, row, changes) {

        },
        pagination: true,
        pageList: [200,500],
        pageSize: 500
    });

    operCancelBox.datagrid({
        idField: "RowId",
        fit: true,
        rownumbers: true,
        sortName: "AppDeptAlias,SurgeonShortDesc,OperTime",
        sortOrder: "asc,asc,asc",
        remoteSort: false,
        multiSort: true,
        // nowrap: false,
        toolbar: "#operCancelTools",
        url: ANCSP.DataQuery,
        columns: [
            [{
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
                    field: "AppDeptAlias",
                    title: "科室别名",
                    width: 100,
                    hidden: true
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
                    field: "Infection",
                    title: "传染病",
                    width: 80,
                    formatter: function (value, row, index) {
                        var style = "color:#000;font-weight:bold;font-size:14px;";
                        if (value.indexOf("阳性") >= 0) {
                            style = "color:#FF0033;font-weight:bold;font-size:14px;";
                        }
                        var infectionLabData = "";
                        if (row.InfectionLabData && row.InfectionLabData != "") {
                            infectionLabData = row.InfectionLabData.replace(/#/g, "&#10;");
                        }
                        return "<span title='" + infectionLabData + "' style='" + style + "'>" + value + "</span>";
                    }
                },
                {
                    field: "PrevDiagnosisDesc",
                    title: "术前诊断",
                    width: 100
                },
                {
                    field: "BodySiteDesc",
                    title: "手术部位",
                    width: 60
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
                    field: "OperRequirementDesc",
                    title: "手术要求",
                    width: 120
                },

                {
                    field: "AnaCareProv",
                    title: "麻醉医护",
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
                    field: "EpisodeID",
                    title: "就诊ID",
                    width: 80
                },
                {
                    field: "RowId",
                    title: "手术ID",
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
        rowStyler: function (index, row) {
            return "background-color:" + row.StatusColor + ";";
        },
        queryParams: {
            ClassName: ANCLS.BLL.OperSchedule,
            QueryName: "FindOperScheduleList",
            ArgCnt: 12
        },
        onBeforeLoad: function (param) {
            param.Arg1 = $("#AppDate").datebox("getValue");
            param.Arg2 = $("#AppDate").datebox("getValue");
            param.Arg3 = session.DeptID;
            param.Arg4 = "";
            param.Arg5 = "";
            param.Arg6 = "";
            param.Arg7 = OperStatus.Cancel;
            param.Arg8 = "";
            param.Arg9 = "";
            param.Arg10 = "";
            param.Arg11 = "N";
            param.Arg12 = "N";
        },
        onLoadSuccess: function (data) {
            // clearOperSeq();
        },
        onSelect: function (index, row) {
            // selectedApplications.push(row);
        },
        onUnSelect: function (index, row) {
            // if (selectedApplications && selectedApplications.indexOf(row) >= 0) {
            //     var arrayIndex = selectedApplications.indexOf(row);
            //     selectedApplications.splice(arrayIndex, 1);
            // }
        }
    });

    // arrangedBox.datagrid('enableCellEditing');

    $("#btnQuery").linkbutton({
        onClick: function () {
            // unarrangeBox.datagrid("reload");
            loadUnArrangeBoxData();
            arrangedBox.datagrid("reload");
        }
    });

    $("#btnArrange").linkbutton({
        onClick: function () {
            setOperSeq();
            saveUnArrangeNew(unarrangeBox);
            unarrangeBox.datagrid("clearSelections");
            clearOperSeq();
            clearElements();
        }
    });

    $(".oper-decline").linkbutton({
        onClick: function () {
            relatedBox = $("#" + $(this).attr("data-relateBox"));
            if (dhccl.hasRowSelected(relatedBox, true)) {

                $("#operCancelReason").dialog("open");
                // $.messager.confirm("提示", "是否拒绝手术申请？", function (result) {
                //     if (result) {

                //         //declineOperApplication(dataBox);
                //     }
                // });
            }
        }
    });

    $("#btnUpdate").linkbutton({
        onClick: function () {
            // saveOperArrange(arrangedBox);
            saveOperArrangeNew(arrangedBox);
            arrangedBox.datagrid("clearSelections");
        }
    });

    $("#printUnArrange").linkbutton({
        onClick: function () {
            var printDatas = unarrangeBox.datagrid("getRows");
            if (printDatas && printDatas.length > 0) {
                // printList(printDatas, "unarrange");
                printListNew(printDatas, "unarrange");
            } else {
                $.messager.alert("提示", "列表无数据可打印", "warning");
            }

        }
    });

    $("#printArrange").linkbutton({
        onClick: function () {
            var printDatas = arrangedBox.datagrid("getRows");
            if (printDatas && printDatas.length > 0) {
                // printList(printDatas, "arrange");
                printListNew(printDatas, "arrange");
            } else {
                $.messager.alert("提示", "列表无数据可打印", "warning");
            }

        }
    });

    $("#OperRoom,#ArrangedOperRoom").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.ConfigQueries,
                param.QueryName = "FindOperRoom",
                param.Arg1 = session.DeptID,
                param.Arg2 = "R",
                param.ArgCnt = 2
        },
        valueField: "RowId",
        textField: "Description",
        onSelect:function(record){
            // var selector="#"+$(this).attr("id")+"Container";
            // $(selector).empty();
            // var nurseSelector="#"+$(this).attr("id")+record.RowId;
            // if($(nurseSelector).length>0) return;
            // var html="<span class='oper-nurse oper-nurse-inroom' data-rowid='"+record.RowId+"'>"+record.Description;
            // html+="<span class='close'>&times</span></span>"
            // $(selector).append(html);
            // $(".close").click(function(){
            //     $(this).parent().remove();
            // });
            var elementID=$(this).attr("id");
            genArrangeElement(record,elementID,true);
        }
    });

    $("#ScrubNurse,#CircualNurse,#ArrangedScrubNurse,#ArrangedCircualNurse").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = session.DeptID;
            param.ArgCnt = 2;
        },
        valueField: "RowId",
        textField: "Description",
        // groupField: "FirstChar",
        // multiple: true,
        mode: "remote",
        onSelect:function(record){
            // var selector="#"+$(this).attr("id")+"Container";
            // var nurseId=$(this).attr("id")+record.RowId;
            // var nurseSelector="#"+nurseId;
            // if($(nurseSelector).length>0) return;
            // var html="<span id='"+nurseId+"' class='oper-nurse oper-nurse-inroom' data-rowid='"+record.RowId+"'>"+record.Description;
            // html+="<span class='close'>&times</span></span>"
            // $(selector).append(html);
            // $(".close").click(function(){
            //     $(this).parent().remove();
            // });
            var elementID=$(this).attr("id");
            genArrangeElement(record,elementID);
            $(this).combobox("setValue","");
        },
        onLoadSuccess:function(data){
            if(data && data.length==1){
                $(this).combobox("select",data[0].RowId);
                $(this).combobox("hidePanel");
            }
        }
    });

    $("#btnSaveOtherArrange").linkbutton({
        onClick: SaveDeptSchedule
    });

    $("#btnMoveUp,#btnMoveDown").linkbutton({
        onClick: function () {
            var selectedRow = $("#arrangedBox").datagrid("getSelected");
            if (!selectedRow) return;
            if (!selectedRow.OperRoom || selectedRow.OperRoom === "") return;
            var dataRows = $("#arrangedBox").datagrid("getRows");
            var roomRows = [];
            for (var i = 0; i < dataRows.length; i++) {
                if (dataRows[i].OperRoom === selectedRow.OperRoom) {
                    roomRows.push(dataRows[i]);
                }
            }
            var sortRows = roomRows.sort(function (obj1, obj2) {
                var val1 = parseInt(obj1.OperSeq);
                var val2 = parseInt(obj2.OperSeq);
                if (val1 < val2) {
                    return -1;
                } else if (val1 > val2) {
                    return 1;
                } else {
                    return 0;
                }
            });
            var selectedIndex = sortRows.indexOf(selectedRow);
            if ($(this).attr("id") === "btnMoveUp" && selectedIndex <= 0) return;
            if ($(this).attr("id") === "btnMoveDown" && selectedIndex >= sortRows.length - 1) return;
            var operScheduleList = [];
            var direction=($(this).attr("id") === "btnMoveUp"?"up":"down");
            var result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"ChangeRoomOperSeq",selectedRow.RowId,direction);
            if(result){
                $("#arrangedBox").datagrid("reload");
            }

        }
    });

    $("#btnQueryCancel").linkbutton({
        onClick: function () {
            $("#operCancelList").dialog("open");
            $("#operCancelBox").datagrid("reload");
        }
    });

    $("#btnDeptArrange").linkbutton({
        onClick:function(){
            $("#deptArrangeList").dialog("open");
        }
    });

    $("#btnRevokeCancel").linkbutton({
        onClick: function () {
            if (dhccl.hasRowSelected(operCancelBox, true)) {
                var selectedRows = operCancelBox.datagrid("getSelections");
                var operScheduleList = [];
                for (var i = 0; i < selectedRows.length; i++) {
                    var selectedRow = selectedRows[i];
                    operScheduleList.push({
                        RowId: selectedRow.RowId,
                        Status: "",
                        StatusCode: OperStatus.Application,
                        ClassName: ANCLS.Model.OperSchedule
                    });
                }
                var result = dhccl.saveDatas(ANCSP.DataListService, {
                    jsonData: dhccl.formatObjects(operScheduleList),
                    MethodName: "SaveOperArrange",
                    ClassName: ANCLS.BLL.OperArrange
                });
                dhccl.showMessage(result, "保存", null, null, function () {
                    operCancelBox.datagrid("reload");
                    unarrangeBox.datagrid("reload");
                });
            }
        }
    });

    $("#btnChangeNurse").linkbutton({
        onClick:function(){
            changeContainerElement("ArrangedScrubNurse","ArrangedCircualNurse");
        }
    });

    $("#btnRevoke").linkbutton({
        onClick:function(){
            $.messager.confirm("提示","是否要撤回当前选中的手术？",function(result){
                if(result){
                    var selections=arrangedBox.datagrid("getSelections");
                    if(selections && selections.length>0){
                        var opsIdPara="";
                        for(var i=0;i<selections.length;i++){
                            if(opsIdPara!==""){
                                opsIdPara+="^";
                            }
                            opsIdPara+=selections[i].RowId;
                        }
                        if(opsIdPara!==""){
                            var ret=dhccl.runServerMethod("DHCAN.BLL.OperArrange","RevokeArrange",opsIdPara);
                            if(ret.success){
                                arrangedBox.datagrid("reload");
                                loadUnArrangeBoxData();
                            }else{
                                $.messager.alert("提示","撤回失败，原因："+ret.message,"error");
                            }
                        }
                    }
                }
            })
            
            
        }
    });

    initOperCancelReason();
    loadDeptSchedule();
    loadUnArrangeBoxData();
    // loadOperRooms();
    // loadOperNurses();
});

function genArrangeElement(record,elementID,emptyContainer){
    var selector="#"+elementID+"Container";
    var nurseId=elementID+record.RowId;
    var nurseSelector="#"+nurseId;
    if(emptyContainer && emptyContainer===true){
        $(selector).empty();
    }
    if($(nurseSelector).length>0) return;
    var html="<span id='"+nurseId+"' class='oper-nurse oper-nurse-inroom' data-rowid='"+record.RowId+"'>"+record.Description;
    html+="<span class='close'>&times</span></span>"
    $(selector).append(html);
    $(".close").click(function(){
        $(this).parent().remove();
    });
}

function changeContainerElement(sourceEl,targetEl){
    var sourceSelector="#"+sourceEl+"Container";
    var targetSelector="#"+targetEl+"Container";
    var sourceHtml=$(sourceSelector).html();
    var targetHtml=$(targetSelector).html();
    $(sourceSelector).empty();
    $(sourceSelector).append(targetHtml);
    $(targetSelector).empty();
    $(targetSelector).append(sourceHtml);
}

function clearElements(){
    clearArrangeElement("ScrubNurse");
    clearArrangeElement("CircualNurse");
    clearArrangeElement("OperRoom");
}

function clearArrangeElement(elementID){
    var selector="#"+elementID+"Container";
    $(selector).empty();
}

function loadUnArrangeBoxData(){
    var appDatas=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName: ANCLS.BLL.OperSchedule,
            QueryName: "FindOperScheduleList",
            ArgCnt: 13,
            Arg1 : $("#AppDate").datebox("getValue"),
            Arg2 : $("#AppDate").datebox("getValue"),
            Arg3 : session.DeptID,
            Arg4 : "",
            Arg5 : "",
            Arg6 : "",
            Arg7 : "",
            Arg8 : "",
            Arg9 : "",
            Arg10 : "",
            Arg11 : "N",
            Arg12 : "N",
            Arg13 : "Y"
    },"json");
    if(!appDatas) return;
    var arrangeConfig=getArrangeConfig();
    if(!arrangeConfig) return;
    var appDeptSeqArr=arrangeConfig.AppDeptSeq.split(splitchar.comma);
    var ignoreAppDeptArr=arrangeConfig.IgnoreAppDept.split(splitchar.comma);
    var filterAppDatas=[];
    for(var i=0;i<appDatas.length;i++){
        var appData=appDatas[i];
        if(ignoreAppDeptArr.indexOf(appData.AppDeptDesc)>=0)
        {
            continue;
        }
        filterAppDatas.push(appData);
    }
    var sortedAppDatas=filterAppDatas.sort(function(obj1,obj2){
        var appDept1=obj1.AppDeptDesc;
        var appDept2=obj2.AppDeptDesc;
        var appDeptAlias1=obj1.AppDeptAlias;
        var appDeptAlias2=obj2.AppDeptAlias;
        var surgeonAlias1=obj1.SurgeonShortDesc;
        var surgeonAlias2=obj2.SurgeonShortDesc;
        var operDT1=obj1.OperDateTime;
        var operDT2=obj2.OperDateTime;
        var appDeptInd1=appDeptSeqArr.indexOf(appDept1);
        var appDeptInd2=appDeptSeqArr.indexOf(appDept2);
        if(appDeptInd1<0 && appDeptInd2>=0){
            return 1;
        }
        if (appDeptInd1>=0 && appDeptInd2<0){
            return -1;
        }
        if(appDeptInd1<appDeptInd2){
            return -1;
        }else if(appDeptInd1>appDeptInd2){
            return 1;
        }else{
            if(appDeptAlias1<appDeptAlias2){
                return -1;
            }else if(appDeptAlias1>appDeptAlias2){
                return 1;
            }else{
                if(surgeonAlias1<surgeonAlias2){
                    return -1;
                }else if(surgeonAlias1>surgeonAlias2){
                    return 1;
                }else{
                    if(operDT1<operDT2){
                        return -1;
                    }else if(operDT1>operDT2){
                        return 1;
                    }else{
                        return 0;
                    }
                    return 0;
                }
                return 0;
            }
            return 0;
        }
    });

    var lastedData={
        rows:sortedAppDatas,
        total:sortedAppDatas.length
    };

    $("#unarrangeBox").datagrid("loadData",lastedData);
}

function existsOperSeq(operSeq, showMsg) {
    var result = false;
    var selectedRow = $("#arrangedBox").datagrid("getSelected");
    if (!selectedRow) return result;
    if (!selectedRow.OperRoom) return;
    var dataRows = $("#arrangedBox").datagrid("getRows");
    var selectedOperRoom=$("#ArrangedOperRoom").combobox("getValue");
    for (var i = 0; i < dataRows.length; i++) {
        var dataRow = dataRows[i];
        if (dataRow.RowId === selectedRow.RowId) continue;
        if (dataRow.OperRoom === selectedOperRoom && dataRow.OperSeq === operSeq) {
            result = true;
            if (showMsg === true) {
                $.messager.alert("提示", "该手术间已存在相同台次的手术。", "warning");
            }
            break;
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
                $("arrangedBox").datagrid("reload");
                $("unarrangBox").datagrid("reload");
            });
        }
    });

    $("#ReasonOptions").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindReason";
            param.Arg1 = "C";
            param.ArgCnt = 1;
        },
        onChange: function (newValue, oldValue) {
            var reasonDesc = $("#CancelReason").val(),
                optionValue = $(this).combobox("getValue"),
                optionData = $(this).combobox("getData");
            if (!optionValue || optionValue == "") return;
            if (!optionData || optionData.length <= 0) return;
            var currentOption = "";
            for (var i = 0; i < optionData.length; i++) {
                var option = optionData[i];
                if (option.RowId == optionValue) {
                    currentOption = option.Description;
                }
            }
            if (currentOption == "") return;
            if ($.trim(reasonDesc) != "") {
                reasonDesc += "；";
            }
            reasonDesc += currentOption;
            $("#CancelReason").val(reasonDesc);
            $("#ReasonOptions").combobox("clear", "");
            $("#ReasonOptions").combobox("setText", "");
        }
    })

    $("#btnExitReason").linkbutton({
        onClick: function () {
            $("#reasonForm").form("clear");
            $("#operCancelReason").dialog("close");
        }
    });

    $("#operCancelReason").dialog({
        onOpen: function () {
            $("#reasonForm").form("clear");
        }
    });

    $("#btnSaveReason").linkbutton({
        onClick: function () {
            if (!relatedBox) return;
            var formData = $("#reasonForm").serializeJson();
            var selectedRows = relatedBox.datagrid("getSelections");
            if (formData && selectedRows && selectedRows.length > 0) {
                var operScheduleList = [];
                for (var i = 0; i < selectedRows.length; i++) {
                    var selectedRow = selectedRows[i];
                    operScheduleList.push({
                        ClassName: ANCLS.Model.OperSchedule,
                        RowId: selectedRow.RowId,
                        Status: "",
                        StatusCode: "Cancel",
                        OriginalStatusCode: "^Application^Audit^Arrange^",
                        CancelReason: formData.CancelReason,
                        CancelUser: session.UserID,
                        CancelDate: "",
                        CancelTime: ""
                    });
                }
                var result = dhccl.saveDatas(ANCSP.DataListService, {
                    jsonData: dhccl.formatObjects(operScheduleList),
                    MethodName: "CancelApplications",
                    ClassName: ANCLS.BLL.OperSchedule
                });
                dhccl.showMessage(result, "保存", null, null, function () {
                    $("#operCancelReason").dialog("close");
                    relatedBox.datagrid("reload");
                });
            }
        }
    });
}

function loadOperRooms() {
    var url = ANCSP.DataQuery,
        param = {
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindOperRoom",
            Arg1: session.DeptID,
            ArgCnt: 1
        },
        dataType = "json";
    var operRoomList = dhccl.getDatas(url, param, dataType);
    if (operRoomList && operRoomList.length > 0) {
        $.each(operRoomList, function (index, operRoom) {
            var html = "<div class='oper-room' data-rowId='" + operRoom.RowId + "'>" + operRoom.Description + "</div>";
            $("#OperRoomList").append(html);
        });

        $(".oper-room").click(function () {
            selectOperRoom($(this));
        });
    }
}

function selectOperRoom(operRoom) {
    if (operRoom.hasClass("oper-room-selected")) {
        operRoom.removeClass("oper-room-selected");
    } else {
        operRoom.addClass("oper-room-selected");
        clearOperRoomSelected(operRoom.attr("data-rowId"));
    }
}

function loadOperNurses() {
    var url = ANCSP.DataQuery,
        param = {
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindCareProvByLoc",
            Arg1: "",
            Arg2: session.DeptID,
            ArgCnt: 2
        },
        dataType = "json";
    var nurseList = dhccl.getDatas(url, param, dataType);
    if (nurseList && nurseList.length > 0) {
        $.each(nurseList, function (index, nurse) {
            var html = "<div class='scrub-nurse' data-rowId='" + nurse.RowId + "'>" + nurse.Description + "</div>";
            $("#ScrubNurseList").append(html);
            html = "<div class='circual-nurse' data-rowId='" + nurse.RowId + "'>" + nurse.Description + "</div>";
            $("#CircualNurseList").append(html);
        });

        $(".scrub-nurse").click(function () {
            selectScrubNurse($(this));
        });

        $(".circual-nurse").click(function () {
            selectCircualNurse($(this));
        });
    }

}

function selectScrubNurse(scrubNurse) {
    var circualNurseSelector = $(".circual-nurse-selected[data-rowid='" + scrubNurse.attr("data-rowid") + "'");
    if (circualNurseSelector.length > 0) {
        var message = scrubNurse.text() + "已经选择为巡回护士，不能再选择为器械护士";
        $.messager.alert("提示", message, "warning")
        return;
    }
    if (scrubNurse.hasClass("scrub-nurse-selected")) {
        scrubNurse.removeClass("scrub-nurse-selected");
    } else {
        scrubNurse.addClass("scrub-nurse-selected");
    }
}

function clearScrubNurseSelection(ignoreNurse) {
    $(".scrub-nurse-selected").each(function () {
        if ($(this).attr("data-rowId") != ignoreNurse) {
            $(this).removeClass("scrub-nurse-selected");
        }
    });
}

function selectCircualNurse(circualNurse) {
    var scrubNurseSelector = $(".scrub-nurse-selected[data-rowid='" + circualNurse.attr("data-rowid") + "'");
    if (scrubNurseSelector.length > 0) {
        var message = circualNurse.text() + "已经选择为器械护士，不能再选择为巡回护士";
        $.messager.alert("提示", message, "warning")
        return;
    }
    if (circualNurse.hasClass("circual-nurse-selected")) {
        circualNurse.removeClass("circual-nurse-selected");
    } else {
        circualNurse.addClass("circual-nurse-selected");
    }
}

function clearCircualNurseSelection(ignoreNurse) {
    $(".circual-nurse-selected").each(function () {
        if ($(this).attr("data-rowId") != ignoreNurse) {
            $(this).removeClass("circual-nurse-selected");
        }
    });
}

function getSelectedNurses(selector) {
    var result = ""
    $(selector).each(function () {
        var rowId = $(this).attr("data-rowId");
        if (result != "") {
            result += ","
        }
        result += rowId;
    });
    return result;
}

function clearOperRoomSelected(ignoreRoom) {
    $(".oper-room-selected").each(function () {
        if ($(this).attr("data-rowId") != ignoreRoom) {
            $(this).removeClass("oper-room-selected");
        }
    });
}

function clearAllSelection() {
    clearOperRoomSelected("");
    clearScrubNurseSelection("");
    clearCircualNurseSelection("");
}

function endEditDataBox(dataBox) {
    var dataRows = dataBox.datagrid("getRows");
    if (dataRows && dataRows.length > 0) {
        for (var i = 0; i < dataRows.length; i++) {
            var rowIndex = dataBox.datagrid("getRowIndex", dataRows[i]);
            dataBox.datagrid("endEdit", rowIndex);
        }
    }
}

function saveOperArrangeNew(dataBox) {
    endEditDataBox(dataBox);
    var arrangeData = {
            OperRoom: getSelectedOperNurses("ArrangedOperRoomContainer"),
            ScrubNurse: getSelectedOperNurses("ArrangedScrubNurseContainer"),
            CircualNurse: getSelectedOperNurses("ArrangedCircualNurseContainer")
        },
        selectedOperList = dataBox.datagrid("getSelections"),
        operScheduleList = [];
    if (arrangeData.OperRoom === "" && arrangeData.ScrubNurse.length == 0 && arrangeData.CircualNurse.length == 0) {
        $.messager.alert("提示", "手术间，器械护士，巡回护士不同同时为空！", "warning");
        return;
    }
    if (existsOperSeq(arrangeData.OperSeq, true) === true) return;
    if (arrangeData && selectedOperList && selectedOperList.length > 0) {
        // var scrubNurseArray = $("#ArrangedScrubNurse").combobox("getValues"),
        //     circualNurseArray = $("#ArrangedCircualNurse").combobox("getValues");
        // if (scrubNurseArray && scrubNurseArray.length > 0) {
        //     arrangeData.ScrubNurse = scrubNurseArray.join(splitchar.comma);
        // }
        // if (circualNurseArray && circualNurseArray.length > 0) {
        //     arrangeData.CircualNurse = circualNurseArray.join(splitchar.comma);
        // }
        $.each(selectedOperList, function (index, item) {
            if(item.OperRoom!=arrangeData.OperRoom){
                item.OperSeq=getRoomNextOperSeq("ArrangedOperRoom", "arrangedBox");
            }
            operScheduleList.push({
                ClassName: ANCLS.Model.OperSchedule,
                RowId: item.RowId,
                OperRoom: arrangeData.OperRoom ? arrangeData.OperRoom : "",
                OriginalRoom:item.OperRoom,
                OperSeq: item.OperSeq,
                Status: "",
                ScrubNurse: arrangeData.ScrubNurse ? arrangeData.ScrubNurse : "",
                CircualNurse: arrangeData.CircualNurse ? arrangeData.CircualNurse : "",
                StatusCode: OperStatus.Arrange
            });
        });
        var jsonData = dhccl.formatObjects(operScheduleList);
        dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData,
            MethodName: "SaveOperArrange",
            ClassName: ANCLS.BLL.OperArrange
        }, function (data) {
            dhccl.showMessage(data, "保存", null, null, function () {
                $("#arrangedBox").datagrid("reload");
                $("#arrangeForm").form("clear");
            });
        });
    }
}

function getSelectedOperNurses(container){
    var selector="#"+container;
    var result=splitchar.empty;
    if($(selector).length<=0) return result;
    $(selector).find(".oper-nurse").each(function(index,el){
        var rowId=$(el).attr("data-rowid");
        if(parseInt(rowId)>0 && result!==splitchar.empty){
            result+=splitchar.comma;
        }
        result+=rowId;
    });
    return result;
}

function saveUnArrangeNew(dataBox) {
    endEditDataBox(dataBox);
    var arrangeData = {
            OperRoom: getSelectedOperNurses("OperRoomContainer"),
            ScrubNurse: getSelectedOperNurses("ScrubNurseContainer"),
            CircualNurse: getSelectedOperNurses("CircualNurseContainer")
        },
        selectedOperList = selectedApplications, //dataBox.datagrid("getSelections"),
        operScheduleList = [];
    if (arrangeData.OperRoom === "" && arrangeData.ScrubNurse.length == 0 && arrangeData.CircualNurse.length == 0) {
        $.messager.alert("提示", "手术间，器械护士，巡回护士不同同时为空！", "warning");
        return;
    }
    if (arrangeData && selectedOperList && selectedOperList.length > 0) {
        // var scrubNurseArray = $("#ScrubNurse").combobox("getValues"),
        //     circualNurseArray = $("#CircualNurse").combobox("getValues");
        // if (scrubNurseArray && scrubNurseArray.length > 0) {
        //     arrangeData.ScrubNurse = scrubNurseArray.join(splitchar.comma);
        // }
        // if (circualNurseArray && circualNurseArray.length > 0) {
        //     arrangeData.CircualNurse = circualNurseArray.join(splitchar.comma);
        // }
        $.each(selectedOperList, function (index, item) {
            operScheduleList.push({
                ClassName: ANCLS.Model.OperSchedule,
                RowId: item.RowId,
                OperRoom: arrangeData.OperRoom,
                OperSeq: item.OperSeq ? item.OperSeq : "",
                Status: "",
                ScrubNurse: arrangeData.ScrubNurse ? arrangeData.ScrubNurse : "",
                CircualNurse: arrangeData.CircualNurse ? arrangeData.CircualNurse : "",
                StatusCode: OperStatus.Arrange
            });
        });
        var jsonData = dhccl.formatObjects(operScheduleList);
        dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData,
            MethodName: "SaveOperArrange",
            ClassName: ANCLS.BLL.OperArrange
        }, function (data) {
            dhccl.showMessage(data, "保存", null, null, function () {
                loadUnArrangeBoxData();
                $("#arrangedBox").datagrid("reload");
                $("#unarrangeForm").form("clear");
            });
        });
    }
}


function saveOperArrange(dataBox) {
    endEditDataBox(dataBox);
    var selectedOperList = dataBox.datagrid("getSelections"),
        selectedOperRoom = $(".oper-room-selected").attr("data-rowId"),
        selectedScrubNurses = getSelectedNurses(".scrub-nurse-selected"),
        selectedCircualNurses = getSelectedNurses(".circual-nurse-selected"),
        operScheduleList = [];
    if (selectedOperList && selectedOperList.length > 0 && selectedOperRoom) {
        $.each(selectedOperList, function (index, item) {
            operScheduleList.push({
                ClassName: ANCLS.Model.OperSchedule,
                RowId: item.RowId,
                OperRoom: selectedOperRoom,
                OperSeq: item.OperSeq,
                Status: "",
                ScrubNurse: selectedScrubNurses,
                CircualNurse: selectedCircualNurses,
                StatusCode: "Arrange"
            });
        });

        var jsonData = dhccl.formatObjects(operScheduleList);
        $.ajax({
            url: ANCSP.DataListService,
            data: {
                jsonData: jsonData,
                MethodName: "SaveOperArrange",
                ClassName: ANCLS.BLL.OperArrange
            },
            async: false,
            type: "post",
            success: function (data) {
                dhccl.showMessage(data, "保存", null, null, function () {
                    $("#unarrangeBox").datagrid("reload");
                    $("#arrangedBox").datagrid("reload");
                    selectedApplications.length = 0;
                    clearAllSelection();
                });
            }
        });
    }
}

function declineOperApplication(dataBox) {
    var selectedOperList = dataBox.datagrid("getSelections"),
        operScheduleList = [];
    if (selectedOperList && selectedOperList.length > 0) {
        $.each(selectedOperList, function (index, item) {
            operScheduleList.push({
                ClassName: ANCLS.Model.OperSchedule,
                RowId: item.RowId,
                Status: "",
                StatusCode: "Decline"
            });
        });
        var jsonData = dhccl.formatObjects(operScheduleList);
        $.ajax({
            url: CLCLS.BLL.Admission,
            data: {
                jsonData: jsonData,
                MethodName: "SaveOperArrange",
                ClassName: ANCLS.BLL.OperArrange
            },
            async: false,
            type: "post",
            success: function (data) {
                dhccl.showMessage(data, "保存", null, null, function () {
                    dataBox.datagrid("reload");
                });
            }
        });
    }
}

function clearOperSeq() {
    selectedApplications.splice(0, selectedApplications.length);
    
}

function clearArrangedOperSeq(){
    selectedArrangeList.splice(0, selectedApplications.length);
}

function getRoomNextOperSeq(roomSelector, boxSelector) {
    var operList = $("#" + boxSelector).datagrid("getRows"),
        // selectedRoom = $(".oper-room-selected").attr("data-rowId"),
        selectedRoom = $("#" + roomSelector).combobox("getValue"),
        currentSeq = 1;
    if (operList && operList.length > 0) {
        var maxSeq = 0;
        $.each(operList, function (index, item) {
            if (item.OperRoom == selectedRoom && item.OperSeq != "") {
                var operSeq = parseInt(item.OperSeq);
                if (operSeq > maxSeq) {
                    maxSeq = operSeq;
                }
            }
        });
        currentSeq = maxSeq + 1;
    }
    return currentSeq;
}

function setOperSeq() {
    var operList = $("#arrangedBox").datagrid("getRows"),
        // selectedRoom = $(".oper-room-selected").attr("data-rowId"),
        selectedRoom = getSelectedOperNurses("OperRoomContainer"),
        currentSeq = 1;
    if (operList && operList.length > 0) {
        var maxSeq = 0;
        $.each(operList, function (index, item) {
            if (item.OperRoom == selectedRoom && item.OperSeq != "") {
                var operSeq = parseInt(item.OperSeq);
                if (operSeq > maxSeq) {
                    maxSeq = operSeq;
                }
            }
        });
        currentSeq = maxSeq + 1;
    }
    if (selectedApplications && selectedApplications.length > 0) {
        var selectedRows = $("#unarrangeBox").datagrid("getSelections");
        var tempApps = [];
        for (var i = 0; i < selectedApplications.length; i++) {
            if (selectedRows.indexOf(selectedApplications[i]) >= 0) {
                tempApps.push(selectedApplications[i]);
            }
        }
        $.each(tempApps, function (index, item) {
            item.OperSeq = currentSeq + index;
        });
    }
}

function selectArrangedOperation(index, row) {
    // if (row.ScrubNurse && row.ScrubNurse != "") {
    //     var scrubNurseArr = row.ScrubNurse.split(splitchar.comma);
    //     $("#ArrangedScrubNurse").combobox("setValues", scrubNurseArr);
    // }
    // if (row.CircualNurse && row.CircualNurse != "") {
    //     var circualNurseArr = row.CircualNurse.split(splitchar.comma);
    //     $("#ArrangedCircualNurse").combobox("setValues", circualNurseArr);
    // }
    // $("#ArrangedOperRoom").combobox("setValue", row.OperRoom);
    // $("#ArrangedOperSeq").numberspinner("setValue", row.OperSeq);
    var record={RowId:"",Description:""};
    var scrubNurseIdArr=row.ScrubNurse.split(splitchar.comma);
    var scrubNurseDescArr=row.ScrubNurseDesc.split(splitchar.comma);
    $("#ArrangedScrubNurseContainer").empty();
    for(var i=0;i<scrubNurseIdArr.length;i++){
        record.RowId=scrubNurseIdArr[i];
        record.Description=scrubNurseDescArr[i];
        genArrangeElement(record,"ArrangedScrubNurse");
    }
    var circualNurseIdArr=row.CircualNurse.split(splitchar.comma);
    var circaulNurseDescArr=row.CircualNurseDesc.split(splitchar.comma);
    $("#ArrangedCircualNurseContainer").empty();
    for(var i=0;i<circualNurseIdArr.length;i++){
        record.RowId=circualNurseIdArr[i];
        record.Description=circaulNurseDescArr[i];
        genArrangeElement(record,"ArrangedCircualNurse");
    }

    record.RowId=row.OperRoom;
    record.Description=row.RoomDesc;
    $("#ArrangedOperRoomContainer").empty();
    genArrangeElement(record,"ArrangedOperRoom",true);
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

function printList(printDatas, configCode) {
    var excel = null;
    try {
        excel = new ExcelHelper();
        var arrangeConfig = getArrangeConfig();
        var printConfig = getPrintConfig(arrangeConfig, configCode);
        var templateUrl = window.location.protocol + "//" + window.location.host + printConfig.templateUrl;
        excel.open(templateUrl);

        // 标题信息(手术日期、手术室)
        var titleInfo = {
            OperationDate: $("#AppDate").datebox("getValue"),
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
        excel.printPreview();
    } catch (error) {
        alert(error.message);
    } finally {
        if (excel) {
            excel.visible(false);
            excel.quit();
        }
    }

}

function printListNew(printDatas, configCode) {
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
        OperationDate: $("#AppDate").datebox("getValue"),
        OperDeptDesc: session.DeptDesc
    };

    var LODOP = getLodop();
    LODOP.PRINT_INIT("山西省肿瘤医院手术排班表");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "SSS");
    LODOP.ADD_PRINT_TEXT(15, 250, 200, 70, "山西省肿瘤医院手术排班表");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 18);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    //LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(85, 20, "100%", 28, "科室：" + titleInfo.OperDeptDesc);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 400, "100%", 28, "日期：" + titleInfo.OperationDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(85, 700, "100%", 28, "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;}</style><table><thead><tr>";
    for (var i = 0; i < printConfig.columns.length; i++) {
        var column = printConfig.columns[i];
        html += "<th style='width:" + column.width + "px'>" + column.title + "</th>";
    }
    html += "</tr></thead><tbody>";
    for (var i = 0; i < printDatas.length; i++) {
        var printData = printDatas[i];
        html += "<tr>";
        for (var j = 0; j < printConfig.columns.length; j++) {
            var column = printConfig.columns[j];
            html += "<td style='" + (column.style ? column.style : "") + "'>" + printData[column.field] + "</td>";
        }
        html += "</tr>";
    }
    html += "</tbody></table>";
    LODOP.ADD_PRINT_TABLE(115, 0, "100%", "100%", html);
    LODOP.PREVIEW();
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

function loadDeptSchedule() {
    var deptSchedules = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DeptSchedule,
        QueryName: "FindDeptSchedule",
        Arg1: $("#AppDate").datebox("getValue"),
        Arg2: session.DeptID,
        ArgCnt: 2
    }, "json");
    if (deptSchedules && deptSchedules.length > 0) {
        var deptSchedule = deptSchedules[0];
        $("#otherArrange").val(deptSchedule.Content);
        $("#otherArrange").attr("data-RowId", deptSchedule.RowId);
    }
}

function SaveDeptSchedule() {
    dhccl.saveDatas(dhccl.csp.dataService, {
        ClassName: ANCLS.BLL.DeptSchedule,
        RowId: $("#otherArrange").attr("data-RowId"),
        ScheduleDate: $("#AppDate").datebox("getValue"),
        DeptID: session.DeptID,
        Content: $("#otherArrange").val(),
        UpdateUserID: session.UserID
    }, function (result) {
        dhccl.showMessage(result, "科室安排");
    });
}