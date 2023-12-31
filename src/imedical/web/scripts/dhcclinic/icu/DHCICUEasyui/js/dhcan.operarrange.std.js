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
    crewShiftList:null
};

function initPage(){
    initArrangeForm();
    initArrangeBox();
    extractOperList();
    initOperRooms();
    initCrewShift();
    initRoomArrangeInfo();
    
    //$("body").layout("collapse","east");
    initAttendance();
}

/**
 * 初始化排班表格
 */
function initArrangeBox(){
    var roomEditorOptions=getOperRoomEditorOptions();
    var scrubEditorOptions=getScrubNurseEditorOptions();
    var circualEditorOptions=getCircualNurseEditorOptions();
    var seqTypeEditorOptions=getSeqTypeEditorOptions();
    var seqEditorOptions=getSeqEditorOptions();
    // 设置表格属性
    var columns=[[
        {field:"CheckStatus",title:"选择",checkbox:true,width:40},
        {
            field: "SourceTypeDesc",
            title: "手术类型",
            width: 76,
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
        {field:"OperRoom",title:"术间ID",hidden:true},
        // {field:"RoomDesc",title:"术间",width:100,editor:{type:"combobox",options:roomEditorOptions}},
        {field:"RoomDesc",title:"术间",width:100,editor:{type:"combobox",options:roomEditorOptions}},
        {field:"PlanOperSeq",title:"计划台次",width:76},
        {field:"SeqType",title:"正常台",width:60},
        {field:"AppDeptDesc",title:"科室",width:90,formatter:function(value,row,index){
            if(row.OperStatusCode==="Accept"){
                return "<span style='color:red'>"+value+"</span>";
            }
			return value;
        }},
        {field:"SurgeonDesc",title:"术者",width:60},
        {field:"PrevDiagnosis",title:"诊断",width:100},
        {field:"PlanOperDesc",title:"手术名称",width:180},
        {field:"FirstScrubNurse",title:"器械护士1",hidden:true},
        {field:"FirstScrubNurseDesc",title:"器械1",width:75,editor:{type:"combogrid",options:scrubEditorOptions}},
        {field:"SecScrubNurse",title:"器械护士2",hidden:true},
        {field:"SecScrubNurseDesc",title:"器械2",width:75,editor:{type:"combogrid",options:scrubEditorOptions}},
        {field:"FirstCirNurse",title:"巡回护士1",hidden:true},
        {field:"FirstCirNurseDesc",title:"巡回1",width:75,editor:{type:"combogrid",options:circualEditorOptions}},
        {field:"SecCirNurse",title:"巡回护士2",hidden:true},
        {field:"SecCirNurseDesc",title:"巡回2",width:75,editor:{type:"combogrid",options:circualEditorOptions}},
        {field:"OperSeq",title:"台次",width:40,editor:{type:"numberbox",options:seqEditorOptions}},
        {field:"PatName",title:"姓名",width:60,formatter:function(value,row,index){
            if(row.OperStatusCode==="Accept"){
                return "<span style='color:red'>"+value+"</span>";
            }
			return value;
        }},
        {field:"PatGender",title:"性别",width:40},
        {field:"PatAge",title:"年龄",width:50},
        {field:"PatBedCode",title:"床号",width:40},
        {field:"FirstAssDesc",title:"一助",width:60},
        {field:"PrevAnaMethodDesc",title:"麻醉方法",width:100},
        {field:"AnesthesiologistDesc",title:"麻醉医生",width:80},
        {field:"AnaAssistantDesc",title:"麻醉助手",width:80,formatter:function(value,row,index){
            if(value){
                var valueArr=value.split(",");
                if(valueArr.length>0){
                    return valueArr[0];
                }
            }
			return value;
        }},
        
        {field:"InfectionOper",title:"感染",width:40},
        {field:"OperPositionDesc",title:"体位",width:60},
        {field:"Antibiosis",title:"抗生素",width:62},
        {field:"OperRequirementDesc",title:"备注",width:120},
        {field:"SpecialMaterial",title:"特殊仪器及器械",width:120},
        {field:"HighConsume",title:"高值耗材",width:120},
    ]];

    $("#arrangeBox").datagrid({
        fit:true,
        nowrap:false,
        title:"手术排班列表",
        headerCls:"panel-header-gray",
        columns:columns,
        toolbar:"#arrangeTools",
        iconCls:"icon-paper",
        rownumber:true,
        checkOnSelect:false,
        selectOnCheck:false,
        url: ANCSP.DataQuery,
        queryParams:{
            ClassName:ANCLS.BLL.OperScheduleList,
            QueryName:"FindOperScheduleList",
            ArgCnt:7
        },
        onBeforeLoad:function(param){
            param.Arg1 = $("#operDate").datebox("getValue");
            param.Arg2 = $("#operDate").datebox("getValue");
            param.Arg3 = session.DeptID;
            param.Arg4 = "";
            param.Arg5 = "";
            param.Arg6 = "";
            param.Arg7 = "Application^Accept^Arrange^RoomIn^RoomOut^PACUIn^PACUOut";
        },
        onLoadSuccess:function(data){
            if(data && data.rows && data.rows.length>=0){
                var panel=$("#arrangeBox").datagrid("getPanel");
                $(panel).panel("setTitle","手术排班列表(共"+data.rows.length+"台手术)");
            }
            if(operArrange.checkedIndexList && operArrange.checkedIndexList.length>0){
                var checedIndexList=operArrange.checkedIndexList;
                for(var i=0;i<checedIndexList.length;i++){
                    var rowIndex=checedIndexList[i];
                    $("#arrangeBox").datagrid("checkRow",rowIndex);
                }
                operArrange.checkedIndexList=null;
            }
            initAttendance();
            
        },
        onBeginEdit:function(rowIndex,rowData){
            operArrange.editIndex=rowIndex;
            operArrange.editData=rowData;
        },
        onAfterEdit:editorAfterEdit,
        rowStyler: function(index, row) {
            if(isNaN(row.RoomCode)===false){
                var roomCode=Number(row.RoomCode);
                if(roomCode>0){
                    if (roomCode%2===0){
                        return "background-color:#94E290"
                    }else{
                        return "background-color:#FFCCCC"
                    }
                }
                
            }
            // if(row.OperRoom==="" && row.ScrubNurse==="" && row.CircualNurse==="" && row.SecCirNurse===""){
            //     return "background-color:#CCCCFF";
            // }
            // return "background-color:"+row.StatusColor;
			return "background-color:#eee";
        },
        onClickCell:clickArrangeCell,
        view: groupview,
        groupField: "RoomDesc",
        groupFormatter: function (value, rows) {
            var title=value,nurseStr="";
            var nurseArr=[];
            if(rows.length>0){
                for(var i=0;i<rows.length;i++){
                    var row=rows[i];
                    if(row.FirstScrubNurseDesc && nurseArr.indexOf(row.FirstScrubNurseDesc)<0){
                        nurseArr.push(row.FirstScrubNurseDesc);
                    }
                    if(row.SecScrubNurseDesc && nurseArr.indexOf(row.SecScrubNurseDesc)<0){
                        nurseArr.push(row.SecScrubNurseDesc);
                    }
                    if(row.FirstCirNurseDesc && nurseArr.indexOf(row.FirstCirNurseDesc)<0){
                        nurseArr.push(row.FirstCirNurseDesc);
                    }
                    if(row.SecCirNurseDesc && nurseArr.indexOf(row.SecCirNurseDesc)<0){
                        nurseArr.push(row.SecCirNurseDesc);
                    }
                }
            }
            if(!value){
                title="未排";
            }
            if(nurseArr.length>0){
                nurseStr="("+nurseArr.join(" ")+")";
            }
            return title + nurseStr;
        }
    });

    // 设置表格的可编辑性
    $("#arrangeBox").datagrid("enableCellEditing");
}

/**
 * 初始化排班表单
 */
function initArrangeForm(){
    // 设置默认日期
    $("#operDate").datebox({
        onSelect:selectNewDate
    });
    var today=(new Date()).addDays(operArrangeConfig.qryCondition.operDate),
        todayStr=today.format("yyyy-MM-dd");
    $("#operDate").datebox("setValue",todayStr);
    
    // $("#scrubNurse1,#scrubNurse2,#cirNurse1,#cirNurse2").combogrid({
    //     url: ANCSP.MethodService,
    //     onBeforeLoad: function(param) {
    //         param.ClassName = ANCLS.BLL.OperSchedule;
    //         param.MethodName = "GetOperNurseJSON";
    //         param.Arg1=$("#operDate").datebox("getValue");
    //         param.Arg2 = param.q?param.q:"";
    //         param.Arg3 = session.DeptID;
    //         param.ArgCnt = 3;
    //     },
    //     panelWidth:450,
    //     idField: "RowId",
    //     textField: "Description",
    //     columns:[[
    //         {field:"RowId",title:"ID",hidden:true},
    //         {field:"Description",title:"手术护士",width:100},
    //         {field:"ArrangeInfo",title:"今日已排",width:300}
    //     ]],
    //     rowStyler: function (index, row) {
    //         if(row.AttendanceInfo){
    //             return "background-color:#eee;";
    //         }
            
    //     },
    //     mode: "remote",
    //     onChange:function(newValue,oldValue){
    //         if(newValue){
    //             var id=$(this).attr("id");
    //             arrangeOperListNurse(newValue,id);
    //         }
            
    //     }
    // });

    // $("#preNightShift,#holidayShift,#cirNurseShift,#nightShift,#outAdmShift").combobox({
    //     url: ANCSP.MethodService,
    //     onBeforeLoad: function(param) {
    //         param.ClassName = ANCLS.BLL.OperSchedule;
    //         param.MethodName = "GetOperNurseJSON";
    //         param.Arg1=$("#operDate").datebox("getValue");
    //         param.Arg2 = param.q?param.q:"";
    //         param.Arg3 = session.DeptID;
    //         param.ArgCnt = 3;
    //     },
    //     valueField: "RowId",
    //     textField: "Description",
    //     mode: "remote",
    //     onSelect:function(record){
    //         var elementID=$(this).attr("id");
    //         genArrangeElement(record,elementID);
    //         $(this).combobox("clear");
    //     }
    // });

    $("#operRoom").combobox({
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
            arrangeOperListRoom();
        }
    });


    // 提取手术列表
    $("#btnExtract").linkbutton({
        onClick:extractOperList
    });

    // 提交手术列表
    $("#btnSubmit").linkbutton({
        onClick:submitOperList
    });

    // 保存手术列表
    $("#btnSave").linkbutton({
        onClick:saveOperList
    });

    // 取消手术
    $("#btnRevoke").linkbutton({
        onClick:revokeOperList
    });

    // 查询手术
    $("#btnQuery").linkbutton({
        onClick:findOperList
    });

    // 批量安排手术
    $("#btnArrange").linkbutton({
        onClick:arrangeOperList
    });

    $("#btnDel").linkbutton({
        onClick:cancelOperList
    });

    $("#btnPrint").linkbutton({
        onClick:function(){
            var printDatas = $("#arrangeBox").datagrid("getChecked");
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

    $("#btnAttendance").linkbutton({
        onClick:function(){
            $("#attendanceDialog").dialog("open");
        }
    });

    $("#btnCloseAttendance").linkbutton({
        onClick:function(){
            $("#attendanceDialog").dialog("close");
        }
    });
    
    $("#btnConfirmAttendance").linkbutton({
        onClick:function(){
            $("#attendanceDialog").dialog("close");
            initAttendance();
            $("#arrangeBox").datagrid("reload");
            reloadNurseOptions();
        }
    });
}

function initAttendance(){
    $(".attendance .arrange-container").text("");
    var operDate=$("#operDate").datebox("getValue");
    var attendanceList=dhccl.runServerMethod(ANCLS.BLL.Attendance,"GetAttendanceInfo",operDate,session.DeptID);
    if(attendanceList && attendanceList.length>0){
        operArrange.attendance=attendanceList[0];
        for(var property in operArrange.attendance){
            $("#"+property).text(operArrange.attendance[property]);
        }
    }
}

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
        OperationDate: $("#operDate").datebox("getValue"),
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

/**
 * 提取手术，手术被提取后，科室医生不能修改和取消手术
 */
function extractOperList(){
    var operDate=$("#operDate").datebox("getValue");
    var result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"AcceptOperList",operDate,session.UserID);
    if(result.success){
        $("#arrangeBox").datagrid("reload");
    }else{
        //$.messager.alert("提示","提取手术失败，原因："+result.result,"error");
    }
}

function arrangeOperList(){
    var checkedOperList=$("#arrangeBox").datagrid("getChecked");
    if(checkedOperList && checkedOperList.length>0){
        var opsIdArr=[];
        for(var i=0;i<checkedOperList.length;i++){
            var checkedOper=checkedOperList[i];
            opsIdArr.push(checkedOper.RowId);
        }
        var scrubNurse1=$("#scrubNurse1").combogrid("getValue") || '',
            scrubNurse2=$("#scrubNurse2").combogrid("getValue") || '',
            cirNurse1=$("#cirNurse1").combogrid("getValue") || '',
            cirNurse2=$("#cirNurse2").combogrid("getValue") || '',
            operRoomId=$("#operRoom").combobox("getValue") || '';
        if(!operRoomId){
            $.messager.alert("提示","请先选择手术间，再进行安排！","warning");
            return;
        }
        if(!cirNurse1 && !cirNurse2){
            $.messager.alert("提示","请先选择巡回护士，再进行安排！","warning");
            return;
        }
        var result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"ArrangeOperList",opsIdArr.join("^"),operRoomId,scrubNurse1,scrubNurse2,cirNurse1,cirNurse2);
        if(result.success){
            $("#arrangeBox").datagrid("clearChecked");
            $("#arrangeBox").datagrid("reload");
        }else{
            $.messager.alert("提示","安排手术失败，原因："+result.result,"error");
        }
    }else{
        $.messager.alert("提示","请先选择需要安排的手术，再进行操作！","warning");
    }
}

function arrangeOperListRoom(){
    var checkedOperList=$("#arrangeBox").datagrid("getChecked");
    var checedIndexList=[];
    if(checkedOperList && checkedOperList.length>0){
        var opsIdArr=[];
        var otherStatusOper=false;
        for(var i=0;i<checkedOperList.length;i++){
            var checkedOper=checkedOperList[i];
            var rowIndex=$("#arrangeBox").datagrid("getRowIndex",checkedOper);
            checedIndexList.push(rowIndex);
            if(checkedOper.OperStatusCode!=="Accept" && checkedOper.OperStatusCode!=="Arrange"){
                otherStatusOper=true;
                continue;
            }
            opsIdArr.push(checkedOper.RowId);
        }
        if(otherStatusOper){
            $.messager.alert("提示","勾选的手术中含有未提取的手术，请提取后再操作。","error");
            return;
        }
        operArrange.checkedIndexList=checedIndexList;
        var operRoomId=$("#operRoom").combobox("getValue") || '';
        var result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"ArrangeOperListRoom",opsIdArr.join("^"),operRoomId);
        if(result.success){
            //$("#arrangeBox").datagrid("clearChecked");
            $("#arrangeBox").datagrid("reload");
        }else{
            $.messager.alert("提示","安排手术失败，原因："+result.result,"error");
        }
    }else{
        $.messager.alert("提示","请先选择需要安排的手术，再进行操作！","warning");
    }
}

function arrangeOperListNurse(nurseId,nurseType){
    var checkedOperList=$("#arrangeBox").datagrid("getChecked");
    var checedIndexList=[];
    if(checkedOperList && checkedOperList.length>0){
        var opsIdArr=[];
        var otherStatusOper=false;
        for(var i=0;i<checkedOperList.length;i++){
            var checkedOper=checkedOperList[i];
            var rowIndex=$("#arrangeBox").datagrid("getRowIndex",checkedOper);
            checedIndexList.push(rowIndex);
            if(checkedOper.OperStatusCode!=="Accept" && checkedOper.OperStatusCode!=="Arrange"){
                otherStatusOper=true;
                continue;
            }
            opsIdArr.push(checkedOper.RowId);
        }
        if(otherStatusOper){
            $.messager.alert("提示","勾选的手术中含有未提取的手术，请提取后再操作。","error");
            return;
        }
        operArrange.checkedIndexList=checedIndexList;
        var result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"ArrangeOperListNurse",opsIdArr.join("^"),nurseId,nurseType);
        if(result.success){
            //$("#arrangeBox").datagrid("clearChecked");
            $.ajaxSettings.async=false;
            $("#arrangeBox").datagrid("reload");
            $.ajaxSettings.async=true;
            
        }else{
            $.messager.alert("提示","安排手术失败，原因："+result.result,"error");
        }
    }else{
        $.messager.alert("提示","请先选择需要安排的手术，再进行操作！","warning");
    }
}

/**
 * 提交手术（手术排班信息发布）
 */
function submitOperList()
{
    $.messager.confirm("提示","是否要发布所有手术？",function(r){
        if(r){
            endEditDataBox($("#arrangeBox"));
            var operDate=$("#operDate").datebox("getValue");
            var result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"SubmitOperList",operDate,session.UserID);
            if(result.success){
                $("#arrangeBox").datagrid("reload");
            }else{
                $.messager.alert("提示","发布手术失败，原因："+result.result,"error");
            }
        }
    });
    
}

function saveOperList(){
    endEditDataBox($("#arrangeBox"));
    $("#arrangeBox").datagrid("reload");
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

/**
 * 取消手术
 */
function revokeOperList(){
	var selectionRows=$("#arrangeBox").datagrid("getChecked");
	if(!selectionRows || selectionRows.length<=0)
	{
		$.messager.alert("提示","请先选择需要撤回的手术，再进行操作！","warning");
		return;
	}
    $.messager.confirm("提示","是否撤回所有勾选的手术？",function(r){
        if(r){
			var opsIdArr=[];
            for(var i=0;i<selectionRows.length;i++){
				var row=selectionRows[i];
				opsIdArr.push(row.RowId);
			}
            var result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"RevokeArrange",opsIdArr.join("^"));
            if(result.success){
                $("#arrangeBox").datagrid("reload");
            }else{
                $.messager.alert("提示","撤回手术失败，原因："+result.result,"error");
            }
        }
    });
}

/**
 * 取消手术
 */
function cancelOperList(){
	var selectionRows=$("#arrangeBox").datagrid("getChecked");
	if(!selectionRows || selectionRows.length<=0)
	{
		$.messager.alert("提示","请先选择需要删除的手术，再进行操作！","warning");
		return;
	}
    $.messager.confirm("提示","是否删除所有勾选的手术？",function(r){
        if(r){
			var opsIdArr=[];
            for(var i=0;i<selectionRows.length;i++){
				var row=selectionRows[i];
				opsIdArr.push(row.RowId);
			}
            var result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"CancelArrange",opsIdArr.join("^"));
            if(result.success){
                $("#arrangeBox").datagrid("reload");
            }else{
                $.messager.alert("提示","删除手术失败，原因："+result.result,"error");
            }
        }
    });
}

/**
 * 查询手术列表
 */
function findOperList(){
    $("#arrangeBox").datagrid("reload");
}

/**
 * 手术列表排序
 */
function sortOperList(){

}

function reloadOperList(){

}

function initOperRooms(){
    var operRooms=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindOperRoom",
        Arg1:session.DeptID,
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
            var operDate=$("#operDate").datebox("getValue");
            $("#attendanceDialog").dialog({
                content:"<iframe scrolling='yes' frameborder='0' src='dhcan.dailyattendance.csp?operDate="+operDate+"' style='width:100%;height:100%'></iframe>"
            })
            $("#attendanceDialog").dialog("open");
        }
    });

    $("#btnAttendanceContainer").css("text-align","center");
}

function getOperRoomEditorOptions(){
    return {
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
            operArrange.selectedOperRoom={
                RowId:record.RowId,
                Description:record.Description
            };
            $("#arrangBox").datagrid("acceptChanges");
            $("#arrangBox").datagrid("endEdit",operArrange.editIndex);
        }
    }
}

function getSeqTypeEditorOptions(){
    return {
        valueField:"code",
        textField:"description",
        data:[{
            code:"N",
            description:"正常"
        },{
            code:"C",
            description:"接台"
        }],
        onSelect:function(record){
            operArrange.selectedSeqType={
                Code:record.code,
                Description:record.description
            };
        }
    }
}

// function getScrubNurseEditorOptions(){
//     return {
//         url: ANCSP.DataQuery,
//         onBeforeLoad: function(param) {
//             param.ClassName = CLCLS.BLL.Admission;
//             param.QueryName = "FindCareProvByLoc";
//             param.Arg1 = param.q?param.q:"";
//             param.Arg2 = session.DeptID;
//             param.ArgCnt = 2;
//         },
//         valueField: "RowId",
//         textField: "Description",
//         mode: "remote",
//         onSelect:function(record){
//             var existsNurse=existsCareProv(record.RowId);
//             if(existsNurse && existsNurse.indexOf("S^")===0){
//                 var messageArray=existsNurse.split("^");
//                 var message=messageArray[1];
//                 $.messager.alert("提示",record.Description+"已被安排在"+message,"warning");
//             }
//             operArrange.selectedScrubNurse={
//                 RowId:record.RowId,
//                 Description:record.Description
//             };
//         }
//     }
// }

function getScrubNurseEditorOptions(){
    return {
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.OperScheduleList;
            param.MethodName = "GetOperNurseJSON";
            param.Arg1=$("#operDate").datebox("getValue");
            param.Arg2 = param.q?param.q:"";
            param.Arg3 = session.DeptID;
            param.ArgCnt = 3;
        },
        panelWidth:450,
        idField: "RowId",
        textField: "Description",
        columns:[[
            {field:"RowId",title:"ID",hidden:true},
            {field:"Description",title:"手术护士",width:100},
            {field:"ArrangeInfo",title:"今日已排",width:300}
        ]],
        rowStyler: function (index, row) {
            if(row.AttendanceInfo){
                return "background-color:#eee;";
            }
            
        },
        mode: "remote",
        onSelect:function(rowIndex,record){
            // var existsNurse=existsCareProv(record.RowId);
            // if(existsNurse && existsNurse.indexOf("S^")===0){
            //     var messageArray=existsNurse.split("^");
            //     var message=messageArray[1];
            //     $.messager.alert("提示",record.Description+"已被安排在"+message,"warning");
            // }
            operArrange.selectedScrubNurse={
                RowId:record.RowId,
                Description:record.Description
            };
            $("#arrangBox").datagrid("acceptChanges");
            $("#arrangBox").datagrid("endEdit",operArrange.editIndex);
        },
        view: groupview,
        groupField: "ArrangeFlag",
        groupFormatter: function (value, rows) {
            return value;
        }
    }
}

function getSeqEditorOptions(){
    return {
        min:1,
        max:100
    }
}

function getCircualNurseEditorOptions(){
    return {
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.OperScheduleList;
            param.MethodName = "GetOperNurseJSON";
            param.Arg1=$("#operDate").datebox("getValue");
            param.Arg2 = param.q?param.q:"";
            param.Arg3 = session.DeptID;
            param.ArgCnt = 3;
        },
        panelWidth:450,
        panelHeight:450,
        idField: "RowId",
        textField: "Description",
        columns:[[
            {field:"RowId",title:"ID",hidden:true},
            {field:"Description",title:"手术护士",width:100},
            {field:"ArrangeInfo",title:"今日已排",width:300}
        ]],
        rowStyler: function (index, row) {
            if(row.AttendanceInfo){
                return "background-color:#eee;";
            }
            
        },
        mode: "remote",
        onSelect:function(rowIndex,record){
            // var existsNurse=existsCareProv(record.RowId);
            // if(existsNurse && existsNurse.indexOf("S^")===0){
            //     var messageArray=existsNurse.split("^");
            //     var message=messageArray[1];
            //     $.messager.alert("提示",record.Description+"已被安排在"+message,"warning");
            // }
            operArrange.selectedCirNurse={
                RowId:record.RowId,
                Description:record.Description
            };
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
    if(changes.RoomDesc && operArrange.selectedOperRoom){
        rowData.RoomDesc=operArrange.selectedOperRoom.Description;
        rowData.OperRoom=operArrange.selectedOperRoom.RowId;
        result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"UpdateOperRoom",rowData.RowId,rowData.OperRoom,session.UserID);
    }
    if(changes.FirstScrubNurseDesc || changes.FirstScrubNurseDesc==="" || (changes.hasOwnProperty("FirstScrubNurseDesc") && changes.FirstScrubNurseDesc==undefined)){
        if(changes.FirstScrubNurseDesc==="" || changes.FirstScrubNurseDesc===undefined){
            rowData.FirstScrubNurse="";
        }else{
            if(operArrange.selectedScrubNurse){
                rowData.FirstScrubNurseDesc=operArrange.selectedScrubNurse.Description;
                rowData.FirstScrubNurse=operArrange.selectedScrubNurse.RowId;
            }
        }
        result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"UpdateScrubNurse",rowData.RowId,rowData.FirstScrubNurse,session.UserID);
    }
    if(changes.SecScrubNurseDesc || changes.SecScrubNurseDesc==="" || (changes.hasOwnProperty("SecScrubNurseDesc") && changes.SecScrubNurseDesc==undefined)){
        if(changes.SecScrubNurseDesc==="" || changes.SecScrubNurseDesc==undefined){
            rowData.SecScrubNurse="";
        }else{
            if(operArrange.selectedScrubNurse){
                rowData.SecScrubNurseDesc=operArrange.selectedScrubNurse.Description;
                rowData.SecScrubNurse=operArrange.selectedScrubNurse.RowId;
            }
        }
        result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"UpdateSecScrubNurse",rowData.RowId,rowData.SecScrubNurse,session.UserID);
    }
    if(changes.FirstCirNurseDesc || changes.FirstCirNurseDesc==="" || (changes.hasOwnProperty("FirstCirNurseDesc") && changes.FirstCirNurseDesc==undefined)){
        if(changes.FirstCirNurseDesc===""|| changes.FirstCirNurseDesc===undefined){
            rowData.FirstCirNurse="";
        }else{
            if(operArrange.selectedCirNurse){
                rowData.FirstCirNurseDesc=operArrange.selectedCirNurse.Description;
                rowData.FirstCirNurse=operArrange.selectedCirNurse.RowId;
            }
        }
        result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"UpdateFirstCirNurse",rowData.RowId,rowData.FirstCirNurse,session.UserID);
    }
    if(changes.SecCirNurseDesc || changes.SecCirNurseDesc==="" || (changes.hasOwnProperty("SecCirNurseDesc") && changes.SecCirNurseDesc==undefined)){
        if(changes.SecCirNurse==="" ||  changes.SecCirNurseDesc==undefined){
            rowData.SecCirNurse="";
        }else{
            if(operArrange.selectedCirNurse){
                rowData.SecCirNurseDesc=operArrange.selectedCirNurse.Description;
                rowData.SecCirNurse=operArrange.selectedCirNurse.RowId;
            }
        }
        result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"UpdateSecCirNurse",rowData.RowId,rowData.SecCirNurse,session.UserID);
    }
    if(changes.SeqTypeDesc && operArrange.selectedSeqType){
        rowData.SeqTypeDesc=operArrange.selectedSeqType.Description;
        rowData.SeqType=operArrange.selectedSeqType.Code;
    }
    if(changes.OperSeq){
        rowData.OperSeq=changes.OperSeq;
        result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"UpdateOperSeq",rowData.RowId,rowData.OperSeq);
    }
    if(result && result.success){
        $("#arrangeBox").datagrid("refreshRow",rowIndex);
    }else{
        $.messager.alert("提示","手术排班信息保存失败，原因："+result.result,"error");
    }
    
}

function clickArrangeCell(rowIndex,field,value){
    var rows=$(this).datagrid("getRows");
    var curRow=rows[rowIndex];
    // 手术状态为接收和安排状态的手术，才可以排班。
    // if(curRow.StatusCode!=="Accept" && curRow.StatusCode!=="Arrange"){
    //     $(this).datagrid("cancelEdit",rowIndex);
    // }
    // 先安排手术间，才能再安排其他信息。
    if(field==="OperSeq" || field==="ScrubNurseDesc" || field==="SecScrubNurseDesc" || field==="CircualNurseDesc" || field==="SecCirNurseDesc"){
        if(!curRow.OperRoom || curRow.OperRoom===""){
            $(this).datagrid("cancelEdit",rowIndex);
            $.messager.alert("提示","请先安排手术间，再排其他信息。","warning");
        }
    }
}

function selectNewDate(operDate){
    var operDateStr=operDate.format("yyyy-MM-dd");
    $("#arrangeBox").datagrid("reload");
    //reloadNurseOptions();
    extractOperList();
    // $("#scrubNurse1,#scrubNurse2,#cirNurse1,#cirNurse2").combogrid("reload");
}

function reloadNurseOptions(){
    $("#scrubNurse1,#scrubNurse2,#cirNurse1,#cirNurse2").each(function(index,item){
        var grid=$(this).combogrid("grid");
        grid.datagrid("reload");

    });
}

function existsCareProv(selectedCareProv){
    var result="E^";
    var rowDatas=$("#arrangeBox").datagrid("getData");
    if(rowDatas && rowDatas.rows && rowDatas.rows.length>0){
        for(var i=0;i<rowDatas.rows.length;i++){
            var rowData=rowDatas.rows[i];
            if(rowData.ScrubNurse===selectedCareProv || rowData.CircualNurse===selectedCareProv || rowData.SecCirNurse===selectedCareProv){
                result="S^"+rowData.RoomDesc;
            }
        }
    }
    return result;
}

$(document).ready(initPage);