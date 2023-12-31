var operSchedule = null;
$(document).ready(function() {
    dhccl.parseDateTimeFormat();
    operDataManager.initFormData(loadApplicationData,calcRiskScore);
    initPage();
    operDataManager.setCheckChange();
    calcRiskScore();
});

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
		onClick: function () {
			archive();
		}
    });

    SignTool.loadSignature();
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
        $(printSelector).text($(this).checkbox("getValue")?"√":"");
        if($(this).checkbox("getValue"))$(printSelector).addClass('print-checkbox-checked');
    });
}

function setPrintTextkBox(){
    $("input[type='text']").each(function(index,el){
        var printSelector="#"+$(this).attr("id")+"_Print";
        if($(printSelector).length<=0) return;
        //$(printSelector).addClass("print-checkbox-print");
       // $(printSelector).text($(this).text());
       $(printSelector).text($(this).val());
        //var tt=$(this).val();
        //if($(this).text()) 
        
        if($(this).attr("class").indexOf("hisui-datetimebox") !== -1 )
        {
            var tt=$(this).datebox('getValue');
            $(printSelector).text($(this).datebox('getValue'));
        }
        $(printSelector).addClass('print-textbox-value');
    });
}

function loadApplicationData(appData) {
    // $("#patientForm").form("load", operApplicationInfo[0]);
    if(!appData) return;
	operSchedule = appData;
    $("#OperDate").text(appData.OperDate);
    $("#PatDeptDesc").text(appData.PatDeptDesc);
    $("#PatName").text(appData.PatName);
    $("#MedcareNo").text(appData.MedcareNo);
    $("#OperationDesc").text(appData.OperDesc);
}

function printMessage() {
    var count=operDataManager.printCount(session.RecordSheetID,session.ModuleCode)
    var ifMessage=operDataManager.ifPrintMessage()
    if(ifMessage!="Y"||Number(count)==0) printPatTransRecord()
    else if(Number(count)>0){
        $.messager.confirm("提示","表单已打印"+count+"次,是否继续打印",function (r)
        {
            if(r)
            {
                printPatTransRecord()
            } 
        } );
    }
}

function printPatTransRecord() {
    operDataManager.reloadPatInfo(loadApplicationData);
    var lodop = getLodop();
    lodop.PRINT_INIT("printPatTransRecord" + session.OPSID);
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
    operDataManager.savePrintLog(session.RecordSheetID,session.ModuleCode,session.UserID)
    //}

    
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
    var hospName=getHospital();
    lodop.ADD_PRINT_TEXT(50, 0, "100%", 60, session.ExtHospDesc+"患者交接记录");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 18);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    //lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    //lodop.SET_PRINT_STYLEA(0,"AlignJustify",1);

   setPrintCheckBox();
   setPrintTextkBox();
    var html="<html><head>"+$("head").html();
    html+="<style> .hisui-linkbutton,.hisui-checkbox,.hischeckbox_square-blue,.textbox {display:none}";
    html+="img.signature {border:none;}"
    html+=".print-checkbox {font-size:22px; width:10px;height: 10px;border: 2px solid #000;display: inline-block;text-align: center;line-height: 10px;}"
    html+=".print-checkbox-checked {font-size:16px; width:10px;height: 10px;border: 2px solid #000;display: inline-block;text-align: center;line-height: 10px; font-weight: bold;}"
	html+=".print-textbox-value {display: inline-block}</style></head>"
    html+="<body>"+$("#PatTransRecorddiv").html();
    html+="<div><table class=form-table-normal style=width:100%><tr><td colspan=2 class=form-table-title>护士签名(交)</td>"
    html+="<td colspan=2><div class=form-rows><div><div class=form-row form-row-normal><div class=form-title-normal>交患者护士:"+$("#PreANFromNurseSign").triggerbox("getValue")+"</div>"
    html+="</div></div><div><div class=form-row form-row-normal><div class=form-title-normal>接患者护士:"+$("#PreANToNurseSign").triggerbox("getValue")+"</div>"
    html+="</div></div></div></td><td colspan=2><div class=form-rows><div><div class=form-row form-row-normal><div class=form-title-normal>交患者护士:"+$("#PreOPFromNurseSign").triggerbox("getValue")+"</div>"
    html+="</div></div><div><div class=form-row form-row-normal><div class=form-title-normal>接患者护士:"+$("#PreOPToNurseSign").triggerbox("getValue")+"</div>"
    html+="</div></div></div></td><td colspan=2><div class=form-rows><div><div class=form-row form-row-normal><div class=form-title-normal>交患者护士:"+$("#PreOutFromNurseSign").triggerbox("getValue")+"</div>"
    html+="</div></div><div><div class=form-row form-row-normal><div class=form-title-normal>接患者护士:"+$("#PreOutToNurseSign").triggerbox("getValue")+"</div>"
    html+="</div></div></div></td></tr></table></div></body></html>"
   
   lodop.ADD_PRINT_HTM(130,0,760,"100%",html);
   //LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Page");//整页缩放
   lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);//宽度溢出缩放
   lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW",true);//高度溢出缩放
  
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
                            valueObject: valueObject
                        });
                    }
                    var opts = {
                        ip : session.ArchiveServerIP,
                        port : session.ArchiveServerPort,
                        type : "OPTrans",
                        id : curOperSchedule.OPSID,
                        date : curOperSchedule.OperDate,
                        filename : "术前访视单.pdf",
                        patName : curOperSchedule.PatName,
                        moduleName : "术前访视单"
                    };
                    lodopPrintView.archive(opts);
                }else{
                    $.messager.alert("错误", "未配置打印模板!", "error");
                }
            }
        });
    }
}
