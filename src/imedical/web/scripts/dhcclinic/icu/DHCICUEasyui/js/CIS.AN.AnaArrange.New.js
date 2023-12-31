
var operArrange={
    operList:null,
    selectedOperList:null,
    selectedAnaExpert:null,
    selectedAnesthesiologist:null,
    selectedAnaAssistant:null,
    selectedAnaMethod:null,
    editIndex:-1,
    editData:null,
    checkedIndexList:null,
    attendance:null,
    operRooms:null,
    crewShiftList:null,
    roomArrangeList:{}
};

$(document).ready(function() {
    dhccl.parseDateFormat();
    var dataBox = $("#dataBox");
    // $("#AppDate").datebox("setValue", (new Date()).format("yyyy-MM-dd"));
    $("#OperDate").datebox("setValue",((new Date()).addDays(1)).format("dd/MM/yyyy"));
    
    var anaExpertOpts=getAnaDocEditorOptions("AnaExpert",false);
    var anesthesiologistOpts=getAnaDocEditorOptions("Anesthesiologist",false);
    var anaAssistantOpts=getAnaDocEditorOptions("AnaAssistant",true);
    var anaMethodOpts=getAnaMethodOptions();
    dataBox.datagrid({
        title:"麻醉排班列表",
        idField: "RowId",
        fit: true,
        rownumbers: true,
        checkOnSelect:false,
        selectOnCheck:false,
        toolbar: "#dataTool",
        url: ANCSP.MethodService,
        headerCls:"panel-header-gray",
        iconCls:"icon-paper",
        columns: [
            [
                { field: "OperDate", title: "手术日期", width: 80,hidden:true },
                {field:"CheckStatus",title:"选择",checkbox:true,width:40},
                {
                    field: "SourceTypeDesc",
                    title: "手术类型",
                    width: 76,
                    styler: function (value, row, index) {
                        switch (row.SourceType) {
                            case "B":
                                return "background-color:"+SourceTypeColors.Book+";";
                            case "E":
                                return "background-color:"+SourceTypeColors.Emergency+";";
                            default:
                                return "background-color:white;";
                        }
                    }
                },
                {field:"RoomDesc",title:"术间",width:70},
                {field:"OperSeq",title:"台次",width:48},
                {field:"PatName",title:"姓名",width:76},
                {field:"PatGender",title:"性别",width:40},
                {field:"PatAge",title:"年龄",width:50},
                { field: "AppDeptDesc", title: "申请科室", width: 100 },
                { field: "OperDeptDesc", title: "手术室", width: 100, hidden: true },
                { field: "PrevDiagnosis", title: "术前诊断", width: 100 },
                { field: "OperDesc", title: "手术名称", width: 160 },
                { field: "ArrAnaMethod", title: "麻醉方法", width: 160,editor:{type:"combobox",options:anaMethodOpts},formatter:function(value,row,index){
                    return row.ArrAnaMethodDesc;
                } },
                {
                    field: "SurgeonDesc",
                    title: "手术医生",
                    width: 80
                },
                { field: "ArrAnaExpert", title: "麻醉指导", width: 80 ,editor:{type:"combogrid",options:anaExpertOpts},formatter:function(value,row,index){
                    return row.ArrAnaExpertDesc;
                } },
                { field: "ArrAnesthesiologist", title: "麻醉医生", width: 80,editor:{type:"combogrid",options:anesthesiologistOpts},formatter:function(value,row,index){
                    return row.ArrAnesthesiologistDesc;
                } },
                { field: "ArrAnaAssistant", title: "麻醉助手", width: 120,editor:{type:"combogrid",options:anaAssistantOpts},formatter:function(value,row,index){
                    return row.ArrAnaAssistantDesc;
                }},
                { field: "ArrAnaStaff", title: "实习进修", width: 100,editor:{type:"validatebox"} },
                { field: "ScrubNurseDesc", title: "器械护士", width: 80 },
                { field: "CircualNurseDesc", title: "巡回护士", width: 80 },
                { field: "LabInfo", title: "检验信息", width: 120,hidden:true },
                {field:"StatusDesc",title:"状态",width:50,styler:function(value,row,index){
                    return "background-color:" + row.StatusColor + ";";
                }}
            ]
        ],
        onBeforeLoad: function(param) {
            $(this).datagrid("clearSelections");
            param.ClassName=ANCLS.BLL.AnaArrange;
            param.MethodName="GetArrOperList";
            param.Arg1 = $("#OperDate").datebox("getValue");
            param.Arg2 = $("#OperDate").datebox("getValue");
            param.Arg3 = session.DeptID;
            param.ArgCnt=3;
        },
        onLoadSuccess:function(data){
            initAttendance();
        },
        view: groupview,
        groupField: "RoomDesc",
        groupFormatter: function(value, rows) {
            var roomDesc = value;
            if (!roomDesc || roomDesc == "") {
                roomDesc = "未排手术";
            }
            var title=value,andocStr="",roomCode="";
            var andocArr=[];
            if(rows.length>0){
                for(var i=0;i<rows.length;i++){
                    var row=rows[i];
                    roomCode=row.RoomCode;
                    if(row.ArrAnesthesiologistDesc && andocArr.indexOf(row.ArrAnesthesiologistDesc)<0){
                        andocArr.push(row.ArrAnesthesiologistDesc);
                    }
                }
            }
            if(!value){
                title="未排";
            }
            if(andocArr.length>0){
                andocStr="("+andocArr.join(" ")+")";
            }
            if(roomCode){
                operArrange.roomArrangeList[roomCode]=andocArr.join("，");
            }
            return roomDesc + " 共" + rows.length + "台手术"+andocStr;
        },
        onSelect: function (index, row) {
        },
        onBeginEdit:function(rowIndex,rowData){
            operArrange.editIndex=rowIndex;
            operArrange.editData=rowData;
        },
        onAfterEdit:editorAfterEdit,
        onClickCell:clickArrangeCell
    });
    dataBox.datagrid("enableCellEditing");

    $("#btnQuery").linkbutton({
        onClick: function() {
            dataBox.datagrid("reload");
        }
    });

    // 保存排班
    $("#btnSave").linkbutton({
        onClick:function(){
            endEditDataBox($("#dataBox"));
            operArrange.roomArrangeList={};   //重新加载右侧科室人员排班信息
            $("#dataBox").datagrid("reload");
        }
    });
	
	// 发布手术列表
    $("#btnSubmit").linkbutton({
        onClick:submitOperList
    });

    
    $("#btnPrint").linkbutton({
        onClick:function(){
            var printDatas = dataBox.datagrid("getRows");
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

    initOperRooms();
    initCrewShift();
    initRoomArrangeInfo();
    initAttendance();
});

function getAnaMethodOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindAnaestMethod";
            param.Arg1 = param.q?param.q:"";
            param.ArgCnt = 1;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        multiple:true,
        onSelect:function(record){
            var values=$(this).combobox("getValues");
            var valueStr="";
            if(values && values.length>0){
                valueStr=values.join(",");
            }
            var texts=$(this).combobox("getText");
            operArrange.selectedAnaMethod={
                RowId:valueStr,
                Description:texts
            };
        },
        onUnselect:function(){
            var values=$(this).combobox("getValues");
            var valueStr="";
            if(values && values.length>0){
                valueStr=values.join(",");
            }
            var texts=$(this).combobox("getText");
            operArrange.selectedAnaMethod={
                RowId:valueStr,
                Description:texts
            };
        }
    }
}

function initFilterTools(){
    // var htmlArr=[
    //     "<div id='filterTool' style='padding:10px;'>",
    //     "<input id='filterDesc' class='hisui-triggerbox' style='width:430px;'>",
    //     "</div>"
    // ];
    // $(htmlArr.join("")).appendTo("body");
    // $(".filter-desc").triggerbox({
    //     icon:"searchbox-button",
    //     plain:true,
    //     handler:function(){
    //         var editor=$("#dataBox").datagrid("getEditor",{
    //             index:operArrange.editIndex,
    //             field:operArrange.editField
    //         });
    //         var grid=$(editor.target).combogrid("grid");
    //         grid.datagrid("reload");
    //     }
    // });
}

function getAnaDocEditorOptions(field,multiple){
    //$("#filter"+field+"Tool").remove();
    var htmlArr=[
        "<div style='padding:10px;'>",
        "<input class='textbox filter-desc' style='width:423px;'>",
        "</div>"
    ];

    // $("#filter"+field).triggerbox({
    //     icon:"searchbox-button",
    //     plain:true,
    //     handler:function(){
    //         var editor=$("#dataBox").datagrid("getEditor",{
    //             index:operArrange.editIndex,
    //             field:operArrange.editField
    //         });
    //         var grid=$(editor.target).combogrid("grid");
    //         grid.datagrid("reload");
    //     }
    // });

    return {
        id:field,
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            // var opts=$(this).datagrid("options");
            // var filterSelector="#filter"+opts.id;
            var filterDesc=param.filterDesc?param.filterDesc:"";
            param.ClassName = ANCLS.BLL.OperScheduleList;
            param.MethodName = "GetAnaDocJSON";
            param.Arg1=$("#OperDate").datebox("getValue");
            param.Arg2 = filterDesc;
            param.Arg3 = session.DeptID;
            param.ArgCnt = 3;
        },
        panelWidth:450,
        panelHeight:450,
        idField: "RowId",
        textField: "Description",
        multiple:multiple,
        toolbar:htmlArr.join(""),
        columns:[[
            {field:"RowId",title:"ID",hidden:true},
            {field:"Description",title:"麻醉医生",width:100},
            {field:"ArrangeInfo",title:"今日已排",width:300}
        ]],
        rowStyler: function (index, row) {
            if(row.AttendanceInfo){
                return "background-color:#eee;";
            }
            
        },
        mode: "remote",
        onChange:function(oldValue,newValue){
            var text=$(this).combogrid("getText");
            if(multiple){
                var values=$(this).combogrid("getValues");
                var valueStr="";
                if (values && values.length>0) valueStr=values.join(",");
                operArrange["selected"+field]={
                    RowId:valueStr,
                    Description:text
                };
            }else{
                // var value=$(this).combogrid("getValues");
                // operArrange["selected"+field]={
                //     RowId:value,
                //     Description:text
                // };
            }
        },
        onShowPanel:function(){
            $(".filter-desc").triggerbox({
                icon:"searchbox-button",
                plain:true,
                handler:function(){
                    var editor=$("#dataBox").datagrid("getEditor",{
                        index:operArrange.editIndex,
                        field:operArrange.editField
                    });
                    var filterDesc=$(this).triggerbox("getValue");
                    var grid=$(editor.target).combogrid("grid");
                    grid.datagrid("reload",{
                        filterDesc:filterDesc
                    });
                }
            });

            $(".filter-desc").each(function(index,item){
                var textbox=$(item).triggerbox("textbox");
                textbox.keydown(function (e) { 
                    if(e.keyCode===13){
                        var editor=$("#dataBox").datagrid("getEditor",{
                            index:operArrange.editIndex,
                            field:operArrange.editField
                        });
                        var filterDesc=$(this).val();
                        var grid=$(editor.target).combogrid("grid");
                        grid.datagrid("reload",{
                            filterDesc:filterDesc
                        });
                    }
                });
            })
        },
        onHidePanel:function(){
            var text=$(this).combogrid("getText");
            if(multiple){
                var values=$(this).combogrid("getValues");
                var valueStr="";
                if (values && values.length>0) valueStr=values.join(",");
                operArrange["selected"+field]={
                    RowId:valueStr,
                    Description:text
                };
            }else{
                // var value=$(this).combogrid("getValues");
                // operArrange["selected"+field]={
                //     RowId:value,
                //     Description:text
                // };
            }
            $("#filterDesc").triggerbox("setValue","");
        },
        onSelect:function(rowIndex,record){
            // var existsNurse=existsCareProv(record.RowId);
            // if(existsNurse && existsNurse.indexOf("S^")===0){
            //     var messageArray=existsNurse.split("^");
            //     var message=messageArray[1];
            //     $.messager.alert("提示",record.Description+"已被安排在"+message,"warning");
            // }
            if(multiple){
                // var values=$(this).combogrid("getValues");
                // var text=$(this).combogrid("getText");
                // var valueStr="";
                // if (values && values.length>0) valueStr=values.join(",");
                // operArrange["selected"+field]={
                //     RowId:valueStr,
                //     Description:text
                // };
            }else{
                operArrange["selected"+field]={
                    RowId:record.RowId,
                    Description:record.Description
                };
            }
            
        },
        view: groupview,
        groupField: "ArrangeFlag",
        groupFormatter: function (value, rows) {
            return value;
        }
    }
}

function editorAfterEdit(rowIndex,rowData,changes){
    var result=null;
    if(changes.ArrAnaExpert && operArrange.selectedAnaExpert){
        rowData.ArrAnaExpertDesc=operArrange.selectedAnaExpert.Description;
        rowData.ArrAnaExpert=operArrange.selectedAnaExpert.RowId;
        result=dhccl.runServerMethod(ANCLS.BLL.AnaArrange,"UpdateAnaExpert",rowData.RowId,rowData.ArrAnaExpert,session.UserID);
    }
    if(changes.ArrAnesthesiologist && operArrange.selectedAnesthesiologist){
        rowData.ArrAnesthesiologistDesc=operArrange.selectedAnesthesiologist.Description;
        rowData.ArrAnesthesiologist=operArrange.selectedAnesthesiologist.RowId;
        result=dhccl.runServerMethod(ANCLS.BLL.AnaArrange,"UpdateAnesthesiologist",rowData.RowId,rowData.ArrAnesthesiologist,session.UserID);
    }
    if(changes.ArrAnaAssistant && operArrange.selectedAnaAssistant){
        rowData.ArrAnaAssistantDesc=operArrange.selectedAnaAssistant.Description;
        rowData.ArrAnaAssistant=operArrange.selectedAnaAssistant.RowId;
        result=dhccl.runServerMethod(ANCLS.BLL.AnaArrange,"UpdateAnaAssistant",rowData.RowId,rowData.ArrAnaAssistant,session.UserID);
    }
    if(changes.ArrAnaStaff){
        rowData.ArrAnaStaff=changes.ArrAnaStaff;
        result=dhccl.runServerMethod(ANCLS.BLL.AnaArrange,"UpdateAnaStaff",rowData.RowId,rowData.ArrAnaStaff,session.UserID);
    }
    if(changes.ArrAnaMethod && operArrange.selectedAnaMethod){
        rowData.ArrAnaMethodDesc=operArrange.selectedAnaMethod.Description;
        rowData.ArrAnaMethod=operArrange.selectedAnaMethod.RowId;
        result=dhccl.runServerMethod(ANCLS.BLL.AnaArrange,"UpdateArrAnaMethod",rowData.RowId,rowData.ArrAnaMethod,session.UserID);
    }
    if(result){
        if(result.success){
            $("#dataBox").datagrid("refreshRow",rowIndex);
        }else{
            $.messager.alert("提示","手术排班信息保存失败，原因："+result.result,"error");
        }
    }
    
}

function clickArrangeCell(rowIndex,field,value){
    operArrange.editField=field;
}

function initOperRooms(){
    var operRooms=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindOperRoom",
        Arg1:"",
        Arg2:"R",
        ArgCnt:2
    },"json");
    operArrange.operRooms=operRooms;
}

function initCrewShift(){
    var crewShiftList=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindCrewShift",
        Arg1:session.DeptID,
        Arg2:"",
        ArgCnt:2
    },"json");
    operArrange.crewShiftList=crewShiftList;
}

function initRoomArrangeInfo()
{
    $(".attendance").empty();
    var htmlArr=["<form style='margin:0'>"];
    var crewShiftList=operArrange.crewShiftList;
    if(crewShiftList && crewShiftList.length>0){
        var shiftGroupList=dhccl.group(crewShiftList,"FloorDesc");
        for(var i=0;i<shiftGroupList.length;i++){
            var crewShiftGroup=shiftGroupList[i];
            if(i===0){
                htmlArr.push("<div class='form-row-group' style='padding-bottom:0'><span class='form-btn'><a href='#' id='btnAttendance'>科室考勤</a></span></div>");
            }
            htmlArr.push("<div class='form-row-group' style='padding-bottom:0'><div class='form-row-grouptitle'>"+crewShiftGroup.id+"</div><div class='form-rows'>");
            
            for(var j=0;j<crewShiftGroup.data.length;j++){
                var crewShift=crewShiftGroup.data[j];
                htmlArr.push("<div><div class='form-row'><div class='form-title-right45'>"+crewShift.StatusDesc+"</div>");
                htmlArr.push("<div class='form-item-normal'><span id="+crewShift.StatusCode+" class='arrange-container'></span></div></div></div>"); 
            }
            // if(i==shiftGroupList.length-1){
            //     htmlArr.push("<div><div class='form-row'><div id='btnAttendanceContainer' style='text-align:center'><a href='#' id='btnAttendance'>科室考勤</a></div></div></div>");
            // }
            htmlArr.push("</div></div>");
        }
        
        
    }
    var operRooms=operArrange.operRooms;
    if(operRooms && operRooms.length>0){
        htmlArr.push("<div class='form-row-group' style='padding-bottom:0'><div class='form-row-grouptitle'>术间排班汇总</div><div class='form-rows'>");
        for(var i=0;i<operRooms.length;i++){
            var operRoom=operRooms[i];
            htmlArr.push("<div><div class='form-row'><div class='form-title-right45'>"+operRoom.Description+"</div>");
            htmlArr.push("<div class='form-item-normal'><span id="+operRoom.Code+" class='arrange-container'></span></div></div></div>");
        }
        htmlArr.push("</div></div>");
    }
    htmlArr.push("</form>")

    $(".attendance").append(htmlArr.join(""));
    $("#btnAttendance").linkbutton({
        iconCls:"icon-cal-pen",
        plain:true,
        onClick:function(){
            var operDate=$("#OperDate").datebox("getValue");
            $("#attendanceDialog").dialog({
                content:"<iframe scrolling='yes' frameborder='0' src='CIS.AN.DailyAttendance.csp?operDate="+operDate+"' style='width:100%;height:100%'></iframe>"
            })
            $("#attendanceDialog").dialog("open");
        }
    });

    $("#btnAttendanceContainer").css("text-align","center");
}

function initAttendance(){
    $(".attendance .arrange-container").text("");
    var operDate=$("#OperDate").datebox("getValue");
    var attendanceList=dhccl.runServerMethod(ANCLS.BLL.Attendance,"GetAttendanceInfo",operDate,session.DeptID);
    if(attendanceList && attendanceList.length>0){
        operArrange.attendance=attendanceList[0];
        for(var property in operArrange.attendance){
            $("#"+property).text(operArrange.attendance[property]);
        }
    }

    if(operArrange.roomArrangeList){
        for(var property in operArrange.roomArrangeList){
            $("#"+property).text(operArrange.roomArrangeList[property]);
        }
    }
}


function sortNumber(a, b) {
    if (!a || a == "") {
        return -1;
    }
    if (!b || b == "") {
        return 1;
    }
    var firstNum = parseInt(a),
        secondNum = parseInt(b);
    return (firstNum > secondNum ? 1 : -1);
}


function saveAnaArrange(dataBox) {
    var anaMethodId=$("#AnaMethod").combobox("getValue");
    if ($("#AnaMethod").combobox("getText")===""){
        anaMethodId="";
    }
    var anaExpertId=$("#AnaExpert").combobox("getValue");
    if ($("#AnaExpert").combobox("getText")===""){
        anaExpertId="";
    }
    var anesthesiologistId=$("#Anesthesiologist").combobox("getValue");
    if ($("#Anesthesiologist").combobox("getText")===""){
        anesthesiologistId="";
    }
    var careProvData = {
            ArrAnaExpert: anaExpertId,
            ArrAnesthesiologist: anesthesiologistId,
            ArrAnaAssistant: getSelectedOperNurses("AnaAssistantContainer"),
            ArrAnaStaff:$("#AnaAddtionalStaff").val()
        },
        selectedOperList = dataBox.datagrid("getChecked"),
        operScheduleList = [];
    if (careProvData && selectedOperList && selectedOperList.length > 0) {
        $.each(selectedOperList, function(index, item) {
            operScheduleList.push({
                ClassName: ANCLS.Model.Anaesthesia,
                OperSchedule:item.RowId,
                RowId: item.AnaestID?item.AnaestID:"",
                ArrAnaExpert: careProvData.ArrAnaExpert,
                ArrAnesthesiologist: careProvData.ArrAnesthesiologist,
                ArrAnaAssistant: careProvData.ArrAnaAssistant,
                ArrAnaStaff: careProvData.ArrAnaStaff,
                ArrAnaMethod:anaMethodId,
                UserID:session.UserID
            });
        });
        var jsonData = dhccl.formatObjects(operScheduleList);
        dhccl.saveDatas(ANCSP.DataListService, {
            ClassName:ANCLS.BLL.AnaArrange,
            MethodName:"SaveAnaArrange",
            jsonData: jsonData
        }, function(data) {
            dhccl.showMessage(data, "保存", null, null, function() {
                dataBox.datagrid("reload");
                dataBox.datagrid("clearSelections");
                $("#careProvForm").form("clear");
				// updateAnaArrange(dataBox);	
            });
        });
    }
}


function saveOperArrange(dataBox) {
    var selectedOperList = dataBox.datagrid("getSelections"),
        selectedAnaExpert = $(".anaest-expert-selected").attr("data-rowId"),
        selectedAnesthesiologist = $(".anesthesiologist-selected").attr("data-rowId"),
        selectedAnaestAssistants = getSelectedAssistants(".anaest-assistant-selected"),
        operScheduleList = [];
    if (selectedOperList && selectedOperList.length > 0 && selectedAnesthesiologist) {
        $.each(selectedOperList, function(index, item) {
            operScheduleList.push({
                ClassName: ANCLS.Model.OperSchedule,
                RowId: item.RowId,
                Status: "",
                AnaExpert: selectedAnaExpert,
                Anesthesiologist: selectedAnesthesiologist,
                AnaAssistant: selectedAnaestAssistants,
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
            success: function(data) {
                dhccl.showMessage(data, "保存", null, null, function() {
                    dataBox.datagrid("reload");
                });
            }
        });
    }
}

/**
 * 提交手术（手术排班信息发布）
 */
function submitOperList()
{
    $.messager.confirm("提示","是否要发布所有手术？",function(r){
        if(r){
            endEditDataBox($("#dataBox"));
            var operDate=$("#OperDate").datebox("getValue");
            var result=dhccl.runServerMethod(ANCLS.BLL.AnaArrange,"SubmitArrange",operDate,session.UserID);
            if(result.success){
                $("#dataBox").datagrid("reload");
            }else{
                $.messager.alert("提示","发布手术失败，原因："+result.result,"error");
            }
        }
    });
    
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

function loadDeptSchedule() {
    var deptSchedules = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: dhcan.bll.deptSchedule,
        QueryName: "FindDeptSchedule",
        Arg1: $("#OperDate").datebox("getValue"),
        Arg2: session.DeptID,
        ArgCnt: 2
    }, "json");
    if (deptSchedules && deptSchedules.length > 0) {
        var deptSchedule = deptSchedules[0];
        $("#deptArrange").val(deptSchedule.Content);
        $("#deptArrange").attr("data-RowId", deptSchedule.RowId);
    }
}

function SaveDeptSchedule() {
    dhccl.saveDatas(dhccl.csp.dataService, {
        ClassName: dhcan.cls.deptSchedule,
        RowId: $("#deptArrange").attr("data-RowId"),
        ScheduleDate: $("#OperDate").datebox("getValue"),
        DeptID: session.DeptID,
        Content: $("#deptArrange").val(),
        UpdateUserID: session.UserID
    }, function(result) {
        dhccl.showMessage(result, "科室安排");
    });
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
        OperationDate: $("#OperDate").datebox("getValue"),
        OperDeptDesc: session.DeptDesc
    };

    // var LODOP = getLodop();
    var printSetting=operListConfig.print;
	var hospital=getHospital(); //YuanLin 20191210 医院名称自动获取
	var printtitle=hospital[0].HOSP_Desc+"手术排班表";
    LODOP.PRINT_INIT(printtitle);
    // LODOP.SET_PRINT_PAGESIZE(printSetting.direction, printSetting.paperSize.width, printSetting.paperSize.height, "SSS");
    LODOP.SET_PRINT_PAGESIZE("2", "", "", "A4");
    LODOP.ADD_PRINT_TEXT(25, 250, 500, 40, printtitle);
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 18);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
    LODOP.ADD_PRINT_TEXT(65, 20, "100%", 28, "科室：" + titleInfo.OperDeptDesc);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(65, 400, "100%", 28, "日期：" + titleInfo.OperationDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(65, 700, "100%", 28, "总计：" + printDatas.length+"台手术");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(65, 900, "100%", 28, "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true)
    //var totalWidth=900;
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-left:none;border-right:none;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;}</style><table style='"+totalWidth+"pt'><thead><tr>";
    var totalWidth=0;
    for (var i = 0; i < printConfig.columns.length; i++) {
        var column = printConfig.columns[i];
        totalWidth+=column.width;
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
			printValue=printValue?printValue:"";   //YuanLin 20191210
            if(column.field==="RoomDesc" && curRoom===preRoom){
                printValue="";
            }
            html += "<td style='" + (column.style ? column.style : "") + "'>" + printValue + "</td>";
        }
        html += "</tr>";
        preRoom=printData.RoomDesc;
    }
    html += "</tbody></table>";

    
    LODOP.ADD_PRINT_TABLE(90, 20, totalWidth+"pt", "100%", html);
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

function getArrangeConfig() {
    var result = null;
    $.ajaxSettings.async = false;
    $.getJSON("../service/dhcanop/data/anarrange.json?random=" + Math.random(), function (data) {
        result = data;
    }).error(function (message) {
        alert(message);
    });
    $.ajaxSettings.async = true;
    return result;
}

function getHospital(){
	var result = null;
    $.ajaxSettings.async = false;
    var result = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindHospitalDesc",
        ArgCnt: 0
    }, "json");
    $.ajaxSettings.async = true;
    return result;
}