var anaestConsent = {
    operSchedule: null
};

$(document).ready(function() {
    operDataManager.initFormData(loadApplicationData);
    initPage();
    operDataManager.setCheckChange();
    initPatSign();
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

    $("#btnRefresh").linkbutton({
        onClick: function() {
            window.location.reload();
        }
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

    $("#btnPatSign,#btnAgentSign").linkbutton({
        onClick: function() {
            var signCode = $(this).attr("data-signcode");
            var signParam = {
                plainText: "test",
                RecordSheet: session.RecordSheetID,
                SignCode: signCode,
                loadImage: function(signImage, fingerImage) {
                    if (signImage) {
                        var signImageSrc = "data:image/gif;base64," + signImage;
                        switch (signCode) {
                            case "PatSign":
                                $("#PatSignImage").attr("src", signImageSrc);
                                break;
                            case "AgentSign":
                                $("#AgentSignImage").attr("src", signImageSrc);
                                break;
                        }
                    }

                    if (fingerImage) {
                        var fingerImageSrc = "data:image/gif;base64," + fingerImage;
                        switch (signCode) {
                            case "PatSign":
                                $("#PatSignFingerImage").attr("src", fingerImageSrc);
                                break;
                            case "AgentSign":
                                $("#AgentSignFingerImage").attr("src", fingerImageSrc);
                                break;
                        }
                    }
                }
            }

            handSign.sign(signParam);
        }
    });

    $("#btnPatOpinionSign").linkbutton({
        onClick: function() {
            var signCode = $(this).attr("data-signcode");
            var signParam = {
                RecordSheet: session.RecordSheetID,
                SignCode: signCode,
                loadImage: function(signImage) {
                    if (signImage) {
                        var signImageSrc = "data:image/gif;base64," + signImage;
                        $("#PatOpinionSignImage").attr("src", signImageSrc);
                    }
                }
            }

            handSign.signOpinion("患方意见", signParam);
        }
    })
}

/**
 * 初始化患者/家属签名图片
 */
function initPatSign() {
    handSign.loadImage(session.RecordSheetID, "PatSign,AgentSign");
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

function createPrintOnePage(lodop, operSchedule) {
    lodop.PRINT_INIT("打印麻醉记录单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontSize", 11);
    //lodop.ADD_PRINT_TEXT(30, -105, 620, 30, "东华标准版数字化医院");
    lodop.ADD_PRINT_TEXT(30, 60, 620, 30, session.ExtHospDesc || "");
    lodop.SET_PRINT_STYLEA(0, "FontName", "宋体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Bold",1);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);

    lodop.ADD_PRINT_TEXT(60, 60, 620, 30, "麻醉知情同意书");
    lodop.SET_PRINT_STYLEA(0, "FontName", "宋体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Bold",1);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);

    // lodop.ADD_PRINT_LINE(50, 90, 50, 741, 0, 2);
    // lodop.ADD_PRINT_LINE(20, 80, 1060, 80, 0, 1);

    var linePaddingTop = 16,
        linePaddingRight = 5,
        textMarginLeft = 60;
    var width = 50,
        height = 30;
    var startPos = {
        x: textMarginLeft,
        y: 100
    }
    width = 45;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 65, 15, "姓名：");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 70, 15, operSchedule.PatName);
    //lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 55, 15, "性别：");
    startPos.x += width;
    width = 30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 50, 15, operSchedule.PatGender);
    //lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 45;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 55, 15, "年龄：");
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 60, 15, operSchedule.PatAge);
    //lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 45;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 55, 15, "科室：");
    startPos.x += width;
    width = 150;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 180, 15, operSchedule.PatDeptDesc);
    //lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 45;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 55, 15, "床号：");
    startPos.x += width;
    width = 55;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 80, 15, operSchedule.PatBedCode);
    //lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 55;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 75, 15, "住院号：");
    startPos.x += width;
    width = 70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 80, 15, operSchedule.MedcareNo);
    //lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    var padding = {
        top: 8,
        left: 5
    }
    startPos.x = textMarginLeft;
    startPos.y += height;
    width = 120;
    height = 30;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, height, 2, 1);
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, 660, 893, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, 120, 15, "术前诊断");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);

    startPos.x += width;
    width = 540;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, height, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, 540, 15, operSchedule.PrevDiagnosisDesc);

    startPos.x = textMarginLeft;
    startPos.y += height;
    width = 120;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, height, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, 120, 15, "拟行手术方案");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);

    startPos.x += width;
    width = 240;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, height, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, 240, 15, operSchedule.PlanOperDesc);

    startPos.x += width;
    width = 120;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, height, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, 120, 15, "拟行麻醉");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);

    startPos.x += width;
    width = 180;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, height, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, 180, 15, operSchedule.PrevAnaMethodDesc);

    startPos.x = textMarginLeft;
    startPos.y += height;
    width = 660;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, height, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, 660, 15, "麻醉前访（发现的特殊情况）：");

    startPos.x = textMarginLeft;
    startPos.y += height;
    width = 660;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, 30, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, 355, 660, 15, "麻 醉 意 外");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 13);

    padding.left = 25;
    width = 660;
    padding.top = 40;
    //lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, 150, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "1.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left - 35, 20, "根据麻醉操作常规，按照药品使用说明使用各类麻醉药品后，病人仍出现中毒，过敏或高敏");
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "反应，甚至危及生命。");
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "2.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left - 33, 20, "全身麻醉时，特别是对急症饱腹病人，麻醉前已采取力所能及的预防措施,但仍不能");
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "完全避免发生呕吐、返流、误吸甚至窒息死亡。");
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "3.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left - 34, 20, "在基础麻醉或椎管阻滞麻醉时，使用规定剂量的麻醉药品，仍出现呼吸抑制、血压下");
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "降或麻醉平面过高，虽经积极抢救，仍出现不良后果。");
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "4.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "其他：");

    startPos.x = textMarginLeft;
    startPos.y += 60;
    width = 660;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, height, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + 10, 343, 660, 15, "麻 醉 并 发 症");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 13);

    padding.left = 25;
    width = 660;
    padding.top = 40;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, height, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "1.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left - 40, 20, "全身麻醉气管插管过程中，虽按常规操作，仍有可能发生牙齿脱落、鼻出血、唇");
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left - 35, 20, "出血、喉痉挛、喉头水肿、声带损伤、 杓状软骨脱位、支气管痉挛等不良后果。");
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);

    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "2.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left - 40, 20, "全身麻醉后，出现恶性高热、肌松剂敏感致长时间无呼吸、苏醒延迟，积极");
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "抢救后仍出现不良后果。");
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "3.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left - 20, 20, "围术期进行麻醉深度，有创动静脉检测时可能发生局部皮肤过敏，损");
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "血管损伤、血肿、血气胸、空气栓塞、感染等");
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "4.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left - 20, 20, "麻醉手术期间可能发生低血压、高血压、脑血管意外、心律失常、心肌梗塞、肺栓塞、循");
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "环衰竭、呼吸衰竭、 心脏骤停等。");

    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "至截瘫致残等不良后果。");
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "5.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "麻醉手术中发生过敏。输血、输液不良反应，水、电解质及酸碱平衡紊乱。");
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "6.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "神经阻滞麻醉导致局部血肿、血气胸、神经损伤等。");
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "7.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left - 20, 20, "椎管内麻醉，按操作规程进行脊椎穿刺、置管、注射麻醉药物后，发生全脊麻；");
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left - 20, 20, "术后发生腰背痛、头痛、硬脊膜外血肿； 神经损伤、尿潴留、甚");
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "8.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left - 35, 20, "椎管内麻醉穿刺或局麻时，已严格按常规消毒操作，仍发生注射或穿刺部");
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "9.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "麻醉手术可能诱发和加重已有的合并症，导致组织器官功能衰竭。");
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "10.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "麻醉后出现恶心、呕吐、多汗、寒战、躁动、惊厥等。");
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "11.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "急诊手术时发生各种意外及并发症的可能性明显增加。");
    startPos.y += 20;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + 5, "100%", 20, "12.");
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left, 20, "其他：");

    startPos.x = textMarginLeft;
    startPos.y += 80;
    padding.top = 50;
    width = 660;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, height, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + 10, 100, 660, 15, "  提 示：手 术 后 为 策 安 全，进 入 麻 醉 恢 复 室 恢 复。");

    startPos.y += height;
    startPos.x = textMarginLeft;
    padding.left = 20;
    padding.top = 8;
    width = 660;
    height = 80;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, height, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left + 10, 40, "    并发症及意外事故有其不可预见性，不可能在此逐一例举，拟定麻醉方法根据实际麻醉和手术需要有可能临时更改。 如对以上各项表示理解并同意麻醉，请履行签字手续。");
    startPos.y += 50;
    startPos.x = 350;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x, "100%", 20, "姓名：");
    var patSignImage = $("#PatSignImage").attr("src");
    var patSignFingerImage = $("#PatSignFingerImage").attr("src");
    if (patSignImage) lodop.ADD_PRINT_IMAGE(startPos.y, startPos.x + 25, 80, 40, "<img src='" + patSignImage + "'>");
    if (patSignFingerImage) lodop.ADD_PRINT_IMAGE(startPos.y, startPos.x + 105, 80, 40, "<img src='" + patSignFingerImage + "'>");
    startPos.x += 180;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x, "100%", 20, "与患者关系：");

    startPos.y += 30;
    startPos.x = textMarginLeft;
    height = 93;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, width, height, 2, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x + padding.left, width - padding.left + 10, 40, "    术后镇痛：为尽量减轻患者术后的伤口疼痛，我们可为患者提供术后止痛泵镇痛服务，如有需要请签字。");
    startPos.y += 50;
    startPos.x = 350;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x, "100%", 20, "姓名：");
    var agentSignImage = $("#AgentSignImage").attr("src");
    var agentSignFingerImage = $("#AgentSignFingerImage").attr("src");
    if (agentSignImage) lodop.ADD_PRINT_IMAGE(startPos.y, startPos.x + 25, 80, 40, "<img src='" + agentSignImage + "'>");
    if (agentSignFingerImage) lodop.ADD_PRINT_IMAGE(startPos.y, startPos.x + 105, 80, 40, "<img src='" + agentSignFingerImage + "'>");
    startPos.x += 180;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x, "100%", 20, "与患者关系：");

    startPos.y += 50;
    startPos.x = 350;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x, "100%", 20, "麻醉医师：");
    startPos.x += 180;
    lodop.ADD_PRINT_TEXT(startPos.y + padding.top, startPos.x, "100%", 20, "日期：");
}