$(document).ready(function() {
    $("#ScrubNurse").next("span").find("input").prop("placeholder", "请选择器械护士");
    $("#CircualNurse").next("span").find("input").prop("placeholder", "请选择巡回护士");
    $("#Surgeon").next("span").find("input").prop("placeholder", "请选择手术医生");
    var dataBox = $("#dataBox");
    // $("#AppDate").datebox("setValue", (new Date()).format("yyyy-MM-dd"));
    $("#AppDate").datebox("setValue",((new Date()).addDays(1)).format("yyyy-MM-dd"));
    
    dataBox.datagrid({
        title:"麻醉排班列表",
        idField: "RowId",
        fit: true,
        // nowrap: false,
        rownumbers: true,
        toolbar: "#dataTool",
        url: ANCSP.DataQuery,
        columns: [
            [
                { field: "OperDate", title: "手术日期", width: 80,hidden:true },
                { field: "RoomDesc", title: "手术间", width: 80, sortable: true,
				 sorter:function(a,b){
				 	a=a.replace(/[^0-9]/ig,"");
				 	b=b.replace(/[^0-9]/ig,"");
				 	if(a==""&&b==""){
				 		return 0
				 	}else if(a!=""&&b!=""){
				 		if(a>b){
				 			return 1;
				 		}else if(a<b){
				 			return -1;
				 		}else{
				 			return 0;
				 		}
				 	}else if(a==""){
				 		return 1;
				 	}else{
				 		return -1;
				 	}
				 }},
                {
                    field: "OperSeq",
                    title: "台次",
                    width: 60,
                    sortable: true,
                    order: "asc",
                    sorter: sortNumber
                },
                {
                    field: "Patient",
                    title: "手术患者",
                    width: 120,
                    formatter: function(value, row, index) {
                        return (row.PatName + "(" + row.PatGender + "," + row.PatAge + ")");
                    }
                },
                { field: "AppDeptDesc", title: "申请科室", width: 100 },
                { field: "OperDeptDesc", title: "手术室", width: 100, hidden: true },
                { field: "PrevDiagnosis", title: "术前诊断", width: 100 },
                { field: "OperDesc", title: "手术名称", width: 160 },
                //
                
                { field: "PrevAnaMethodDesc", title: "麻醉方法", width: 160 },
                { field: "PrevAnaMethod", title: "麻醉方法", width: 160,hidden: true },
                {
                    field: "SurgeonDesc",
                    title: "手术医生",
                    width: 80
                },
                { field: "ArrAnaExpertDesc", title: "麻醉指导", width: 80 },
                { field: "ArrAnaDocDesc", title: "麻醉医生", width: 80 },
                { field: "ArrAnaAssDesc", title: "麻醉助手", width: 120 },
                { field: "ArrAnaStaff", title: "实习进修", width: 100 },
                
                { field: "ScrubNurseDesc", title: "器械护士", width: 80 },
                { field: "CircualNurseDesc", title: "巡回护士", width: 80 },
                { field: "LabInfo", title: "检验信息", width: 120,hidden:true },
                { field: "SourceTypeDesc", title: "类型", width: 80,hidden:true },
                { field: "OperStatusDesc", title: "手术状态", width: 80,hidden:true }
            ]
        ],
        rowStyler: function(index, row) {
            if(row.ArrAnaDocDesc===""){
                return "background-color:#CCCCFF";
            }
            return "background-color:" + row.StatusColor + ";";
        },
        queryParams: {
            ClassName: ANCLS.BLL.OperScheduleList,
            QueryName: "FindOperScheduleList",
            ArgCnt: 11
        },
        onBeforeLoad: function(param) {
            $(this).datagrid("clearSelections");
            param.Arg1 = $("#AppDate").datebox("getValue");
            param.Arg2 = $("#AppDate").datebox("getValue");
            param.Arg3 = session.DeptID;
            param.Arg4 = "";
            param.Arg5 = "";
            param.Arg6 = "";
            param.Arg7 = "Application^Accept^Audit^Arrange";
            param.Arg8 = "";
            param.Arg9 = "";
            param.Arg10 = "";
            param.Arg11 = "N";
            // param.Arg14=$("#PatNameOrMedNo").val();
            // var scrubNurseDesc=$("#ScrubNurse").combobox("getText"),scrubNurseId="";
            // if(scrubNurseDesc!==""){
            //     scrubNurseId=$("#ScrubNurse").combobox("getValue");
            // }
            // param.Arg15=scrubNurseId;
            // var circualNurseDesc=$("#CircualNurse").combobox("getText"),circualNurseId="";
            // if(circualNurseDesc!==""){
            //     circualNurseId=$("#CircualNurse").combobox("getValue");
            // }
            // param.Arg16=circualNurseId;
            // param.Arg17=$("#Surgeon").combobox("getText");
        },
        sortName: "RoomDesc,OperSeq",
        sortOrder: "asc,asc",
        remoteSort: false,
        multiSort: true,
        view: groupview,
        groupField: "RoomDesc",
        groupFormatter: function(value, rows) {
            var roomDesc = value;
            if (!roomDesc || roomDesc == "") {
                roomDesc = "未排手术";
            }

            return roomDesc + " 共" + rows.length + "台手术";
        },
        onSelect: function (index, row) {
            selectArrangedOperation(index, row);
        }
    });
    //dataBox.datagrid("enableCellEditing");
    $("#btnQuery").linkbutton({
        onClick: function() {
            dataBox.datagrid("reload");
        }
    });

    $("#AnaExpert,#Anesthesiologist,#AnaAssistant").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = session.DeptID;
            param.ArgCnt = 2;
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
            genArrangeElement(record,elementID);
            $(this).combobox("setValue","");
        }
    });

    $("#btnArrange").linkbutton({
        onClick: function() {
            if (hasCareProvSelected(dataBox)) {
                var operDate=$("#AppDate").datebox("getValue");
                var selectedAnaDoc=$("#Anesthesiologist").combobox("getValue");
                var selectedAnaDocDesc=$("#Anesthesiologist").combobox("getText");
                var ret=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"HasArrangeFirstSeq",operDate,session.DeptID,selectedAnaDoc);
                if(ret.success===false){
                    $.messager.alert("提示","麻醉医生："+selectedAnaDocDesc+"已安排到"+ret.result+"首台手术。","warning");
                    //return;
                }
                // saveOperArrange(dataBox);
                saveAnaArrange(dataBox);
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
            var ret=dhccl.runServerMethod("DHCAN.BLL.OperArrange","SyncAnaArrangeInfo",$("#AppDate").datebox("getValue"));
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

    $("#btnReset").linkbutton({
        onClick:function(){
            $("#AppDate").datebox("setValue",((new Date()).addDays(1)).format("yyyy-MM-dd"));
            $("#PatNameOrMedNo").val("");
            $("#ScrubNurse,#CircualNurse,#Surgeon").combobox("clear");
            //dataBox.datagrid("reload");
        }
    });

    //loadDeptSchedule();

    // loadAnaCareProvs();
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

function selectArrangedOperation(index, row) {
    var record={RowId:"",Description:""};
    var anaAssistIdArr=row.ArrAnaAss.split(splitchar.comma);
    var anaAssistDescArr=row.ArrAnaAssDesc.split(splitchar.comma);
    $("#AnaAssistantContainer").empty();
    for(var i=0;i<anaAssistIdArr.length;i++){
        record.RowId=anaAssistIdArr[i];
        record.Description=anaAssistDescArr[i];
        genArrangeElement(record,"AnaAssistant",true);
    }

    record.RowId=row.ArrAnaExpert;
    record.Description=row.ArrAnaExpertDesc;
    $("#AnaExpertContainer").empty();
    genArrangeElement(record,"AnaExpert",true);
    $("#AnaExpert").combobox("setValue",record.RowId);
    $("#AnaExpert").combobox("setText",record.Description);
    

    record.RowId=row.ArrAnaDoc;
    record.Description=row.ArrAnaDocDesc;
    $("#AnesthesiologistContainer").empty();
    genArrangeElement(record,"Anesthesiologist",true);
    $("#Anesthesiologist").combobox("setValue",record.RowId);
    $("#Anesthesiologist").combobox("setText",record.Description);
    record.RowId=row.PrevAnaMethod;
    record.Description=row.PrevAnaMethodDesc;
    $("#AnaMethod").combobox("setValue",record.RowId);
    $("#AnaMethod").combobox("setText",record.Description);//
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
		var ret=dhccl.runServerMethod("DHCAN.BLL.OperArrange","SyncAnaArrangeInfo",$("#AppDate").datebox("getValue"));
		if(ret.success){
            dataBox.datagrid("reload");
            dataBox.datagrid("clearSelections");
            $("#AnaMethod").combobox("setValue","");
            $("#AnaExpert").combobox("setValue","");
            $("#Anesthesiologist").combobox("setValue","");
            $("#AnaAssistantContainer").empty();
            $.messager.alert("提示","麻醉排班信息提交成功!","info");
		}else{
			$.messager.alert("提示","麻醉排班信息提交失败，原因："+ret.message,"error");
		}
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
            AnaExpert: anaExpertId,
            Anesthesiologist: anesthesiologistId,
            AnaAssistant: getSelectedOperNurses("AnaAssistantContainer"),
            AnaAddtionalStaff:$("#AnaAddtionalStaff").val()
        },
        selectedOperList = dataBox.datagrid("getSelections"),
        operScheduleList = [];
    if (careProvData && selectedOperList && selectedOperList.length > 0) {
        $.each(selectedOperList, function(index, item) {
            operScheduleList.push({
                ClassName: ANCLS.Model.AnaestSchedule,
                OperSchedule:item.RowId,
                RowId: item.AnaScheduleId?item.AnaScheduleId:"",
                AnaExpert: careProvData.AnaExpert,
                Anesthesiologist: careProvData.Anesthesiologist,
                AnaAssistant: careProvData.AnaAssistant,
                AnaAddtionalStaff: careProvData.AnaAddtionalStaff,
                AnaMethod:anaMethodId
            });
        });
        var jsonData = dhccl.formatObjects(operScheduleList);
        dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData
        }, function(data) {
            dhccl.showMessage(data, "保存", null, null, function() {
                //dataBox.datagrid("reload");
               // dataBox.datagrid("clearSelections");
                //$("#careProvForm").form("clear");
				updateAnaArrange(dataBox);	
            });
        });
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

function loadDeptSchedule() {
    var deptSchedules = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: dhcan.bll.deptSchedule,
        QueryName: "FindDeptSchedule",
        Arg1: $("#AppDate").datebox("getValue"),
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
        ScheduleDate: $("#AppDate").datebox("getValue"),
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
        OperationDate: $("#AppDate").datebox("getValue"),
        OperDeptDesc: session.DeptDesc
    };

    // var LODOP = getLodop();
    var printSetting=operListConfig.print;
    LODOP.PRINT_INIT(printSetting.title);
    // LODOP.SET_PRINT_PAGESIZE(printSetting.direction, printSetting.paperSize.width, printSetting.paperSize.height, "SSS");
    LODOP.SET_PRINT_PAGESIZE("2", "", "", "A4");
    LODOP.ADD_PRINT_TEXT(25, 250, 500, 40, printSetting.title);
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