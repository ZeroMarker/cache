$(document).ready(function () {
    operDataManager.initFormData(loadApplicationData);
    initPage();
    operDataManager.setCheckChange();
    signCommon.loadSignature();
    operDataManager.disableEditControls("#btnSavePreVisit,#btnPrint,#btnRefresh,#UserName,#Password,#btnSign,#btnExit,#PreOperVisit,#PostOperVisit,#btnPrevSignature,#btnPostvSignature,#PreOperVisitDate,#PostOperVisitDate");
    initLostVisitReason();
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
    //保存术前访视信息
    $("#btnSavePreVisit").linkbutton({
        onClick: function () {
            operDataManager.saveOperDatas();
        }
    });
    //保存术后访视信息
    $("#btnSavePostVisit").linkbutton({
        onClick: function () {
            operDataManager.saveOperDatas();
        }
    });
    //打印
    $("#btnPrint").linkbutton({
        onClick: printOperationVisit
    });

    $("#btnRefresh").linkbutton({
        onClick:function(){
            window.location.reload();
        }
    });

    $("#btnPrevSignature,#btnPostvSignature").linkbutton({
        onClick: function () {
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

function initLostVisitReason(){
    // 如果已有术前术后签名数据，那么术前失访原因和术后失访原因控件置为不可用。
    var signImg=$("#PreOperVisit").attr("src");
    if(!signImg || signImg===""){
        $("#PreLostVisitReason").removeAttr("disabled");
    }
    signImg=$("#PostOperVisit").attr("src");
    if(!signImg || signImg===""){
        $("#PostLostVisitReason").removeAttr("disabled");
    }
}

function showSignImage(imgID, imgData) {
    $("#" + imgID).attr("src", "data:image/png;base64," + imgData);
}

// 获取病人信息
function loadApplicationData(appData) {
    if (appData) {
        $("#PatName").val(appData.PatName);
        $("#PatGender").val(appData.PatGender);
        $("#PatAge").val(appData.PatAge);
        $("#PatDept").val(appData.PatDeptDesc);
        $("#PatWardBed").val(appData.PatBedCode);
        $("#PatMedCareNo").val(appData.MedcareNo);
        $("#PatANMethod").val(appData.PrevAnaMethodDesc);
    }
}

function printOperationVisit() {
    var lodop = getLodop();
    createPrintOnePage(lodop);
    // lodop.PREVIEW();
    lodop.PRINT();
}

function createPrintOnePage(lodop) {
    lodop.PRINT_INIT("OperationVisit" + session.OPSID);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontName", "宋体");
    lodop.SET_PRINT_STYLE("FontSize", 13);

    lodop.ADD_PRINT_TEXT(40, 220, 350, 30, "山西省肿瘤医院手术患者访视单");
    lodop.SET_PRINT_STYLEA(1, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(1, "Bold", 1);
    lodop.SET_PRINT_STYLEA(1, "AlignJustify", 1);

    lodop.ADD_PRINT_TEXT(80, 100, 200, 15, "术前访视内容：");
    lodop.SET_PRINT_STYLEA(2, "FontSize", 14);

    lodop.ADD_PRINT_TEXT(120, 100, 200, 15, "科室");
    lodop.ADD_PRINT_LINE(140, 140, 140, 280, 0, 1);
    lodop.ADD_PRINT_TEXT(120, 140, 200, 15, $("#PatDept").val());

    lodop.ADD_PRINT_TEXT(120, 300, 200, 15, "床号");
    lodop.ADD_PRINT_LINE(140, 340, 140, 400, 0, 1);
    lodop.ADD_PRINT_TEXT(120, 340, 200, 15, $("#PatWardBed").val());

    lodop.ADD_PRINT_TEXT(120, 420, 200, 15, "姓名");
    lodop.ADD_PRINT_LINE(140, 460, 140, 540, 0, 1);
    lodop.ADD_PRINT_TEXT(120, 460, 200, 15, $("#PatName").val());

    lodop.ADD_PRINT_TEXT(120, 560, 200, 15, "性别");
    lodop.ADD_PRINT_LINE(140, 600, 140, 680, 0, 1);
    lodop.ADD_PRINT_TEXT(120, 600, 200, 15, $("#PatGender").val());

    lodop.ADD_PRINT_TEXT(160, 100, 200, 15, "年龄");
    lodop.ADD_PRINT_LINE(180, 140, 180, 220, 0, 1);
    lodop.ADD_PRINT_TEXT(160, 140, 200, 15, $("#PatAge").val());

    lodop.ADD_PRINT_TEXT(160, 240, 200, 15, "住院号");
    lodop.ADD_PRINT_LINE(180, 300, 180, 400, 0, 1);
    lodop.ADD_PRINT_TEXT(160, 300, 200, 15, $("#PatMedCareNo").val());

    lodop.ADD_PRINT_TEXT(160, 420, 200, 15, "手术史");
    lodop.ADD_PRINT_TEXT(160, 480, 200, 15, "无");
    lodop.ADD_PRINT_RECT(160, 500, 15, 15, 0, 1);
    lodop.ADD_PRINT_TEXT(160, 500, 200, 15, $("#OperHistCheckBox1").checkbox("getValue") === true ? "√" : "");
    lodop.ADD_PRINT_TEXT(160, 520, 200, 15, "有");
    lodop.ADD_PRINT_RECT(160, 540, 15, 15, 0, 1);
    lodop.ADD_PRINT_TEXT(160, 540, 200, 15, $("#OperHistCheckBox2").checkbox("getValue") === true ? "√" : "");
    lodop.ADD_PRINT_LINE(180, 560, 180, 680, 0, 1);
    lodop.ADD_PRINT_TEXT(160, 560, 200, 15, $("#OperationHistoryText").val());
    //lodop.PRINT_DESIGN();

    lodop.ADD_PRINT_TEXT(200, 100, 200, 15, "过敏史");
    lodop.ADD_PRINT_TEXT(200, 160, 200, 15, "无");
    lodop.ADD_PRINT_RECT(200, 180, 15, 15, 0, 1);
    lodop.ADD_PRINT_TEXT(200, 180, 200, 15, $("#AllergicHistoryCHK1").checkbox("getValue") === true ? "√" : "");
    lodop.ADD_PRINT_TEXT(200, 200, 200, 15, "有");
    lodop.ADD_PRINT_RECT(200, 220, 15, 15, 0, 1);
    lodop.ADD_PRINT_TEXT(200, 220, 200, 15, $("#AllergicHistoryCHK2").checkbox("getValue") === true ? "√" : "");
    lodop.ADD_PRINT_LINE(220, 240, 220, 400, 0, 1);
    lodop.ADD_PRINT_TEXT(200, 240, 200, 15, $("#AllergicHistoryText").val());

    lodop.ADD_PRINT_TEXT(200, 420, 200, 15, "麻醉方式");
    lodop.ADD_PRINT_LINE(220, 500, 220, 680, 0, 1);
    lodop.ADD_PRINT_TEXT(200, 500, 200, 15, $("#PatANMethod").val());

    lodop.ADD_PRINT_TEXT(240, 100, 200, 15, "核对患者：");
    lodop.ADD_PRINT_RECT(240, 200, 15, 15, 0, 1);
    lodop.ADD_PRINT_TEXT(240, 200, 200, 15, $("#CheckPatNotice").prop("checked") == true ? "√" : "");
    lodop.ADD_PRINT_TEXT(240, 220, 200, 15, "通知单");
    lodop.ADD_PRINT_RECT(240, 280, 15, 15, 0, 1);
    lodop.ADD_PRINT_TEXT(240, 280, 200, 15, $("#CheckPatMedicalRecord").prop("checked") == true ? "√" : "");
    lodop.ADD_PRINT_TEXT(240, 300, 200, 15, "病历");
    lodop.ADD_PRINT_RECT(240, 340, 15, 15, 0, 1);
    lodop.ADD_PRINT_TEXT(240, 340, 200, 15, $("#CheckPatWristband").prop("checked") == true ? "√" : "");
    lodop.ADD_PRINT_TEXT(240, 360, 200, 15, "患者腕带");
    lodop.ADD_PRINT_RECT(240, 440, 15, 15, 0, 1);
    lodop.ADD_PRINT_TEXT(240, 440, 200, 15, $("#CheckPatOPSite").prop("checked") == true ? "√" : "");
    lodop.ADD_PRINT_TEXT(240, 460, 200, 15, "手术部位");

    lodop.ADD_PRINT_TEXT(280, 100, 200, 15, "化验单：");
    lodop.ADD_PRINT_RECT(280, 200, 15, 15, 0, 1);
    lodop.ADD_PRINT_TEXT(280, 200, 200, 15, $("#LabSheetCHK1").checkbox("getValue") === true ? "√" : "");
    lodop.ADD_PRINT_TEXT(280, 220, 200, 15, "齐全");
    lodop.ADD_PRINT_RECT(280, 280, 15, 15, 0, 1);
    lodop.ADD_PRINT_TEXT(280, 280, 200, 15, $("#LabSheetCHK2").checkbox("getValue") === true ? "√" : "");
    lodop.ADD_PRINT_TEXT(280, 300, 200, 15, "不齐全");

    lodop.ADD_PRINT_TEXT(320, 100, 600, 15, "为了您的手术顺利实施，请您协助我们做以下工作：");
    lodop.ADD_PRINT_TEXT(360, 100, 600, 15, "1、术前请排空大、小便，不要穿自己的衣服，卧床静候");
    lodop.ADD_PRINT_TEXT(400, 100, 600, 15, "2、请取掉饰物及金属物品、假牙、隐形眼镜，不要化妆");
    lodop.ADD_PRINT_TEXT(440, 100, 600, 15, "3、不要携带钱和贵重物品进入手术室");
    lodop.ADD_PRINT_TEXT(480, 100, 650, 15, "4、当患者进入手术室后，请家属在'家属等候区'安静等候，请勿在手术室门口滞留，必要时我们会用语音系统告知相关情况");
    lodop.ADD_PRINT_TEXT(520, 120, 600, 15, "必要时我们会用语音系统告知相关情况");
    lodop.ADD_PRINT_TEXT(560, 100, 600, 15, "5、进入手术室后需为您进行以下操作，请您配合：");
    lodop.ADD_PRINT_TEXT(600, 100, 600, 15, "安全核查、安全固定、静脉输液、麻醉、导尿、安置手术体位等，");
    lodop.ADD_PRINT_TEXT(640, 100, 600, 15, "如有特殊需求请您告知我们，我们会尽量满足。");

    lodop.ADD_PRINT_TEXT(680, 100, 200, 15, "访视护士签名：");
    lodop.ADD_PRINT_LINE(700, 220, 700, 300, 0, 1);
    lodop.ADD_PRINT_IMAGE(660, 210, "100%", "100%", $("#PrevSignature").attr("src"));

    lodop.ADD_PRINT_TEXT(680, 320, 200, 15, "访视日期：");
    lodop.ADD_PRINT_LINE(700, 400, 700, 500, 0, 1);
    lodop.ADD_PRINT_TEXT(680, 400, 200, 15, $("#PreOperVisitDate").datebox("getValue"));

    lodop.ADD_PRINT_TEXT(720, 100, 200, 15, "回访护士签名：");
    lodop.ADD_PRINT_LINE(740, 220, 740, 300, 0, 1);
    lodop.ADD_PRINT_IMAGE(700, 210, "100%", "100%", $("#PostvSignature").attr("src"));

    lodop.ADD_PRINT_TEXT(720, 320, 200, 15, "回访日期：");
    lodop.ADD_PRINT_LINE(740, 400, 740, 500, 0, 1);
    lodop.ADD_PRINT_TEXT(720, 400, 200, 15, $("#PostOperVisitDate").datebox("getValue"));
}