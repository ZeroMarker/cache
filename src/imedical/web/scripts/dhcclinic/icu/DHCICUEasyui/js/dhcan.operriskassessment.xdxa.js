var operRiskAssessment={
    operSchedule:null
};
$(document).ready(function() {
    operDataManager.initFormData(loadApplicationData,calcRiskScore);
    initPage();
    operDataManager.setCheckChange();
    calcRiskScore();
    signCommon.loadSignature();
});

function initPage(){
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
        }
    });
    $("#btnPrint").linkbutton({
        onClick: printOperRiskAssessment
    });

    $("#btnRefresh").linkbutton({
        onClick:function(){
            window.location.reload();
        }
    });

    $("#btnPreanSurgeonSign,#btnPreanAnesthetistSign,#btnPreanOperNurseSign").linkbutton({
        onClick: function () {
            var dataIntegrity=operDataManager.isDataIntegrity(".operdata");
            if(dataIntegrity===false){
                $.messager.alert("提示","数据不完整，不能签名。","warning");
                return;
            }
            var signCode = $(this).attr("data-signcode");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode,
                printCallBack:printOperRiskAssessmentPDF
            });
            signView.initView();
            signView.open();
        }
    });
}

function calcRiskScore(){
    var bladeScore=Number($("#OpBladeClean").attr("data-score"));
    var asaClassScore=Number($("#ASAClass").attr("data-score"));
    var durationScore=Number($("#OpDurationTimes").attr("data-score"));
    $("#OpBladeCleanScore").text((bladeScore>0)?bladeScore:0);
    $("#ASAClassScore").text((asaClassScore>0)?asaClassScore:0);
    $("#OpDurationTimesScore").text((durationScore>0)?durationScore:0);
    // if(!isNaN(bladeScore)){
    //     $("#OpBladeCleanScore").text(bladeScore);
    // }
    // if(!isNaN(asaClassScore)){
    //     $("#ASAClassScore").text(asaClassScore);
    // }
    // if(!isNaN(durationScore)){
    //     $("#OpDurationTimesScore").text(durationScore);
    // }
    if(!isNaN(bladeScore) || !isNaN(asaClassScore) || !isNaN(durationScore)){
        $("#SumScore").text(((!isNaN(bladeScore)?bladeScore:0)+(!isNaN(asaClassScore)?asaClassScore:0)+(!isNaN(durationScore)?durationScore:0)));
    }else{
        $("#SumScore").text("");
    }
}

function setPrintCheckBox(){
    $("input[type='checkbox']").each(function(index,el){
        var printSelector="#"+$(this).attr("id")+"_Print";
        if($(printSelector).length<=0 || $(printSelector).hasClass("print-novalue")) return;
        //$(printSelector).addClass("print-checkbox-print");
        $(printSelector).text($(this).checkbox("getValue")?"√":"");
        if($(this).checkbox("getValue"))$(printSelector).addClass('print-checkbox-checked');
    });
}

function loadApplicationData(appData) {
    // $("#patientForm").form("load", operApplicationInfo[0]);
    if(!appData) return;
    operRiskAssessment.operSchedule=appData;
    $("#OperDate").text(appData.OperDate);
    $("#PatDeptDesc").text(appData.PatDeptDesc);
    $("#PatName").text(appData.PatName);
    $("#MedcareNo").text(appData.MedcareNo);
    $("#OperationDesc").text(appData.PlanOperationDesc);
}

function printOperRiskAssessment() {
    // var dataIntegrity=operDataManager.isDataIntegrity(".operdata");
    // if(dataIntegrity===false){
    //     $.messager.alert("提示","手术风险评估数据不完整，不能打印。","warning");
    //     return;
    // }
    operDataManager.printCount(session.RecordSheetID,session.ModuleCode,true);
    operDataManager.reloadPatInfo(loadApplicationData);
    var lodop = getLodop();
    lodop.PRINT_INIT("OperRiskAssessment" + session.OPSID);
    // lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    var printCount;
    if(lodop.SET_PRINTER_INDEXA(PrintSetting.PrintPaper.Printer))
    {
        createPrintOnePage(lodop,operRiskAssessment.operSchedule);
        lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
        printCount=lodop.PREVIEW();

    }else{
        createPrintOnePage(lodop,operRiskAssessment.operSchedule);
        lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
        printCount=lodop.PREVIEW();
    }
    if(printCount>0){
        operDataManager.savePrintLog(session.RecordSheetID,session.ModuleCode,session.UserID);
    }
    
    // createPrintOnePage(lodop);
    // lodop.PREVIEW();

}

function printOperRiskAssessmentPDF(){
    // operDataManager.reloadPatInfo(loadApplicationData);
    // // var surgeonSignImg=$("#PreanSurgeonSign").attr("src");
    // // var nurseSignImg=$("#PreanOperNurseSign").attr("src");
    // // var anaSignImg=$("#PreanAnesthetistSign").attr("src");
    // // var hasAllSigned=(surgeonSignImg && surgeonSignImg!=="" && nurseSignImg && nurseSignImg!=="" && anaSignImg && anaSignImg!=="");
    // // if (!hasAllSigned) return;
    // var lodop = getLodop();
    // lodop.SET_PRINT_PAGESIZE(1,0,0,PrintSetting.AuditSign.Paper);
    // createPrintOnePage(lodop);
    // FTPWeb.initOptions({
    //     lodop:lodop,
    //     printer:PrintSetting.AuditSign.Printer,
    //     fileName:"OperRiskAssessment"+session.OPSID,
    //     operDate:$("#OperDate").text(),
    //     opsId:session.OPSID
    // });
    // FTPWeb.uploadFiles();
}

function createPrintOnePage(lodop,operSchedule) {    
    var config=sheetPrintConfig;
    var imgWidth=config.logo.imgWidth;
    var imgHeight=config.logo.imgHeight;
    var imgTop=config.logo.imgTop;
    var imgLeft=config.logo.imgLeft;
    var top=config.paper.margin.top;
    var left=config.paper.margin.left;

    var printSettings={
        top:50,
        left:35,
        lineHeight:25,
        checkLineHeight:28,
        titleHeight:45,
        titleRectHeight:30,
        logoMaginBottom:10,
        contentAreaWidth:681,
        columnWidth:227,
        contentTop:105
    };

    var pos={
        base:{x:printSettings.left,y:printSettings.contentTop},
        start:{x:printSettings.left,y:printSettings.contentTop}
    };
    
    lodop.ADD_PRINT_IMAGE(imgTop,imgLeft,imgWidth,imgHeight,"<img src='"+config.logo.imgSrc+"' >");
    lodop.SET_PRINT_STYLEA(0, "Stretch", 2);

    lodop.SET_PRINT_STYLE("FontSize", 11);
    // lodop.ADD_PRINT_IMAGE("2cm","5cm",800,140,"<img src='"+sheetPrintConfig.logo.imgSrc+"' width='800'>");
    // lodop.SET_PRINT_STYLEA(0, "Stretch", 2);

    lodop.ADD_PRINT_TEXT(pos.start.y, pos.start.x, "100%", 60, "手术风险评估表");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 18);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);
    pos.start.y+=printSettings.titleHeight;
    
    lodop.ADD_PRINT_TEXT(pos.start.y, "1.5cm", 200, 15, "姓名："+$("#PatName").text());
    lodop.ADD_PRINT_TEXT(pos.start.y, "5.0cm", 200, 15, "性别："+operSchedule.PatGender);
    lodop.ADD_PRINT_TEXT(pos.start.y, "7.0cm", 200, 15, "年龄："+operSchedule.PatAge);
    lodop.ADD_PRINT_TEXT(pos.start.y, "9.5cm", 200, 15, "科室："+$("#PatDeptDesc").text());
    lodop.ADD_PRINT_TEXT(pos.start.y, "14.0cm", 200, 15, "床号："+operSchedule.PatBedCode);
    lodop.ADD_PRINT_TEXT(pos.start.y, "16.0cm", 200, 15, "住院号："+$("#MedcareNo").text());
    pos.start.y+=printSettings.lineHeight;
    lodop.ADD_PRINT_TEXT(pos.start.y, "1.5cm", 200, 15, "日期："+$("#OperDate").text());
    lodop.ADD_PRINT_TEXT(pos.start.y, "5.0cm", "100%", 30, "实施手术："+$("#OperationDesc").text());

    pos.start.y+=printSettings.lineHeight+10;
    // setPrintCheckBox();
    // var html="<html><head>"+$("head").html();
    // html+="<style> .hisui-linkbutton,.hisui-checkbox,.hischeckbox_square-blue,.textbox {display:none}";
    // html+="img.signature {border:none;}"
    // html+=".print-checkbox {font-size:22px; width:10px;height: 10px;border: 2px solid #000;display: inline-block;text-align: center;line-height: 10px;}"
    // html+=".print-checkbox-checked {font-size:16px; width:10px;height: 10px;border: 2px solid #000;display: inline-block;text-align: center;line-height: 10px; font-weight: bold;}</style></head>"
    // html+="<body style='font-size:14px;'>"+$("#riskAssessmentRecord").html()+"</body></html>";
    
    // lodop.ADD_PRINT_HTM(pos.start.y,"0.5cm","RightMargin:0.5cm","BottomMargin:"+config.margin.bottom,html);

    var htmlArr=[
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size: 14px;} td {padding:8px;}", 
        ".checkbox-item {margin: 0 10px;}</style>",
        "<table style='width:670px;'><thead><tr style='height:30px;'><th colspan='2' style='width:220px'>1.手术切口清洁程度</th><th colspan='2' style='width:200px'>2.麻醉分级(ASA分级)</th><th colspan='2'>3.手术持续时间</th></tr></thead>",
        "<tbody><tr><td style='width:180px'><input type='checkbox' "+(($("#OpBladeCleanCHK1").checkbox("getValue")===true)?"checked":"")+">I类手术切口(清洁手术)</td><td style='width:20px'>0</td>",
        "<td style='width:180px'><input type='checkbox' "+(($("#ASAClassCHK1").checkbox("getValue")===true)?"checked":"")+">P1:正常的患者:除局部病变外,无系统性病变</td><td style='width:20px'>0</td>",
        "<td style='width:180px'><input type='checkbox' "+(($("#OpDurationTimesCHK1").checkbox("getValue")===true)?"checked":"")+">T1:手术在3小时内完成</td><td style='width:20px'>0</td></tr>",
        "<tr><td style='width:220px' colspan='2'>手术野无污染；手术切口周边无炎症；患者没有进行气道、食道和/或尿道插管；患者没有意识障碍。</td>",
        "<td style='width:180px'><input type='checkbox' "+(($("#ASAClassCHK2").checkbox("getValue")===true)?"checked":"")+">P2:患者有轻微的临床症状:有轻度或中度系统性疾病</td><td>0</td>",
        "<td><input type='checkbox' "+(($("#OpDurationTimesCHK2").checkbox("getValue")===true)?"checked":"")+">T2:完成手术超过3小时</td><td>1</td></tr>",
        "<tr><td style='width:180px'><input type='checkbox' "+(($("#OpBladeCleanCHK2").checkbox("getValue")===true)?"checked":"")+">II类手术切口(相对清洁手术)</td><td>0</td>",
        "<td style='width:180px'><input type='checkbox' "+(($("#ASAClassCHK3").checkbox("getValue")===true)?"checked":"")+">P3:有严重系统性疾病,日常活动受限,但未丧失工作能力</td><td>0</td>",
        "<td style='width:200px' rowspan='8' colspan='2'><p>随访：切口愈合与感染情况</p><p style='padding-bottom:20px;'>切口甲级愈合</p><p><span style='display:inline-block;width:80px;'>切口感染--</span>浅层感染</p>",
        "<p style='padding-bottom:20px;'><span style='display:inline-block;width:80px;'></span>深层感染</p><p>在与评价项目相应的框内\"□\"打钩\"√\"后，分值相加即可完成！</p></td></tr>",
        "<tr><td rowspan='2' colspan='2' style='width:220px'>上、下呼吸道，上、下消化道，泌尿生殖道或经以上器官的手术；患者进行气道、食道和/或尿道插管；患者病情稳定；行胆囊、阴道、阑尾、耳鼻手术的患者。</td>",
        "<td style='width:180px'><input type='checkbox' "+(($("#ASAClassCHK4").checkbox("getValue")===true)?"checked":"")+">P4:有严重系统性疾病,已丧失工作能力,威胁生命安全</td><td>1</td></tr>",
        "<tr><td style='width:180px'><input type='checkbox' "+(($("#ASAClassCHK5").checkbox("getValue")===true)?"checked":"")+">P5:病情危重，生命难以维持的濒死病人</td><td>1</td></tr>",
        "<tr><td><input type='checkbox' "+(($("#OpBladeCleanCHK3").checkbox("getValue")===true)?"checked":"")+">III类手术切口(清洁-污染手术)</td><td>1</td>",
        "<td style='width:180px'><input type='checkbox' "+(($("#ASAClassCHK6").checkbox("getValue")===true)?"checked":"")+">P6:脑死亡的患者</td><td>1</td></tr>",
        "<tr><td style='width:200px' rowspan='2' colspan='2'>开放、新鲜且不干净的伤口，前次手术后感染的切口；手术中需采取消毒措施的切口。</td><th colspan='2' style='width:200px'>4.手术类别</th></tr>",
        "<tr><td colspan='2'><input type='checkbox' "+(($("#OperationTypeCHK1").checkbox("getValue")===true)?"checked":"")+">4.1.浅层组织手术</td></tr>",
        "<tr><td><input type='checkbox' "+(($("#OpBladeCleanCHK4").checkbox("getValue")===true)?"checked":"")+">IV类手术切口(污染手术)</td><td>1</td>",
        "<td colspan='2' style='width:200px'><input type='checkbox' "+(($("#OperationTypeCHK2").checkbox("getValue")===true)?"checked":"")+">4.2.深部组织手术</td></tr>",
        "<tr><td style='width:200px' rowspan='2' colspan='2'>严重的外伤，手术切口有炎症、组织坏死，或有内脏引流管。</td>",
        "<td colspan='2' style='width:200px'><input type='checkbox' "+(($("#OperationTypeCHK3").checkbox("getValue")===true)?"checked":"")+">4.3.器官类别</td></tr>",
        "<tr><td colspan='2' style='width:200px'><input type='checkbox' "+(($("#OperationTypeCHK4").checkbox("getValue")===true)?"checked":"")+">4.4.腔隙手术</td>",
        "<td colspan='2'><input type='checkbox' "+(($("#EmergencyOperCHK").checkbox("getValue")===true)?"checked":"")+">急诊手术</td></tr>",
        "<tr><td colspan='6'>手术风险评估分数：<span>手术切口清洁度("+$("#OpBladeCleanScore").text()+"分)</span><span>+麻醉ASA分级("+$("#ASAClassScore").text()+"分)</span>",
        "<span>+手术持续时间("+$("#OpDurationTimesScore").text()+"分)</span><span>="+$("#SumScore").text()+"分</span><br>NNIS级数：",
        "<input type='checkbox' "+(($("#NNISRateCHK1").checkbox("getValue")===true)?"checked":"")+">-0&nbsp;&nbsp;",
        "<input type='checkbox' "+(($("#NNISRateCHK2").checkbox("getValue")===true)?"checked":"")+">-1&nbsp;&nbsp;",
        "<input type='checkbox' "+(($("#NNISRateCHK3").checkbox("getValue")===true)?"checked":"")+">-2&nbsp;&nbsp;",
        "<input type='checkbox' "+(($("#NNISRateCHK4").checkbox("getValue")===true)?"checked":"")+">-3</td></tr></tbody></table>",
        "<div style='margin-top:20px'><span style='margin-right:120px;'>手术医生签名：</span><span style='margin-right:120px;'>麻醉医生签名：</span><span style='margin-right:120px;'>巡回护士签名：</span></div>"
    ];
    
    lodop.ADD_PRINT_HTM(pos.start.y,"1.5cm",700,"100%",htmlArr.join(""));
}

