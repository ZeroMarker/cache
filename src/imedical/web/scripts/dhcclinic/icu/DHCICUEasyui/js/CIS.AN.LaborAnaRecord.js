var anaestConsent = {
    operSchedule: null
};

$(document).ready(function() {
    dhccl.parseDateFormat();
    dhccl.parseDateTimeFormat();
    operDataManager.initFormData(loadApplicationData);
    initPage();
    operDataManager.setCheckChange();
    SignTool.loadSignature(function(){
        return operDataManager.getOperDatas();
    });
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
}

function print() {
    var LODOP = getLodop();
    if (anaestConsent.operSchedule.Status == "1") {
        $.messager.alert("提示:", "该病人分娩记录未审核，请先审核，然后再打印！！");
        return;
    }
    createPrintOnePage(LODOP, anaestConsent.operSchedule);

    LODOP.PREVIEW();
    //LODOP.PRINT();
    $.messager.popover({ msg: "打印完成！！", type: "success", timeout: 2000 });

}

function printView() {
    var LODOP = getLodop();
    if (anaestConsent.operSchedule.Status == "1") {
        $.messager.alert("提示:", "该病人分娩记录未审核，请先审核，然后再打印！！");
        return;
    }
    createPrintOnePage(LODOP, anaestConsent.operSchedule);
    LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    LODOP.PREVIEW();
    //LODOP.PRINT();
    $.messager.popover({ msg: "打印完成！！", type: "success", timeout: 2000 });
}


function createPrintOnePage(LODOP, operSchedule) {
    LODOP.PRINT_INIT("分娩镇痛前记录单");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.SET_PRINT_STYLE("FontSize", 10);

    LODOP.ADD_PRINT_TEXT(30, 30, 740, 30, session.ExtHospDesc || "东华标准版医院");
    //LODOP.ADD_PRINT_TEXT(30, 300, 300, 30, "南方医科大学南方医院");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 15);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);

    LODOP.ADD_PRINT_TEXT(60, 300, 520, 30, "分 娩 镇 痛 记 录 单");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);

    //LODOP.ADD_PRINT_LINE(60, 90, 60, 741, 0, 2);
    //LODOP.ADD_PRINT_LINE(20, 80, 1030, 80, 0, 1);

    var rowY = 110,
        lineTop = 15;

    LODOP.ADD_PRINT_TEXT(rowY, 40, 50, 15, "性名:");
    LODOP.ADD_PRINT_TEXT(rowY, 80, 100, 15, operSchedule.PatName);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 75, rowY + lineTop, 150, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 160, 45, 15, "性别:");
    LODOP.ADD_PRINT_TEXT(rowY, 195, 20, 15, operSchedule.PatGender);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 190, rowY + lineTop, 220, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 230, 45, 15, "年龄:");
    LODOP.ADD_PRINT_TEXT(rowY, 270, 50, 15, operSchedule.PatAge);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 265, rowY + lineTop, 310, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 320, "100%", 15, "科室:");
    LODOP.ADD_PRINT_TEXT(rowY, 360, "100%", 15, operSchedule.PatDeptDesc);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_TEXT(rowY, 420, 80, 15, operSchedule.PatDeptDesc);
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 355, rowY + lineTop, 530, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 540, "100%", 15, "床号:");
    LODOP.ADD_PRINT_TEXT(rowY, 580, "100%", 15, operSchedule.PatBedCode);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_TEXT(rowY, 540, 50, 15, operSchedule.BedCode ||'2-1床');
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 580, rowY + lineTop, 600, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 630, "100%", 15, "病案号:");
    LODOP.ADD_PRINT_TEXT(rowY, 680, "100%", 15, operSchedule.MedcareNo);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    // //LODOP.ADD_PRINT_TEXT(rowY, 645, 90, 15, operSchedule.MedcareNo);
    LODOP.ADD_PRINT_LINE(rowY + lineTop, 680, rowY + lineTop, 740, 0, 1);

    var rowTopY = 125,
        lineLeftX = 40,
        lineRightX = 740,
        rowHeight = 30;

    var patInfoRow1TopY = rowTopY;
    var patInfoRow2TopY = rowTopY + rowHeight * 1;
    var patInfoRow3TopY = rowTopY + rowHeight * 2;
    //rowTopY=rowTopY+10;
    var patInfoRow4TopY = rowTopY + rowHeight * 3;
    var patInfoRow5TopY = rowTopY + rowHeight * 4;
    var patInfoRow6TopY = rowTopY + rowHeight * 5;
    var patInfoRow7TopY = rowTopY + rowHeight * 6;

    LODOP.ADD_PRINT_LINE(patInfoRow1TopY, lineLeftX + 1, patInfoRow1TopY, lineRightX - 1, 0, 1);
    LODOP.ADD_PRINT_LINE(patInfoRow2TopY - 5, lineLeftX + 1, patInfoRow2TopY - 5, lineRightX - 1, 0, 1);
    LODOP.ADD_PRINT_LINE(patInfoRow3TopY - 5, lineLeftX + 1, patInfoRow3TopY - 5, lineRightX - 1, 0, 1);
    //LODOP.ADD_PRINT_LINE(patInfoRow4TopY-20, lineLeftX + 1, patInfoRow4TopY-20, lineRightX -1, 0, 1);

    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY + 10, 40, 50, 15, "ID:");
    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY + 10, 70, 100, 15, operSchedule.RegNo);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY + 10, 160, 60, 15, "身高:");
    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY + 10, 200, 60, 15, $("#delBeforeHeight").val() + " cm");
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY + 10, 280, 50, 15, "体重:");
    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY + 10, 320, 60, 15, $("#delBeforeWeight").val() + " kg");
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY + 10, 380, 80, 15, "术前诊断:");
    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY + 10, 450, 300, 45, operSchedule.PrevDiagnosisDesc);
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_LINE(patInfoRow2TopY+lineTop+10, 110, patInfoRow2TopY+lineTop+10, 730, 0, 1);

    LODOP.ADD_PRINT_TEXT(patInfoRow2TopY + 10, 40, 180, 15, "拟行操作: 分娩镇痛");
    //LODOP.ADD_PRINT_TEXT(patInfoRow2TopY+10, 160, 730, 15, "("+operSchedule.OperationDesc +")");
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    var constRowTopY1 = 180;
    var rowHeightNew = 25
    var constRowTopY2 = constRowTopY1 + rowHeightNew * 1;
    var constRowTopY3 = constRowTopY1 + rowHeightNew * 2;
    var constRowTopY4 = constRowTopY1 + rowHeightNew * 3;
    var constRowTopY5 = constRowTopY1 + rowHeightNew * 4;
    var constRowTopY6 = constRowTopY1 + rowHeightNew * 5;

    var constRowTopY7 = constRowTopY1 + rowHeightNew * 6;
    var constRowTopY8 = constRowTopY1 + rowHeightNew * 7;

    var constRowTopY9 = constRowTopY1 + rowHeightNew * 8;

    var constRowTopY10 = constRowTopY1 + rowHeightNew * 9;
    constRowTopY1 = constRowTopY1 + 20;
    var constRowTopY11 = constRowTopY1 + rowHeightNew * 10;
    var constRowTopY12 = constRowTopY1 + rowHeightNew * 11;
    var constRowTopY13 = constRowTopY1 + rowHeightNew * 12;
    var constRowTopY14 = constRowTopY1 + rowHeightNew * 13;

    var constRowTopY15 = constRowTopY1 + rowHeightNew * 14;
    var constRowTopY16 = constRowTopY1 + rowHeightNew * 15;

    var constRowTopY17 = constRowTopY1 + rowHeightNew * 16;
    var constRowTopY18 = constRowTopY1 + rowHeightNew * 17;
    var constRowTopY19 = constRowTopY1 + rowHeightNew * 18;
    constRowTopY1 = constRowTopY1 - 20;
    var constRowTopY20 = constRowTopY1 + rowHeightNew * 19;
    var constRowTopY21 = constRowTopY1 + rowHeightNew * 20;
    var constRowTopY22 = constRowTopY1 + rowHeightNew * 21;
    constRowTopY1 = constRowTopY1 - rowHeightNew;
    var constRowTopY23 = constRowTopY1 + rowHeightNew * 22;
    var constRowTopY24 = constRowTopY1 + rowHeightNew * 23;
    var constRowTopY25 = constRowTopY1 + rowHeightNew * 24;
    var constRowTopY26 = constRowTopY1 + rowHeightNew * 25;
    var constRowTopY27 = constRowTopY1 + rowHeightNew * 26;
    var constRowTopY28 = constRowTopY1 + rowHeightNew * 27;
    var constRowTopY29 = constRowTopY1 + rowHeightNew * 28;
    var constRowTopY30 = constRowTopY1 + rowHeightNew * 29;
    var constRowTopY31 = constRowTopY1 + rowHeightNew * 30;
    var constRowTopY32 = constRowTopY1 + rowHeightNew * 31;
    var constRowTopY33 = constRowTopY1 + rowHeightNew * 32;
    var constRowTopY34 = constRowTopY1 + rowHeightNew * 33;
    var constRowTopY35 = constRowTopY1 + rowHeightNew * 34;
    ////第一行
    LODOP.ADD_PRINT_TEXT(constRowTopY2, 40, 80, 15, "ASA分级：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    LODOP.ADD_PRINT_TEXT(constRowTopY2, 100, 80, 15, $("#delAfterASAClass").combobox("getText") + "级");
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    LODOP.ADD_PRINT_TEXT(constRowTopY2, 160, 100, 15, "NYHA分级：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    LODOP.ADD_PRINT_TEXT(constRowTopY2, 230, 80, 15, $("#delAfterNYHA").combobox("getText") + "级");
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    LODOP.ADD_PRINT_TEXT(constRowTopY2, 300, 140, 15, "麻醉前特殊情况：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    LODOP.ADD_PRINT_TEXT(constRowTopY2, 415, 300, 15, $("#delAfterSpecialNote").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    /// end 第一行

    //// 第二行
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 40, 140, 15, "麻醉前生命体征：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY3, 160, 40, 15, "BP");
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 190, 40, 15, $("#delAfterSys").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 217, 40, 15, "/");
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 230, 40, 15, $("#delAfterDia").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 250, 60, 15, " mmHg");
    LODOP.ADD_PRINT_LINE(constRowTopY3 + 15, 180, constRowTopY3 + 15, 250, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY3, 320, 40, 15, "PR");
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 345, 40, 15, $("#delAfterPulse").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 370, 60, 15, "次/分");
    LODOP.ADD_PRINT_LINE(constRowTopY3 + 15, 340, constRowTopY3 + 15, 370, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY3, 430, 40, 15, "RR");
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 455, 40, 15, $("#delAfterRR").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 480, 60, 15, "次/分");
    LODOP.ADD_PRINT_LINE(constRowTopY3 + 15, 450, constRowTopY3 + 15, 480, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY3, 540, 40, 15, "T");
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 560, 40, 15, $("#delAfterTemper").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 590, 60, 15, "℃");
    LODOP.ADD_PRINT_LINE(constRowTopY3 + 15, 550, constRowTopY3 + 15, 590, 0, 1);

    //// end 第二行

    //// 第三行
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 40, 100, 15, "体格检查：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY4, 110, 150, 15, "镇痛开始前宫口开大：");
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 250, 40, 15, $("#delAfterHysBig").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 280, 60, 15, "cm");
    LODOP.ADD_PRINT_LINE(constRowTopY4 + 15, 240, constRowTopY4 + 15, 280, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY4, 320, 150, 15, "VAS：");
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 355, 40, 15, $("#delAfterVASScore").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 380, 60, 15, "分");
    LODOP.ADD_PRINT_LINE(constRowTopY4 + 15, 350, constRowTopY4 + 15, 380, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY4, 430, 100, 15, "胎心率：");
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 485, 40, 15, $("#delAfterFetalHeart").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 520, 60, 15, "次/分");
    LODOP.ADD_PRINT_LINE(constRowTopY4 + 15, 480, constRowTopY4 + 15, 520, 0, 1);

    //// end 第三行

    /// 第四行
    LODOP.ADD_PRINT_TEXT(constRowTopY5, 40, 100, 15, "镇痛方式：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    LODOP.ADD_PRINT_TEXT(constRowTopY5, 110, 600, 15, $("#delAfterPainMethod").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    /// end 第四行

    /// 第五行
    LODOP.ADD_PRINT_TEXT(constRowTopY6, 40, 100, 15, "操作经过：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    LODOP.ADD_PRINT_TEXT(constRowTopY6, 110, 100, 15, $("#delAfterOperation").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY6, 200, 60, 15, "位，");
    LODOP.ADD_PRINT_LINE(constRowTopY6 + 15, 105, constRowTopY6 + 15, 200, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY6, 250, 100, 15, "穿刺间隙：");
    LODOP.ADD_PRINT_TEXT(constRowTopY6, 320, 100, 15, $("#delAfterPunction").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY6 + 15, 310, constRowTopY6 + 15, 390, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY6, 430, 130, 15, "导管留置深度：");
    LODOP.ADD_PRINT_TEXT(constRowTopY6, 525, 30, 15, $("#delAfterTubeLength").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY6, 550, 200, 15, "cm");
    LODOP.ADD_PRINT_LINE(constRowTopY6 + 15, 520, constRowTopY6 + 15, 550, 0, 1);

    /// end 第五行

    //// 第六行
    LODOP.ADD_PRINT_TEXT(constRowTopY7, 40, 100, 15, "麻醉用药：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    LODOP.ADD_PRINT_TEXT(constRowTopY7, 110, 100, 15, "试验量：");
    LODOP.ADD_PRINT_TEXT(constRowTopY7, 160, 550, 15, $("#delAfterTestVolum").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_LINE(constRowTopY7+15,105,constRowTopY7+15,200,0,1);
    /// end 第六行

    //// 第七行
    LODOP.ADD_PRINT_TEXT(constRowTopY8, 123, 80, 15, "首剂：");
    LODOP.ADD_PRINT_TEXT(constRowTopY8, 160, 550, 15, $("#delAfterFirstVolum").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_LINE(constRowTopY8+15,105,constRowTopY8+15,200,0,1);

    /// end 第七行

    //// 第八行
    LODOP.ADD_PRINT_TEXT(constRowTopY9, 85, 120, 15, "镇痛泵配置：");
    LODOP.ADD_PRINT_TEXT(constRowTopY9, 160, 550, 15, $("#delAfterBeng").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_LINE(constRowTopY9+15,105,constRowTopY9+15,200,0,1);

    /// end 第八行

    //// 第九行
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 110, 80, 15, "持续量：");
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 160, 60, 15, $("#delAfterContinueVolum").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 210, 40, 15, "ml/h");
    LODOP.ADD_PRINT_LINE(constRowTopY10 + 15, 155, constRowTopY10 + 15, 210, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY10, 260, 80, 15, "自控量：");
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 320, 40, 15, $("#delAfterSelfConVolum").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 350, 40, 15, "ml");
    LODOP.ADD_PRINT_LINE(constRowTopY10 + 15, 310, constRowTopY10 + 15, 350, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY10, 390, 80, 15, "锁定时间：");
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 460, 40, 15, $("#delAfterLockTime").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 490, 40, 15, "min");
    LODOP.ADD_PRINT_LINE(constRowTopY10 + 15, 450, constRowTopY10 + 15, 490, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY10, 530, 80, 15, "麻醉平面：");
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 600, 60, 15, $("#delAfterAnaPanl").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY10 + 15, 590, constRowTopY10 + 15, 700, 0, 1);

    /// end 第九行

    /// 表格
    /// 横线
    LODOP.ADD_PRINT_LINE(constRowTopY10 + 20, 40, constRowTopY10 + 20, 730, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY11 + 20, 40, constRowTopY11 + 20, 730, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY12 + 20, 40, constRowTopY12 + 20, 730, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY13 + 20, 40, constRowTopY13 + 20, 730, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY14 + 20, 40, constRowTopY14 + 20, 730, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY15 + 20, 40, constRowTopY15 + 20, 730, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY16 + 20, 40, constRowTopY16 + 20, 730, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY17 + 20, 40, constRowTopY17 + 20, 730, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY19 + 20, 40, constRowTopY19 + 20, 730, 0, 1);
    //LODOP.ADD_PRINT_LINE(constRowTopY19+20,40,constRowTopY19+20,730,0,1);
    //LODOP.ADD_PRINT_LINE(constRowTopY20+20,40,constRowTopY20+20,730,0,1);
    //LODOP.ADD_PRINT_LINE(constRowTopY21+20,40,constRowTopY21+20,730,0,1);
    /// end 横线

    /// 竖线
    LODOP.ADD_PRINT_LINE(constRowTopY10 + 20, 40, constRowTopY19 + 20, 40, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY10 + 20, 200, constRowTopY17 + 20, 200, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY10 + 20, 330, constRowTopY17 + 20, 330, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY10 + 20, 430, constRowTopY17 + 20, 430, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY10 + 20, 530, constRowTopY17 + 20, 530, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY10 + 20, 630, constRowTopY17 + 20, 630, 0, 1);

    LODOP.ADD_PRINT_LINE(constRowTopY10 + 20, 730, constRowTopY19 + 20, 730, 0, 1);

    /// end 竖线


    LODOP.ADD_PRINT_TEXT(constRowTopY11, 100, 80, 15, "时间");
    LODOP.ADD_PRINT_TEXT(constRowTopY11, 230, 100, 15, "血压(mmHg)");
    LODOP.ADD_PRINT_TEXT(constRowTopY11, 340, 100, 15, "脉搏(次/分)");
    LODOP.ADD_PRINT_TEXT(constRowTopY11, 440, 100, 15, "呼吸(次/分)");
    LODOP.ADD_PRINT_TEXT(constRowTopY11, 555, 100, 15, "SPO2(%)");
    LODOP.ADD_PRINT_TEXT(constRowTopY11, 655, 100, 15, "VAS评分");

    LODOP.ADD_PRINT_TEXT(constRowTopY12, 80, 100, 15, "镇痛开始时");
    LODOP.SET_PRINT_STYLE("FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY12, 240, 100, 15, $("#AnalgesiaStartBP").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY12, 370, 100, 15, $("#AnalgesiaStartPR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY12, 470, 100, 15, $("#AnalgesiaStartRR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY12, 570, 100, 15, $("#AnalgesiaStartSPO2").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY12, 670, 100, 15, $("#AnalgesiaStartVAS").val());
    LODOP.SET_PRINT_STYLE("FontColor", "#000000"); //更换颜色

    LODOP.ADD_PRINT_TEXT(constRowTopY13, 80, 120, 15, "镇痛后 15 min");
    LODOP.SET_PRINT_STYLE("FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY13, 240, 100, 15, $("#AnalgesiaIn15minBP").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY13, 370, 100, 15, $("#AnalgesiaIn15minPR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY13, 470, 100, 15, $("#AnalgesiaIn15minRR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY13, 570, 100, 15, $("#AnalgesiaIn15minSPO2").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY13, 670, 100, 15, $("#AnalgesiaIn15minVAS").val());
    LODOP.SET_PRINT_STYLE("FontColor", "#000000"); //更换颜色

    LODOP.ADD_PRINT_TEXT(constRowTopY14, 80, 120, 15, "镇痛后 30 min");
    LODOP.SET_PRINT_STYLE("FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY14, 240, 100, 15, $("#AnalgesiaIn30minBP").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY14, 370, 100, 15, $("#AnalgesiaIn30minPR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY14, 470, 100, 15, $("#AnalgesiaIn30minRR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY14, 570, 100, 15, $("#AnalgesiaIn30minSPO2").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY14, 670, 100, 15, $("#AnalgesiaIn30minVAS").val());
    LODOP.SET_PRINT_STYLE("FontColor", "#000000"); //更换颜色

    LODOP.ADD_PRINT_TEXT(constRowTopY15, 80, 100, 15, "镇痛后");
    LODOP.ADD_PRINT_TEXT(constRowTopY15, 140, 80, 15, "hour");
    LODOP.SET_PRINT_STYLE("FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY15, 125, 80, 15, $("#AnalgesiaAfterOneHour").val());

    LODOP.ADD_PRINT_TEXT(constRowTopY15, 240, 100, 15, $("#AnalgesiaAfterOneBP").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY15, 370, 100, 15, $("#AnalgesiaAfterOnePR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY15, 470, 100, 15, $("#AnalgesiaAfterOneRR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY15, 570, 100, 15, $("#AnalgesiaAfterOneSPO2").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY15, 670, 100, 15, $("#AnalgesiaAfterOneVAS").val());
    LODOP.SET_PRINT_STYLE("FontColor", "#000000"); //更换颜色

    LODOP.ADD_PRINT_TEXT(constRowTopY16, 80, 80, 15, "镇痛后");
    LODOP.ADD_PRINT_TEXT(constRowTopY16, 145, 80, 15, "hour");
    LODOP.SET_PRINT_STYLE("FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY16, 120, 80, 15, $("#AnalgesiaAfterTwoHour").val());

    LODOP.ADD_PRINT_TEXT(constRowTopY16, 240, 100, 15, $("#AnalgesiaAfterTwoBP").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY16, 370, 100, 15, $("#AnalgesiaAfterTwoPR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY16, 470, 100, 15, $("#AnalgesiaAfterTwoRR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY16, 570, 100, 15, $("#AnalgesiaAfterTwoSPO2").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY16, 670, 100, 15, $("#AnalgesiaAfterTwoVAS").val());
    LODOP.SET_PRINT_STYLE("FontColor", "#000000"); //更换颜色

    LODOP.ADD_PRINT_TEXT(constRowTopY17, 80, 120, 15, "分娩结束时");
    LODOP.SET_PRINT_STYLE("FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY17, 240, 100, 15, $("#LaborAfterBP").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY17, 370, 100, 15, $("#LaborAfterPR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY17, 470, 100, 15, $("#LaborAfterRR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY17, 570, 100, 15, $("#LaborAfterSPO2").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY17, 670, 100, 15, $("#LaborAfterVAS").val());
    LODOP.SET_PRINT_STYLE("FontColor", "#000000"); //更换颜色
    /*
    LODOP.ADD_PRINT_TEXT(constRowTopY18,60,120,15,"镇痛开始时间：");
    LODOP.ADD_PRINT_TEXT(constRowTopY18,170,100,15,$("#delStartPainTime").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY18,350,120,15,"宫口全开时间：");
    LODOP.ADD_PRINT_TEXT(constRowTopY18,450,100,15,$("#delStartHysTime").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY18,540,120,15,"胎儿娩出时间：");
    LODOP.ADD_PRINT_TEXT(constRowTopY18,640,100,15,$("#delBabyBornTime").val());

    LODOP.ADD_PRINT_TEXT(constRowTopY19,60,120,15,"Apgar评分1分钟：");
    LODOP.ADD_PRINT_TEXT(constRowTopY19,170,100,15,$("#delApgarScore1").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY19,350,120,15,"5分钟：");
    LODOP.ADD_PRINT_TEXT(constRowTopY19,450,100,15,$("#delApgarScore5").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY19,540,120,15,"胎儿体重：");
    LODOP.ADD_PRINT_TEXT(constRowTopY19,640,100,15,$("#delBabyWeight").val());

    LODOP.ADD_PRINT_TEXT(constRowTopY20,60,120,15,"胎盘娩出时间：");
    LODOP.ADD_PRINT_TEXT(constRowTopY20,170,100,15,$("#delMataBornTime").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY20,350,120,15,"镇痛泵停用时间：");
    LODOP.ADD_PRINT_TEXT(constRowTopY20,460,100,15,$("#delStopPainTime").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY20,540,120,15,"硬膜外导管拔除：");
    LODOP.ADD_PRINT_TEXT(constRowTopY20,650,100,15,$("#delTubeOUtTime").val());
    */
    LODOP.ADD_PRINT_TEXT(constRowTopY18, 60, 120, 15, "其他用药：");
    LODOP.ADD_PRINT_TEXT(constRowTopY18, 125, 560, 45, $("#delPainOtherDrug").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    /// end  表格

    //// 第21行
    /*
    LODOP.ADD_PRINT_TEXT(constRowTopY22,40,100,15,"麻醉总结：");
    LODOP.SET_PRINT_STYLEA(0,"Bold",1);
    LODOP.ADD_PRINT_TEXT(constRowTopY22,120,180,15,"分娩结束时bolus次数：");
    LODOP.ADD_PRINT_TEXT(constRowTopY22,270,30,15,$("#delEndBolusCount").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY22,300,50,15,"次，");
    LODOP.ADD_PRINT_LINE(constRowTopY22+15,265,constRowTopY22+15,300,0,1);

    LODOP.ADD_PRINT_TEXT(constRowTopY22,360,100,15,"总用药量：");
    LODOP.ADD_PRINT_TEXT(constRowTopY22,430,40,15,$("#delEndBolusCount").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY22,470,30,15,"ml");
    LODOP.ADD_PRINT_LINE(constRowTopY22+15,425,constRowTopY22+15,470,0,1);
    */
    //// end 第21行

    /// 第21行
    LODOP.ADD_PRINT_TEXT(constRowTopY23, 40, 100, 15, "不良反应：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);

    var delEndUnEffect = $("#delEndUnEffect").val();
    if (delEndUnEffect.indexOf("低血压") > -1) {
        DrawRectAndRight(LODOP, constRowTopY23, 120);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY23, 120);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY23, 140, 80, 15, "低血压");
    if (delEndUnEffect.indexOf("恶心") > -1) {
        DrawRectAndRight(LODOP, constRowTopY23, 200);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY23, 200);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY23, 220, 80, 15, "恶心");
    if (delEndUnEffect.indexOf("呕吐") > -1) {
        DrawRectAndRight(LODOP, constRowTopY23, 260);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY23, 260);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY23, 280, 80, 15, "呕吐");
    if (delEndUnEffect.indexOf("下肢麻木无力") > -1) {
        DrawRectAndRight(LODOP, constRowTopY23, 320);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY23, 320);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY23, 340, 100, 15, "下肢麻木无力");
    if (delEndUnEffect.indexOf("皮肤瘙痒") > -1) {
        DrawRectAndRight(LODOP, constRowTopY23, 430);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY23, 430);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY23, 450, 80, 15, "皮肤瘙痒");

    if (delEndUnEffect.indexOf("发热") > -1) {
        DrawRectAndRight(LODOP, constRowTopY23, 520);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY23, 520);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY23, 540, 80, 15, "发热");
    if (delEndUnEffect.indexOf("穿破硬脊膜") > -1) {
        DrawRectAndRight(LODOP, constRowTopY23, 590);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY23, 590);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY23, 610, 100, 15, "穿破硬脊膜");
    //// end 第21行

    /// 第22行
    LODOP.ADD_PRINT_TEXT(constRowTopY24, 40, 120, 15, "双下肢运动：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delEndLegsMoving = $("#delEndLegsMoving").val();
    if (delEndLegsMoving == "自如") {
        DrawRectAndRight(LODOP, constRowTopY24, 120);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY24, 120);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY24, 140, 80, 15, "自如");
    if (delEndLegsMoving == "障碍") {
        DrawRectAndRight(LODOP, constRowTopY24, 200);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY24, 200);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY24, 220, 80, 15, "障碍");

    LODOP.ADD_PRINT_TEXT(constRowTopY24, 305, 120, 15, "肢体麻木：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delEndBodyFellless = $("#delEndBodyFellless").val();
    if (delEndBodyFellless == "无") {
        DrawRectAndRight(LODOP, constRowTopY24, 370);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY24, 370);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY24, 390, 80, 15, "无");
    if (delEndBodyFellless == "有") {
        DrawRectAndRight(LODOP, constRowTopY24, 430);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY24, 430);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY24, 450, 80, 15, "有");

    /*
	LODOP.ADD_PRINT_TEXT(constRowTopY24,40,100,15,"分娩方式：");
	LODOP.SET_PRINT_STYLEA(0,"Bold",1);

	var delEndBornMethod=$("#delEndBornMethod").val();
    if (delEndBornMethod=="顺产")
	{
		DrawRectAndRight(LODOP,constRowTopY24,120);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY24,120);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY24, 140, 80, 15,"顺产");
	if (delEndBornMethod=="侧切")
	{
		DrawRectAndRight(LODOP,constRowTopY24,200);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY24,200);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY24, 220, 80, 15,"侧切");
	if (delEndBornMethod=="儿吸")
	{
		DrawRectAndRight(LODOP,constRowTopY24,260);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY24,260);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY24, 280, 80, 15,"儿吸");
	if (delEndBornMethod=="产钳")
	{
		DrawRectAndRight(LODOP,constRowTopY24,320);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY24,320);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY24, 340, 100, 15,"产钳");
	if (delEndBornMethod=="剖宫产")
	{
		DrawRectAndRight(LODOP,constRowTopY24,430);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY24,430);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY24, 450, 80, 15,"剖宫产");
	*/
    //// end 第22行


    //// 第23行

    LODOP.ADD_PRINT_TEXT(constRowTopY25, 40, 140, 15, "麻醉后不良反应：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delAnaEndUnEffect = $("#delAnaEndUnEffect").val();
    if (delAnaEndUnEffect == "无") {
        DrawRectAndRight(LODOP, constRowTopY25, 160);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY25, 160);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY25, 180, 80, 15, "无");
    if (delAnaEndUnEffect == "有") {
        DrawRectAndRight(LODOP, constRowTopY25, 220);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY25, 220);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY25, 240, 80, 15, "有");

    /*
    LODOP.ADD_PRINT_TEXT(constRowTopY25,40,140,15,"镇痛后访视：");
    LODOP.SET_PRINT_STYLEA(0,"Bold",1);

    LODOP.ADD_PRINT_TEXT(constRowTopY25,160,40,15,"BP");
    LODOP.ADD_PRINT_TEXT(constRowTopY25,190,40,15,$("#delEndVisitSYS").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY25,217,40,15,"/");
    LODOP.ADD_PRINT_TEXT(constRowTopY25,230,40,15,$("#delEndVisitDIA").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY25,250,60,15," mmHg");
    LODOP.ADD_PRINT_LINE(constRowTopY25+15,180,constRowTopY25+15,250,0,1);

    LODOP.ADD_PRINT_TEXT(constRowTopY25,320,40,15,"PR");
    LODOP.ADD_PRINT_TEXT(constRowTopY25,345,40,15,$("#delEndVisitPR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY25,370,60,15,"次/分");
    LODOP.ADD_PRINT_LINE(constRowTopY25+15,340,constRowTopY25+15,370,0,1);

    LODOP.ADD_PRINT_TEXT(constRowTopY25,430,40,15,"RR");
    LODOP.ADD_PRINT_TEXT(constRowTopY25,455,40,15,$("#delEndVisitRR").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY25,480,60,15,"次/分");
    LODOP.ADD_PRINT_LINE(constRowTopY25+15,450,constRowTopY25+15,480,0,1);

    LODOP.ADD_PRINT_TEXT(constRowTopY25,540,40,15,"T");
    LODOP.ADD_PRINT_TEXT(constRowTopY25,560,40,15,$("#delEndVisitTemper").val());
    LODOP.ADD_PRINT_TEXT(constRowTopY25,590,60,15,"℃");
    LODOP.ADD_PRINT_LINE(constRowTopY25+15,550,constRowTopY25+15,590,0,1);
    */
    //// end 第23行

    //// 第24行
    /*
	LODOP.ADD_PRINT_TEXT(constRowTopY26,40,120,15,"双下肢运动：");
	LODOP.SET_PRINT_STYLEA(0,"Bold",1);
	var delEndLegsMoving=$("#delEndLegsMoving").val();
    if (delEndLegsMoving=="自如")
	{
		DrawRectAndRight(LODOP,constRowTopY26,120);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY26,120);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY26, 140, 80, 15,"自如");
	if (delEndLegsMoving=="障碍")
	{
		DrawRectAndRight(LODOP,constRowTopY26,200);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY26,200);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY26, 220, 80, 15,"障碍");

	LODOP.ADD_PRINT_TEXT(constRowTopY26,305,120,15,"肢体麻木：");
	LODOP.SET_PRINT_STYLEA(0,"Bold",1);
	var delEndBodyFellless=$("#delEndBodyFellless").val();
    if (delEndBodyFellless=="无")
	{
		DrawRectAndRight(LODOP,constRowTopY26,370);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY26,370);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY26, 390, 80, 15,"无");
	if (delEndBodyFellless=="有")
	{
		DrawRectAndRight(LODOP,constRowTopY26,430);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY26,430);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY26, 450, 80, 15,"有");

	
	LODOP.ADD_PRINT_TEXT(constRowTopY26,520,120,15,"感染：");
	LODOP.SET_PRINT_STYLEA(0,"Bold",1);
	var delEndInfect=$("#delEndInfect").val();
    if (delEndInfect=="无")
	{
		DrawRectAndRight(LODOP,constRowTopY26,560);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY26,560);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY26, 580, 80, 15,"无");
	if (delEndInfect=="有")
	{
		DrawRectAndRight(LODOP,constRowTopY26,620);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY26,620);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY26, 640, 80, 15,"有");
	*/
    //// end 第24行

    //// 第25行
    /*
	LODOP.ADD_PRINT_TEXT(constRowTopY27,40,120,15,"穿刺点红肿：");
	LODOP.SET_PRINT_STYLEA(0,"Bold",1);
	var delEndpuncPoint=$("#delEndpuncPoint").val();
    if (delEndpuncPoint=="有")
	{
		DrawRectAndRight(LODOP,constRowTopY27,120);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY27,120);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY27, 140, 80, 15,"有");
	if (delEndpuncPoint=="无")
	{
		DrawRectAndRight(LODOP,constRowTopY27,200);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY27,200);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY27, 220, 80, 15,"无");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY27,305,140,15,"麻醉后不良反应：");
	LODOP.SET_PRINT_STYLEA(0,"Bold",1);
	var delAnaEndUnEffect=$("#delAnaEndUnEffect").val();
    if (delAnaEndUnEffect=="无")
	{
		DrawRectAndRight(LODOP,constRowTopY27,420);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY27,420);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY27, 440, 80, 15,"无");
	if (delAnaEndUnEffect=="有")
	{
		DrawRectAndRight(LODOP,constRowTopY27,480);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY27,480);
    }
	LODOP.ADD_PRINT_TEXT(constRowTopY27, 500, 80, 15,"有");
	*/

    //// end 第25行

    /// 第26行  constRowTopY28
    LODOP.ADD_PRINT_TEXT(constRowTopY26, 40, 60, 15, "处理：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    LODOP.ADD_PRINT_TEXT(constRowTopY26, 90, 610, 45, $("#delEndUnEffectDisposel").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY26 + 15, 80, constRowTopY26 + 15, 720, 0, 1);
    //// end 第 26行

    /// 签名
    LODOP.ADD_PRINT_LINE(constRowTopY29 + 15, 340, constRowTopY29 + 15, 440, 0, 1);
    LODOP.ADD_PRINT_LINE(constRowTopY29 + 15, 500, constRowTopY29 + 15, 680, 0, 1);
    LODOP.ADD_PRINT_TEXT(constRowTopY29, 220, 160, 15, "麻醉科医师签名：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var PreOpVisitorSignImage = $("#PreOpVisitorSignImage").attr("src");
    if (PreOpVisitorSignImage) {
    	var PreOpVisitorSignHtml="<img "+((PreOpVisitorSignImage && PreOpVisitorSignImage!="")?("src='"+PreOpVisitorSignImage+"'"):"")+">";
	    LODOP.ADD_PRINT_IMAGE(constRowTopY28 + 15, 350, 50, 50, PreOpVisitorSignHtml);
		LODOP.SET_PRINT_STYLEA(0,"Stretch",2);
    }
    else LODOP.ADD_PRINT_TEXT(constRowTopY29, 350, 300, 15, $("#PreOpVisitorSign").triggerbox('getValue'));
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_TEXT(constRowTopY29, 450, 120, 15, "日期：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    LODOP.ADD_PRINT_TEXT(constRowTopY29, 530, 400, 15, $("#AnnoteSignDT").datebox("getValue"));
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);

    /// 新增拔管模块

    LODOP.ADD_PRINT_RECT(constRowTopY30 + 10, 40, 700, rowHeightNew * 4, 0, 1);

    LODOP.ADD_PRINT_TEXT(constRowTopY31, 50, 60, 15, "拔管：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    LODOP.ADD_PRINT_TEXT(constRowTopY31, 100, 60, 15, "于");
    LODOP.ADD_PRINT_TEXT(constRowTopY31, 130, 120, 15, $("#TubeOutMonthDay").datebox("getValue"));
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY31 + 15, 120, constRowTopY31 + 15, 230, 0, 1);
    LODOP.ADD_PRINT_TEXT(constRowTopY31, 230, 150, 15, "拔除硬膜外导管。");
    LODOP.ADD_PRINT_TEXT(constRowTopY31, 490, 120, 15, "麻醉医生:");
    LODOP.ADD_PRINT_TEXT(constRowTopY31, 570, 200, 15, $("#OutTubeAnaDoctor").val());
    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(constRowTopY31 + 15, 560, constRowTopY31 + 15, 700, 0, 1);

    var IDCheck = CheckBoxValue("OutTubeSucessfully", "拔管顺利，导管完整，穿刺点无异常");
    if (IDCheck == "checked") {
        DrawRectAndRight(LODOP, constRowTopY32, 100);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY32, 100);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY32, 120, 280, 15, "拔管顺利，导管完整，穿刺点无异常。");
    LODOP.ADD_PRINT_TEXT(constRowTopY32, 430, 200, 15, "执行者(医生/护士):");
    LODOP.ADD_PRINT_TEXT(constRowTopY32, 570, 200, 15, $("#OutTubeExcuteDoctorOrNurse").val());
    LODOP.ADD_PRINT_LINE(constRowTopY32 + 15, 560, constRowTopY32 + 15, 700, 0, 1);

    //var OutTubeSpecialDetail=$("#OutTubeSpecialDetail").val();
    var OutTubeSpecialDetail = CheckBoxValue("OutTubeSpecialDetail", "特殊情况处理");
    if (OutTubeSpecialDetail == "checked") {
        DrawRectAndRight(LODOP, constRowTopY33, 100);
    } else {
        DrawRectAndRightNull(LODOP, constRowTopY33, 100);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY33, 120, 280, 15, "特殊情况处理：");

    LODOP.ADD_PRINT_TEXT(constRowTopY33, 220, 280, 30, $("#OutTubeSpecialDetailText").val());

    LODOP.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
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