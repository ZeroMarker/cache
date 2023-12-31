
var operArrange={
    operList:null,
    selectedOperList:null,
    selectedOperRoom:null,
    selectedScrubNurse:null,
    selectedCirNurse:null,
    selectedSeqType:null,
    editIndex:-1,
    editData:null,
    checkedIndexList:null,
    attendance:null,
    operRooms:null,
    crewShiftList:null,
    roomArrangeList:{}
};
var selectStatus=null;
var selectedOperSeq=null;
$(document).ready(function() {
    dhccl.parseDateFormat();
    var dataBox = $("#dataBox");
    // $("#AppDate").datebox("setValue", (new Date()).format("yyyy-MM-dd"));
    $("#OperDate").datebox("setValue",((new Date()).addDays(1)).format("dd/MM/yyyy"));
    var columnsConfig=dhccl.runServerMethod("CIS.AN.BL.DataGrid","GetDataColumns",session.ModuleID,"dataBox",session.GroupID,session.UserID);
	var columns =[
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
			{field:"MedcareNo",title:"住院号",width:80},
			{field:"PatBedCode",title:"床号",width:50},
			{ field: "AppDeptDesc", title: "申请科室", width: 100 },
			{ field: "OperDeptDesc", title: "手术室", width: 100, hidden: true },
			{ field: "PrevDiagnosisDesc", title: "术前诊断", width: 100 },
			{ field: "OperDesc", title: "手术名称", width: 160 },
			{ field: "ArrAnaMethodDesc", title: "麻醉方法", width: 160 },
			{ field: "AnaMethod", title: "麻醉方法", width: 160,hidden: true },
			{
				field: "SurgeonDesc",
				title: "手术医生",
				width: 80
			},
			{ field: "ArrAnaExpertDesc", title: "麻醉指导", width: 80 },
			{ field: "ArrAnesthesiologistDesc", title: "麻醉医生", width: 80 },
			{ field: "ArrAnaAssistantDesc", title: "麻醉助手", width: 120 },
			{ field: "ArrAnaStaff", title: "实习进修", width: 100 },
			
			{ field: "ScrubNurseDesc", title: "器械护士", width: 80 },
			{ field: "CircualNurseDesc", title: "巡回护士", width: 80 },
			{ field: "LabInfo", title: "检验信息", width: 120,hidden:true },
			{field:"StatusDesc",title:"状态",width:50,styler:function(value,row,index){
				return "background-color:" + row.StatusColor + ";";
			}}
		]
	];
	initColumns(columns[0], columnsConfig);
    dataBox.datagrid({
        title:"麻醉排班列表",
        idField: "RowId",
        fit: true,
        rownumbers: true,
        pagination: true,
        pageSize: 100,
        pageList: [50, 100, 200,300,400,500],
        checkOnSelect:true,
        selectOnCheck:true,
        toolbar: "#dataTool",
        url: ANCSP.MethodService,
        headerCls:"panel-header-gray",
        iconCls:"icon-paper",
        columns: columns,
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
            selectArrangedOperation(index, row);
        }
    });
    //dataBox.datagrid("enableCellEditing");
    $("#btnQuery").linkbutton({
        onClick: function() {
            operArrange.roomArrangeList={}; //清空上次术间排班汇总信息 YuanLin 20200514
            dataBox.datagrid("reload");
        }
    });
	
	// 发布手术列表
    $("#btnSubmit").linkbutton({
        onClick:submitOperList
    });

    $("#AnaExpert,#Anesthesiologist,#AnaAssistant").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = session.DeptID;
            param.Arg3 = "Y";
            param.ArgCnt = 3;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        onSelect:function(record){
            var elementID=$(this).attr("id");
            genArrangeElement(record,elementID,true);
            
        }
    });
    $("#AnaMethod").combobox({
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
        onSelect:function(record){
            // var elementID=$(this).attr("id");
            // genArrangeElement(record,elementID);
            
        }
    })

    $("#PatInfo").on("input propertychange",function(){
        dataBox.datagrid("clearSelections");
        var compareText=$("#PatInfo").val();
        if(compareText==="") return;
        var dataRows=dataBox.datagrid("getRows");
        if(dataRows && dataRows.length>0){
            var count=0;
            for(var i=dataRows.length-1;i>0;i--){
                var dataRow=dataRows[i];
                if (dataRow.PatName.indexOf(compareText)>=0 || dataRow.MedcareNo.indexOf(compareText)>=0){
                    dataBox.datagrid("selectRow",i);
                    // count++;
                    // if(count===1){
                    //     dataBox.datagrid("scrollTo",i);
                    // }
                }
            }
            // dataBox.datagrid("scrollTo",0);
        }
    });

    $("#Surgeon").on("input propertychange",function(){
        dataBox.datagrid("clearSelections");
        var compareText=$("#Surgeon").val();
        if(compareText==="") return;
        var dataRows=dataBox.datagrid("getRows");
        if(dataRows && dataRows.length>0){
            var count=0;
            for(var i=0;i<dataRows.length;i++){
                var dataRow=dataRows[i];
                if (dataRow.SurgeonDesc.indexOf(compareText)>=0 || dataRow.AssistantDesc.indexOf(compareText)>=0){
                    dataBox.datagrid("selectRow",i);
                    count++;
                    if(count===1){
                        dataBox.datagrid("scrollTo",i);
                    }
                }
            }
        }
    });

    $("#ScrubNurse").on("input propertychange",function(){
        dataBox.datagrid("clearSelections");
        var compareText=$("#ScrubNurse").val();
        if(compareText==="") return;
        
        var dataRows=dataBox.datagrid("getRows");
        if(dataRows && dataRows.length>0){
            var count=0,firstIndex=0;
            for(var i=0;i<dataRows.length;i++){
                var dataRow=dataRows[i];
                if (dataRow.ScrubNurseDesc.indexOf(compareText)>=0){
                    dataBox.datagrid("selectRow",i);
                    count++;
                    if(count===1){
                        firstIndex=i;
                    }
                }
            }
            dataBox.datagrid("scrollTo",firstIndex);
        }
    });

    // $("#ScrubNurse,#CircualNurse").combobox({
    //     url: ANCSP.DataQuery,
    //     onBeforeLoad: function (param) {
    //         param.ClassName = CLCLS.BLL.Admission;
    //         param.QueryName = "FindCareProvByLoc";
    //         param.Arg1 = param.q ? param.q : "";
    //         param.Arg2 = "29";
    //         param.ArgCnt = 2;
    //     },
    //     valueField: "RowId",
    //     textField: "Description",
    //     mode: "remote",
    //     onSelect:function(record){
    //         var dataRows=dataBox.datagrid("getRows");
    //         if(dataRows && dataRows.length>0){
    //             var compareID=","+record.RowId+",";
    //             var count=0
    //             for(var i=0;i<dataRows.length;i++){
    //                 var dataRow=dataRows[i];
    //                 var scrubNurseStr=","+dataRow.ScrubNurse+",";
                    
    //                 if (scrubNurseStr.indexOf(compareID)>=0 || dataRow.ScrubNurseDesc.indexOf(record.Description)>=0){
    //                     dataBox.datagrid("select",i);
    //                     count++;
    //                     if(count===1){
    //                         dataBox.datagrid("scrollTo",i);
    //                     }
    //                 }
    //             }
    //         }
    //     }
    // });

    // $("#Surgeon").combobox({
    //     url: ANCSP.DataQuery,
    //     onBeforeLoad: function (param) {
    //         param.ClassName = CLCLS.BLL.Admission;
    //         param.QueryName = "FindCareProv";
    //         param.Arg1 = param.q ? param.q : "";
    //         param.Arg2 = "";
    //         param.ArgCnt = 2;
    //     },
    //     valueField: "RowId",
    //     textField: "Description",
    //     mode: "remote",
    //     onSelect:function(record){
    //         var dataRows=dataBox.datagrid("getRows");
    //         if(dataRows && dataRows.length>0){
    //             var count=0
    //             for(var i=0;i<dataRows.length;i++){
    //                 var dataRow=dataRows[i];
    //                 if (dataRow.Surgeon===record.RowId || dataRow.SurgeonDesc.indexOf(record.Description)>=0){
    //                     dataBox.datagrid("select",i);
    //                     count++;
    //                     if(count===1){
    //                         dataBox.datagrid("scrollTo",i);
    //                     }
    //                 }
    //             }
    //         }
    //     }
    // });


    $("#AnaAssistant").combobox({
        onSelect:function(record){
            var elementID=$(this).attr("id");
            let careProvRecord={
                RowId:record.RowId,
                Description:record.Description
            }
            genArrangeElement(careProvRecord,elementID);
            $(this).combobox("setValue","");
        }
    });

    $("#btnArrange").linkbutton({
        onClick: function() {
			var selectedDatas = $("#dataBox").datagrid("getChecked");
			if (!selectedDatas || selectedDatas.length >1) {
				$.messager.alert("提示","请选择其中一条手术进行保存，不可多选！","warning");
				return;
			}
            if(selectStatus!=="Receive" && selectStatus!=="Arrange"){
                $.messager.alert("提示","手术状态为接收或安排状态才可以排班。","warning");
                return;
            }
            if (hasCareProvSelected(dataBox)) {
                var operDate=$("#OperDate").datebox("getValue");
                var selectedAnaDoc=$("#Anesthesiologist").combobox("getValue");
                var selectedAnaDocDesc=$("#Anesthesiologist").combobox("getText");
                var ret=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"HasArrangeFirstSeq",operDate,session.DeptID,selectedAnaDoc);
                if(ret.success===false){
                    $.messager.alert("提示","麻醉医生："+selectedAnaDocDesc+"已安排到"+ret.result+"首台手术。","warning");
                    //return;
                }
				var ret=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"ExistsOperSeqByAnDoc",operDate,session.DeptID,selectedAnaDoc,selectedOperSeq);
                if(ret.success===false){
                    $.messager.alert("提示","麻醉医生："+selectedAnaDocDesc+"已安排到"+ret.result+"相同台次。","warning");
                    //return;
                }
                // saveOperArrange(dataBox);
                saveAnaArrange(dataBox);
                $("#dataBox").datagrid("reload");
            } else {
                $.messager.alert("提示", "请先选择麻醉医生再安排手术！", "warning");
            }

        }
    });

    $(".oper-decline").linkbutton({
        onClick: function() {
            if (hasRowSelected(dataBox, true)) {
                $.messager.confirm("提示", "是否拒绝手术申请？", function(result) {
                    if (result) {
                        declineOperApplication(dataBox);
                    }
                });
            }
        }
    });

    $("#btnUpdate").linkbutton({
        onClick: function() {
            // saveOperArrange(arrangedBox);
            //saveAnaArrange(arrangedBox);
            var ret=dhccl.runServerMethod("DHCAN.BLL.OperArrange","SyncAnaArrangeInfo",$("#OperDate").datebox("getValue"));
            if(ret.success){
                $.messager.alert("提示","麻醉排班信息提交成功!","info");
            }else{
                $.messager.alert("提示","麻醉排班信息提交失败，原因："+ret.message,"error");
            }
        }
    });

    $("#btnSaveDeptArrange").linkbutton({
        onClick: SaveDeptSchedule
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
	$("#btnExport").linkbutton({
        onClick:function(){
            var rows = dataBox.datagrid("getChecked");
            if (rows && rows.length > 0) {
                var columnFields = $("#dataBox").datagrid("getColumnFields");
				if (!columnFields || columnFields.length < 1) return;
				var aoa = [], // array of array
				fieldArray = [];
				for (var fieldInd = 0; fieldInd < columnFields.length; fieldInd++) {
					var columnField = columnFields[fieldInd];
					var columnOpts = $("#dataBox").datagrid(
					  "getColumnOption",
					  columnField
					);
					fieldArray.push(columnOpts.title);
				}
				aoa.push(fieldArray);
				for (var i = 0; i < rows.length; i++) {
					var row = rows[i],
					valueArray = [];
					for (var j = 0; j < columnFields.length; j++) {
						var columnField = columnFields[j];
						var columnOpts = $("#dataBox").datagrid(
							"getColumnOption",
							columnField
						);
						if ( columnOpts.DescField && columnOpts.DescField !== "" && columnOpts.DescField !== columnOpts.field) 
						{
							if (columnOpts.DescField === "RoomDesc")
								var NewField = columnOpts.DescField;
							else var NewField = columnOpts.field + "Desc";
							valueArray.push(row[NewField] || "");
						} 
						else 
						{
							valueArray.push(row[columnOpts.field] || "");
						}
					}
					aoa.push(valueArray);
				}
				if (aoa.length > 0 && window.excelmgr) {
					window.excelmgr.aoa2excel(aoa, "麻醉排班列表.xlsx");
				}
            } else {
                $.messager.alert("提示", "请先选勾选需要导出的手术", "warning");
            }
        }
    });

    $("#btnReset").linkbutton({
        onClick:function(){
            $("#OperDate").datebox("setValue",((new Date()).addDays(1)).format("yyyy-MM-dd"));
            $("#PatNameOrMedNo").val("");
            $("#ScrubNurse,#CircualNurse,#Surgeon").combobox("clear");
            //dataBox.datagrid("reload");
        }
    });

    //loadDeptSchedule();

    // loadAnaCareProvs();
    initOperRooms();
    initCrewShift();
    initRoomArrangeInfo();
    initAttendance();
	initOperlistBoxColumnDisplay();
});

function initOperlistBoxColumnDisplay() {
    var testIcon = dhccl.runServerMethod("CIS.AN.BL.OperScheduleList", "GetOperConfig", "OperListEdit");
    if (testIcon.result == "Y") {
        $("#dataBox").datagrid("enableGridSetting", {
            clickHandler: function(columnOptList) {
                var columnEditor = new DataGridEditor({
                    title: "麻醉排班列表",
                    data: columnOptList,
                    moduleId: session.ModuleID,
                    elementId: "dataBox",
                    closeCallBack: function() {
                        window.location.reload();
                    }
                });
                columnEditor.open();
            }
        });
    }
}
function initColumns(columns, columnsConfig) {
    for (var i = 0; i < columns.length; i++) {
        for (var j = 0; j < columnsConfig.length; j++) {
            var test = columns[i].field;
            var test1 = columnsConfig[j].field;
            if (columns[i].field == columnsConfig[j].field) {
                if (columnsConfig[j].hidden == "true") columns[i].hidden = true;
                else columns[i].hidden = false;
                if (columnsConfig[j].sortable == "true") columns[i].sortable = true;
                else columns[i].sortable = false;
                columns[i].width = columnsConfig[j].width;
                columns[i].SeqNo = columnsConfig[j].SeqNo;
            }

        }
    }
    columns.sort(function(a, b) {
        return a.SeqNo - b.SeqNo;
    });
}
function initOperRooms(){
	//取麻醉科关联的手术室科室Id
	var linklocIdArr=[];
	var linklocId="";
    var linklocIdStr=dhccl.runServerMethodNormal(CLCLS.BLL.Admission,"GetLinkLocId",session.DeptID);
	if(linklocIdStr!==""){
		linklocIdArr=linklocIdStr.split("^");
		linklocId=linklocIdArr[0];
	}
    var operRooms=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindOperRoom",
        Arg1:(linklocId!=="") ? linklocId:session.DeptID,
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
                htmlArr.push("<div class='form-row-group' style='padding-bottom:0'><span class='form-btn'><a href='#' style=\"padding-left:0;\" id='btnAttendance'>科室考勤</a></span></div>");
            }
            htmlArr.push("<div class='form-row-group' style='padding-bottom:0'><div class='form-row-grouptitle'>"+crewShiftGroup.id+"</div><div class='form-rows'>");
            
            for(var j=0;j<crewShiftGroup.data.length;j++){
                var crewShift=crewShiftGroup.data[j];
                htmlArr.push("<div><div class='form-row'><div class='form-title-right2'>"+crewShift.StatusDesc+"</div>");
                htmlArr.push("<div class='form-item-normal'><span id="+crewShift.Status+" class='arrange-container'></span></div></div></div>"); 
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
            htmlArr.push("<div><div class='form-row'><div class='form-title-right2'>"+operRoom.Description+"</div>");
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

function genArrangeElement(record,elementID,emptyContainer){
    var selector="#"+elementID+"Container";
    var nurseId=elementID+record.RowId;
    var nurseSelector="#"+nurseId;
    if(emptyContainer && emptyContainer===true){
        //$(selector).empty();
    }
    if($(nurseSelector).length>0) return;
    var html="<span id='"+nurseId+"' class='oper-nurse oper-nurse-inroom' data-rowid='"+record.RowId+"'>"+record.Description;
    html+="<span class='close'>&times</span></span>"
    $(selector).append(html);
    $(".close").click(function(){
        $(this).parent().remove();
    });
}

function selectArrangedOperation(index, row) {
    selectStatus=row.StatusCode;
	selectedOperSeq=row.OperSeq;
    var record={RowId:"",Description:""};
    var anaAssistIdArr=row.ArrAnaAssistant.split(splitchar.comma);
    var anaAssistDescArr=row.ArrAnaAssistantDesc.split(splitchar.comma);
    $("#AnaAssistantContainer").empty();
    for(var i=0;i<anaAssistIdArr.length;i++){
        record.RowId=anaAssistIdArr[i];
        record.Description=anaAssistDescArr[i];
        genArrangeElement(record,"AnaAssistant",true);
    }

    record.RowId=row.ArrAnaExpert;
    record.Description=row.ArrAnaExpertDesc;
    // $("#AnaExpertContainer").empty();
    // genArrangeElement(record,"AnaExpert",true);
    $("#AnaExpert").combobox("setValue",record.RowId);
    $("#AnaExpert").combobox("setText",record.Description);
    

    record.RowId=row.ArrAnesthesiologist;
    record.Description=row.ArrAnesthesiologistDesc;
    // $("#AnesthesiologistContainer").empty();
    // genArrangeElement(record,"Anesthesiologist",true);
    $("#Anesthesiologist").combobox("setValue",record.RowId);
    $("#Anesthesiologist").combobox("setText",record.Description);
    record.RowId=row.ArrAnaMethod;
    record.Description=row.ArrAnaMethodDesc;
    $("#AnaMethod").combobox("setValue",record.RowId);
    $("#AnaMethod").combobox("setText",record.Description);//

    $("#AnaAddtionalStaff").val(row.ArrAnaStaff || "");
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

function loadAnaCareProvs() {
    var url = ANCSP.DataQuery,
        param = {
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindCareProvByLoc",
            Arg1: "",
            Arg2: session.DeptID,
            ArgCnt: 2
        },
        dataType = "json";
    var careprovList = dhccl.getDatas(url, param, dataType);
    if (careprovList && careprovList.length > 0) {
        $.each(careprovList, function(index, careprov) {
            var html = "<div class='anaest-expert' data-rowId='" + careprov.RowId + "'>" + careprov.Description + "</div>";
            $("#AnaestExpertList").append(html);
            html = "<div class='anesthesiologist' data-rowId='" + careprov.RowId + "'>" + careprov.Description + "</div>";
            $("#Anesthesiologist").append(html);
            html = "<div class='anaest-assistant' data-rowId='" + careprov.RowId + "'>" + careprov.Description + "</div>";
            $("#AnaestAssistantList").append(html);
        });

        $(".anaest-expert").click(function() {
            if ($(this).hasClass("anaest-expert-selected")) {
                $(this).removeClass("anaest-expert-selected");
            } else {
                $(this).addClass("anaest-expert-selected");
                clearCareProvSelected("anaest-expert-selected", $(this).attr("data-rowId"));
            }
        });

        $(".anesthesiologist").click(function() {
            if ($(this).hasClass("anesthesiologist-selected")) {
                $(this).removeClass("anesthesiologist-selected");
            } else {
                $(this).addClass("anesthesiologist-selected");
                clearCareProvSelected("anesthesiologist-selected", $(this).attr("data-rowId"));
            }
        });

        $(".anaest-assistant").click(function() {
            if ($(this).hasClass("anaest-assistant-selected")) {
                $(this).removeClass("anaest-assistant-selected");
            } else {
                $(this).addClass("anaest-assistant-selected");
            }
        });
    }

}

function getSelectedAssistants(selector) {
    var result = ""
    $(selector).each(function() {
        var rowId = $(this).attr("data-rowId");
        if (result != "") {
            result += ","
        }
        result += rowId;
    });
    return result;
}

function clearCareProvSelected(selector, ignoreRowId) {
    $("." + selector).each(function() {
        if ($(this).attr("data-rowId") != ignoreRowId) {
            $(this).removeClass(selector);
        }
    });
}
function updateAnaArrange(dataBox){
		// var ret=dhccl.runServerMethod("DHCAN.BLL.OperArrange","SyncAnaArrangeInfo",$("#OperDate").datebox("getValue"));
		// if(ret.success){
        //     dataBox.datagrid("reload");
        //     dataBox.datagrid("clearSelections");
        //     $("#AnaMethod").combobox("setValue","");
        //     $("#AnaExpert").combobox("setValue","");
        //     $("#Anesthesiologist").combobox("setValue","");
        //     $("#AnaAssistantContainer").empty();
        //     $.messager.alert("提示","麻醉排班信息提交成功!","info");
		// }else{
		// 	$.messager.alert("提示","麻醉排班信息提交失败，原因："+ret.message,"error");
		// }
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
    var sendAnaArrangeInfo=dhccl.runServerMethodNormal(ANCLS.BLL.DataConfiguration,"GetValueByKey","SendAnaArrangeInfo");
	if(sendAnaArrangeInfo!="Y"){      //发布麻醉排班信息配置为"否"时自动发布排班信息 YL 20200616
	    var operDate=$("#operDate").datebox("getValue");
		var result=dhccl.runServerMethod(ANCLS.BLL.AnaArrange,"SubmitArrange",operDate,session.UserID);
		if(result.success){
			$("#dataBox").datagrid("reload");
		}else{
			$.messager.alert("提示","发布手术失败，原因："+result.result,"error");
        }
	}
}

function hasCareProvSelected() {
    var result = false;
    // var careProvData = {
    //     AnaExpert: getSelectedOperNurses("AnaExpertContainer"),
    //     Anesthesiologist: getSelectedOperNurses("AnesthesiologistContainer"),
    //     AnaAssistant: getSelectedOperNurses("AnaAssistantContainer"),
    //     AnaAddtionalStaff:$("#AnaAddtionalStaff").val()
    // };
    var anaExpertId=$("#AnaExpert").combobox("getValue");
    if ($("#AnaExpert").combobox("getText")===""){
        anaExpertId="";
    }
    var anesthesiologistId=$("#Anesthesiologist").combobox("getValue");
    if ($("#Anesthesiologist").combobox("getText")===""){
        anesthesiologistId="";
    }
    var careProvData = {
        AnaExpert: anaExpertId,
        Anesthesiologist: anesthesiologistId,
        AnaAssistant: getSelectedOperNurses("AnaAssistantContainer"),
        AnaAddtionalStaff:$("#AnaAddtionalStaff").val()
    };
    if (careProvData) {
        if (careProvData.AnaExpert && careProvData.AnaExpert != "") {
            result = true;
        }
        if (careProvData.Anesthesiologist && careProvData.Anesthesiologist != "") {
            result = true;
        }
        if (careProvData.AnaAssistant && careProvData.AnaAssistant != "") {
            result = true;
        }
        if (careProvData.AnaAddtionalStaff && careProvData.AnaAddtionalStaff != "") {
            result = true;
        }
    }
    return result;
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

function declineOperApplication(dataBox) {
    var selectedOperList = dataBox.datagrid("getSelections"),
        operScheduleList = [];
    if (selectedOperList && selectedOperList.length > 0) {
        $.each(selectedOperList, function(index, item) {
            operScheduleList.push({
                ClassName: ANCLS.Model.OperSchedule,
                RowId: item.RowId,
                Status: "",
                StatusCode: "Decline"
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
    //LODOP.PRINT_INIT(printtitle);
    // LODOP.SET_PRINT_PAGESIZE(printSetting.direction, printSetting.paperSize.width, printSetting.paperSize.height, "SSS");
    LODOP.SET_PRINT_PAGESIZE("2", "", "", "A4");
    LODOP.ADD_PRINT_TEXT(10, 250, 500, 40, hospital[0].HOSP_Desc);
    LODOP.SET_PRINT_STYLEA(0, "FontName", "宋体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
    LODOP.SET_PRINT_STYLEA(0, "Bold",1);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
    LODOP.ADD_PRINT_TEXT(40, 250, 500, 40, "麻醉排班表");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "宋体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
    LODOP.SET_PRINT_STYLEA(0, "Bold",1);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
    LODOP.ADD_PRINT_TEXT(80, 20, "100%", 28, "科室：" + titleInfo.OperDeptDesc);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(80, 400, "100%", 28, "日期：" + titleInfo.OperationDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(80, 700, "100%", 28, "总计：" + printDatas.length+"台手术");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(80, 900, "100%", 28, "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);
    LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1);
    //var totalWidth=900;
    var html = "<style>table,td,th {border: 1px solid black;border-style:solid;border-collapse:collapse;font-size:16px;} table{table-layout:fixed;}</style><table style='"+totalWidth+"pt'><thead><tr>";
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

    
    LODOP.ADD_PRINT_TABLE(105, 20, totalWidth+"pt", "100%", html);
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

function reloadDatagrid(){  
    $("#dataBox").datagrid('reload');
  } 