var anaestConsent = {
    operSchedule: null
};
var operApplication=null
$(document).ready(function() {
    initPage();
    operDataManager.setCheckChange();
    operDataManager.initFormData(loadApplicationData);
    SignTool.loadSignature();
});

/**
 * 调用所有页面元素初始化函数
 */
function initPage() {
    initDelegates();
}

/**
 * 初始化所有按钮单击事件
 */
function initDelegates() {
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
        }
    });

    $("#btnPrint").linkbutton({
        onClick: print
    });

    $("#btnPrintView").linkbutton({
        onClick: printView
    });

    $("#btnPatSignComplication,#btnPatSignPCA,#btnPatSignAnaest").linkbutton({
        onClick: function() {
            var signCode = $(this).attr("data-signcode");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode
            });
            signView.initView();
            signView.open();
        }
    });
    var columns=[[
        /*
        {field:"DiagID",title:"<span class='required-color'>*</span>时间",width:80,editor:{type:"combogrid",options:""},formatter:function(value,row,index){
            return row.DiagDesc;
        }},*/
        {field:"StartTime",title:"时间",width:70,editor:{type:"validatebox"}},
        {field:"HR",title:"心率次/分",width:70,editor:{type:"validatebox"}},
        {field:"Resp",title:"呼吸次/分",width:70,editor:{type:"validatebox"}},
        {field:"NBP",title:"无创血压mmhg",width:100,editor:{type:"validatebox"}},
        {field:"ABP",title:"有创血压mmhg",width:100,editor:{type:"validatebox"}},
        {field:"SPO2",title:"血氧饱和度%",width:100,editor:{type:"validatebox"}},
        {field:"Medication",title:"术中用药",width:300,editor:{type:"combogrid",options:getMedicationOptions("Medication")}},
        {field:"Illness",title:"病情观察",width:300,editor:{type:"combogrid",options:getMedicationOptions("Illness")}},
        {field:"UpdateUser",title:"护士签名",width:80,hidden:true,editor:{type:""}},
        {field:"RowId",title:"RowId",width:70,hidden:true,editor:{type:"validatebox"}},
    ]];

    

    $("#operDrugCollectData").datagrid({
        width: 1200,
        height: 500,
        singleSelect: true,
        rownumbers: true,
        columns:columns,
        toolbar:"<div style='padding:3px 0'><a href='#' id='btnAddDrugCollectData'>新增</a><a href='#' id='btnDelCollectData'>删除</a><a href='#' id='btnSaveDrugCollectData'>保存</a><a href='#' id='btnSynDrugCollectData'>同步</a></div>",
        headerCls:"panel-header-gray",
        bodyCls:"panel-header-gray",
        onBeforeEdit:function(rowIndex,rowData){
        },
        onAfterEdit:function(rowIndex,rowData,changes){
        },
        onClickRow:function(rowIndex,rowData){
            var DataRows=$("#operDrugCollectData").datagrid("getRows");
            if(DataRows && DataRows.length>0){
                for(var i=0;i<DataRows.length;i++){
                    $("#operDrugCollectData").datagrid("endEdit",i);
                    if(i==rowIndex)
                    {
                        $(this).datagrid("beginEdit",rowIndex);
                    }
                }
            }
            
            
        },
    });

    $("#btnAddDrugCollectData").linkbutton({
        iconCls:"icon-add",
        plain:true,
        onClick:function(){
            
            var rows=$("#operDrugCollectData").datagrid("getRows");
            for(var i=0;i<rows.length;i++){
                $("#operDrugCollectData").datagrid("endEdit",i);
            }

            $("#operDrugCollectData").datagrid("appendRow",{
                StartTime:"",
                HR:"",
                Resp:"",
                NBP:"",
                ABP:"",
                SPO2:"",
                Medication:"",
                Illness:"",
                UpdateUser:"",
                RowId:""
            });
            var rows=$("#operDrugCollectData").datagrid("getRows");
        }
    });

    $("#btnDelCollectData").linkbutton({
        iconCls:"icon-remove",
        plain:true,
        onClick:function(){
            var selectedRow=$("#operDrugCollectData").datagrid("getSelected");
            if(!selectedRow){
                $.messager.alert("提示","请先选择需要删除的行，再操作。","warning");
            }else{
                $.messager.confirm("提示","是否删除选择的行？",function(r){
                    if(r){
                        var rowIndex=$("#operDrugCollectData").datagrid("getRowIndex",selectedRow);
                        $("#operDrugCollectData").datagrid("deleteRow",rowIndex);
                        if(selectedRow.RowId!=="")
                        {
                            var deleresult = dhccl.runServerMethod("CIS.AN.BL.OperCareData", "DelCareData",selectedRow.RowId);
                        }
                    }
                })
                
            }
        }
    });
    
    $("#btnSaveDrugCollectData").linkbutton({
        iconCls:"icon-save",
        plain:true,
        onClick:function(){
            var SaveDataList=[];
            var DataRows=$("#operDrugCollectData").datagrid("getRows");
            if(DataRows && DataRows.length>0){
                for(var i=0;i<DataRows.length;i++){
                    $("#operDrugCollectData").datagrid("endEdit",i);
                    var DataRow=DataRows[i];
                    if (DataRow.StartTime=="") continue;
                    var SaveData={
                        RecordSheet:session.RecordSheetID,
                        StartTime:DataRow.StartTime,
                        HR:DataRow.HR,
                        Resp:DataRow.Resp,
                        NBP:DataRow.NBP,
                        ABP:DataRow.NBP,
                        SPO2:DataRow.SPO2,
                        Medication:DataRow.Medication,
                        Illness:DataRow.Illness,
                        UpdateUser:DataRow.UpdateUser,
                        RowId:DataRow.RowId,
                        EditFlag : "N",
                        ClassName:"CIS.AN.OperCareData"
                    }
                    SaveDataList.push(SaveData);
                    //formatArr.push(diagRow.DiagID+propSplitChar+diagRow.DiagDesc+propSplitChar+(diagRow.DiagNote || ''));
                }
                var operCareRecordData = dhccl.formatObjects(SaveDataList);
	            var saveSign = dhccl.runServerMethod("CIS.AN.BL.OperCareData", "SaveCareData",operCareRecordData);
                if(saveSign.result)
                {
                    $.messager.alert("提示","保存成功","success");
                }
            }
        }
    });

    $("#btnSynDrugCollectData").linkbutton({
        iconCls:"icon-refresh",
        plain:true,
        onClick:function(){
            var SynSTDT=$("#SynSTDT").datebox("getValue");
            var SynEndDT=$("#SynEndDT").datebox("getValue");
            var SynTimeInterval=$("#SynTimeInterval").val();
            var RecordSheet=session.RecordSheetID;
            var SynSign = dhccl.runServerMethod("CIS.AN.BL.OperCareData", "SyncCollectData",RecordSheet,ArrOperRoom,SynSTDT,SynEndDT,SynTimeInterval);
            $("#operDrugCollectData").datagrid("reload")
        }
    });
}

function getMedicationOptions(Code){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDictDataByCode";
            param.Arg1 = Code;
            param.ArgCnt = 1;
        },
        pagination:true,
        pageSize:10,
        panelWidth:500,
        panelHeight:400,
        idField: "Description",
        textField: "Description",
        columns:[[
            {field:"Description",title:"名称",width:380},
            {field:"RowId",title:"RowId",width:100}
        ]],
        mode: "remote",
        onSelect:function(rowIndex,rowData){
        }
    }
}
/**
 * 根据手术申请数据，设置病人信息表单元素的值。
 * @param {object} operApplication 手术申请数据对象
 */
function loadApplicationData(operApplication) {
    if (operApplication == null) return;
    anaestConsent.operSchedule = operApplication;
    $("#PatName").text(operApplication.PatName);
    $("#PatGender").text(operApplication.PatGender);
    $("#PatAge").text(operApplication.PatAge);
    $("#PatDeptDesc").text(operApplication.PatDeptDesc);
    $("#PatBedCode").text(operApplication.PatBedCode);
    $("#MedcareNo").text(operApplication.MedcareNo);
    $("#RegNo").text(operApplication.RegNo);
    $("#PlanOperationDesc").text(operApplication.OperInfo);
    $("#PrevDiagnosisDesc").text(operApplication.PrevDiagnosisDesc);
    $("#PrevAnaMethodDesc").text(operApplication.PrevAnaMethodDesc);
    $("#OperDate").text(operApplication.OperDate);
    $("#InHosDate").text(operApplication.InHosDate);

    $("#delBeforeHeight").val(anaestConsent.operSchedule.PatHeight);
    $("#delBeforeWeight").val(anaestConsent.operSchedule.PatWeight);
    $("#SynTimeInterval").val("15")
    ArrOperRoom=operApplication.ArrOperRoom
    var CareDataList = dhccl.runServerMethod("CIS.AN.BL.OperCareData", "FindCareDataList",session.RecordSheetID);
    $("#operDrugCollectData").datagrid("loadData",CareDataList);
}

function print() {
    var LODOP = getLodop();
    if (anaestConsent.operSchedule.Status == "1") {
        $.messager.alert("提示:", "该病人分娩记录未审核，请先审核，然后再打印！！");
        return;
    }
    createPrintOnePage(LODOP, anaestConsent.operSchedule);

    //LODOP.PREVIEW();
    LODOP.PRINT();
    //$.messager.popover({ msg: "打印完成！！", type: "success", timeout: 2000 });

}

function printView() {
    var LODOP = getLodop();
    if (anaestConsent.operSchedule.Status == "1") {
        $.messager.alert("提示:", "该病人分娩记录未审核，请先审核，然后再打印！！");
        return;
    }
    createPrintOnePage(LODOP, anaestConsent.operSchedule);
    //LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    LODOP.PREVIEW();
    //LODOP.PRINT();
    $.messager.popover({ msg: "打印完成！！", type: "success", timeout: 2000 });
}

function createPrintOnePage(LODOP, operSchedule) {
    LODOP.PRINT_INIT("手术介入护理记录单");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.SET_PRINT_STYLE("FontSize", 10);

    LODOP.ADD_PRINT_TEXT(30, 30, 740, 30, session.ExtHospDesc || "东华标准版医院");
    //LODOP.ADD_PRINT_TEXT(30, 300, 300, 30, "南方医科大学南方医院");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 15);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);

    LODOP.ADD_PRINT_TEXT(60, 300, 520, 30, "手术介入护理记录单");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);

    //LODOP.ADD_PRINT_LINE(60, 90, 60, 741, 0, 2);
    //LODOP.ADD_PRINT_LINE(20, 80, 1030, 80, 0, 1);

    var rowY = 110,
        lineTop = 15;

    LODOP.ADD_PRINT_TEXT(rowY, 40, 50, 15, "日期:");
    LODOP.ADD_PRINT_TEXT(rowY, 80, 100, 15, $("#OperCareDT").datebox("getValue"));
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 75, rowY + lineTop, 150, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 160, "100%", 15, "科室:");
    LODOP.ADD_PRINT_TEXT(rowY, 195, "100%", 15, operSchedule.PatDeptDesc);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_TEXT(rowY, 420, 80, 15, operSchedule.PatDeptDesc);
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 190, rowY + lineTop, 280, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 290, "100%", 15, "床号:");
    LODOP.ADD_PRINT_TEXT(rowY, 320, "100%", 15, operSchedule.PatBedCode);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_TEXT(rowY, 540, 50, 15, operSchedule.BedCode ||'2-1床');
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 315, rowY + lineTop, 350, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 360, 50, 15, "性名:");
    LODOP.ADD_PRINT_TEXT(rowY, 400, 100, 15, operSchedule.PatName);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 390, rowY + lineTop, 450, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 460, "100%", 15, "病案号:");
    LODOP.ADD_PRINT_TEXT(rowY, 510, "100%", 15, operSchedule.MedcareNo);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    // //LODOP.ADD_PRINT_TEXT(rowY, 645, 90, 15, operSchedule.MedcareNo);
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 500, rowY + lineTop, 580, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 590, 45, 15, "性别:");
    LODOP.ADD_PRINT_TEXT(rowY, 635, 20, 15, operSchedule.PatGender);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 630, rowY + lineTop, 660, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 670, 45, 15, "年龄:");
    LODOP.ADD_PRINT_TEXT(rowY, 705, 50, 15, operSchedule.PatAge);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 705, rowY + lineTop, 730, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY+25, 40, 80, 40, "术前诊断:");
    LODOP.ADD_PRINT_TEXT(rowY+25, 110, 300, 40, operSchedule.PrevDiagnosisDesc);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(rowY + lineTop+25, 100, rowY + lineTop +25, 300, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY+25, 310, 80, 40, "手术名称:");
    LODOP.ADD_PRINT_TEXT(rowY+25, 380, 300, 40, operSchedule.PlanOperDesc);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(rowY + lineTop +25, 370, rowY + lineTop+25, 700, 0, 1);

    var rowTopY = 125,
        lineLeftX = 40,
        lineRightX = 740,
        rowHeight = 30;
    
    var constRowTopY1 = 180;
    var rowHeightNew = 25
    var constRowTopY2 = constRowTopY1 + rowHeightNew * 1;
   
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 40, 120, 15, "过敏史：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var CareRecordAllergy = $("#CareRecordAllergy").val();
    if (CareRecordAllergy == "无") {
        DrawRectAndRight(LODOP, constRowTopY1, 105);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 105);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 125, 80, 15, "无");
    if (CareRecordAllergy == "有") {
        DrawRectAndRight(LODOP, constRowTopY1, 165);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 165);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 185, 80, 15, "有");

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 220, 70, 40, "术中用药:");
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 300, 500, 40, $("#OperCareDrug").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY1+lineTop, 290, constRowTopY1 + lineTop, 600, 0, 1);

    var CareRecordjz = $("#CareRecordjz").val();
    if (CareRecordjz == "急诊") {
        DrawRectAndRight(LODOP, constRowTopY1, 610);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 610);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 635, 80, 15, "急诊");
    if (CareRecordjz == "择期") {
        DrawRectAndRight(LODOP, constRowTopY1, 670);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 670);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 695, 80, 15, "择期");

    constRowTopY1=constRowTopY1+rowHeightNew

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 40, 70, 40, "手术时间:");
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 110, 50, 40, $("#OperCareOpertime").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY1+lineTop, 110, constRowTopY1 + lineTop, 160, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 160, 20, 40, "-");
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 180, 50, 40, $("#OperCareOpertime1").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY1+lineTop, 170, constRowTopY1 + lineTop, 220, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 230, 70, 40, "手术医生:");
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 300, 70, 40, $("#OperCareDoctor").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY1+lineTop, 290, constRowTopY1 + lineTop, 370, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 390, 70, 40, $("#OperCareDoctor1").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY1+lineTop, 380, constRowTopY1 + lineTop, 460, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 480, 70, 40, $("#OperCareDoctor2").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY1+lineTop, 470, constRowTopY1 + lineTop, 550, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 570, 70, 40, $("#OperCareDoctor2").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY1+lineTop, 560, constRowTopY1 + lineTop, 640, 0, 1);

    constRowTopY1=constRowTopY1+rowHeightNew

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 40, 120, 15, "无菌包：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var OperCareWJB = $("#OperCareWJB").val();
    if (OperCareWJB == "包装完整") {
        DrawRectAndRight(LODOP, constRowTopY1, 105);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 105);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 125, 80, 15, "包装完整");
    if (OperCareWJB == "包外指示卡合格") {
        DrawRectAndRight(LODOP, constRowTopY1, 185);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 185);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 205, 100, 15, "包外指示卡合格");

    if (OperCareWJB == "包内指示卡合格") {
        DrawRectAndRight(LODOP, constRowTopY1, 295);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 295);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 315, 100, 15, "包内指示卡合格");

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 420, 120, 15, "麻醉方式：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var CareRecordMethod = $("#CareRecordMethod").val();
    if (CareRecordMethod == "局麻") {
        DrawRectAndRight(LODOP, constRowTopY1, 485);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 485);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 505, 50, 15, "局麻");
    if (CareRecordMethod == "全麻") {
        DrawRectAndRight(LODOP, constRowTopY1, 535);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 535);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 555, 50, 15, "全麻");
    if (CareRecordMethod == "硬膜外") {
        DrawRectAndRight(LODOP, constRowTopY1, 585);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 585);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 605, 100, 15, "硬膜外");
    if (CareRecordMethod == "监护麻醉") {
        DrawRectAndRight(LODOP, constRowTopY1, 645);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 645);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 665, 100, 15, "监护麻醉");

    constRowTopY1=constRowTopY1+rowHeightNew

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 40, 120, 40, "造影剂及用量:");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 155, 80, 40, "碘帕醇:");
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 210, 50, 40, $("#CareRecordDPC").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 245, 30, 40, "ml");
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY1+lineTop, 200, constRowTopY1 + lineTop, 245, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 280, 90, 40, "碘克沙醇:");
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 350, 50, 40, $("#CareRecordDKSC").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 380, 30, 40, "ml");
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY1+lineTop, 340, constRowTopY1 + lineTop, 380, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 420, 90, 40, "碘普罗胺:");
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 490, 50, 40, $("#CareRecordDPLA").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 520, 30, 40, "ml");
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY1+lineTop, 480, constRowTopY1 + lineTop, 520, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 560, 60, 40, "其他:");
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 610, 50, 40, $("#CareRecordQT").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY1+lineTop, 600, constRowTopY1 + lineTop, 680, 0, 1);

    constRowTopY1=constRowTopY1+rowHeightNew

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 40, 120, 15, "血管入径:");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 125, 50, 15, "桡动脉");
    var CareRecordRDM = $("#CareRecordRDM").val();
    if (CareRecordRDM == "左") {
        DrawRectAndRight(LODOP, constRowTopY1, 170);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 170);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 190, 80, 15, "左");
    if (CareRecordRDM == "右") {
        DrawRectAndRight(LODOP, constRowTopY1, 210);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 210);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 230, 100, 15, "右");

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 270, 50, 15, "股动脉");
    var CareRecordGDM = $("#CareRecordGDM").val();
    if (CareRecordGDM == "左") {
        DrawRectAndRight(LODOP, constRowTopY1, 345);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 345);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 365, 80, 15, "左");
    if (CareRecordGDM == "右") {
        DrawRectAndRight(LODOP, constRowTopY1, 385);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 385);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 405, 100, 15, "右");

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 445, 50, 15, "股静脉");
    var CareRecordGJM = $("#CareRecordGJM").val();
    if (CareRecordGJM == "左") {
        DrawRectAndRight(LODOP, constRowTopY1, 495);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 495);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 515, 80, 15, "左");
    if (CareRecordGJM == "右") {
        DrawRectAndRight(LODOP, constRowTopY1, 535);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 535);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 555, 100, 15, "右");

    constRowTopY1=constRowTopY1+rowHeightNew

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 125, 50, 15, "颈静脉");
    var CareRecordJJM = $("#CareRecordJJM").val();
    if (CareRecordJJM == "左") {
        DrawRectAndRight(LODOP, constRowTopY1, 170);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 170);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 190, 80, 15, "左");
    if (CareRecordJJM == "右") {
        DrawRectAndRight(LODOP, constRowTopY1, 210);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 210);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 230, 100, 15, "右");

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 270, 90, 15, "锁骨下静脉");
    var CareRecordSGXJM = $("#CareRecordSGXJM").val();
    if (CareRecordSGXJM == "左") {
        DrawRectAndRight(LODOP, constRowTopY1, 345);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 345);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 365, 80, 15, "左");
    if (CareRecordSGXJM == "右") {
        DrawRectAndRight(LODOP, constRowTopY1, 385);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY1, 385);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 405, 100, 15, "右");

    LODOP.ADD_PRINT_TEXT(constRowTopY1, 445, 50, 40, "其他:");
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 480, 200, 40, $("#CareRecordXGRJQT").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY1+lineTop, 470, constRowTopY1 + lineTop, 680, 0, 1);

    constRowTopY1=constRowTopY1+rowHeightNew*2
    LODOP.ADD_PRINT_TEXT(constRowTopY1, 340, 140, 40, "术中用药及病情观察");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    
    LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew, 40, constRowTopY1 + rowHeightNew, 730, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew*2, 40, constRowTopY1 + rowHeightNew*2, 730, 0, 1);
    
   
   
     
    var DataRows = $("#operDrugCollectData").datagrid("getRows");
    if (DataRows && DataRows.length > 0) {
        /// 竖线
        LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew, 40, constRowTopY1 + rowHeightNew * (DataRows.length + 2), 40, 0, 1);
        LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew, 100, constRowTopY1 + rowHeightNew * (DataRows.length + 2), 100, 0, 1);
        LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew, 160, constRowTopY1 + rowHeightNew * (DataRows.length + 2), 160, 0, 1);
        LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew, 220, constRowTopY1 + rowHeightNew * (DataRows.length + 2), 220, 0, 1);
        LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew, 280, constRowTopY1 + rowHeightNew * (DataRows.length + 2), 280, 0, 1);
        LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew, 340, constRowTopY1 + rowHeightNew * (DataRows.length + 2), 340, 0, 1);

        LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew, 400, constRowTopY1 + rowHeightNew * (DataRows.length + 2), 400, 0, 1);
        LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew, 530, constRowTopY1 + rowHeightNew * (DataRows.length + 2), 530, 0, 1);
        LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew, 660, constRowTopY1 + rowHeightNew * (DataRows.length + 2), 660, 0, 1);

        LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew, 730, constRowTopY1 + rowHeightNew * (DataRows.length + 2), 730, 0, 1);
        
        constRowTopY1 = constRowTopY1 + rowHeightNew 
        var tabelHeight=5
        LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 50, 80, 15, "时间");
        LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 110, 50, 15, "心率次/分");
        LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 170, 50, 15, "呼吸次/分");
        LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 220, 70, 15, "无创血压(mmHg)");
        LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 280, 70, 15, "有创血压(mmHg)");
        LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 350, 100, 15, "SPO2(%)");
        LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 430, 100, 15, "术中用药");
        LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 560, 100, 15, "病情观察");
        LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 670, 100, 15, "护士签名");
        var base64="data:image/png;base64,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"
        /// end 竖线
        for (var i = 0; i < DataRows.length; i++) {
            var DataRow=DataRows[i];
            
            constRowTopY1 = constRowTopY1 + rowHeightNew
            LODOP.ADD_PRINT_LINE(constRowTopY1 + rowHeightNew, 40, constRowTopY1 + rowHeightNew, 730, 0, 1);
            LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 50, 80, 15, DataRow.StartTime);
            LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 110, 50, 15, DataRow.HR);
            LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 170, 50, 15, DataRow.Resp);
            LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 230, 70, 15, DataRow.NBP);
            LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 290, 70, 15, DataRow.ABP);
            LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 350, 100, 15, DataRow.SPO2);
            LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 430, 100, 15, DataRow.Medication);
            LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 560, 100, 15, DataRow.Illness);
            LODOP.ADD_PRINT_IMAGE(constRowTopY1+tabelHeight,670,15,15,base64)
            LODOP.SET_PRINT_STYLEA(0,"Stretch",1);
            //LODOP.ADD_PRINT_TEXT(constRowTopY1+tabelHeight, 670, 100, 15, DataRow.UpdateUser);
            //LODOP.ADD_PRINT_IMAGE(constRowTopY1+tabelHeight,600,100,30,base64)
        }
        
        
    }
}

/// 画打勾选框
function DrawRectAndRight(tmplodop, tmptop, tmpleft) {
    tmplodop.ADD_PRINT_RECT(tmptop, tmpleft + 5, "3.3mm", "3.3mm", 0, 1);
    tmplodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    tmplodop.ADD_PRINT_TEXT(tmptop - 5, tmpleft, 30, 15, "√");
    tmplodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    tmplodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    tmplodop.SET_PRINT_STYLEA(0, "FontSize", 15);
}

/// 画空白方框
function DrawRectAndRightNull(tmplodop, tmptop, tmpleft) {
    tmplodop.ADD_PRINT_RECT(tmptop, tmpleft + 5, "3.3mm", "3.3mm", 0, 1);
    tmplodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    tmplodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    tmplodop.SET_PRINT_STYLEA(0, "FontSize", 15);
}

function CheckBoxValue(formItemName, value) {
    var result = "unchecked";
    var jqArray = $("input[data-formitem='" + formItemName + "']");
    var length = jqArray.size();
    for (var i = 0; i < length; i++) {
        if ((jqArray.eq(i).val() == value) && (jqArray.eq(i).checkbox("getValue"))) {
            result = "checked";
            break;
        }
    }
    return result;
}