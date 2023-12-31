var anaestConsent = {
    operSchedule:null
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
	if(operApplication==null) return ;
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
	$("#InHosDate").text(operApplication.InHosDate);
}

function print() {
    var LODOP = getLodop();
    createPrintOnePage(LODOP,anaestConsent.operSchedule);
    LODOP.PREVIEW();
	//LODOP.PRINT();
	$.messager.popover({msg:"打印完成！！",type:"success",timeout:2000});

}

function printView()
{
	var LODOP = getLodop();
	createPrintOnePage(LODOP,anaestConsent.operSchedule);
	LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    LODOP.PREVIEW();
	//LODOP.PRINT();
	$.messager.popover({msg:"打印完成！！",type:"success",timeout:2000});
}


function createPrintOnePage(LODOP,operSchedule) {
    LODOP.PRINT_INIT("分娩镇痛知情同意书");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.SET_PRINT_STYLE("FontSize", 11);
    LODOP.ADD_PRINT_TEXT(30, 300, 300, 30, "南方医科大学南方医院");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 15);
    
    LODOP.ADD_PRINT_TEXT(60, 280, 520, 30, "分 娩 镇 痛 知 情 同 意 书");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);

    //LODOP.ADD_PRINT_LINE(60, 90, 60, 741, 0, 2);
    //LODOP.ADD_PRINT_LINE(20, 80, 1030, 80, 0, 1);

    var rowY=110, lineTop=15;

    LODOP.ADD_PRINT_TEXT(rowY, 40, 50, 15, "性名:");
    LODOP.ADD_PRINT_TEXT(rowY, 80, 100, 15,operSchedule.PatName);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(rowY+lineTop, 75, rowY+lineTop, 150, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 160, 45, 15, "性别:");
    LODOP.ADD_PRINT_TEXT(rowY, 195, 20, 15, operSchedule.PatGender);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(rowY+lineTop, 190, rowY+lineTop, 220, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 230, 45, 15, "年龄:");
    LODOP.ADD_PRINT_TEXT(rowY, 270, 50, 15,operSchedule.PatAge);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    LODOP.ADD_PRINT_LINE(rowY+lineTop, 265, rowY+lineTop, 310, 0, 1);

	LODOP.ADD_PRINT_TEXT(rowY, 320, "100%", 15, "科室:");
    LODOP.ADD_PRINT_TEXT(rowY, 360, "100%", 15, operSchedule.PatDeptDesc);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_TEXT(rowY, 420, 80, 15, operSchedule.PatDeptDesc);
    LODOP.ADD_PRINT_LINE(rowY+lineTop, 355, rowY+lineTop, 530, 0, 1);

	LODOP.ADD_PRINT_TEXT(rowY, 540, "100%", 15, "床号:");
    LODOP.ADD_PRINT_TEXT(rowY, 580, "100%", 15, operSchedule.PatBedCode);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_TEXT(rowY, 540, 50, 15, operSchedule.BedCode ||'2-1床');
    LODOP.ADD_PRINT_LINE(rowY+lineTop, 580, rowY+lineTop, 600, 0, 1);

	LODOP.ADD_PRINT_TEXT(rowY, 630, "100%", 15, "病案号:");
    LODOP.ADD_PRINT_TEXT(rowY, 680, "100%", 15, operSchedule.MedcareNo);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    // //LODOP.ADD_PRINT_TEXT(rowY, 645, 90, 15, operSchedule.MedcareNo);
    LODOP.ADD_PRINT_LINE(rowY+lineTop, 680, rowY+lineTop, 740, 0, 1);

    var rowTopY = 125,
    lineLeftX = 40,
    lineRightX= 740,
    rowHeight = 30;

    var patInfoRow1TopY = rowTopY;
    var patInfoRow2TopY = rowTopY+rowHeight*1;
    var patInfoRow3TopY = rowTopY+rowHeight*2;
	//rowTopY=rowTopY+10;
    var patInfoRow4TopY = rowTopY+rowHeight*3;
	var patInfoRow5TopY = rowTopY+rowHeight*4;
	var patInfoRow6TopY = rowTopY+rowHeight*5;
	var patInfoRow7TopY = rowTopY+rowHeight*6;

    LODOP.ADD_PRINT_LINE(patInfoRow1TopY, lineLeftX+1, patInfoRow1TopY, lineRightX-1, 0, 1);
    LODOP.ADD_PRINT_LINE(patInfoRow2TopY, lineLeftX+1, patInfoRow2TopY, lineRightX-1, 0, 1);
    LODOP.ADD_PRINT_LINE(patInfoRow3TopY, lineLeftX+1, patInfoRow3TopY, lineRightX-1, 0, 1);
    //LODOP.ADD_PRINT_LINE(patInfoRow4TopY-20, lineLeftX + 1, patInfoRow4TopY-20, lineRightX -1, 0, 1);
	
	LODOP.ADD_PRINT_TEXT(patInfoRow1TopY+10, 40, 50, 15, "ID:");
    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY+10, 70, 100, 15,operSchedule.RegNo);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	LODOP.ADD_PRINT_TEXT(patInfoRow1TopY+10, 200, 80, 15, "术前诊断:");
    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY+10, 270, 730, 15,operSchedule.PrevDiagnosisDesc);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	//LODOP.ADD_PRINT_LINE(patInfoRow2TopY+lineTop+10, 110, patInfoRow2TopY+lineTop+10, 730, 0, 1);
	
	LODOP.ADD_PRINT_TEXT(patInfoRow2TopY+10, 40, 120, 15, "分娩镇痛方式:");
    LODOP.ADD_PRINT_TEXT(patInfoRow2TopY+10, 160, 730, 15,operSchedule.OperationDesc);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	LODOP.ADD_PRINT_TEXT(patInfoRow4TopY, 70, 710, 15, "我院分娩镇痛采用目前国际上技术最成熟，应用最为广泛椎管内神经阻滞术镇痛。《中国产科麻醉专家共");
	LODOP.ADD_PRINT_TEXT(patInfoRow5TopY, 40, 710, 15, "识(2017年)》中明确指出椎管内镇痛对母婴安全，是一项安全有效的分娩镇痛措施。分娩镇痛优点：");

	var constRowTopY1 = 250;
	var rowHeightNew=30
	var constRowTopY2 = constRowTopY1+rowHeightNew*1;
	var constRowTopY3 = constRowTopY1+rowHeightNew*2;
	var constRowTopY4 = constRowTopY1+rowHeightNew*3;
	constRowTopY1=constRowTopY1+10;
	var constRowTopY5 = constRowTopY1+rowHeightNew*4;
	var constRowTopY6 = constRowTopY1+rowHeightNew*5;
	var constRowTopY7 = constRowTopY1+rowHeightNew*6;
	
	var constRowTopY8 = constRowTopY1+rowHeightNew*7;
	var constRowTopY9 = constRowTopY1+rowHeightNew*8;
	var constRowTopY10 = constRowTopY1+rowHeightNew*9;
	var constRowTopY11 = constRowTopY1+rowHeightNew*10;
	var constRowTopY12 = constRowTopY1+rowHeightNew*11;
	var constRowTopY13 = constRowTopY1+rowHeightNew*12;
	var constRowTopY14 = constRowTopY1+rowHeightNew*13;
	var constRowTopY15 = constRowTopY1+rowHeightNew*14;
	constRowTopY1=constRowTopY1+10;
	var constRowTopY16 = constRowTopY1+rowHeightNew*15;
	var constRowTopY17 = constRowTopY1+rowHeightNew*16;
	var constRowTopY18 = constRowTopY1+rowHeightNew*17;
	var constRowTopY19 = constRowTopY1+rowHeightNew*18;
	constRowTopY1=constRowTopY1+30;
	var constRowTopY20 = constRowTopY1+rowHeightNew*19;
	var constRowTopY21 = constRowTopY1+rowHeightNew*20;
	var constRowTopY22 = constRowTopY1+rowHeightNew*21;
	var constRowTopY23 = constRowTopY1+rowHeightNew*22;
	var constRowTopY24 = constRowTopY1+rowHeightNew*23;
	var constRowTopY25 = constRowTopY1+rowHeightNew*24;
	var constRowTopY26 = constRowTopY1+rowHeightNew*25;
	var constRowTopY27 = constRowTopY1+rowHeightNew*26;
	

	LODOP.ADD_PRINT_TEXT(constRowTopY2, 40, 710, 15, "    一、减轻分娩疼痛从而减轻机体应激反应，帮助产妇顺利完成产程。");
	LODOP.ADD_PRINT_TEXT(constRowTopY3, 40, 710, 15, "    二、消除产痛引起的过度通气而导致的机体酸碱平衡紊乱。");
	LODOP.ADD_PRINT_TEXT(constRowTopY4, 40, 710, 15, "    三、可根据产程进展的需要，灵活提供产程需要的产钳助产及剖宫产手术。");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY5, 40, 710, 15, "    但受医学科学技术条件限制、目前尚难以完全避免相关意外和并发症。现将分娩镇痛相关事项和存在的");
	LODOP.ADD_PRINT_TEXT(constRowTopY6, 40, 710, 15, "(但不限于)风险进行告知如下：");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY7, 40, 710, 15, "    一、施行分娩镇痛，是以维护产妇及胎儿的安全为最高原则。故无论在技术及用药方面，本院都经由合格");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY8, 40, 710, 15, "专业的麻醉医师执行。");
	LODOP.ADD_PRINT_TEXT(constRowTopY9, 40, 710, 15, "    二、由有经验的麻醉医师施行分娩镇痛，对产妇及胎儿是相当安全的，大多数产妇也能有效止痛。但有时");
	LODOP.ADD_PRINT_TEXT(constRowTopY10, 40, 710, 15,"还是可能发生一些副作用：如暂时性的发抖、低血压、呕吐以及较少见的头痛、背痛、感染、抽搐、药物特异");
	LODOP.ADD_PRINT_TEXT(constRowTopY11, 40, 710, 15,"过敏或其它偶发之病变等，我们会加以预防或作适当的处理，产妇不用过于担心。");
	LODOP.ADD_PRINT_TEXT(constRowTopY12, 40, 710, 15,"    三、行椎管内神经阻滞穿刺可能发生的并发症:硬膜外血肿，穿刺部位或椎管内感染，脊神经或脊髓损伤，");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY13, 40, 710, 15,"呼吸和循环抑制，全脊麻，麻醉不完善或失败等。");
	LODOP.ADD_PRINT_TEXT(constRowTopY14, 40, 710, 15,"    四、目前医疗保险暂不给付分娩镇痛，您必需自费支付此项目，包括止痛用药、材料及技术费等，需依院");
	LODOP.ADD_PRINT_TEXT(constRowTopY15, 40, 710, 15,"方规定收费。");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY16, 40, 710, 15,"    我对麻醉医师所告知的、因受医学科学技术条件限制、目前尚难以完全避免的麻醉意外和并发症表示理解。");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY17, 40, 710, 15,"我愿意承担分娩镇痛可能引起的风险和并发症，自愿要求实施分娩镇痛。我就分娩镇痛的相关问题及风险向我的");
	LODOP.ADD_PRINT_TEXT(constRowTopY18, 40, 710, 15,"麻醉医师进行了详细的咨询，并得到了满意的答复。");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY18, 420, 710, 15,"我");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	var ConstCurePainValue=$("#delNewConstant").val();
	if (ConstCurePainValue=="同意")
	{
		DrawRectAndRight(LODOP,constRowTopY18,440);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY18,440);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY18, 460, 710, 15,"同意");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	if (ConstCurePainValue=="不同意")
	{
		DrawRectAndRight(LODOP,constRowTopY18,510);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY18,510);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY18, 530, 710, 15,"不同意");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	
	LODOP.ADD_PRINT_TEXT(constRowTopY18, 600, 710, 15,"行无痛分娩。");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	constRowTopY19=constRowTopY19+10;
	LODOP.ADD_PRINT_LINE(constRowTopY19+15, 130, constRowTopY19+15, 250, 0, 1);
	LODOP.ADD_PRINT_LINE(constRowTopY19+15, 320, constRowTopY19+15, 420, 0, 1);
	LODOP.ADD_PRINT_LINE(constRowTopY19+15, 500, constRowTopY19+15, 680, 0, 1);
	
	LODOP.ADD_PRINT_TEXT(constRowTopY19, 60, 120, 15,"产妇签名：");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	LODOP.ADD_PRINT_TEXT(constRowTopY19, 250, 120, 15,"家属签名：");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	LODOP.ADD_PRINT_TEXT(constRowTopY19, 430, 120, 15,"签名日期：");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	LODOP.ADD_PRINT_TEXT(constRowTopY19, 530, 400, 15, "   年     月     日");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	
	
	LODOP.ADD_PRINT_TEXT(constRowTopY20, 40, 710, 15,"    医生陈述：我已经告知产妇及家属将要施行的分娩镇痛麻醉方式、此次麻醉及麻醉后可能发生的并发症和风险、");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY21, 40, 710, 15,"根据治疗的需要更改为其他麻醉方法的可能性，并且解答了产妇及家属关于此次麻 醉的相关问题。");
	LODOP.ADD_PRINT_TEXT(constRowTopY22, 40, 710, 15,"麻醉医师进行了详细的咨询，并得到了满意的答复。");
	
	
	var noteRowTopY = 860;
	var rowHeightNew=22
	var noteRowTopY1=noteRowTopY+rowHeightNew*1
	var noteRowTopY2=noteRowTopY+rowHeightNew*2+10
	var noteRowTopY3=noteRowTopY+rowHeightNew*3+20
	var noteRowTopY4=noteRowTopY+rowHeightNew*4+30
	var noteRowTopY5=noteRowTopY+rowHeightNew*5+40
	var noteRowTopY6=noteRowTopY+rowHeightNew*6+50
	var noteRowTopY7=noteRowTopY+rowHeightNew*7+60
	var noteRowTopY8=noteRowTopY+rowHeightNew*8+70
	var noteRowTopY9=noteRowTopY+rowHeightNew*9+80
	
	noteRowTopY4=noteRowTopY4+20;
	LODOP.ADD_PRINT_LINE(noteRowTopY4+15, 320, noteRowTopY4+15, 420, 0, 1);
	LODOP.ADD_PRINT_LINE(noteRowTopY4+15, 500, noteRowTopY4+15, 680, 0, 1);
	LODOP.ADD_PRINT_TEXT(noteRowTopY4, 250, 120, 15,"医生签名：");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	LODOP.ADD_PRINT_TEXT(noteRowTopY4, 430, 120, 15,"签名日期：");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	LODOP.ADD_PRINT_TEXT(noteRowTopY4, 530, 400, 15, "   年     月     日");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
}

/// 画打勾选框
function DrawRectAndRight(tmplodop,tmptop,tmpleft)
{
	tmplodop.ADD_PRINT_RECT(tmptop,tmpleft+5,"3.3mm","3.3mm",0,1);
	tmplodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	tmplodop.ADD_PRINT_TEXT(tmptop-5, tmpleft, 30, 15,"√");
	tmplodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	tmplodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
	tmplodop.SET_PRINT_STYLEA(0, "FontSize", 15);
}

/// 画空白方框
function DrawRectAndRightNull(tmplodop,tmptop,tmpleft)
{
	tmplodop.ADD_PRINT_RECT(tmptop,tmpleft+5,"3.3mm","3.3mm",0,1);
	tmplodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
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



