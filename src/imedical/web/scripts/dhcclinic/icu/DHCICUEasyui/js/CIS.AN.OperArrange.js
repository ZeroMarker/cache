var operListMenu,operRooms,seqList;
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
    roomArrangeList:{},
    editRow:{index:-1,data:null}
};

/**
   * 加载公共数据
   */
  function loadCommonData() {
    var queryPara = [
      {
        ListName: "seqList",
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindDictDataByCode",
        Arg1: "OperSeq",
        ArgCnt: 1,
      }
    ];
    var queryData = dhccl.getDatas(
      ANCSP.DataQueries,
      {
        jsonData: dhccl.formatObjects(queryPara),
      },
      "json"
    );
    if (queryData) {
      for (var key in queryData) {
        seqList = queryData[key];
      }
    }
  }

function initPage(){
	loadCommonData();
    initArrangeForm();
    initArrangeBox();
    // extractOperList();
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
    var columnsConfig=dhccl.runServerMethod("CIS.AN.BL.DataGrid","GetDataColumns",session.ModuleID,"operlistBox",session.GroupID,session.UserID);
    // 设置表格属性
    var columns = [
        [
            { field: "CheckStatus", title: "选择", checkbox: true, width: 40 },
            {
                field: "SourceTypeDesc",
                title: "类型",
                width: 48,
                styler: function(value, row, index) {
                    switch (row.SourceType) {
                        case "B":
                            return "background-color:" + SourceTypeColors.Book + ";";
                        case "E":
                            return "background-color:" + SourceTypeColors.Emergency + ";";
                        default:
                            return "background-color:white;";
                    }
                }
            },
            {
                field: "StatusDesc",
                title: "状态",
                width: 50,
                styler: function(value, row, index) {
                    return "background-color:" + row.StatusColor + ";";
                }
            },
            { field: "SeqTypeDesc", title: "台型", width: 60 },
            { field: "PlanSeq", title: "拟台", width: 48 },
            { field: "ArrOperRoom", title: "术间ID", hidden: true },
            // {field:"RoomDesc",title:"术间",width:100,editor:{type:"combobox",options:roomEditorOptions}},
            { field: "ArrRoomDesc", title: "术间", width: 70, editor: { type: "combobox", options: roomEditorOptions } },
            { field: "OperSeq", title: "台次", width: 48, editor: { type: "combobox", options: seqEditorOptions } },
            { field: "ArrOperTime", title: "时间", width: 70, editor: { type: "timespinner" } },
            {
                field: "AppDeptDesc",
                title: "科室",
                width: 90,
                formatter: function(value, row, index) {
                    return value;
                    if (row.OperStatusCode === "Accept") {
                        return "<span style='color:red'>" + value + "</span>";
                    }
                    return value;
                }
            },
            { field: "SurgeonDesc", title: "术者", width: 60 },
            { field: "PrevDiagnosisDesc", title: "诊断", width: 100 },
            { field: "OperDesc", title: "手术名称", width: 180 },
            { field: "ArrFirstScrubNurse", title: "器械护士1", hidden: true },
            { field: "ArrFirstScrubNurseDesc", title: "器械1", width: 80, editor: { type: "combogrid", options: scrubEditorOptions } },
            { field: "ArrSecScrubNurse", title: "器械护士2", hidden: true },
            { field: "ArrSecScrubNurseDesc", title: "器械2", width: 80, editor: { type: "combogrid", options: scrubEditorOptions } },
            { field: "ArrFirstCirNurse", title: "巡回护士1", hidden: true },
            { field: "ArrFirstCirNurseDesc", title: "巡回1", width: 80, editor: { type: "combogrid", options: circualEditorOptions } },
            { field: "ArrSecCirNurse", title: "巡回护士2", hidden: true },
            { field: "ArrSecCirNurseDesc", title: "巡回2", width: 80, editor: { type: "combogrid", options: circualEditorOptions } },

            {
                field: "PatName",
                title: "姓名",
                width: 76,
                formatter: function(value, row, index) {
                    return value;
                    if (row.OperStatusCode === "Accept") {
                        return "<span style='color:red'>" + value + "</span>";
                    }
                    return value;
                }
            },
            { field: "PatGender", title: "性别", width: 40 },
            { field: "PatAge", title: "年龄", width: 50 },
            { field: "PatBedCode", title: "床号", width: 40 },
            { field: "FirstAsstDesc", title: "一助", width: 60 },
            { field: "PrevAnaMethodDesc", title: "麻醉方法", width: 100, hidden: true },
            { field: "AnesthesiologistDesc", title: "麻醉医生", width: 80, hidden: true },
            {
                field: "AnaAssistantDesc",
                title: "麻醉助手",
                width: 80,
                formatter: function(value, row, index) {
                    if (value) {
                        var valueArr = value.split(",");
                        if (valueArr.length > 0) {
                            return valueArr[0];
                        }
                    }
                    return value;
                },
                hidden: true
            },

            { field: "InfectionOperDesc", title: "感染", width: 48 },
            { field: "OperPositionDesc", title: "体位", width: 76 },
            { field: "AntibiosisDesc", title: "抗生素", width: 62 },
            { field: "SurgicalMaterials", title: "仪器器械", width: 80 },
            { field: "HighConsume", title: "高值耗材", width: 80 },
            { field: "OperNote", title: "备注", width: 120 }

        ]
    ];
    initColumns(columns[0], columnsConfig);

    $("#arrangeBox").datagrid({
        fit: true,
        // nowrap:false,
        title: "手术排班列表",
        headerCls: "panel-header-gray",
        columns: columns,
        toolbar: "#arrangeTools",
        iconCls: "icon-paper",
        rownumber: true,
        pagination: true,
        pageSize: 500,
        pageList: [50, 100, 200, 300, 400, 500],
        checkOnSelect: false,
        selectOnCheck: false,
        url: ANCSP.MethodService,
        queryParams: {
            ClassName: ANCLS.BLL.OperArrange,
            MethodName: "GetArrOperList",
            ArgCnt: 3
        },
        onBeforeLoad: function(param) {
            param.Arg1 = $("#operDate").datebox("getValue");
            param.Arg2 = $("#operDate").datebox("getValue");
            param.Arg3 = session.DeptID;
        },
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length >= 0) {
                var panel = $("#arrangeBox").datagrid("getPanel");
                $(panel).panel("setTitle", "手术排班列表(共" + data.rows.length + "台手术)");
            }
            if (operArrange.checkedIndexList && operArrange.checkedIndexList.length > 0) {
                var checedIndexList = operArrange.checkedIndexList;
                for (var i = 0; i < checedIndexList.length; i++) {
                    var rowIndex = checedIndexList[i];
                    $("#arrangeBox").datagrid("checkRow", rowIndex);
                }
                operArrange.checkedIndexList = null;
            }
            initAttendance();

        },
        onBeginEdit: function(rowIndex, rowData) {
            operArrange.editIndex = rowIndex;
            operArrange.editData = rowData;
			operArrange.editor = $("#arrangeBox").datagrid("getEditor", { index: rowIndex, field: operArrange.editField });
        },
        onAfterEdit: editorAfterEdit,
        // rowStyler: function(index, row) {
        //     if(isNaN(row.RoomCode)===false){
        //         var roomCode=Number(row.RoomCode);
        //         if(roomCode>0){
        //             if (roomCode%2===0){
        //                 return "background-color:#94E290"
        //             }else{
        //                 return "background-color:#FFCCCC"
        //             }
        //         }

        //     }
        //     // if(row.OperRoom==="" && row.ScrubNurse==="" && row.CircualNurse==="" && row.SecCirNurse===""){
        //     //     return "background-color:#CCCCFF";
        //     // }
        //     // return "background-color:"+row.StatusColor;
        // 	return "background-color:#eee";
        // },
        onClickCell: clickArrangeCell,
        view: groupview,
        groupField: "ArrRoomDesc",
        groupFormatter: function(value, rows) {
            var title = value,
                nurseStr = "",
                roomCode = "";
            var nurseArr = [];
            if (rows.length > 0) {
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    //roomCode=row.ArrRoomCode;
                    //roomCode=row.ArrRoomDesc;     //用code会遗留可激活列修改前数据
                    roomCode = row.ArrRoomDesc.replace(/\[|\]|\(|\)|\{|\}/g, "")
                    if (row.ArrFirstScrubNurseDesc && nurseArr.indexOf(row.ArrFirstScrubNurseDesc) < 0) {
                        nurseArr.push(row.ArrFirstScrubNurseDesc);
                    }
                    if (row.ArrSecScrubNurseDesc && nurseArr.indexOf(row.ArrSecScrubNurseDesc) < 0) {
                        nurseArr.push(row.ArrSecScrubNurseDesc);
                    }
                    if (row.ArrFirstCirNurseDesc && nurseArr.indexOf(row.ArrFirstCirNurseDesc) < 0) {
                        nurseArr.push(row.ArrFirstCirNurseDesc);
                    }
                    if (row.ArrSecCirNurseDesc && nurseArr.indexOf(row.ArrSecCirNurseDesc) < 0) {
                        nurseArr.push(row.ArrSecCirNurseDesc);
                    }
                }
            }
            if (!value) {
                title = "未排";
            }
            if (nurseArr.length > 0) {
                nurseStr = "(" + nurseArr.join(" ") + ")";
            }
            if (roomCode) {
                operArrange.roomArrangeList[roomCode] = nurseArr.join("，");
            }

            return title + nurseStr;
        },
        onRowContextMenu: function(e, rowIndex, rowData) {
            e.preventDefault();
            if (!operListMenu) {
                createOperListMenu(rowData);
            }
            operListMenu.menu('show', {
                left: e.pageX,
                top: e.pageY
            });
            var opts = operListMenu.menu("options");
            opts.rowIndex = rowIndex;
            opts.rowData = rowData;
        }
    });

    // 设置表格的可编辑性
    $("#arrangeBox").datagrid("enableCellEditing");

    setOperlistBoxColumnDisplay();
}

/**
 * 初始化排班表单
 */
function initArrangeForm() {
    // 设置默认日期
    dhccl.parseDateFormat();
    $("#operDate").datebox({
        onSelect: selectNewDate
    });
    var today = (new Date()).addDays(operArrangeConfig.qryCondition.operDate);
    if (session.DateFormat == "j/n/Y") var todayStr = today.format("dd/MM/yyyy");
    else var todayStr = today.format("yyyy-MM-dd");
    $("#operDate").datebox("setValue", todayStr);

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
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries,
                param.QueryName = "FindOperRoom",
                param.Arg1 = session.DeptID,
                param.Arg2 = "R",
                param.ArgCnt = 2
        },
        valueField: "RowId",
        textField: "Description",
        onSelect: function(record) {
            arrangeOperListRoom();
        }
    });


    // 提取手术列表
    $("#btnExtract").linkbutton({
        onClick: extractOperList
    });

    // 提交手术列表
    $("#btnSubmit").linkbutton({
        onClick: submitOperList
    });

    // 保存手术列表
    $("#btnSave").linkbutton({
        onClick: saveOperList
    });

    // 取消手术
    $("#btnRevoke").linkbutton({
        onClick: revokeOperList
    });

    // 查询手术
    $("#btnQuery").linkbutton({
        onClick: findOperList
    });

    // 批量安排手术
    $("#btnArrange").linkbutton({
        onClick: arrangeOperList
    });

    $("#btnDel").linkbutton({
        onClick: cancelOperList
    });

    $("#btnPrint").linkbutton({
        onClick: function() {
            var printDatas = $("#arrangeBox").datagrid("getChecked");
            if (printDatas && printDatas.length > 0) {
                // printList(printDatas, "arrange");
                var LODOP = getLodop();
                printListNew(printDatas, "arrange", LODOP);
                LODOP.PREVIEW();
            } else {
                $.messager.alert("提示", "列表无数据可打印", "warning");
            }
        }
    });

    $("#btnAttendance").linkbutton({
        onClick: function() {
            $("#attendanceDialog").dialog("open");
        }
    });

    $("#btnCloseAttendance").linkbutton({
        onClick: function() {
            $("#attendanceDialog").dialog("close");
        }
    });

    $("#btnConfirmAttendance").linkbutton({
        onClick: function() {
            $("#attendanceDialog").dialog("close");
            initAttendance();
            $("#arrangeBox").datagrid("reload");
            reloadNurseOptions();
        }
    });
}

function initAttendance() {
    $(".attendance .arrange-container").text("");
    var operDate = $("#operDate").datebox("getValue");
    var attendanceList = dhccl.runServerMethod(ANCLS.BLL.Attendance, "GetAttendanceInfo", operDate, session.DeptID);
    if (attendanceList && attendanceList.length > 0) {
        operArrange.attendance = attendanceList[0];
        for (var property in operArrange.attendance) {
            $("#" + property).text(operArrange.attendance[property]);
        }
    }

    if (operArrange.roomArrangeList) {
        for (var property in operArrange.roomArrangeList) {
            $("#" + property).text(operArrange.roomArrangeList[property]);
        }
    }
}

function genArrangeElement(record, elementID, emptyContainer) {
    var selector = "#" + elementID + "Container";
    var nurseId = elementID + record.RowId;
    var nurseSelector = "#" + nurseId;
    if (emptyContainer && emptyContainer === true) {
        $(selector).empty();
    }
    if ($(nurseSelector).length > 0) return;
    var html = "<span id='" + nurseId + "' class='oper-nurse oper-nurse-inroom' data-rowid='" + record.RowId + "'>" + record.Description;
    html += "<span class='close'>&times</span></span>"
    $(selector).append(html);
    $(".close").click(function() {
        $(this).parent().remove();
    });
}

function printListNew(printDatas, configCode, LODOP) {
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
    var printSetting = operListConfig.print;
    var hospital = getHospital(); //YuanLin 20191210 医院名称自动获取
    //LODOP.PRINT_INIT(printtitle);
    // LODOP.SET_PRINT_PAGESIZE(printSetting.direction, printSetting.paperSize.width, printSetting.paperSize.height, "");
    LODOP.SET_PRINT_PAGESIZE("2", "", "", "SSS");
    LODOP.ADD_PRINT_TEXT(15, 250, 500, 40, hospital[0].HOSP_Desc);
    LODOP.SET_PRINT_STYLEA(0, "FontName", "宋体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
    LODOP.SET_PRINT_STYLEA(0, "Bold",1);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
    LODOP.ADD_PRINT_TEXT(40, 250, 500, 40, "手术排班表");
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
    LODOP.ADD_PRINT_TEXT(80, 700, "100%", 28, "总计：" + printDatas.length + "台手术");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(80, 900, "100%", 28, "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>"); // 设置页码，pageNO和pageCount是Lodop提供的全局变量。
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    LODOP.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", false);
    LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1);
    var totalWidth = operListConfig.print.paperSize.rect.width;
    var html = "<style>table,td,th {border: 1px solid black;border-style:solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;}</style><table style='" + totalWidth + "pt'><thead><tr>";
    //var totalWidth=0;
    for (var i = 0; i < printConfig.columns.length; i++) {
        var column = printConfig.columns[i];
        //totalWidth+=column.width;
        html += "<th style='width:" + column.width + "pt'>" + column.title + "</th>"; // 使用pt绝对单位，不会造成分辨率变化导致元素显示变动
    }
    html += "</tr></thead><tbody>";
    var curRoom = "",
        preRoom = "";
    for (var i = 0; i < printDatas.length; i++) {
        var printData = printDatas[i];
        curRoom = printData.RoomDesc;
        html += "<tr>";
        for (var j = 0; j < printConfig.columns.length; j++) {
            var column = printConfig.columns[j];
            var printValue = printData[column.field];
            printValue = printValue ? printValue : "";
            if (column.field === "RoomDesc" && curRoom === preRoom) {
                printValue = "";
            }
            html += "<td style='" + (column.style ? column.style : "") + "'>" + printValue + "</td>";
        }
        html += "</tr>";
        preRoom = printData.RoomDesc;
    }
    html += "</tbody></table>";


    LODOP.ADD_PRINT_TABLE(100, 10, totalWidth + "pt", "100%", html); // 高度设置成100%，表示占用剩余整页的高度。

}

function getArrangeConfig() {
    var result = null;
    $.ajaxSettings.async = false;
    $.getJSON("../service/dhcanop/data/operarrange.json?random=" + Math.random(), function(data) {
        result = data;
    }).error(function(message) {
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
function extractOperList() {
    // var operDate=$("#operDate").datebox("getValue");
    // var result=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"AcceptOperList",operDate,session.UserID);
    // if(result.success){
    //      $("#arrangeBox").datagrid("reload");
    // }else{
    //     $.messager.alert("提示","提取手术失败，原因："+result.result,"error");
    // }

    $("#arrangeBox").datagrid("reload");
}

function arrangeOperList() {
    var checkedOperList = $("#arrangeBox").datagrid("getChecked");
    if (checkedOperList && checkedOperList.length > 0) {
        var opsIdArr = [];
        for (var i = 0; i < checkedOperList.length; i++) {
            var checkedOper = checkedOperList[i];
            opsIdArr.push(checkedOper.RowId);
        }
        var scrubNurse1 = $("#scrubNurse1").combogrid("getValue") || '',
            scrubNurse2 = $("#scrubNurse2").combogrid("getValue") || '',
            cirNurse1 = $("#cirNurse1").combogrid("getValue") || '',
            cirNurse2 = $("#cirNurse2").combogrid("getValue") || '',
            operRoomId = $("#operRoom").combobox("getValue") || '';
        if (!operRoomId) {
            $.messager.alert("提示", "请先选择手术间，再进行安排！", "warning");
            return;
        }
        if (!cirNurse1 && !cirNurse2) {
            $.messager.alert("提示", "请先选择巡回护士，再进行安排！", "warning");
            return;
        }
        var result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ArrangeOperList", opsIdArr.join("^"), operRoomId, scrubNurse1, scrubNurse2, cirNurse1, cirNurse2);
        if (result.success) {
            $("#arrangeBox").datagrid("clearChecked");
            $("#arrangeBox").datagrid("reload");
        } else {
            $.messager.alert("提示", "安排手术失败，原因：" + result.result, "error");
        }
    } else {
        $.messager.alert("提示", "请先选择需要安排的手术，再进行操作！", "warning");
    }
}

function arrangeOperListRoom() {
    var checkedOperList = $("#arrangeBox").datagrid("getChecked");
    var checedIndexList = [];
    if (checkedOperList && checkedOperList.length > 0) {
        var opsIdArr = [];
        var otherStatusOper = false;
        for (var i = 0; i < checkedOperList.length; i++) {
            var checkedOper = checkedOperList[i];
            var rowIndex = $("#arrangeBox").datagrid("getRowIndex", checkedOper);
            checedIndexList.push(rowIndex);
            if (checkedOper.OperStatusCode !== "Accept" && checkedOper.OperStatusCode !== "Arrange") {
                otherStatusOper = true;
                continue;
            }
            opsIdArr.push(checkedOper.RowId);
        }
        if (otherStatusOper) {
            $.messager.alert("提示", "勾选的手术中含有未提取的手术，请提取后再操作。", "error");
            return;
        }
        operArrange.checkedIndexList = checedIndexList;
        var operRoomId = $("#operRoom").combobox("getValue") || '';
        var result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ArrangeOperListRoom", opsIdArr.join("^"), operRoomId);
        if (result.success) {
            //$("#arrangeBox").datagrid("clearChecked");
            $("#arrangeBox").datagrid("reload");
        } else {
            $.messager.alert("提示", "安排手术失败，原因：" + result.result, "error");
        }
    } else {
        $.messager.alert("提示", "请先选择需要安排的手术，再进行操作！", "warning");
    }
}

function arrangeOperListNurse(nurseId, nurseType) {
    var checkedOperList = $("#arrangeBox").datagrid("getChecked");
    var checedIndexList = [];
    if (checkedOperList && checkedOperList.length > 0) {
        var opsIdArr = [];
        var otherStatusOper = false;
        for (var i = 0; i < checkedOperList.length; i++) {
            var checkedOper = checkedOperList[i];
            var rowIndex = $("#arrangeBox").datagrid("getRowIndex", checkedOper);
            checedIndexList.push(rowIndex);
            if (checkedOper.OperStatusCode !== "Accept" && checkedOper.OperStatusCode !== "Arrange") {
                otherStatusOper = true;
                continue;
            }
            opsIdArr.push(checkedOper.RowId);
        }
        if (otherStatusOper) {
            $.messager.alert("提示", "勾选的手术中含有未提取的手术，请提取后再操作。", "error");
            return;
        }
        operArrange.checkedIndexList = checedIndexList;
        var result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ArrangeOperListNurse", opsIdArr.join("^"), nurseId, nurseType);
        if (result.success) {
            //$("#arrangeBox").datagrid("clearChecked");
            $.ajaxSettings.async = false;
            $("#arrangeBox").datagrid("reload");
            $.ajaxSettings.async = true;

        } else {
            $.messager.alert("提示", "安排手术失败，原因：" + result.result, "error");
        }
    } else {
        $.messager.alert("提示", "请先选择需要安排的手术，再进行操作！", "warning");
    }
}

/**
 * 提交手术（手术排班信息发布）
 */
function submitOperList() {
    $.messager.confirm("提示", "是否要发布所有手术？", function(r) {
        if (r) {
            endEditDataBox($("#arrangeBox"));
            var operDate = $("#operDate").datebox("getValue");
            var result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "SubmitOperList", operDate, session.UserID);
            if (result.success) {
                $("#arrangeBox").datagrid("reload");
            } else {
                $.messager.alert("提示", "发布手术失败，原因：" + result.result, "error");
            }
        }
    });

}

function saveOperList() {
    endEditDataBox($("#arrangeBox"));
    operArrange.roomArrangeList = {}; //重新加载右侧科室人员排班信息
    $("#arrangeBox").datagrid("reload");
    var sendOperArrangeInfo = dhccl.runServerMethodNormal(ANCLS.BLL.DataConfiguration, "GetValueByKey", "SendOperArrangeInfo");
    if (sendOperArrangeInfo != "Y") { //发布手术排班信息配置为"否"时自动发布排班信息 YL 20200616
        var operDate = $("#operDate").datebox("getValue");
        var result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "SubmitOperList", operDate, session.UserID);
        if (result.success) {
            $("#arrangeBox").datagrid("reload");
        } else {
            $.messager.alert("提示", "发布手术失败，原因：" + result.result, "error");
        }
    }
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
function revokeOperList() {
    var selectionRows = $("#arrangeBox").datagrid("getChecked");
    if (!selectionRows || selectionRows.length <= 0) {
        $.messager.alert("提示", "请先选择需要撤回的手术，再进行操作！", "warning");
        return;
    }
    $.messager.confirm("提示", "是否撤回所有勾选的手术？", function(r) {
        if (r) {
            var operRows = "";
            var opsIdArr = [];
            for (var i = 0; i < selectionRows.length; i++) {
                var row = selectionRows[i];
                if ((row.StatusDesc !== "安排") && (row.StatusDesc !== "接收")) {
                    if (operRows == "") operRows = i + 1;
                    else operRows = operRows + "," + (i + 1);
                    continue;
                }
                opsIdArr.push(row.RowId);
            }
            var result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "RevokeArrange", opsIdArr.join("^"), session.UserID);
            if (result.success) {
                if (operRows == "") $.messager.alert("提示", "撤回手术成功", "info");
                if (operRows != "") {
                    $.messager.alert("提示", "其余手术撤回成功", "info");
                    $.messager.alert("提示", "其中所勾选手术中第" + operRows + "条手术非安排或接收状态不予撤回!", "warning");
                }
                $("#arrangeBox").datagrid("reload");
            } else {
                if (operRows != "") $.messager.alert("提示", "所勾选手术中第" + operRows + "条手术非安排或接收状态不予撤回!", "warning");
                else { $.messager.alert("提示", "撤回手术失败，原因：" + result.result, "error"); }
            }
        }
    });
}

/**
 * 取消手术
 */
function cancelOperList() {
    var selectionRows = $("#arrangeBox").datagrid("getChecked");
    if (!selectionRows || selectionRows.length <= 0) {
        $.messager.alert("提示", "请先选择需要删除的手术，再进行操作！", "warning");
        return;
    }
    $.messager.confirm("提示", "是否删除所有勾选的手术？", function(r) {
        if (r) {
            var opsIdArr = [];
            for (var i = 0; i < selectionRows.length; i++) {
                var row = selectionRows[i];
                opsIdArr.push(row.RowId);
            }
            var result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "CancelArrange", opsIdArr.join("^"));
            if (result.success) {
                $("#arrangeBox").datagrid("reload");
            } else {
                $.messager.alert("提示", "删除手术失败，原因：" + result.result, "error");
            }
        }
    });
}

/**
 * 查询手术列表
 */
function findOperList() {
    $("#arrangeBox").datagrid("reload");
}

/**
 * 手术列表排序
 */
function sortOperList() {

}

function reloadOperList() {

}

function initOperRooms() {
    operRooms = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindOperRoom",
        Arg1: session.DeptID,
        Arg2: "R",
        ArgCnt: 2
    }, "json");
    operArrange.operRooms = operRooms;
}

function initCrewShift() {
    var crewShiftList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindCrewShift",
        Arg1: session.DeptID,
        Arg2: "Y",
        ArgCnt: 2
    }, "json");
    operArrange.crewShiftList = crewShiftList;
}

function initRoomArrangeInfo() {
    $(".attendance").empty();
    var htmlArr = ["<form style='margin:0'>"];
    var crewShiftList = operArrange.crewShiftList;
    if (crewShiftList && crewShiftList.length > 0) {
        var shiftGroupList = dhccl.group(crewShiftList, "FloorDesc");
        for (var i = 0; i < shiftGroupList.length; i++) {
            var crewShiftGroup = shiftGroupList[i];
            if (i === 0) {
                htmlArr.push("<div class='form-row-group' style='padding-bottom:0'><span class='form-btn' style=\"padding-left:3px;\"><a href='#' id='btnAttendance'>科室考勤</a></span></div>");
            }
            htmlArr.push("<div class='form-row-group' style='padding-bottom:0'><div class='form-row-grouptitle'>" + crewShiftGroup.id + "</div><div class='form-rows'>");

            for (var j = 0; j < crewShiftGroup.data.length; j++) {
                var crewShift = crewShiftGroup.data[j];
                htmlArr.push("<div><div class='form-row'><div class='form-title-right45'>" + crewShift.StatusDesc + "</div>");
                htmlArr.push("<div class='form-item-normal'><span id=" + crewShift.RowId + " class='arrange-container'></span></div></div></div>");
            }
            // if(i==shiftGroupList.length-1){
            //     htmlArr.push("<div><div class='form-row'><div id='btnAttendanceContainer' style='text-align:center'><a href='#' id='btnAttendance'>科室考勤</a></div></div></div>");
            // }
            htmlArr.push("</div></div>");
        }


    }
    var operRooms = operArrange.operRooms;
    if (operRooms && operRooms.length > 0) {
        htmlArr.push("<div class='form-row-group' style='padding-bottom:0'><div class='form-row-grouptitle'>术间排班汇总</div><div class='form-rows'>");
        for (var i = 0; i < operRooms.length; i++) {
            var operRoom = operRooms[i];
            htmlArr.push("<div><div class='form-row'><div class='form-title-right45'>" + operRoom.Description + "</div>");
            htmlArr.push("<div class='form-item-normal'><span id=" + operRoom.Description.replace(/\[|\]|\(|\)|\{|\}/g, "") + " class='arrange-container'></span></div></div></div>");
        }
        htmlArr.push("</div></div>");
    }
    htmlArr.push("</form>")

    $(".attendance").append(htmlArr.join(""));
    $("#btnAttendance").linkbutton({
        iconCls: "icon-cal-pen",
        plain: true,
        onClick: function() {
            var operDate = $("#operDate").datebox("getValue");
            $("#attendanceDialog").dialog({
                content: "<iframe scrolling='yes' frameborder='0' src='CIS.AN.DailyAttendance.csp?operDate=" + operDate + "' style='width:100%;height:100%'></iframe>"
            })
            $("#attendanceDialog").dialog("open");
        }
    });

    $("#attendanceDialog").dialog({
        onClose: function() {
            initAttendance();
        }
    });

    $("#btnAttendanceContainer").css("text-align", "center");
}

function getOperRoomEditorOptions() {
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries,
                param.QueryName = "FindOperRoom",
                param.Arg1 = session.DeptID,
                param.Arg2 = "R",
                param.ArgCnt = 2
        },
        valueField: "RowId",
        textField: "Description",
        panelWidth: 100,
        onSelect: function(record) {
            operArrange.selectedOperRoom = {
                RowId: record.RowId,
                Description: record.Description
            };
            $("#arrangBox").datagrid("acceptChanges");
            $("#arrangBox").datagrid("endEdit", operArrange.editIndex);
        }
    }
}

function getSeqTypeEditorOptions() {
    return {
        valueField: "code",
        textField: "description",
        data: [{
            code: "N",
            description: "正常"
        }, {
            code: "C",
            description: "接台"
        }],
        onSelect: function(record) {
            operArrange.selectedSeqType = {
                Code: record.code,
                Description: record.description
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

function getScrubNurseEditorOptions() {
    return {
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.OperScheduleList;
            param.MethodName = "GetOperNurseJSON";
            param.Arg1 = $("#operDate").datebox("getValue");
            param.Arg2 = param.q ? param.q : "";
            param.Arg3 = session.DeptID;
            param.ArgCnt = 3;
        },
        panelWidth: 450,
        panelHeight: 450,
        idField: "RowId",
        textField: "Description",
        columns: [
            [
                { field: "RowId", title: "ID", hidden: true },
                { field: "Description", title: "手术护士", width: 100 },
                { field: "ArrangeInfo", title: "今日已排", width: 300 }
            ]
        ],
        rowStyler: function(index, row) {
            if (row.AttendanceInfo) {
                return "background-color:#eee;";
            }

        },
        mode: "remote",
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length === 1) {
                $(this).combogrid("setValue", data.rows[0].RowId);
            }
        },
        onSelect: function(rowIndex, record) {
            // var existsNurse=existsCareProv(record.RowId);
            // if(existsNurse && existsNurse.indexOf("S^")===0){
            //     var messageArray=existsNurse.split("^");
            //     var message=messageArray[1];
            //     $.messager.alert("提示",record.Description+"已被安排在"+message,"warning");
            // }
            operArrange.selectedScrubNurse = {
                RowId: record.RowId,
                Description: record.Description
            };
            $("#arrangBox").datagrid("acceptChanges");
            $("#arrangBox").datagrid("endEdit", operArrange.editIndex);
        },
        view: groupview,
        groupField: "ArrangeFlag",
        groupFormatter: function(value, rows) {
            return value;
        }
    }
}

function getSeqEditorOptions() {
    return {
        valueField: "value",
        textField: "text",
        data: CommonArray.OperSeqList,
        editable: false,
        onSelect: function(record) {
            var operDate = operArrange.editData.OperDate;
            var operSeq = record.value;
            var operRoom = operArrange.selectedOperRoom.RowId;
            var RoomDesc = operArrange.selectedOperRoom.Description;
            if(operRoom == ""){
				var operRoom = operArrange.editData.OperRoom;
			}
			if(RoomDesc == ""){
			var RoomDesc = operArrange.editData.RoomDesc;
			}
            if (operRoom && operDate && operSeq) {
                var existsOperSeq = dhccl.runServerMethodNormal(ANCLS.BLL.OperArrange, "ExistsOperSeq", operDate, operRoom, operSeq);
                if (existsOperSeq === "Y") {
                    $.messager.alert("提示", "手术台次重复", "warning");
                }
            }
        }
    }
}

function getCircualNurseEditorOptions() {
    return {
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.OperScheduleList;
            param.MethodName = "GetOperNurseJSON";
            param.Arg1 = $("#operDate").datebox("getValue");
            param.Arg2 = param.q ? param.q : "";
            param.Arg3 = session.DeptID;
            param.ArgCnt = 3;
        },
        panelWidth: 450,
        panelHeight: 450,
        idField: "RowId",
        textField: "Description",
        columns: [
            [
                { field: "RowId", title: "ID", hidden: true },
                { field: "Description", title: "手术护士", width: 100 },
                { field: "ArrangeInfo", title: "今日已排", width: 300 }
            ]
        ],
        rowStyler: function(index, row) {
            if (row.AttendanceInfo) {
                return "background-color:#eee;";
            }

        },
        mode: "remote",
        onSelect: function(rowIndex, record) {
            // var existsNurse=existsCareProv(record.RowId);
            // if(existsNurse && existsNurse.indexOf("S^")===0){
            //     var messageArray=existsNurse.split("^");
            //     var message=messageArray[1];
            //     $.messager.alert("提示",record.Description+"已被安排在"+message,"warning");
            // }
            operArrange.selectedCirNurse = {
                RowId: record.RowId,
                Description: record.Description
            };
        },
        view: groupview,
        groupField: "ArrangeFlag",
        groupFormatter: function(value, rows) {
            return value;
        }
    }
}

function editorAfterEdit(rowIndex, rowData, changes) {
    var result = null;
    if (changes.ArrRoomDesc && operArrange.selectedOperRoom) {
        rowData.ArrRoomDesc = operArrange.selectedOperRoom.Description;
        rowData.ArrOperRoom = operArrange.selectedOperRoom.RowId;
        result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "UpdateOperRoom", rowData.RowId, rowData.ArrOperRoom, session.UserID);
        //$("#arrangeBox").datagrid("reload");
    }
    if (changes.ArrFirstScrubNurseDesc || changes.ArrFirstScrubNurseDesc === "" || (changes.hasOwnProperty("ArrFirstScrubNurseDesc") && changes.ArrFirstScrubNurseDesc == undefined)) {
        if (changes.ArrFirstScrubNurseDesc === "" || changes.ArrFirstScrubNurseDesc === undefined) {
            rowData.ArrFirstScrubNurse = "";
        } else {
            if (operArrange.selectedScrubNurse) {
                rowData.ArrFirstScrubNurseDesc = operArrange.selectedScrubNurse.Description;
                rowData.ArrFirstScrubNurse = operArrange.selectedScrubNurse.RowId;
            }
        }
        result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "UpdateScrubNurse", rowData.RowId, rowData.ArrFirstScrubNurse, session.UserID);
        $("#arrangeBox").datagrid("reload");
    }
    if (changes.ArrSecScrubNurseDesc || changes.ArrSecScrubNurseDesc === "" || (changes.hasOwnProperty("ArrSecScrubNurseDesc") && changes.ArrSecScrubNurseDesc == undefined)) {
        if (changes.ArrSecScrubNurseDesc === "" || changes.ArrSecScrubNurseDesc == undefined) {
            rowData.ArrSecScrubNurse = "";
        } else {
            if (operArrange.selectedScrubNurse) {
                rowData.ArrSecScrubNurseDesc = operArrange.selectedScrubNurse.Description;
                rowData.ArrSecScrubNurse = operArrange.selectedScrubNurse.RowId;
            }
        }
        result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "UpdateSecScrubNurse", rowData.RowId, rowData.ArrSecScrubNurse, session.UserID);
        $("#arrangeBox").datagrid("reload");
    }
    if (changes.ArrFirstCirNurseDesc || changes.ArrFirstCirNurseDesc === "" || (changes.hasOwnProperty("ArrFirstCirNurseDesc") && changes.ArrFirstCirNurseDesc == undefined)) {
        if (changes.ArrFirstCirNurseDesc === "" || changes.ArrFirstCirNurseDesc === undefined) {
            rowData.ArrFirstCirNurse = "";
        } else {
            if (operArrange.selectedCirNurse) {
                rowData.ArrFirstCirNurseDesc = operArrange.selectedCirNurse.Description;
                rowData.ArrFirstCirNurse = operArrange.selectedCirNurse.RowId;
            }
        }
        result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "UpdateFirstCirNurse", rowData.RowId, rowData.ArrFirstCirNurse, session.UserID);
        $("#arrangeBox").datagrid("reload");
    }
    if (changes.ArrSecCirNurseDesc || changes.ArrSecCirNurseDesc === "" || (changes.hasOwnProperty("ArrSecCirNurseDesc") && changes.ArrSecCirNurseDesc == undefined)) {
        if (changes.ArrSecCirNurseDesc === "" || changes.ArrSecCirNurseDesc == undefined) {
            rowData.ArrSecCirNurse = "";
        } else {
            if (operArrange.selectedCirNurse) {
                rowData.ArrSecCirNurseDesc = operArrange.selectedCirNurse.Description;
                rowData.ArrSecCirNurse = operArrange.selectedCirNurse.RowId;
            }
        }
        result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "UpdateSecCirNurse", rowData.RowId, rowData.ArrSecCirNurse, session.UserID);
        $("#arrangeBox").datagrid("reload");
    }
    if (changes.SeqTypeDesc && operArrange.selectedSeqType) {
        rowData.SeqTypeDesc = operArrange.selectedSeqType.Description;
        rowData.SeqType = operArrange.selectedSeqType.Code;
    }
    if (changes.OperSeq) {
        rowData.ArrOperSeq = changes.OperSeq;
        var existOperSeq = dhccl.runServerMethodNormal(ANCLS.BLL.OperArrange, "ExistsOperSeq", rowData.OperDate, rowData.ArrOperRoom, rowData.OperSeq);
        if (existOperSeq === "Y") {
            $.messager.alert("提示", "手术台次重复", "warning");
            $("#arrangeBox").datagrid("reload");
            return;
        }
        result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "UpdateOperSeq", rowData.RowId, rowData.ArrOperSeq);
    }
    if (changes.ArrOperTime) {
        rowData.ArrOperTime = changes.ArrOperTime;
        result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "UpdateOperTime", rowData.RowId, rowData.ArrOperTime);
    }
    if (result) {
        if (result.success) {
            $("#arrangeBox").datagrid("refreshRow", rowIndex);
        } else {
            $.messager.alert("提示", "手术排班信息保存失败，原因：" + result.result, "error");
        }
    }

}

function clickArrangeCell(rowIndex, field, value) {
    operArrange.editField = field;
    var rows = $(this).datagrid("getRows");
    var curRow = rows[rowIndex];
	if (curRow.VisitStatus==="D") {
		$(this).datagrid("cancelEdit", rowIndex);
		$.messager.alert("提示","该患者已出院不能安排手术","info");
		return;
	}
	if (curRow.VisitStatus==="C") {
		$(this).datagrid("cancelEdit", rowIndex);
		$.messager.alert("提示","该患者已退号不能安排手术","info");
		return;
	}
    // var AuditOperations=dhccl.getDatas(ANCSP.DataQuery,{
    //     ClassName:ANCLS.BLL.ConfigQueries,
    //     QueryName:"FindDataConfigurations",
    //     Arg1:"",
    //     ArgCnt:1
    // },"json");
    // if((AuditOperations[8].DataKey=="NeedAuditOperation")&(AuditOperations[8].DataValue=="Y")){
    // 	if(curRow.StatusCode!=="Accept" && curRow.StatusCode!=="Arrange"){
    //         $(this).datagrid("cancelEdit",rowIndex);
    // 		$.messager.alert("提示","手术申请配置为需要审核的，需先审核才可排班","warning");
    // 		return;
    // 	}
    // }
    // 先安排手术间，才能再安排其他信息。
    if (curRow.StatusCode !== "Receive" && curRow.StatusCode !== "Arrange" && curRow.StatusCode !== "Application" && curRow.StatusCode !== "Audit") {
        $(this).datagrid("cancelEdit", rowIndex);
        $.messager.alert("提示", "手术状态为接收或安排状态才可以排班。", "warning");
        return;
    }
    if (field === "ArrOperSeq" || field === "ArrFirstScrubNurseDesc" || field === "ArrSecScrubNurseDesc" || field === "ArrFirstCirNurseDesc" || field === "ArrSecCirNurseDesc" || field === "OperSeq") {
        if (!curRow.ArrRoomDesc || curRow.ArrRoomDesc === "") {
            $(this).datagrid("cancelEdit", rowIndex);
            $.messager.alert("提示", "请先安排手术间，再排其他信息。", "warning");
        }

    }
    if (field === "ArrRoomDesc") {
        if (curRow.StatusCode !== "Application" && curRow.StatusCode !== "Audit" && curRow.StatusCode !== "Receive" && curRow.StatusCode !== "Arrange") {
            $(this).datagrid("cancelEdit", rowIndex);
        }
    }
}

function selectNewDate(operDate) {
    var operDateStr = operDate.format("yyyy-MM-dd");
	operArrange.roomArrangeList = {}; //重新加载右侧科室人员排班信息
    $("#arrangeBox").datagrid("reload");
    // var today=(new Date()).addDays(operArrangeConfig.qryCondition.operDate),
    //     todayStr=today.format("yyyy-MM-dd");
    // if(operDateStr===todayStr){
    //     extractOperList();  //只有选择日期为下一工作日时默认自动提取手术 YuanLin 20200119
    // }
    //reloadNurseOptions();
    // $("#scrubNurse1,#scrubNurse2,#cirNurse1,#cirNurse2").combogrid("reload");
}

function reloadNurseOptions() {
    $("#scrubNurse1,#scrubNurse2,#cirNurse1,#cirNurse2").each(function(index, item) {
        var grid = $(this).combogrid("grid");
        grid.datagrid("reload");

    });
}

function existsCareProv(selectedCareProv) {
    var result = "E^";
    var rowDatas = $("#arrangeBox").datagrid("getData");
    if (rowDatas && rowDatas.rows && rowDatas.rows.length > 0) {
        for (var i = 0; i < rowDatas.rows.length; i++) {
            var rowData = rowDatas.rows[i];
            if (rowData.ScrubNurse === selectedCareProv || rowData.CircualNurse === selectedCareProv || rowData.SecCirNurse === selectedCareProv) {
                result = "S^" + rowData.RoomDesc;
            }
        }
    }
    return result;
}

function getHospital() {
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

function setOperlistBoxColumnDisplay() {
    var testIcon = dhccl.runServerMethod("CIS.AN.BL.OperScheduleList", "GetOperConfig", "OperListEdit");
    if (testIcon.result == "Y") {
        $("#arrangeBox").datagrid("enableGridSetting", {
            clickHandler: function(columnOptList) {
                var columnEditor = new DataGridEditor({
                    title: "手术排班列表",
                    data: columnOptList,
                    moduleId: session.ModuleID,
                    elementId: "operlistBox",
                    closeCallBack: function() {
                        window.location.reload();
                    }
                });
                columnEditor.open();
            }
        });
    }
}

function reloadDatagrid() {
    $("#arrangeBox").datagrid('reload');
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

function createOperListMenu(rowData) {
    operListMenu = $("<div id='operListMenu'></div>").appendTo("body");
    operListMenu.menu({

    });

    // 手术间菜单分为1~5,6~10,11~15,16~20,21~25
    var operRoomItems = [];
    if (operRooms && operRooms.length > 0) {
        var itemRoomCount = 5;
        for (var i = 0; i < operRooms.length; i++) {
            if (i % itemRoomCount === 0) {
                var itemText = (operRoomItems.length * itemRoomCount + 1) + "~" + (operRoomItems.length * itemRoomCount + itemRoomCount);
                operRoomItems.push({
                    text: itemText,
                    items: []
                });
            }
            if (operRoomItems.length > 0) {
                var lastRoomItem = operRoomItems[operRoomItems.length - 1];
                var operRoom = operRooms[i];
                lastRoomItem.items.push({
                    id: operRoom.RowId,
                    text: operRoom.Description,
                    dataItem: operRoom
                });
            }
        }
    }
    operListMenu.menu("appendItem", {
        text: "安排手术间",
        name: "ArrangeOperRoom"
    });
    var arrangeOperRoomItem = operListMenu.menu("findItem", "安排手术间");
    if (operRoomItems && operRoomItems.length > 0 && arrangeOperRoomItem) {
        for (var i = 0; i < operRoomItems.length; i++) {
            var roomItem = operRoomItems[i];
            operListMenu.menu("appendItem", {
                text: roomItem.text,
                parent: arrangeOperRoomItem.target
            });
            var roomItemMenu = operListMenu.menu("findItem", roomItem.text);
            if (roomItemMenu && roomItem.items && roomItem.items.length > 0) {
                for (var j = 0; j < roomItem.items.length; j++) {
                    var roomDetailItem = roomItem.items[j];
                    operListMenu.menu("appendItem", {
                        id: roomDetailItem.id,
                        text: roomDetailItem.text,
                        dataItem: roomDetailItem.dataItem,
                        parent: roomItemMenu.target,
                        onclick: arrangeOperRoom
                    });
                }
            }
        }
    }

    operListMenu.menu("appendItem", {
        text: "巡回与器械互换",
        name: "Exchange",
        onclick: exchange
    });

}

function arrangeOperRoom(menuItem) {
    var menuItem = $("#operListMenu").menu("getItem", this);
    var roomId = menuItem.id;
    var opts = $("#operListMenu").menu("options");
    var checkedOperList = $("#arrangeBox").datagrid("getChecked");
    if (opts.rowData && roomId) {
        if (checkedOperList && checkedOperList.length > 0) {
            for (var i = 0; i < checkedOperList.length; i++) {
                var checkedOper = checkedOperList[i];
                var operRows = i + 1;
                if (checkedOper.StatusCode === "Receive" || checkedOper.StatusCode === "Arrange" || checkedOper.StatusCode === "Application" || checkedOper.StatusCode === "Audit") {
                    var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ChangeOperRoom", opts.rowData.OperDate, checkedOper.RowId, roomId);
                    if (ret.success) {
                        //$("#arrangeBox").datagrid("reload");
                    } else {
                        $.messager.alert("提示", ret.result, "error");
                    }
                } else {
                    $.messager.alert("提示", "所选第" + operRows + "条手术当前状态无权限。", "warning");
                }
            }
            $("#arrangeBox").datagrid("reload");
        } else {
            if (opts.rowData.StatusCode === "Receive" || opts.rowData.StatusCode === "Arrange" || opts.rowData.StatusCode === "Application" || opts.rowData.StatusCode === "Audit") {
                var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ChangeOperRoom", opts.rowData.OperDate, opts.rowData.RowId, roomId);
                if (ret.success) {
                    $("#arrangeBox").datagrid("reload");
                } else {
                    $.messager.alert("提示", ret.result, "error");
                }
            } else {
                $.messager.alert("提示", "当前安全组或当前状态无权限。", "warning");
            }
        }
    }
}

function exchange() {
    var opts = $("#operListMenu").menu("options");
    if (opts.rowData) {
        if (opts.rowData.StatusCode === "Receive" || opts.rowData.StatusCode === "Arrange" || opts.rowData.StatusCode === "Application" || opts.rowData.StatusCode === "Audit") {
            var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ExchangeNurseArrange", opts.rowData.RowId, opts.rowData.ArrFirstScrubNurse, opts.rowData.ArrSecScrubNurse, opts.rowData.ArrFirstCirNurse, opts.rowData.ArrSecCirNurse);
            if (ret.success) {
                $("#arrangeBox").datagrid("reload");
            }
        } else {
            $.messager.alert("提示", "当前安全组或当前状态无权限。", "warning");
        }
    }
}

var action = {
    declineOperation: function() {

    }
}

$(document).ready(initPage);