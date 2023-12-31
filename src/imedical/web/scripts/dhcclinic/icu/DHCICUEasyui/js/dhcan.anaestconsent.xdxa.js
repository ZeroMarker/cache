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

    $("#btnSign,#btnPatSign,#btnAgentSign").linkbutton({
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
    $("#OperDate").text(operApplication.OperDate);
}

function print() {
    var lodop = getLodop();
    createPrintOnePage(lodop, anaestConsent.operSchedule);
    lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();

}

function printNoData() {
    var lodop = getLodop();
    createPrintOnePage(lodop, anaestConsent.operSchedule,true);
    lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();

}

function createPrintOnePage(lodop, operSchedule,nodata) {
    lodop.PRINT_INIT("AnaestConsent"+operSchedule.RowId);
    var prtConfig=sheetPrintConfig,
        logoMargin=prtConfig.logo.margin,
        logoSize=prtConfig.logo.size,
        titleFont=prtConfig.title.font,
        titleSize=prtConfig.title.size,
        titleMargin=prtConfig.title.margin,
        contentSize=prtConfig.content.size,
        contentFont=prtConfig.content.font;
    lodop.SET_PRINT_PAGESIZE(prtConfig.paper.direction, 0, 0, prtConfig.paper.name);
    lodop.SET_PRINT_STYLE("FontSize", contentFont.size);
    lodop.SET_PRINT_STYLE("FontName", contentFont.name);
    lodop.ADD_PRINT_IMAGE(logoMargin.top,logoMargin.left,logoSize.width,logoSize.height,"<img src='"+prtConfig.logo.imgSrc+"'>");
    lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);
    
    var startPos={
        x:prtConfig.paper.margin.left,
        y:logoMargin.top+logoSize.height+logoMargin.bottom
    };
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 620, 30, "麻醉知情同意书");
    lodop.SET_PRINT_STYLEA(0, "FontName", titleFont.name);
    lodop.SET_PRINT_STYLEA(0, "FontSize", titleFont.size);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

    startPos.y+=titleSize.height+titleMargin.bottom;
    var htmlArr=[
              "<style>p {margin:5px auto; font-size:14px;line-height:20px;} .patInfo {margin-right:10px;display:inline-block;border:none;border-bottom:1px solid;height:18px;} .patinfo-title {font-weight:bold} li {font-size:14px;} .title {font-size:14px;font-weight:bold;margin:10px 0 5px 0}</style>",
              "<p><span class='patinfo-title'>姓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名：</span><span class='patinfo' style='width:60px;'>"+(nodata?"":operSchedule.PatName)+"</span>",
              "<span class='patinfo-title'>性别：</span><span class='patinfo' style='width:30px;'>"+(nodata?"":operSchedule.PatGender)+"</span>",
              "<span class='patinfo-title'>年龄：</span><span class='patinfo' style='width:30px;'>"+(nodata?"":operSchedule.PatAge)+"</span>",
              "<span class='patinfo-title'>科室：</span><span class='patinfo' style='width:90px;'>"+(nodata?"":operSchedule.PatDeptDesc)+"</span>",
              "<span class='patinfo-title'>床号：</span><span class='patinfo' style='width:30px;'>"+(nodata?"":operSchedule.PatBedCode)+"</span>",
              "<span class='patinfo-title'>住院号：</span><span class='patinfo' style='width:70px;'>"+(nodata?"":operSchedule.MedcareNo)+"</span></p>",
              "<p><span class='patinfo-title'>术前诊断：</span><span class='patinfo' style='width:580px;'>"+(nodata?"":operSchedule.PrevDiagnosisDesc)+"</span></p>",
              "<p><span class='patinfo-title'>拟施麻醉：</span><span class='patinfo' style='width:580px;'>"+(nodata?"":operSchedule.PrevAnaMethodDesc)+"</span></p>",
              "<p><span class='patinfo-title'>拟施手术：</span><span class='patinfo' style='width:580px;'>"+(nodata?"":operSchedule.OperationDesc)+"</span></p>",
              "<p class='title'>疾病介绍和治疗建议</p>",
              "<div><p>1．麻醉作用的产生主要是利用麻醉药使中枢神经系统或神经系统中某些部位受到抑制的结果。临床麻醉的主要任务是:消除手术疼痛，监测和调控生理功能，保障患者安全，并为手术创造条件。手术是治疗外科疾病的有效方法，但手术引起的创伤和失血可使患者的生理功能处于应激状态；各种麻醉方法和药物对患者的生理功能都有一定影响；外科疾病本身所引起的病理生理改变，以及并存的非外科疾病所导致的器官功能损害等，都是围手术期潜在的危险因素。麻醉的风险性与手术大小并非完全一致，复杂的手术固然可使麻醉的风险性增加，而有时手术并非很复杂，但由于患者的病情和并存疾病的影响，可为麻醉带来更大的风险。</p>",
              "<p>2．为了保证我手术时无痛和医疗安全，手术需要在麻醉和严密监测条件下进行。我有权选择适合我的麻醉方法，但根据我的病情和手术需要，麻醉医师建议我选择以下麻醉方法，必要时允许改变麻醉方式。</p>",
              "<p><input type='checkbox'>全身麻醉；",
              "<input type='checkbox'>全麻+硬膜外麻醉；",
              "<input type='checkbox'>椎管内麻醉；",
              "<input type='checkbox'>神经阻滞；",
              "<input type='checkbox'>局部麻醉+强化；",
              "<input type='checkbox'>其它</p>",
              "<p>3．为了我的手术安全，麻醉医师将严格遵循麻醉操作规范和用药原则；在我手术麻醉期间，麻醉医师始终在现场严密监测我的生命体征，并履行医师职责，对异常情况及时进行治疗和处理。但任何麻醉方法都存在一定风险性，根据目前技术水平尚难以完全避免发生一些医疗意外或并发症。如合并其它疾病，麻醉可诱发或加重已有症状，相关并发症和麻醉风险性也显著增加。</p>",
              "<p>4．为了减轻我术后疼痛，促进康复，麻醉医师向我介绍了术后疼痛治疗的优点、方法和可能引起的意外与并发症，建议我进行术后疼痛治疗。并告知是自愿选择和自费项目。</p>",
              "<p class='title'>麻醉潜在风险和对策</p>",
              "<p>(一)麻醉医师已对我的病情、病史进行了详细询问。我对麻醉医师所告知的、因受医学科学技术条件限制、目前尚难以完全避免的麻醉意外和并发症表示理解。相信麻醉医师会采取积极有效措施加以避免。如果发生紧急情况，医师无法或来不及征得本人或家属意见时，授权麻醉医师按照医学常规予以紧急处理和全力救治。如果所选麻醉方法不能满足手术的需要，授权麻醉医师根据具体情况改变麻醉方式以便顺利完成手术治疗。</p>",
              "<p>(二)我理解麻醉存在以下(但不限于)风险：</p>",
              "<ol><li>与原发病或并存疾病相关：脑出血，脑梗塞，脑水肿；严重心律失常，心肌缺血/梗死，心力衰竭；肺不张，肺水肿，肺栓塞，呼吸衰竭；肾功能障碍或衰竭；术后谵妄，术后认知功能障碍等等。</li>",
              "<li>与药物相关:过敏反应或过敏性休克，局麻药全身毒性反应和神经毒性，严重呼吸和循环抑制，循环骤停，器官功能损害或衰竭，精神异常，恶性高热等。</li>",
              "<li>与不同麻醉方法和操作相关：",
              "<p>1) 神经阻滞：血肿，气胸，神经功能损害，喉返神经麻痹，全脊麻等。</p>",
              "<p>2) 椎管内麻醉：腰背痛，尿失禁或尿潴留，腰麻后头痛，颅神经麻痹，脊神经或脊髓损伤，呼吸和循环抑制，全脊麻甚至循环骤停，硬膜外血肿、脓肿甚至截瘫，穿刺部位或椎管内感染，硬膜外导管滞留或断裂，麻醉不完善或失败等。</p>",
              "<p>3) 全身麻醉：呕吐、误吸，喉痉挛，支气管痉挛，急性上呼吸道梗阻，气管内插管失败，术后咽痛，声带损伤环杓关节脱位，牙齿损伤或脱落，苏醒延迟，术中知晓等。</p></li>",
              "<li>与有创伤性监测相关：局部血肿，纵膈血/气肿，血/气胸，感染，心律失常，血栓形成或肺栓塞，心包填塞，导管打结或断裂，胸导管损伤，神经损伤等。</li>",
              "<li>与输液、输血及血液制品相关：血源性传染病，热源反应，过敏反应，凝血病等。</li>",
              "<li>与外科手术相关：失血性休克，严重迷走神经反射引起的呼吸心跳骤停，压迫心脏或大血管引起的严重循环抑制及其并发症等。</li>",  
              "<li>与急诊手术相关：以上医疗意外和并发症均可发生于急诊手术病人，且发生率较择期手术明显升高。</li>", 
              "<li>与术后镇痛相关：呼吸、循环抑制，恶心呕吐，镇痛不全，硬膜外导管脱出等。<br>一旦发生上述风险和意外，医生会采取积极应对措施。</li></ol>",    
              "<p class='title'>特殊风险或主要高危因素</p>",                                     
              "<p>我理解根据我个人的病情，我可能出现未包括在上述所交待并发症以外的风险：</p>",
              "<p>_______________________________________________________________________________________________</p>",
              "<p>一旦发生上述风险和意外，医生会采取积极应对措施。</p>",
              "<p class='title'>特别提醒</p>",
              "<p>厦门大学附属翔安医院是一所医教研结合的学术医疗中心。可能有实习医师、进修医师、规培医师、研究生，在主治医师的指导下参与患者麻醉。同时，患者用于诊治的组织、血液或其它标本可能用于医院教学和科研。</p>",
              "<p class='title'>患者知情选择</p>",
              "<p><ul><li>麻醉医生已经告知我将要施行的麻醉及麻醉后可能发生的并发症和风险、可能存在的其它麻醉方法并且解答了我关于此次麻醉的相关问题。</li>",
              "<li>我同意在治疗中医生可以根据我的病情对预定的麻醉方式做出调整。</li>",
              "<li>我理解在我的麻醉期间需要多位医生共同进行。</li>",
              "<li>我并未得到治疗百分之百无风险的许诺。</li></ul></p>",
              "<p>患者签名_____________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签名日期______年___月___日</p>",
              "<p>如果患者无法签署知情同意书，请其授权的亲属在此签名：</p>",
              "<p>患者授权亲属签名_____________________&nbsp;&nbsp;与患者关系________&nbsp;&nbsp;签名日期______年___月___日</p>",
              "<p>我同意接受术后疼痛治疗：</p>",
              "<p>患者或患者亲属签名_____________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签名日期______年___月___日</p>",
              "<p class='title'>医生陈述</p>", 
              "<p>我已经告知患者将要施行的麻醉方式、此次麻醉及麻醉后可能发生的并发症和风险、根据手术治疗的需要更改为其他麻醉方法的可能性，并且解答了患者关于此次麻醉的相关问题。</p>",
              "<p>医生签名_____________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签名日期______年___月___日</p></div>"
            ];
    lodop.ADD_PRINT_HTM(startPos.y, startPos.x, contentSize.width, contentSize.height, htmlArr.join(""));
}