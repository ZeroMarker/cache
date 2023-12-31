$(document).ready(function() {
    operDataManager.initFormData(loadApplicationData,calcRiskScore);
    initPage();
    operDataManager.setCheckChange();
    calcRiskScore();
    //signCommon.loadSignatureCommon();
    SignTool.loadSignature();
});

function initPage(){
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
        }
    });
    $("#btnPrint").linkbutton({
        onClick: printMessage
    });

    $("#btnRefresh").linkbutton({
        onClick:function(){
            window.location.reload();
        }
    });

    $("#btnSheetSetting").linkbutton({
        onClick:function(){
            var sheetSettings=new SheetSettings({
                title:"手术访视",
                moduleId:session.ModuleID,
                closeCallBack:function(){
                    window.location.reload();
                }
            });
            sheetSettings.open();
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

    $("#btnArchive").linkbutton({
        onClick:function(){
            archive();
        }
    });
    $("#btnCaseBrow").linkbutton({
        onClick: function(){
            operDataManager.CaseBrow()
        }
    });

    SignTool.loadSignature();
}
function msg(value, name) {
	var signCode = $(this).attr("id");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode
            });
            signView.initView();
            signView.open();
            signCommon.loadSignatureCommon();
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
    $("#RiskScore").val($("#SumScore").text());
}

function setPrintCheckBox(){
    $("input[type='checkbox']").each(function(index,el){
        var printSelector="#"+$(this).attr("id")+"_Print";
        if($(printSelector).length<=0) return;
        //$(printSelector).addClass("print-checkbox-print");
        $(printSelector).text($(this).checkbox("getValue")?"√":"/");
        if($(this).checkbox("getValue"))$(printSelector).addClass('print-checkbox-checked');
    });
}
var operSchedule;
function loadApplicationData(appData) {
    // $("#patientForm").form("load", operApplicationInfo[0]);
    if(!appData) return;
    $("#OperDate").text(appData.OperDate);
    $("#PatDeptDesc").text(appData.PatDeptDesc);
    $("#PatName").text(appData.PatName);
    $("#MedcareNo").text(appData.MedcareNo);
    $("#OperationDesc").text(appData.OperDesc);
    operSchedule=appData;
}

function printMessage() {
    var count=operDataManager.printCount(session.RecordSheetID,session.ModuleCode)
    var ifMessage=operDataManager.ifPrintMessage()
    if(ifMessage!="Y"||Number(count)==0) printOperRiskAssessment()
    else if(Number(count)>0){
        $.messager.confirm("提示","表单已打印"+count+"次,是否继续打印",function (r)
        {
            if(r)
            {
                printOperRiskAssessment()
            } 
        } );
    }
}

function printOperRiskAssessment() {
    operDataManager.reloadPatInfo(loadApplicationData);
    var lodop = getLodop();
    lodop.PRINT_INIT("OperRiskAssessment" + session.OPSID);
    lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    /*
    if(lodop.SET_PRINTER_INDEXA(PrintSetting.PrintPaper.Printer))
    {
        createPrintOnePage(lodop);
        lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
        lodop.PREVIEW();

    }else{*/
    createPrintOnePage(lodop);
    lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
    lodop.PREVIEW();

    operDataManager.savePrintLog(session.RecordSheetID,session.ModuleCode,session.UserID);
    //}

    
    // createPrintOnePage(lodop);
    // lodop.PREVIEW();

}

function printOperRiskAssessmentPDF(){
    operDataManager.reloadPatInfo(loadApplicationData);
    var operSchedule=operDataManager.operScheduleData;
    var operDatas=operDataManager.getOperDatas();
    var relatedData=operDataManager.getOperDatasByCode(operDatas,["OpBladeClean","ASAClass","OpDurationTimes","OperationType","NNISRate","EmergencyOper","RiskScore"]);
    if(operSchedule && relatedData.OpBladeClean && relatedData.ASAClass && relatedData.OpDurationTimes && relatedData.OperationType && relatedData.NNISRate){
        var opts={
            operSchedule:operSchedule,
            fileName:"OperRiskAssessment",
            report:"OperRiskAssessment",
            taskId:"",
            parameter:'['  ///*参数，type 默认为空即可,已经在报表端设置了 备用字段  
            +'{"type": "", "name": "PatName","value": "'+operSchedule.PatName+'","required": false},'
            +'{"type": "", "name": "PatGender","value": "'+operSchedule.PatGender+'","required": false},'
            +'{"type": "", "name": "PatAge","value": "'+operSchedule.PatAge+'","required": false},'
            +'{"type": "", "name": "PatDeptDesc","value": "'+operSchedule.PatDeptDesc+'","required": false},'
            +'{"type": "", "name": "PatBedCode","value": "'+operSchedule.PatBedCode+'","required": false},'
            +'{"type": "", "name": "MedicareNo","value": "'+(operSchedule.MedcareNo)+'","required": false},'
            +'{"type": "", "name": "OperDate","value": "'+operSchedule.OperDate+'","required": false},'
            +'{"type": "", "name": "OperDesc","value": "'+operSchedule.OperDesc+'","required": false},'
            +'{"type": "", "name": "OpBladeClean","value": "'+relatedData.OpBladeClean.DataValue+'","required": false},'
            +'{"type": "", "name": "OpBladeCleanScore","value": "'+relatedData.OpBladeClean.DataScore+'","required": false},'
            +'{"type": "", "name": "OperDuration","value": "'+relatedData.OpDurationTimes.DataValue+'","required": false},'
            +'{"type": "", "name": "OperDurationScore","value": "'+relatedData.OpDurationTimes.DataScore+'","required": false},'
            +'{"type": "", "name": "ASAClass","value": "'+relatedData.ASAClass.DataValue+'","required": false},'
            +'{"type": "", "name": "ASAClassScore","value": "'+relatedData.ASAClass.DataScore+'","required": false},'
            +'{"type": "", "name": "OperationType","value": "'+relatedData.OperationType.DataValue+'","required": false},'
            +'{"type": "", "name": "OperationTypeScore","value": "'+relatedData.OperationType.DataScore+'","required": false},'
            +'{"type": "", "name": "NNISRate","value": "'+relatedData.NNISRate.DataValue+'","required": false},'
            +'{"type": "", "name": "EmergencyOper","value": "'+(relatedData.EmergencyOper?(relatedData.EmergencyOper.DataValue || ''):"")+'","required": false},'
            +'{"type": "", "name": "RiskScore","value": "'+relatedData.RiskScore.DataValue+'","required": false},'
            +']'
        };
        archive.sendArchive(opts);
    }
}

function createPrintOnePage(lodop) {    
    var config=sheetPrintConfig;
    var imgWidth=config.logo.imgWidth;
    var imgHeight=config.logo.imgHeight;
    var imgTop=config.logo.imgTop;
    var imgLeft=config.logo.imgLeft;
    var top=config.paper.margin.top;
    var left=config.paper.margin.left;

    var printSettings={
        top:50,
        left:45,
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
    
    //lodop.ADD_PRINT_IMAGE(imgTop,imgLeft,imgWidth,imgHeight,"<img src='"+config.logo.imgSrc+"' >");
    //lodop.SET_PRINT_STYLEA(0, "Stretch", 2);

    lodop.SET_PRINT_STYLE("FontSize", 11);
    // lodop.ADD_PRINT_IMAGE("2cm","5cm",800,140,"<img src='"+sheetPrintConfig.logo.imgSrc+"' width='800'>");
    // lodop.SET_PRINT_STYLEA(0, "Stretch", 2);

    lodop.ADD_PRINT_TEXT(75, pos.start.x, "100%", 60, session.HospDesc);
    lodop.SET_PRINT_STYLEA(0, "FontName", "宋体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Bold",1);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    lodop.ADD_PRINT_TEXT(pos.start.y, pos.start.x, "100%", 60, "手术风险评估表");
    lodop.SET_PRINT_STYLEA(0, "FontName", "宋体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Bold",1);
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
        "<input type='checkbox' "+(($("#NNISRateCHK1").checkbox("getValue")===true)?"checked":"")+">0&nbsp;&nbsp;",
        "<input type='checkbox' "+(($("#NNISRateCHK2").checkbox("getValue")===true)?"checked":"")+">1&nbsp;&nbsp;",
        "<input type='checkbox' "+(($("#NNISRateCHK3").checkbox("getValue")===true)?"checked":"")+">2&nbsp;&nbsp;",
        "<input type='checkbox' "+(($("#NNISRateCHK4").checkbox("getValue")===true)?"checked":"")+">3</td></tr></tbody></table>",
        "<div style='margin-top:20px'><span style='margin-right:80px;'>术者签名："+$("#SurgeonSign").triggerbox("getValue")+"</span><span style='margin-right:80px;'>麻醉医生签名："+$("#AnesthetistSign").triggerbox("getValue")+"</span><span style='margin-right:80px;'>巡回护士签名："+$("#OperNurseSign").triggerbox("getValue")+"</span></div>"
    ];
    
    lodop.ADD_PRINT_HTM(pos.start.y,"1.5cm",700,"100%",htmlArr.join(""));
}

function createPrintOnePageold(lodop,init) {    
    // lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    // lodop.SET_PRINT_STYLE("FontName", "宋体");
    lodop.SET_PRINT_STYLE("FontSize", 11);
    var hospName=getHospital();
    lodop.ADD_PRINT_TEXT(50, 300, "100%", 60, session.ExtHospDesc+"手术风险评估记录");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    lodop.ADD_PRINT_TEXT(90, 20, 200, 15, "日期："+$("#OperDate").text());
    lodop.ADD_PRINT_TEXT(90, 160, 200, 15, "科别："+$("#PatDeptDesc").text());
    lodop.ADD_PRINT_TEXT(90, 360, 200, 15, "姓名："+$("#PatName").text());
    lodop.ADD_PRINT_TEXT(90, 500, 200, 15, "住院号："+$("#MedcareNo").text());
    lodop.ADD_PRINT_TEXT(120, 20, 200, 15, "登记号:"+(operSchedule?operSchedule.RegNo:""));
    lodop.ADD_PRINT_TEXT(120, 160, "100%", 15, "实施手术名称："+$("#OperationDesc").text());

    setPrintCheckBox();
    var html="<html><head>"+$("head").html();
    html+="<style> .hisui-linkbutton,.hisui-checkbox,.hischeckbox_square-blue,.textbox {display:none}";
    html+="img.signature {border:none;}"
    html+=".print-checkbox {font-size:22px; width:10px;height: 10px;border: 2px solid #000;display: inline-block;text-align: center;line-height: 10px;}"
    html+=".print-checkbox-checked {font-size:16px; width:10px;height: 10px;border: 2px solid #000;display: inline-block;text-align: center;line-height: 10px; font-weight: bold;}</style></head>"
    html+="<body>"+$("#riskAssessmentRecord").html();
    html+=" <div><table><tr><td>术者签名:"+$("#SurgeonSign").triggerbox("getValue")+"<span class=form-title-right6 style=width:140px;> "
    html+=" </td><td>麻醉医师签名:"+$("#AnesthetistSign").triggerbox("getValue")+"<span class=form-title-right6 style=width:140px;>"
    html+="</td><td>巡回护士签名:"+$("#OperNurseSign").triggerbox("getValue")+"<span class=form-title-right6 style=width:140px;></span>"
    html+="</td></tr></table></div>"+"</body></html>"
    lodop.ADD_PRINT_HTM(130,0,760,"100%",html);

    // lodop.ADD_PRINT_RECT(130,20,240,30,0,1);
    // lodop.ADD_PRINT_TEXT(139, 20, 240, 30, "1.手术切口清洁程度");
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    // lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    // lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    // lodop.ADD_PRINT_RECT(130,260,240,30,0,1);
    // lodop.ADD_PRINT_TEXT(139, 260, 240, 30, "2.麻醉分级(ASA分级)");
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    // lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    // lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    // lodop.ADD_PRINT_RECT(130,500,240,30,0,1);
    // lodop.ADD_PRINT_TEXT(139, 500, 240, 30, "3.手术持续时间");
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    // lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    // lodop.SET_PRINT_STYLEA(0, "Alignment", 2);

    // lodop.ADD_PRINT_RECT(160,20,240,720,0,1);
    // lodop.ADD_PRINT_RECT(170,25,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(170,40,240,20, "I类手术切口(清洁手术) ");
    // lodop.ADD_PRINT_TEXT(210,180,240,20, "是");
    
    // lodop.ADD_PRINT_TEXT(210,192,12,12,$("#PreanPatInfoCheckingCHK1").checkbox("getValue")?"√":"");
    // lodop.ADD_PRINT_TEXT(210,220,240,20, "否");
    // lodop.ADD_PRINT_RECT(210,235,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(210,232,12,12,$("#PreanPatInfoCheckingCHK2").checkbox("getValue")?"√":"");

}

function getHospital(){
    var result=null;
    $.ajaxSettings.async=false;
    var result = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindHospitalDesc",
        Arg1:session.HospID,
        ArgCnt: 1
    }, "json");

    $.ajaxSettings.async=true;
    return result;
}


function archive() {
    var curOperSchedule = operSchedule;
    var valueObject = $.extend({}, curOperSchedule);
    var operDatas = operDataManager.getOperDatas();
    $.each(operDatas, function (index, operData) {
        if (!operData.DataItem || operData.DataItem === "") return;
        var controlValue = operDataManager.getControlValue($("#" + operData.DataItem));
        valueObject[operData.DataItem] = controlValue;
    });
    
    var moduleId = session.ModuleID;
    if (moduleId) {
        $.ajax({
            url: ANCSP.MethodService,
            async: true,
            data: {
                ClassName: "CIS.AN.BL.PrintTemplate",
                MethodName: "GetPrintTemplate",
                Arg1: moduleId,
                ArgCnt: 1
            },
            type: "post",
            success: function (data) {
                var result = $.trim(data);
                if (result) {
					var splitChar = String.fromCharCode(2);
                    var templateId = result.split(splitChar)[0];
                    var sheetData = JSON.parse(result.split(splitChar)[1]);
                    var lodopPrintView = window.LodopPrintView.instance;
                    if (!lodopPrintView) {
                        lodopPrintView = window.LodopPrintView.init({
                            sheetData: sheetData.Sheet,
                            valueObject: {
                                PatName:curOperSchedule.PatName,
                                PatGender:curOperSchedule.PatGender,
                                PatAge:curOperSchedule.PatAge,
                                PatDeptDesc:curOperSchedule.PatDeptDesc,
                                PatBedCode: curOperSchedule.PatBedCode,
                                MedcareNo: curOperSchedule.MedcareNo,
                                OperationDesc:curOperSchedule.PlanOperDesc,
                                PrevDiagnosisDesc:curOperSchedule.PrevDiagnosis,
                                OperDate:curOperSchedule.OperDate,
                    
                                OpBladeCleanCHK1: $("#OpBladeCleanCHK1").checkbox("getValue"),
                                OpBladeCleanCHK2: $("#OpBladeCleanCHK2").checkbox("getValue"),
                                OpBladeCleanCHK3: $("#OpBladeCleanCHK3").checkbox("getValue"),
                                OpBladeCleanCHK4: $("#OpBladeCleanCHK4").checkbox("getValue"),
                                OpDurationTimesCHK1: $("#OpDurationTimesCHK1").checkbox("getValue"),
                                OpDurationTimesCHK2: $("#OpDurationTimesCHK2").checkbox("getValue"),
                                OperationTypeCHK1: $("#OperationTypeCHK1").checkbox("getValue"),
                                OperationTypeCHK2:$("#OperationTypeCHK2").checkbox("getValue"),
                                OperationTypeCHK3:$("#OperationTypeCHK3").checkbox("getValue"),
                                OperationTypeCHK4:$("#OperationTypeCHK4").checkbox("getValue"),
                
                                ASAClassCHK1:$("#ASAClassCHK1").checkbox("getValue"),
                                ASAClassCHK2:$("#ASAClassCHK2").checkbox("getValue"),
                                ASAClassCHK3:$("#ASAClassCHK3").checkbox("getValue"),
                                ASAClassCHK4:$("#ASAClassCHK4").checkbox("getValue"),
                                ASAClassCHK5:$("#ASAClassCHK5").checkbox("getValue"),
                                ASAClassCHK6:$("#ASAClassCHK6").checkbox("getValue"),
                                EmergencyOperCHK:$("#EmergencyOperCHK").checkbox("getValue"),
                                NNISRateCHK1:$("#NNISRateCHK1").checkbox("getValue"),
                                NNISRateCHK2:$("#NNISRateCHK2").checkbox("getValue"),
                                NNISRateCHK3:$("#NNISRateCHK3").checkbox("getValue"),
                                NNISRateCHK4:$("#NNISRateCHK4").checkbox("getValue"),
                                //IncisionalInfectionCHK1:$("#IncisionalInfectionCHK1").checkbox("getValue"),
                                //IncisionalInfectionCHK2:$("#IncisionalInfectionCHK2").checkbox("getValue"),
                                //IncisionalInfectionCHK3:$("#IncisionalInfectionCHK3").checkbox("getValue"),
                                OpBladeCleanScore:$("#OpBladeCleanScore").text(),
                                ASAClassScore:$("#ASAClassScore").text(),
                                OpDurationTimesScore:$("#OpDurationTimesScore").text(),
                                SumScore:$("#SumScore").text(),
                                //OperNurseSignDate:$("#OperNurseSignDT").datetimebox("getValue"),
                               // SurgeonSignDate:$("#SurgeonSignDT").datetimebox("getValue"),
                                //AnaDoctorSignDate:$("#AnaDoctorSignDT").datetimebox("getValue"),
                                //ZGYSSignDate:$("#SurgeonSignDT").datetimebox("getValue"),
                                ZGYS:$("#SurgeonSign").triggerbox("getValue"),   //.attr("src"),
                                SurgeonSign:$("#SurgeonSign").triggerbox("getValue"),    //.attr("src"),
                                AnaDoctorSign:$("#AnesthetistSign").triggerbox("getValue"),  //.attr("src"),
                                OperNurseSign:$("#OperNurseSign").triggerbox("getValue")
                            }
                        });
                    }
                    var opts = {
                        ip : session.ArchiveServerIP,
                        port : session.ArchiveServerPort,
                        type : "OPRis",
                        id : curOperSchedule.OPSID,
                        date : curOperSchedule.OperDate,
                        filename : "手术风险评估单.pdf",
                        patName : curOperSchedule.PatName,
                        moduleName : "手术风险评估单"
                    };
                    lodopPrintView.archive(opts);
                }else{
                    $.messager.alert("错误", "未配置打印模板!", "error");
                }
            }
        });
    }
}