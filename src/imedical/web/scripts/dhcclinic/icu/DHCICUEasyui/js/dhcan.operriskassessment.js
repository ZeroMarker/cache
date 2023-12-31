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
        if($(printSelector).length<=0) return;
        //$(printSelector).addClass("print-checkbox-print");
        $(printSelector).text($(this).checkbox("getValue")?"√":"/");
        if($(this).checkbox("getValue"))$(printSelector).addClass('print-checkbox-checked');
    });
}

function loadApplicationData(appData) {
    // $("#patientForm").form("load", operApplicationInfo[0]);
    if(!appData) return;
    $("#OperDate").text(appData.OperDate);
    $("#PatDeptDesc").text(appData.PatDeptDesc);
    $("#PatName").text(appData.PatName);
    $("#MedcareNo").text(appData.MedcareNo);
    $("#OperationDesc").text(appData.OperationDesc);
}

function printOperRiskAssessment() {
    operDataManager.reloadPatInfo(loadApplicationData);
    var lodop = getLodop();
    lodop.PRINT_INIT("OperRiskAssessment" + session.OPSID);
    lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    if(lodop.SET_PRINTER_INDEXA(PrintSetting.PrintPaper.Printer))
    {
        createPrintOnePage(lodop);
        lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
        lodop.PREVIEW();

    }else{
        createPrintOnePage(lodop);
        lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
        lodop.PREVIEW();
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

function createPrintOnePage(lodop,init) {    
    // lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    // lodop.SET_PRINT_STYLE("FontName", "宋体");
    lodop.SET_PRINT_STYLE("FontSize", 11);
    lodop.ADD_PRINT_TEXT(50, 300, "100%", 60, "山西省肿瘤医院手术风险评估记录");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    lodop.ADD_PRINT_TEXT(90, 20, 200, 15, "日期："+$("#OperDate").text());
    lodop.ADD_PRINT_TEXT(90, 160, 200, 15, "科别："+$("#PatDeptDesc").text());
    lodop.ADD_PRINT_TEXT(90, 360, 200, 15, "姓名："+$("#PatName").text());
    lodop.ADD_PRINT_TEXT(90, 500, 200, 15, "住院号："+$("#MedcareNo").text());
    lodop.ADD_PRINT_TEXT(120, 20, "100%", 15, "实施手术名称："+$("#OperationDesc").text());

    setPrintCheckBox();
    var html="<html><head>"+$("head").html();
    html+="<style> .hisui-linkbutton,.hisui-checkbox,.hischeckbox_square-blue,.textbox {display:none}";
    html+="img.signature {border:none;}"
    html+=".print-checkbox {font-size:22px; width:10px;height: 10px;border: 2px solid #000;display: inline-block;text-align: center;line-height: 10px;}"
    html+=".print-checkbox-checked {font-size:16px; width:10px;height: 10px;border: 2px solid #000;display: inline-block;text-align: center;line-height: 10px; font-weight: bold;}</style></head>"
    html+="<body>"+$("#riskAssessmentRecord").html()+"</body></html>";
    
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

