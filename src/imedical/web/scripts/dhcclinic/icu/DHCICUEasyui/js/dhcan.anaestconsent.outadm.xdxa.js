var anaestConsent = {
    operSchedule: null
};

$(document).ready(function() {
    operDataManager.initFormData(loadApplicationData);
    initPage();
    operDataManager.setCheckChange();
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
	
	$("#btnPrintNoData").linkbutton({
        onClick: printNoData
    });

    $("#btnRefresh").linkbutton({
        onClick: function() {
            window.location.reload();
        }
    });

    $("#btnSign,#btnPatSign").linkbutton({
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
    anaestConsent.operSchedule = operApplication;
    $("#PatName").text(operApplication.PatName);
    $("#PatGender").text(operApplication.PatGender);
    $("#PatAge").text(operApplication.PatAge);
    $("#PatDeptDesc").text(operApplication.PatDeptDesc);
    $("#PatBedCode").text(operApplication.PatBedCode);
    $("#MedcareNo").text(operApplication.MedcareNo);
    $("#PlanOperationDesc").text(operApplication.OperInfo);
    $("#PrevDiagnosisDesc").text(operApplication.PrevDiagnosisDesc);
    $("#PrevAnaMethodDesc").text(operApplication.PrevAnaMethodDesc);
}

function print() {
    var lodop = getLodop();
    createPrintOnePage(lodop, anaestConsent.operSchedule);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();

}

function printNoData() {
    var lodop = getLodop();
    createPrintOnePage(lodop, anaestConsent.operSchedule,true);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();

}

function createPrintOnePage(lodop, operSchedule,nodata) {
    lodop.PRINT_INIT("AnaestConsent"+operSchedule.RowId);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontSize", 10);
    lodop.ADD_PRINT_IMAGE(30,200,800,140,"<img src='../service/dhcanop/css/images/logoxa.png' width='800' height='140'>");
    // lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    // lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
    // lodop.ADD_PRINT_TEXT(30, -105, 620, 30, "厦门大学附属翔安医院");
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    // lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    

    lodop.ADD_PRINT_TEXT(110, 333, 620, 30, "非住院患者麻醉知情同意书");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    // lodop.ADD_PRINT_LINE(50, 90, 50, 741, 0, 2);
    // lodop.ADD_PRINT_LINE(20, 80, 1060, 80, 0, 1);

    var linePaddingTop = 16,
        linePaddingRight = 5,
        textMarginLeft = 30;
    var width = 50,
        height = 30;
    var startPos = {
        x: textMarginLeft,
        y: 170
    }
    width = 65;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "病人ID号");
    startPos.x += width;
    width = 100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, (nodata===true)?"":operSchedule.RegNo);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    width = 50;
    startPos.x+=420;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "住院号");
    startPos.x += width;
    width = 100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, (nodata===true)?"":operSchedule.MedcareNo);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    width=35;
    startPos.x=textMarginLeft;
    startPos.y+=height;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 45, 15, "姓名");
    startPos.x += width;
    width = 80;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 70, 15, (nodata===true)?"":operSchedule.PatName);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 45, 15, "性别");
    startPos.x += width;
    width = 30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 50, 15, (nodata===true)?"":operSchedule.PatGender);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 45, 15, "年龄");
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 60, 15, (nodata===true)?"":operSchedule.PatAge);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 45, 15, "科室");
    startPos.x += width;
    width = 150;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 180, 15, (nodata===true)?"":operSchedule.PatDeptDesc);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 45, 15, "床号");
    startPos.x += width;
    width = 70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 80, 15, (nodata===true)?"":operSchedule.PatBedCode);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x += width;
    // width = 45;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 60, 15, "住院号");
    // startPos.x += width;
    // width = 70;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 80, 15, operSchedule.MedcareNo);
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    var padding = {
        top: 8,
        left: 5
    }
    startPos.x = textMarginLeft;
    startPos.y += height;
    width = 65;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "术前诊断");

    startPos.x += width;
    width = 595;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, (nodata===true)?"":operSchedule.PrevDiagnosisDesc);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x = textMarginLeft;
    startPos.y += height;
    width = 65;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "拟施手术");

    startPos.x += width;
    width = 595;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, (nodata===true)?"":operSchedule.OperInfo);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x = textMarginLeft;
    startPos.y += height;
    width = 65;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "拟施麻醉");

    startPos.x += width;
    width = 595;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, (nodata===true)?"":operSchedule.PrevAnaMethodDesc);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x = textMarginLeft;
    startPos.y += height;
    width = 720;

    var htmlArr=[
              "<style>p {margin:10px auto; font-size:15px;line-height:20px;} </style>",
              "<div style='text-indent:2em'><p>由于手术、检查、治疗的需要，为了减轻患者痛苦，促进患者的配合，使手术、检查、治疗能顺利地进行，患者及其家属要求实施麻醉。但任何麻醉均具有风险，在根据患者病情，切实做好麻醉前准备，按麻醉操作技术规范认真做好麻醉及防范措施的情况下，仍有可能发生以下难以避免的麻醉意外及并发症：</p>",
              "<p>1.原发病或/及伴发病（如高血压、冠心病及糖尿病等）重要脏器疾患，可能导致脑血管意外、急性心梗、严重心律失常或脏器功能衰竭等发生，甚至死亡。</p>",
              "<p>2.患者因个体差异等特殊情况对麻醉或其他药物发生过敏、中毒等不良反应，导致休克、心跳呼吸骤停、脑死亡、严重多脏器功能损害。</p>",
              "<p>3.围术期发生恶心、呕吐、返流、误吸、喉水肿、喉痉挛、气道梗阻导致窒息。</p>",
              "<p>4.呼吸抑制、肺部感染、严重心律失常等导致心肺功能障碍、衰竭。</p>",
              "<p>5.因麻醉加重已有的疾病或诱发隐匿性疾病，如哮喘、心脑血管意外等。</p>",
              "<p>6.全麻和抢救气管插管时发生插管困难、插管失败、牙齿脱落、唇、舌、喉、气管等损伤、喉水肿、声嘶、全麻后苏醒延迟。</p>",
              "<p>7.有关麻醉药物的副反应。</p>",
              "<p>8.其他难以预料的并发症和意外。</p>",
              "<p>我科麻醉医师将以良好的医德医术为患者实施麻醉，力争将麻醉风险降低到最低限度。如果换房隐瞒病情（如饮水、呕吐/胃潴留、呕血、器质性心肺疾病史）及实际情况，后果自负。</p>",
              "<p>上述情况医师已讲明，并对患方提出的问题又作了详细的解答，经慎重考虑，患者及家属对麻醉可能出现的风险表示充分的理解，并要求实施麻醉，签字为证。</p>",
              "<p style='margin-top:50px;'>患者(授权委托人)签字：________________&nbsp;&nbsp;&nbsp;&nbsp;关系:_________</p>",
              "<p style='margin-top:50px;'>麻醉医生签字：_______________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;时间：______年___月___日___时___分</p></div>",
            ];
    lodop.ADD_PRINT_HTM(startPos.y, startPos.x, width, "100%", htmlArr.join(""));
}