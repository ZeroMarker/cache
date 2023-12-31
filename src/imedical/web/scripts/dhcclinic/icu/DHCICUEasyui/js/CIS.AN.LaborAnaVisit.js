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
    $("#RegNo").text(operApplication.RegNo);
    $("#PlanOperationDesc").text(operApplication.OperInfo);
    $("#PrevDiagnosisDesc").text(operApplication.PrevDiagnosisDesc);
    $("#PrevAnaMethodDesc").text(operApplication.PrevAnaMethodDesc);
	$("#OperDate").text(operApplication.OperDate);
	$("#InHosDate").text(operApplication.InHosDate);
}

function print() {
    var LODOP = getLodop();
    createPrintOnePage(LODOP,anaestConsent.operSchedule);
   // LODOP.PREVIEW();
	LODOP.PRINT();
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
    LODOP.PRINT_INIT("分娩镇痛前访视记录单");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    
    LODOP.ADD_PRINT_TEXT(30, 300, 300, 30, "南方医科大学南方医院");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 15);
    
    LODOP.ADD_PRINT_TEXT(60, 270, 520, 30, "分 娩 镇 痛 前 访 视 记 录 单");
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
	
	LODOP.ADD_PRINT_TEXT(patInfoRow2TopY+10, 40, 180, 15, "拟行操作: 分娩镇痛");
   // LODOP.ADD_PRINT_TEXT(patInfoRow2TopY+10, 180, 730, 15,"("+operSchedule.OperationDesc +")");
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	var constRowTopY1 = 180;
	var rowHeightNew=32
	var constRowTopY2 = constRowTopY1+rowHeightNew*1;
	var constRowTopY3 = constRowTopY1+rowHeightNew*2;
	var constRowTopY4 = constRowTopY1+rowHeightNew*3;
	var constRowTopY5 = constRowTopY1+rowHeightNew*4;
    var constRowTopY6 = constRowTopY1+rowHeightNew*5;
    constRowTopY1=constRowTopY1+20;
	var constRowTopY7 = constRowTopY1+rowHeightNew*6;
    var constRowTopY8 = constRowTopY1+rowHeightNew*7;
    constRowTopY1=constRowTopY1+20;
	var constRowTopY9 = constRowTopY1+rowHeightNew*8;
	var constRowTopY10 = constRowTopY1+rowHeightNew*9;
	var constRowTopY11 = constRowTopY1+rowHeightNew*10;
	var constRowTopY12 = constRowTopY1+rowHeightNew*11;
	var constRowTopY13 = constRowTopY1+rowHeightNew*12;
    var constRowTopY14 = constRowTopY1+rowHeightNew*13;
    constRowTopY1=constRowTopY1+20;
	var constRowTopY15 = constRowTopY1+rowHeightNew*14;
    var constRowTopY16 = constRowTopY1+rowHeightNew*15;
    constRowTopY1=constRowTopY1+20;
	var constRowTopY17 = constRowTopY1+rowHeightNew*16;
	var constRowTopY18 = constRowTopY1+rowHeightNew*17;
	var constRowTopY19 = constRowTopY1+rowHeightNew*18;
	var constRowTopY20 = constRowTopY1+rowHeightNew*19;
	var constRowTopY21 = constRowTopY1+rowHeightNew*20;
	var constRowTopY22 = constRowTopY1+rowHeightNew*21;
	var constRowTopY23 = constRowTopY1+rowHeightNew*22;
	var constRowTopY24 = constRowTopY1+rowHeightNew*23;
	var constRowTopY25 = constRowTopY1+rowHeightNew*24;
	var constRowTopY26 = constRowTopY1+rowHeightNew*25;
    var constRowTopY27 = constRowTopY1+rowHeightNew*26;
    
	LODOP.SET_PRINT_STYLE("FontSize", 10);
    LODOP.ADD_PRINT_TEXT(constRowTopY2, 50, 710, 15, "快捷评估");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
     /// 第一行
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 70, 100, 15, "意识：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    
    var ConstCurePainValue=$("#delConscious").val();
	if (ConstCurePainValue=="清醒")
	{
		DrawRectAndRight(LODOP,constRowTopY3,120);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY3,120);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY3, 140, 100, 15,"清醒");

	if (ConstCurePainValue=="淡漠")
	{
		DrawRectAndRight(LODOP,constRowTopY3,180);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY3,180);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 200, 100, 15,"淡漠");
    
    if (ConstCurePainValue=="昏迷")
	{
		DrawRectAndRight(LODOP,constRowTopY3,240);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY3,240);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 260, 100, 15,"昏迷");
    
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 320, 100, 15, "呼吸：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delBreath=$("#delBreath").val();
    if (delBreath=="正常")
	{
		DrawRectAndRight(LODOP,constRowTopY3,360);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY3,360);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY3, 380, 100, 15,"正常");

	if (delBreath=="不规则")
	{
		DrawRectAndRight(LODOP,constRowTopY3,420);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY3,420);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 440, 100, 15,"不规则");

    LODOP.ADD_PRINT_TEXT(constRowTopY3, 510, 710, 15, "脉搏：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delPulse=$("#delPulse").val();
    if (delPulse=="有力")
	{
		DrawRectAndRight(LODOP,constRowTopY3,550);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY3,550);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY3, 570, 100, 15,"有力");

	if (delPulse=="细弱")
	{
		DrawRectAndRight(LODOP,constRowTopY3,610);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY3,610);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 630, 100, 15,"细弱");
    if (delPulse=="不能扪及")
	{
		DrawRectAndRight(LODOP,constRowTopY3,670);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY3,670);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY3, 690, 100, 15,"不能扪及");
    ///  end 第一行
    ///   第二行
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 70, 120, 15, "皮肤色泽：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delSkinInfo=$("#delSkinInfo").val();
    if (delSkinInfo=="正常")
	{
		DrawRectAndRight(LODOP,constRowTopY4,150);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY4,150);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY4, 170, 100, 15,"正常");

	if (delSkinInfo=="苍白")
	{
		DrawRectAndRight(LODOP,constRowTopY4,210);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY4,210);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 230, 100, 15,"苍白");
    if (delSkinInfo=="紫绀")
	{
		DrawRectAndRight(LODOP,constRowTopY4,270);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY4,270);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 290, 100, 15,"紫绀");
    if (delSkinInfo=="黄染")
	{
		DrawRectAndRight(LODOP,constRowTopY4,330);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY4,330);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 350, 100, 15,"黄染");

    LODOP.ADD_PRINT_TEXT(constRowTopY4, 510, 710, 15, "温度：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delTempreture=$("#delTempreture").val();
    if (delTempreture=="正常")
	{
		DrawRectAndRight(LODOP,constRowTopY4,550);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY4,550);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY4, 570, 100, 15,"正常");

	if (delTempreture=="湿冷")
	{
		DrawRectAndRight(LODOP,constRowTopY4,610);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY4,610);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 630, 100, 15,"湿冷");
    if (delTempreture=="发热")
	{
		DrawRectAndRight(LODOP,constRowTopY4,670);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY4,670);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY4, 690, 100, 15,"发热");
    ///  end 第二行

    /// 第三行
    LODOP.ADD_PRINT_TEXT(constRowTopY5, 70, 120, 15, "贫血貌：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delAnemiao=$("#delAnemiao").val();
    if (delAnemiao=="有")
	{
		DrawRectAndRight(LODOP,constRowTopY5,150);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY5,150);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY5, 170, 100, 15,"有");

	if (delAnemiao=="无")
	{
		DrawRectAndRight(LODOP,constRowTopY5,210);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY5,210);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY5, 230, 100, 15,"无");

    LODOP.ADD_PRINT_TEXT(constRowTopY5, 495, 120, 15, "过敏史：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delAllergy=$("#delAllergy").val();
    if (delAllergy=="有")
	{
		DrawRectAndRight(LODOP,constRowTopY5,550);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY5,550);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY5, 570, 100, 15,"有");

	if (delAllergy=="无")
	{
		DrawRectAndRight(LODOP,constRowTopY5,610);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY5,610);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY5, 630, 100, 15,"无");
    /// end 第三行

    /// 第四行
    LODOP.ADD_PRINT_TEXT(constRowTopY6, 70, 160, 15, "VAS疼痛评分：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    LODOP.ADD_PRINT_TEXT(constRowTopY6, 180, 50, 15, $("#delVasPainScore").combobox('getText') + " 分");
    LODOP.ADD_PRINT_LINE(constRowTopY6+15, 170, constRowTopY6+15, 220,0,1);


    var delVasPainNoScore=$("#delVasPainNoScore").val();
    if (delVasPainNoScore=="评分不能完成")
	{
		DrawRectAndRight(LODOP,constRowTopY6,260);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY6,260);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY6, 280, 100, 15,"评分不能完成");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);

    /// end 第四行

    /// 第五行
    LODOP.ADD_PRINT_TEXT(constRowTopY7, 50, 710, 15, "麻醉前治疗");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    /// end 第五行

    /// 第六行
    LODOP.ADD_PRINT_TEXT(constRowTopY8, 70, 120, 15, "静脉通路：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delVeinRoad=$("#delVeinRoad").val();
    if (delVeinRoad=="有")
	{
		DrawRectAndRight(LODOP,constRowTopY8,150);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY8,150);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY8, 170, 100, 15,"有");

	if (delVeinRoad=="无")
	{
		DrawRectAndRight(LODOP,constRowTopY8,210);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY8,210);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY8, 230, 100, 15,"无");


    LODOP.ADD_PRINT_TEXT(constRowTopY8, 330, 120, 15, "输液类型：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delTransType=$("#delTransType").val();
    if (delTransType=="输血")
	{
		DrawRectAndRight(LODOP,constRowTopY8,400);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY8,400);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY8, 420, 100, 15,"输血");

	if (delTransType=="输胶体")
	{
		DrawRectAndRight(LODOP,constRowTopY8,460);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY8,460);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY8, 480, 100, 15,"输胶体");
    if (delTransType=="输晶体")
	{
		DrawRectAndRight(LODOP,constRowTopY8,540);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY8,540);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY8, 560, 100, 15,"输晶体");
    /// end 第六行

    /// 第七行
    LODOP.ADD_PRINT_TEXT(constRowTopY9, 50, 710, 15, "急诊检查");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    /// end 第七行

    /// 第八行
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 70, 120, 15, "血常规：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delBloodNormal=$("#delBloodNormal").val();
    if (delBloodNormal=="正常")
	{
		DrawRectAndRight(LODOP,constRowTopY10,150);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY10,150);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY10, 170, 100, 15,"正常");

	if (delBloodNormal=="异常")
	{
		DrawRectAndRight(LODOP,constRowTopY10,210);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY10,210);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 230, 100, 15,"异常");

    if (delBloodNormal=="未查")
	{
		DrawRectAndRight(LODOP,constRowTopY10,270);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY10,270);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 290, 100, 15,"未查");


    LODOP.ADD_PRINT_TEXT(constRowTopY10, 370, 120, 15, "凝血功能：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delGrume=$("#delGrume").val();
    if (delGrume=="正常")
	{
		DrawRectAndRight(LODOP,constRowTopY10,440);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY10,440);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY10, 460, 100, 15,"正常");

	if (delGrume=="异常")
	{
		DrawRectAndRight(LODOP,constRowTopY10,510);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY10,510);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 530, 100, 15,"异常");
    if (delGrume=="未查")
	{
		DrawRectAndRight(LODOP,constRowTopY10,580);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY10,580);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY10, 600, 100, 15,"未查");
    /// end 第八行

    /// 第九行
    LODOP.ADD_PRINT_TEXT(constRowTopY11, 70, 120, 15, "肝功能：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delLiverFucn=$("#delLiverFucn").val();
    if (delLiverFucn=="正常")
	{
		DrawRectAndRight(LODOP,constRowTopY11,150);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY11,150);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY11, 170, 100, 15,"正常");

	if (delLiverFucn=="异常")
	{
		DrawRectAndRight(LODOP,constRowTopY11,210);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY11,210);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY11, 230, 100, 15,"异常");

    if (delLiverFucn=="未查")
	{
		DrawRectAndRight(LODOP,constRowTopY11,270);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY11,270);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY11, 290, 100, 15,"未查");


    LODOP.ADD_PRINT_TEXT(constRowTopY11, 370, 120, 15, "肾功能：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delKidneyFunc=$("#delKidneyFunc").val();
    if (delKidneyFunc=="正常")
	{
		DrawRectAndRight(LODOP,constRowTopY11,440);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY11,440);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY11, 460, 100, 15,"正常");

	if (delKidneyFunc=="异常")
	{
		DrawRectAndRight(LODOP,constRowTopY11,510);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY11,510);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY11, 530, 100, 15,"异常");
    if (delKidneyFunc=="未查")
	{
		DrawRectAndRight(LODOP,constRowTopY11,580);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY11,580);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY11, 600, 100, 15,"未查");
    /// end 第九行

    /// 第十行
    LODOP.ADD_PRINT_TEXT(constRowTopY12, 70, 120, 15, "ECG：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delECGFunc=$("#delECGFunc").val();
    if (delECGFunc=="正常")
	{
		DrawRectAndRight(LODOP,constRowTopY12,150);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY12,150);
	}
	LODOP.ADD_PRINT_TEXT(constRowTopY12, 170, 100, 15,"正常");

	if (delECGFunc=="异常")
	{
		DrawRectAndRight(LODOP,constRowTopY12,210);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY12,210);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY12, 230, 100, 15,"异常");

    if (delECGFunc=="未查")
	{
		DrawRectAndRight(LODOP,constRowTopY12,270);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY12,270);
	}
    LODOP.ADD_PRINT_TEXT(constRowTopY12, 290, 100, 15,"未查");
    /// end  第十行

    /// 第十一行
    LODOP.ADD_PRINT_TEXT(constRowTopY13, 70, 120, 15, "ASA分级：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delASAClass=$("#delASAClass").val();
    if (delASAClass=="Ⅰ")
	{
		DrawRectAndRight(LODOP,constRowTopY13,150);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY13,150);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY13, 170, 100, 15,"Ⅰ");
    if (delASAClass=="Ⅱ")
	{
		DrawRectAndRight(LODOP,constRowTopY13,200);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY13,200);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY13, 220, 100, 15,"Ⅱ");
    if (delASAClass=="Ⅲ")
	{
		DrawRectAndRight(LODOP,constRowTopY13,250);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY13,250);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY13, 270, 100, 15,"Ⅲ");
    if (delASAClass=="Ⅳ")
	{
		DrawRectAndRight(LODOP,constRowTopY13,300);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY13,300);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY13, 320, 100, 15,"Ⅳ");
    if (delASAClass=="Ⅴ")
	{
		DrawRectAndRight(LODOP,constRowTopY13,350);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY13,350);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY13, 370, 100, 15,"Ⅴ");

    var delASAClassType=$("#delASAClassType").val();

    if (delASAClassType=="E")
	{
		DrawRectAndRight(LODOP,constRowTopY13,400);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY13,400);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY13, 420, 100, 15,"E");
    ///  end 第十一行

    /// 第十二行
    LODOP.ADD_PRINT_TEXT(constRowTopY14, 70, 140, 15, "插管难度评估：");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delIntubedif=$("#delIntubedif").val();
    if (delIntubedif=="无困难")
	{
		DrawRectAndRight(LODOP,constRowTopY14,200);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY14,200);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY14, 220, 100, 15,"无困难");
   
    if (delIntubedif=="可疑")
	{
		DrawRectAndRight(LODOP,constRowTopY14,280);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY14,280);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY14, 300, 100, 15,"可疑");

    if (delIntubedif=="插管困难")
	{
		DrawRectAndRight(LODOP,constRowTopY14,350);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY14,350);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY14, 370, 100, 15,"插管困难");

    if (delIntubedif=="通气困难")
	{
		DrawRectAndRight(LODOP,constRowTopY14,450);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY14,450);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY14, 470, 100, 15,"通气困难");
    ///  end 第十二行

     /// 第十三行
     LODOP.ADD_PRINT_TEXT(constRowTopY15, 50, 120, 15, "麻醉计划");
     LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
     /// end 第十三行

    /// 第十四行
    LODOP.ADD_PRINT_TEXT(constRowTopY16, 70, 120, 15, "麻醉选择：");
    LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
    var delAnaMethod=$("#delAnaMethod").val();
    if (delAnaMethod.indexOf("硬膜外阻滞")>-1)
	{
		DrawRectAndRight(LODOP,constRowTopY16,150);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY16,150);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY16, 170, 100, 15,"硬膜外阻滞");

    if (delAnaMethod.indexOf("腰硬联合阻滞")>-1)
	{
		DrawRectAndRight(LODOP,constRowTopY16,280);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY16,280);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY16, 300, 100, 15,"腰硬联合阻滞");

    if (delAnaMethod.indexOf("静脉麻醉")>-1)
	{
		DrawRectAndRight(LODOP,constRowTopY16,430);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY16,430);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY16, 450, 100, 15,"静脉麻醉");
     /// end 第十四行


     /// 第十五行
     LODOP.ADD_PRINT_TEXT(constRowTopY17, 50, 120, 15, "实施要点");
     LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
     /// end 第十五行

     /// 第十六行
    var delMainPoint1=$("#delMainPoint1").val();
    if (delMainPoint1=="吸氧，密切监测生命体征变化")
	{
		DrawRectAndRight(LODOP,constRowTopY18,70);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY18,70);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY18, 90, 200, 15,"吸氧，密切监测生命体征变化");
     /// end 第十六行

     /// 第十七行
    var delMainPoint2=$("#delMainPoint2").val();
    if (delMainPoint2=="力求维持呼吸、循环功能等稳定")
	{
		DrawRectAndRight(LODOP,constRowTopY19,70);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY19,70);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY19, 90, 200, 15,"力求维持呼吸、循环功能等稳定");
     /// end 第十七行

     /// 第十八行
    var delMainPoint3=$("#delMainPoint3").val();
    if (delMainPoint3=="其他")
	{
		DrawRectAndRight(LODOP,constRowTopY20,70);
	}else{
		DrawRectAndRightNull(LODOP,constRowTopY20,70);
    }
    LODOP.ADD_PRINT_TEXT(constRowTopY20, 90, 200, 15,"其他");
    var delMainPointNote=$("#delMainPointNote").val();
    LODOP.ADD_PRINT_TEXT(constRowTopY20, 130, 600, 90,delMainPointNote);
    //LODOP.ADD_PRINT_LINE(constRowTopY20+15, 130, constRowTopY20+15, 720, 0, 1);
   // LODOP.ADD_PRINT_LINE(constRowTopY21+5, 130, constRowTopY21+5, 720, 0, 1);
	//LODOP.ADD_PRINT_LINE(constRowTopY22-4, 130, constRowTopY22-4, 720, 0, 1);
	//LODOP.ADD_PRINT_LINE(constRowTopY23-15, 130, constRowTopY23-15, 720, 0, 1);
	//LODOP.ADD_PRINT_LINE(constRowTopY23+2, 130, constRowTopY23+2, 720, 0, 1);
     /// end 第十八行

     /// 签名
    LODOP.ADD_PRINT_LINE(constRowTopY24+15, 340, constRowTopY24+15, 440, 0, 1);
	LODOP.ADD_PRINT_LINE(constRowTopY24+15, 500, constRowTopY24+15, 680, 0, 1);
	LODOP.ADD_PRINT_TEXT(constRowTopY24, 220, 160, 15,"麻醉科医师签名：");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	LODOP.ADD_PRINT_TEXT(constRowTopY24, 450, 120, 15,"日期：");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	LODOP.ADD_PRINT_TEXT(constRowTopY24, 530, 400, 15, "   年     月     日");
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



