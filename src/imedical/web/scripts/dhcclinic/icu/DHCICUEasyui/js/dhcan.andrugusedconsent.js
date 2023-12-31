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

	 $("#btnAllPrint").linkbutton({
        onClick: printTest
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

function printTest()
{
	
	var data = {};
	data=getBackPageData();
	var arr=Object.keys(data);
	var lengthtpm=arr.length;
	
	var eventData={};
	eventData=GetAllEvents();
	var eventArr=Object.keys(eventData);
	var eventLenth=eventArr.length;
	
	if (eventLenth>lengthtpm)
	{
		//lengthtpm=eventLenth;
	}
	printDrug(anaestConsent.operSchedule,data,lengthtpm,eventLenth)
	/*
	var EpisodeID=getUrlParam("EpisodeID");
	alert(EpisodeID);
	var href = '<iframe scrolling="yes" frameborder="0" src="' + 'dhcan.anaestrecord.csp' +
        '?opsId=' + '5392'+
        '&EpisodeID=' + '5672178' +
        '&moduleCode=AnaestRecord" style="width:100%;height:100%;"></iframe>';
		
	var lnk="dhcan.anrecordvisit.csp?"+'opsId=' + '5392'+'&EpisodeID=' + '5672178' + '&moduleCode=AnaestRecord';
    var title = '测试' + '的麻醉记录';
	showModalDialog(lnk,"测试","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no;");
	*/
}

function printDrug(operSchedule,data,len,eventLenth)
{
	var LODOP = getLodop();
	LODOP.PRINT_INIT("打印麻醉药品");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.SET_PRINT_STYLE("FontSize", 11);
    //LODOP.ADD_PRINT_TEXT(30, 300, 300, 30, "南方医科大学南方医院");
    //LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    //LODOP.SET_PRINT_STYLEA(0, "FontSize", 15);
    
    LODOP.ADD_PRINT_TEXT(60, 233, 520, 30, "麻醉药品用量汇总");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    var rowY=100, tmpHeight=30, lineTop=15;
	var rowY1=rowY+tmpHeight*1;
	var rowY2=rowY+tmpHeight*2;
	
	//第一行
	LODOP.ADD_PRINT_TEXT(rowY, 40, 50, 15, "性名:");
    LODOP.ADD_PRINT_TEXT(rowY, 80, 100, 15,operSchedule.PatName);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_LINE(rowY+lineTop, 75, rowY+lineTop, 150, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 160, 45, 15, "性别:");
    LODOP.ADD_PRINT_TEXT(rowY, 200, 20, 15, operSchedule.PatGender);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_LINE(rowY+lineTop, 190, rowY+lineTop, 220, 0, 1);

    LODOP.ADD_PRINT_TEXT(rowY, 230, 45, 15, "年龄:");
    LODOP.ADD_PRINT_TEXT(rowY, 270, 50, 15,operSchedule.PatAge);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_LINE(rowY+lineTop, 265, rowY+lineTop, 310, 0, 1);

	LODOP.ADD_PRINT_TEXT(rowY, 320, "100%", 15, "科室:");
    LODOP.ADD_PRINT_TEXT(rowY, 360, "100%", 15, operSchedule.PatDeptDesc);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_TEXT(rowY, 420, 80, 15, operSchedule.PatDeptDesc);
    //LODOP.ADD_PRINT_LINE(rowY+lineTop, 355, rowY+lineTop, 530, 0, 1);

	LODOP.ADD_PRINT_TEXT(rowY, 540, "100%", 15, "床号:");
    LODOP.ADD_PRINT_TEXT(rowY, 580, "100%", 15, operSchedule.PatBedCode);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_TEXT(rowY, 540, 50, 15, operSchedule.BedCode ||'2-1床');
    //LODOP.ADD_PRINT_LINE(rowY+lineTop, 580, rowY+lineTop, 600, 0, 1);

	LODOP.ADD_PRINT_TEXT(rowY, 630, "100%", 15, "病案号:");
    LODOP.ADD_PRINT_TEXT(rowY, 680, "100%", 15, operSchedule.MedcareNo);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    // //LODOP.ADD_PRINT_TEXT(rowY, 645, 90, 15, operSchedule.MedcareNo);
    //LODOP.ADD_PRINT_LINE(rowY+lineTop, 680, rowY+lineTop, 740, 0, 1);
	// end 第一行
	
	//第二行
	LODOP.ADD_PRINT_TEXT(rowY1, 40, 100, 15, "手术间:");
    LODOP.ADD_PRINT_TEXT(rowY1, 100, 100, 15,operSchedule.RoomDesc);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_LINE(rowY1+lineTop, 75, rowY1+lineTop, 150, 0, 1);
	
	LODOP.ADD_PRINT_TEXT(rowY1, 200, 100, 15, "麻醉医生:");
    LODOP.ADD_PRINT_TEXT(rowY1, 280, 100, 15, operSchedule.AnaStaff);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    //LODOP.ADD_PRINT_LINE(rowY1+lineTop, 190, rowY+lineTop, 220, 0, 1);
	
	LODOP.ADD_PRINT_TEXT(rowY1, 450, 100, 15, "手术日期:");
    LODOP.ADD_PRINT_TEXT(rowY1, 530, 100, 15, operSchedule.OperDate);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	//end 第二行
	tmpHeight=22;
	LODOP.ADD_PRINT_LINE(rowY+tmpHeight*2+10, 40, rowY+tmpHeight*2+10, 730, 0, 1);
	LODOP.ADD_PRINT_TEXT(rowY+tmpHeight*2+20, 60, 250, 15, "药品名称");
	LODOP.ADD_PRINT_TEXT(rowY+tmpHeight*2+20, 270, 300, 15, "药品总量(单位)");
	LODOP.ADD_PRINT_TEXT(rowY+tmpHeight*2+20, 500, 300, 15, "术中事件");
	LODOP.ADD_PRINT_LINE(rowY+tmpHeight*2+40, 40, rowY+tmpHeight*2+40, 730, 0, 1);
	LODOP.SET_PRINT_STYLE("FontSize", 10);
	
	var rowNewY=rowY+tmpHeight*3+20;
	var drugLenth=len;
	var eventData=GetAllEvents();
	for (var i=0; i<eventLenth; i++)
	{
		if (i< drugLenth)
		{
			LODOP.ADD_PRINT_TEXT(rowNewY+i*tmpHeight, 50, 250, 15, data[i].split("^")[0]);
			LODOP.ADD_PRINT_TEXT(rowNewY+i*tmpHeight, 280, 100, 15, data[i].split("^")[1]);
			LODOP.ADD_PRINT_TEXT(rowNewY+i*tmpHeight, 340, 100, 15, data[i].split("^")[2]);
			LODOP.ADD_PRINT_TEXT(rowNewY+i*tmpHeight, 390, 400, 15, eventData[i]);
			LODOP.ADD_PRINT_LINE(rowNewY+i*tmpHeight+15, 40, rowNewY+i*tmpHeight+15, 730, 0, 1);
		}
		else{
			LODOP.ADD_PRINT_TEXT(rowNewY+i*tmpHeight, 390, 400, 15, eventData[i]);
			LODOP.ADD_PRINT_LINE(rowNewY+i*tmpHeight+15, 40, rowNewY+i*tmpHeight+15, 730, 0, 1);
		}		
	}
	LODOP.ADD_PRINT_LINE(rowY+tmpHeight*2+10, 40, rowY+tmpHeight*3+eventLenth*tmpHeight+10, 40, 0, 1);
	LODOP.ADD_PRINT_LINE(rowY+tmpHeight*2+10, 260, rowY+tmpHeight*3+eventLenth*tmpHeight+10, 260, 0, 1);
	LODOP.ADD_PRINT_LINE(rowY+tmpHeight*2+10, 380, rowY+tmpHeight*3+eventLenth*tmpHeight+10, 380, 0, 1);
	LODOP.ADD_PRINT_LINE(rowY+tmpHeight*2+10, 730, rowY+tmpHeight*3+eventLenth*tmpHeight+10, 730, 0, 1);
	
	var drugs=GetPostOperActiveAna();
	if (drugs!="")
	{
		LODOP.ADD_PRINT_TEXT(rowNewY+(eventLenth+1)*tmpHeight, 50, 200, 45,"术后镇痛：");
		LODOP.SET_PRINT_STYLEA(0,"FontColor", "#ff0000"); //更换颜色
		LODOP.ADD_PRINT_TEXT(rowNewY+(eventLenth+2)*tmpHeight, 50, 690, 45,drugs);
		LODOP.SET_PRINT_STYLEA(0,"FontColor", "#ff0000"); //更换颜色
	}
	//GetAllEvents();
	
	LODOP.PREVIEW();
}

function print() {
    var LODOP = getLodop();
    createPrintOnePage(LODOP,anaestConsent.operSchedule);
    LODOP.PREVIEW();
	//LODOP.PRINT();
	$.messager.popover({msg:"打印完成！！",type:"success",timeout:2000});

}


function createPrintOnePage(LODOP,operSchedule) {
    LODOP.PRINT_INIT("打印麻、精一类同意书");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.SET_PRINT_STYLE("FontSize", 11);
    LODOP.ADD_PRINT_TEXT(30, 300, 300, 30, "南方医科大学南方医院");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 15);
    
    LODOP.ADD_PRINT_TEXT(60, 233, 520, 30, "麻醉药品、第一类精神药品使用知情同意书");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);

    //LODOP.ADD_PRINT_LINE(60, 90, 60, 741, 0, 2);
    //LODOP.ADD_PRINT_LINE(20, 80, 1030, 80, 0, 1);

    var rowY=100, lineTop=15;

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
	


    var rowTopY = 115,
    lineLeftX = 40,
    lineRightX= 740,
    rowHeight = 35;

    var patInfoRow1TopY = rowTopY;
    var patInfoRow2TopY = rowTopY+rowHeight*1;
    var patInfoRow3TopY = rowTopY+rowHeight*2;
    var patInfoRow4TopY = rowTopY+rowHeight*3;
	var patInfoRow5TopY = rowTopY+rowHeight*4;
	var patInfoRow6TopY = rowTopY+rowHeight*5;
	var patInfoRow7TopY = rowTopY+rowHeight*6;

    LODOP.ADD_PRINT_LINE(patInfoRow1TopY, lineLeftX+1, patInfoRow1TopY, lineRightX-1, 0, 1);
    LODOP.ADD_PRINT_LINE(patInfoRow2TopY, lineLeftX+1, patInfoRow2TopY, lineRightX-1, 0, 1);
    LODOP.ADD_PRINT_LINE(patInfoRow3TopY, lineLeftX+1, patInfoRow3TopY, lineRightX-1, 0, 1);
    LODOP.ADD_PRINT_LINE(patInfoRow4TopY, lineLeftX + 1, patInfoRow4TopY, lineRightX -1, 0, 1);
	
	LODOP.ADD_PRINT_TEXT(patInfoRow1TopY+10, 40, 50, 15, "ID:");
    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY+10, 70, 100, 15,operSchedule.RegNo);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	LODOP.ADD_PRINT_TEXT(patInfoRow1TopY+10, 160, 80, 15, "入院时间:");
    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY+10, 230, 130, 15,operSchedule.InHosDate);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	LODOP.ADD_PRINT_TEXT(patInfoRow1TopY+10, 400, 130, 15, "拟行手术时间:");
    LODOP.ADD_PRINT_TEXT(patInfoRow1TopY+10, 500, 130, 15,operSchedule.OperDate);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
    
	
	LODOP.ADD_PRINT_TEXT(patInfoRow2TopY+10, 40, 80, 15, "术前诊断:");
    LODOP.ADD_PRINT_TEXT(patInfoRow2TopY+10, 110, 730, 15,operSchedule.PrevDiagnosisDesc);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	//LODOP.ADD_PRINT_LINE(patInfoRow2TopY+lineTop+10, 110, patInfoRow2TopY+lineTop+10, 730, 0, 1);
	
	LODOP.ADD_PRINT_TEXT(patInfoRow3TopY+10, 40, 80, 15, "拟行手术:");
    LODOP.ADD_PRINT_TEXT(patInfoRow3TopY+10, 110, 730, 15,operSchedule.OperationDesc);
	LODOP.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	LODOP.ADD_PRINT_TEXT(patInfoRow5TopY, 40, 710, 15, "    《麻醉药品和精神药品管理条例》于2005年11月1日实施。为了提高疼痛及相关疾病患者的生存");
	LODOP.ADD_PRINT_TEXT(patInfoRow6TopY, 40, 710, 15, "质量，方便患者领用麻醉药品和第一类精神药品(以下简称麻醉和精神药品)，防止药品流失，在首次");
	LODOP.ADD_PRINT_TEXT(patInfoRow7TopY, 40, 710, 15, "建立门诊病历前，请您认真阅读以下内容:");


	var constRowTopY1 = 350;
	var rowHeightNew=30
	var constRowTopY2 = constRowTopY1+rowHeightNew*1;
	var constRowTopY3 = constRowTopY1+rowHeightNew*2;
	var constRowTopY4 = constRowTopY1+rowHeightNew*3;
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
	var constRowTopY16 = constRowTopY1+rowHeightNew*15;
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
	

	LODOP.ADD_PRINT_TEXT(constRowTopY2, 40, 710, 15, "一、患者所拥有的权利：");
	LODOP.ADD_PRINT_TEXT(constRowTopY3, 40, 710, 15, "   （一）有在医师、药师指导下获得药品的权利；");
	LODOP.ADD_PRINT_TEXT(constRowTopY4, 40, 710, 15, "   （二）有从医师、药师、护师处获得麻醉和精神药品正确、安全、有效使用和保存常识的权利；");
	LODOP.ADD_PRINT_TEXT(constRowTopY5, 40, 710, 15, "   （三）有委托亲属或者监护人代领麻醉药品的权利；");
	LODOP.ADD_PRINT_TEXT(constRowTopY6, 40, 710, 15, "   （四）权利受侵害时向有关部门投诉的权利。");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY7, 40, 710, 15, "    受理投诉卫生行政主管部门电话：61641022");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY8, 40, 710, 15, "二、患者及其亲属或者监护人的义务：");
	LODOP.ADD_PRINT_TEXT(constRowTopY9, 40, 710, 15, "   （一）遵守相关法律、法规及有关规定；");
	LODOP.ADD_PRINT_TEXT(constRowTopY10, 40, 710, 15,"   （二）如实说明病情及是否有药物依赖或药物滥用史；");
	LODOP.ADD_PRINT_TEXT(constRowTopY11, 40, 710, 15,"   （三）患者不再使用麻醉和精神药品时，立即停止取药并将剩余的药品无偿交回建立门诊病历医院；");
	LODOP.ADD_PRINT_TEXT(constRowTopY12, 40, 710, 15,"   （四）不向他人转让或者贩卖麻醉和精神药品。");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY13, 40, 710, 15,"三、重要提示：");
	LODOP.ADD_PRINT_TEXT(constRowTopY14, 40, 710, 15,"   （一）麻醉和精神药品仅供患者因疾病需要而使用，其他一切用作他用或者非法持有的行为，");
	LODOP.ADD_PRINT_TEXT(constRowTopY15, 40, 710, 15,"         都可能导致您触犯刑律或其它法律、规定，要承担相应法律责任。");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY16, 40, 710, 15,"   （二）违反有关规定时，患者或者代办人均要承担相应法律责任。");
	
	LODOP.ADD_PRINT_TEXT(constRowTopY18, 40, 710, 15," 以上内容本人已经详细阅读，同意在享有上述权利的同时，履行相应的义务。");
	
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
	
	LODOP.ADD_PRINT_TEXT(noteRowTopY2+10, 400, 400, 15, "南方医科大学南方医院");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 13);
	LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
	
	LODOP.ADD_PRINT_TEXT(noteRowTopY4, 40, 400, 15, " 经办人医师签名：");
	LODOP.ADD_PRINT_TEXT(noteRowTopY4, 500, 400, 15, "   年     月     日");
	LODOP.ADD_PRINT_TEXT(noteRowTopY5, 40, 400, 15, " 患者(家属)签名：");
	LODOP.ADD_PRINT_TEXT(noteRowTopY5, 500, 400, 15, "   年     月     日");
	LODOP.ADD_PRINT_TEXT(noteRowTopY6, 40, 400, 15,"   与患者的关系：");
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


/// 术后镇痛
function GetPostOperActiveAna() {
    var opsId = anaestConsent.operSchedule.RowId;
	var AllDrugs="";
    var data = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.TestTemp,
        QueryName: "GetPostOperActiveAna",
        Arg1: opsId,
        ArgCnt: 1
    }, "json",false);
	
    if (data && data.length > 0) 
	{
       for (var i=0;i<data.length;i++)
	   {
            var Description = data[i].Description;
			var DataValue = data[i].DataValue;
			var DataUnit = data[i].DataUnit;
				
			var AllDrug=Description +" "+ DataValue +" "+ DataUnit;
			if (AllDrugs=="") 
			{
				AllDrugs=AllDrug;
			}
			else
			{
				AllDrugs=AllDrugs+", "+AllDrug;
			}
        }
    }
	return AllDrugs;
}

/**
 * 获取麻醉药品数据
 */
function getBackPageData() {
    var opsId = anaestConsent.operSchedule.RowId;
    var operDrugDataList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.TestTemp,
        QueryName: 'FindDrugDatasNew',
        Arg1: opsId,
        Arg2: 'N',
        ArgCnt: 2
    }, 'json', false);

    var drugPageData = {};
    var length = operDrugDataList.length;
    for (var i = 0; i < length; i++) {
		var doseUnitDesc=operDrugDataList[i].DoseUnitDesc;
		if(doseUnitDesc=="")
		{
			doseUnitDesc=operDrugDataList[i].SpeedUnitDesc;
		}
		if(doseUnitDesc=="")
		{
			doseUnitDesc=operDrugDataList[i].ConcentrationUnitDesc;
		}
        drugPageData[i] = operDrugDataList[i].Description + "^" + operDrugDataList[i].total + "^" + doseUnitDesc;
		doseUnitDesc="";
    }
	
	var operSelfDrugDataList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.TestTemp,
        QueryName: 'FindDrugDatasNew2',
        Arg1: opsId,
        Arg2: 'N',
        ArgCnt: 2
    }, 'json', false);
	var length2 = operSelfDrugDataList.length;
	for (var i = length; i < (length2+length); i++) {
		var doseUnitDesc=operSelfDrugDataList[i-length].DoseUnitDesc;
		if(doseUnitDesc=="")
		{
			doseUnitDesc=operSelfDrugDataList[i-length].SpeedUnitDesc;
		}
		if(doseUnitDesc=="")
		{
			doseUnitDesc=operSelfDrugDataList[i-length].ConcentrationUnitDesc;
		}
        drugPageData[i] = operSelfDrugDataList[i-length].Description  + "^"  + operSelfDrugDataList[i-length].total + "^" + doseUnitDesc;
		doseUnitDesc="";
    }
	
	var operUnDrugDataList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.TestTemp,
        QueryName: 'FindDrugDatasNew3',
        Arg1: opsId,
        Arg2: 'N',
        ArgCnt: 2
    }, 'json', false);
	var length3 = operUnDrugDataList.length;
	for (var i = length+length2; i < (length2+length+length3); i++) {
		var doseUnitDesc=operUnDrugDataList[i-length-length2].DoseUnitDesc;
		if(doseUnitDesc=="")
		{
			doseUnitDesc=operUnDrugDataList[i-length-length2].SpeedUnitDesc;
		}
		if(doseUnitDesc=="")
		{
			doseUnitDesc=operUnDrugDataList[i-length-length2].ConcentrationUnitDesc;
		}
        drugPageData[i] = operUnDrugDataList[i-length-length2].Description  + "^"  + operUnDrugDataList[i-length-length2].total + "^" + doseUnitDesc;
		doseUnitDesc="";
    }

    return drugPageData;
}

/**
 * 获取所有事件
 **/
 function GetAllEvents()
 {
	var opsId = anaestConsent.operSchedule.RowId;
    var eventList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.TestTemp,
        QueryName: 'FindAllEvents',
        Arg1: opsId,
        Arg2: 'N',
        ArgCnt: 2
    }, 'json', false);

    var eventsData = {};
    var length = eventList.length;
    for (var i = 0; i < length; i++) {
        eventsData[i] = eventList[i].StartTime + "  " + eventList[i].Description;
		doseUnitDesc="";
    }
	return eventsData;
 }