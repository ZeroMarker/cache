$(document).ready(function() {
	initPage();
    operDataManager.initFormData(loadPatInfo,refreshAssessmentResults);
    
    operDataManager.setCheckChange();
    signCommon.loadSignature();
});

function initPage(){
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
            //window.location.reload();
        }
    });
	
	$("#btnPrint").linkbutton({
        onClick: printPosAnesthetic
    });
	
	$("#btnPrintView").linkbutton({
        onClick: printPosAnestheticvisit
	});

	$("#btnGetVolume").linkbutton({
        onClick: GetPatOutInVolume
    });
	
	SetDefaultValue();

	var opsId = dhccl.getQueryString("opsId");
	GetPatVital(opsId);
	GetPatOutInVolume();
	var InPACUOrOutTube10=$("#InPACUOrOutTube10").val();
	if (InPACUOrOutTube10=="入室后10min")
	{
		$("#InPACU10min").show();
		$("#TubeOut10min").hide();
	}
	else if (InPACUOrOutTube10=="拔管后10min")
	{
		$("#InPACU10min").hide();
		$("#TubeOut10min").show();
	}
	else
	{
		$("#InPACU10min").hide();
		$("#TubeOut10min").hide();
	}
	var InPACUOrOutTube60=$("#InPACUOrOutTube60").val();
	if (InPACUOrOutTube60=="入室后60min")
	{
		$("#InPACU60min").show();
		$("#TubeOut60min").hide();
	}
	else if (InPACUOrOutTube60=="拔管后60min")
	{
		$("#InPACU60min").hide();
		$("#TubeOut60min").show();
	}
	else
	{
		$("#InPACU60min").hide();
		$("#TubeOut60min").hide();
	}
	/*

    $("#btnVisitNurseSign,#btnAssessmentNurseSign").linkbutton({
        onClick:function(){
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

    $("#PressureSore1,#PressureSore2").radio({
        onChecked: function() {
            var hasPressureSore = $(this).attr('id') === "PressureSore2";
            if (hasPressureSore) {
                $(".pressurescore-description").show();
            } else {
                $(".pressurescore-description").hide();
            }
        }
    });
    
    $(".assess-form").find(".hisui-radio").radio({
        onChecked: refreshAssessmentResults
    });
    
    $(".assess-form").find(".hisui-checkbox").checkbox({
        onChecked: refreshAssessmentResults,
        onUnChecked: refreshAssessmentResults
    });
	*/
}

function InPACUShow(event,value)
{
	$("#InPACU10min").show();
	$("#TubeOut10min").hide();
}

function InPACUHide(event,value)
{
	$("#InPACU10min").hide();
	//$("#YMMethodRow").show();
}

function OutTubeShow(event,value)
{
	$("#TubeOut10min").show();
	$("#InPACU10min").hide();
}

function OutTubeHide(event,value)
{
	$("#TubeOut10min").hide();
	//$("#YMMethodRow").show();
}



function InPACUShow60(event,value)
{
	$("#InPACU60min").show();
	$("#TubeOut60min").hide();
}

function InPACUHide60(event,value)
{
	$("#InPACU60min").hide();
	//$("#YMMethodRow").show();
}

function OutTubeShow60(event,value)
{
	$("#TubeOut60min").show();
	$("#InPACU60min").hide();
}

function OutTubeHide60(event,value)
{
	$("#TubeOut60min").hide();
	//$("#YMMethodRow").show();
}

var assessmentResultList = {
    scattTrigger: [{
        range: {
            min: 0,
            max: 1
        },
        result: "低风险"
    }, {
        range: {
            min: 2,
            max: 4
        },
        result: "高风险"
    }],
    preoper: [{
        range: {
            min: 0,
            max: 6
        },
        result: "低风险"
    }, {
        range: {
            min: 7,
            max: 14
        },
        result: "中风险"
    }, {
        range: {
            min: 15,
            max: 21
        },
        result: "高风险"
    }],
    inoper: [{
        range: {
            min: 0,
            max: 13
        },
        result: "低风险"
    }, {
        range: {
            min: 14,
            max: 24
        },
        result: "中风险"
    }, {
        range: {
            min: 25,
            max: 39
        },
        result: "高风险"
    }],
    postoper: [{
        range: {
            min: 0,
            max: 15
        },
        result: "低风险"
    }, {
        range: {
            min: 16,
            max: 28
        },
        result: "中风险"
    }, {
        range: {
            min: 29,
            max: 45
        },
        result: "高风险"
    }]
}

function printPosAnestheticvisit() {
    var lodop = getLodop();
    drawPrintOnePage(lodop);
    //lodop.PRINT_INIT("创建打印麻醉后访视记录单");
	//lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    //lodop.SET_PRINT_STYLE("FontSize", 9);
	//lodop.ADD_PRINT_TEXT(30, 300, 300, 30, "南方医科大学南方医院11212121");
	
	//lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    //lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
    //lodop.SET_PREVIEW_WINDOW(1, 0, 0, 0, 0, "");
    lodop.PREVIEW();
    //lodop.PRINT();
    //lodop.PRINT_SETUP();
}

function printPosAnesthetic() {
    var lodop = getLodop();
    drawPrintOnePage(lodop);
    //lodop.PRINT_INIT("创建打印麻醉后访视记录单");
	//lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    //lodop.SET_PRINT_STYLE("FontSize", 9);
	//lodop.ADD_PRINT_TEXT(30, 300, 300, 30, "南方医科大学南方医院11212121");
	
	//lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    //lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
    //lodop.SET_PREVIEW_WINDOW(1, 0, 0, 0, 0, "");
    //lodop.PREVIEW();
    lodop.PRINT();
    //lodop.PRINT_SETUP();
}

function drawPrintOnePage(lodop) {
    lodop.PRINT_INIT("创建打印PACU护理记录单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
   // lodop.SET_PRINT_STYLE("FontName", "微软雅黑");
    lodop.SET_PRINT_STYLE("FontSize", 9);
	lodop.ADD_PRINT_TEXT(30, 300, 300, 30, "南方医科大学南方医院");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 15);
    
    lodop.ADD_PRINT_TEXT(60, 330, 220, 30, "PACU护理记录单");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);

    lodop.ADD_PRINT_TEXT(110, 30, 80, 15, "姓名:");
    lodop.ADD_PRINT_LINE(125, 65, 125, 180, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 70, 170, 15, $("#PatName").text());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色

    lodop.ADD_PRINT_TEXT(110, 185, 50, 15, "性别:");
    lodop.ADD_PRINT_LINE(125, 220, 125, 250, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 225, 80, 15, $("#PatGender").text());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色

    lodop.ADD_PRINT_TEXT(110, 255, 50, 15, "年龄:");
    lodop.ADD_PRINT_LINE(125, 290, 125, 330, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 295, 80, 15, $("#PatAge").text());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色

    lodop.ADD_PRINT_TEXT(110, 340, 80, 15, "住院号:");
    lodop.ADD_PRINT_LINE(125, 385, 125, 450, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 390, 140, 15, $("#MedcareNo").text());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色

	lodop.ADD_PRINT_TEXT(110, 465, 80, 15, "ID:");
    lodop.ADD_PRINT_LINE(125, 485, 125, 570, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 490, 140, 15, $("#RegNo").text());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	
    lodop.ADD_PRINT_TEXT(110, 590, 50, 15, "床号:");
    lodop.ADD_PRINT_LINE(125, 620, 125, 680, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 630, 80, 15, $("#PatBedCode").text());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
    lodop.ADD_PRINT_TEXT(140, 30, 80, 15, "科室:");
    lodop.ADD_PRINT_LINE(155, 65, 155, 310, 0, 1);
    lodop.ADD_PRINT_TEXT(140, 70, 230, 15, $("#PatDeptDesc").text());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色

	lodop.ADD_PRINT_TEXT(140, 350, 90, 15, "ASA分级:");
    lodop.ADD_PRINT_LINE(155, 400, 155, 450, 0, 1);
    lodop.ADD_PRINT_TEXT(140, 405, 80, 15, $("#ASAClass").text()+"级");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_TEXT(140, 485, 90, 15, "麻醉方式:");
    lodop.ADD_PRINT_LINE(155, 540, 155, 680, 0, 1);
    lodop.ADD_PRINT_TEXT(140, 545, 230, 15, $("#AnaestMethod").text());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色

    lodop.ADD_PRINT_TEXT(170, 30, 80, 15, "护理重点:");
    lodop.ADD_PRINT_LINE(185, 100, 185, 470, 0, 1);
    lodop.ADD_PRINT_TEXT(170, 105, 300, 15, $("#CareFocus").val());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_TEXT(170, 485, 90, 15, "手术日期:");
    lodop.ADD_PRINT_LINE(185, 540, 185, 680, 0, 1);
    lodop.ADD_PRINT_TEXT(170, 545, 230, 15, $("#OperDate").text());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	
	var qsmzHeight=20;
	var lineHeght=25;
	var qsmzRow=195;
	var lineRow=200;
	var qsmzRow1=qsmzRow+qsmzHeight*1;
	var qsmzRow2=qsmzRow+qsmzHeight*2;
	var qsmzRow3=qsmzRow+qsmzHeight*3;
	var qsmzRow4=qsmzRow+qsmzHeight*4;
	var qsmzRow5=qsmzRow+qsmzHeight*5;
	var qsmzRow6=qsmzRow+qsmzHeight*6;
	var qsmzRow7=qsmzRow+qsmzHeight*7;
	var qsmzRow8=qsmzRow+qsmzHeight*8;
	var qsmzRow9=qsmzRow+qsmzHeight*9;
	var qsmzRow10=qsmzRow+qsmzHeight*10;
	var qsmzRow11=qsmzRow+qsmzHeight*11;
	var qsmzRow12=qsmzRow+qsmzHeight*12;
	var qsmzRow14=qsmzRow+qsmzHeight*14;
	var qsmzRow15=qsmzRow+qsmzHeight*15;
	var qsmzRow16=qsmzRow+qsmzHeight*16;
	var qsmzRow17=qsmzRow+qsmzHeight*17;
	var qsmzRow18=qsmzRow+qsmzHeight*18;
	
	var lineRow1=lineRow+lineHeght*1;
	lodop.ADD_PRINT_TEXT(qsmzRow+10, 30, 35, 200, "PACU");
	lodop.ADD_PRINT_TEXT(qsmzRow+30, 35, 20, 200, "交接··十一知道交接");
	lodop.ADD_PRINT_RECT(190,23,35,qsmzHeight*11,0,1);
	lodop.ADD_PRINT_RECT(190,23,738,qsmzHeight*11,0,1);
	
	lodop.ADD_PRINT_LINE(qsmzRow-5, 560, qsmzRow3+15, 560, 0, 1);
	
	lodop.ADD_PRINT_TEXT(qsmzRow, 100, 200, 15, "全麻");
	lodop.ADD_PRINT_TEXT(qsmzRow, 570, 200, 15, "硬膜外麻醉/腰麻、神经阻滞");
lodop.ADD_PRINT_LINE(qsmzRow+15, 60, qsmzRow+15, 761, 0, 1);	
	lodop.ADD_PRINT_TEXT(qsmzRow1+5, 580, 200, 15, "入室麻醉平面：");
	lodop.ADD_PRINT_TEXT(qsmzRow1+5, 670, 200, 15, $("#InAnesthesiaPlane").val());
	//lodop.ADD_PRINT_TEXT(qsmzRow1+5, 680, 200, 15, $("#InAnesthesiaPlane").combobox("getText"));
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow2+10, 580, 200, 15, "出室麻醉平面：");
	lodop.ADD_PRINT_TEXT(qsmzRow2+10, 670, 200, 15, $("#OutAnesthesiaPlane").val());
	//lodop.ADD_PRINT_TEXT(qsmzRow2+10, 680, 200, 15, $("#OutAnesthesiaPlane").combobox("getText"));
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	///lodop.ADD_PRINT_HTM(qsmzRow1-2, 60, 80, 20, '<input type="checkbox" class="TracheaCannula" value="气管插管"' + CheckBoxValue("TracheaCannula", "气管插管") + '>');
	var tracheaCannula=CheckBoxValue("TracheaCannula", "气管插管");
	///alert(tracheaCannula);
	if(tracheaCannula=="checked")
	{
		DrawRectAndRight(lodop,qsmzRow1,60);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow1,60);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow1, 80, 200, 15, "气管插管");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow1-2, 140, 80, 20, '<input type="checkbox" class="LaryngealMaskAirway" value="置入喉罩"' + CheckBoxValue("LaryngealMaskAirway", "置入喉罩") + '>');
	var LaryngealMaskAirway=CheckBoxValue("LaryngealMaskAirway", "置入喉罩");
	if(LaryngealMaskAirway=="checked")
	{
		DrawRectAndRight(lodop,qsmzRow1,140);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow1,140);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow1, 160, 200, 15, "置入喉罩");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow1-2, 220, 80, 20, '<input type="checkbox" class="Extubation" value="无或已拔除气管导管(喉罩)"' + CheckBoxValue("Extubation", "无或已拔除气管导管(喉罩)") + '>');
	var Extubation=CheckBoxValue("Extubation", "无或已拔除气管导管(喉罩)");
	if(Extubation=="checked")
	{
		DrawRectAndRight(lodop,qsmzRow1,220);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow1,220);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow1, 240, 300, 15, "无或已拔除气管导管(喉罩)");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow1, 420, 100, 15, "自主呼吸");
	///lodop.ADD_PRINT_HTM(qsmzRow1-2, 480, 80, 20, '<input type="checkbox" class="AutoRespiration" value="有"' + CheckBoxValue("AutoRespiration", "有") + '>');
	var AutoRespiration=$("#AutoRespiration").val();
	if(AutoRespiration.indexOf("有")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow1,480);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow1,480);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow1, 500, 100, 15, "有");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow1-2, 520, 80, 20, '<input type="checkbox" class="AutoRespiration" value="无"' + CheckBoxValue("AutoRespiration", "无") + '>');
	if(AutoRespiration.indexOf("无")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow1,520);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow1,520);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow1, 540, 100, 15, "无");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_TEXT(qsmzRow2, 60, 220, 15, "麻醉机机械通气潮气量:");
	lodop.ADD_PRINT_TEXT(qsmzRow2, 190, 80, 15, $("#TidalVolume").val()+" ml");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow2, 280, 80, 15, "呼吸频率:");
	lodop.ADD_PRINT_TEXT(qsmzRow2, 340, 80, 15, $("#RespRate").val()+" 次/分");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow2, 410, 80, 15, "插管深度:");
	lodop.ADD_PRINT_TEXT(qsmzRow2, 470, 80, 15, $("#TubeDepth").val()+" cm");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_TEXT(qsmzRow3, 60, 120, 15, "牙齿情况:");
	
	var Tooth=$("#Tooth").val();
	if(Tooth.indexOf("固定")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow3,130);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow3,130);
	}
	///lodop.ADD_PRINT_HTM(qsmzRow3-2,130, 80, 20, '<input type="checkbox" class="Tooth" value="松动"' + CheckBoxValue("Tooth", "松动") + '>');
	lodop.ADD_PRINT_TEXT(qsmzRow3, 150, 120, 15, "固定");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow3-2,210, 80, 20, '<input type="checkbox" class="Tooth" value="假牙"' + CheckBoxValue("Tooth", "假牙") + '>');
	if(Tooth.indexOf("松动")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow3,210);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow3,210);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow3, 230, 120, 15, "松动");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow3-2,290, 80, 20, '<input type="checkbox" class="Tooth" value="缺牙"' + CheckBoxValue("Tooth", "缺牙") + '>');
	if(Tooth.indexOf("假牙")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow3,290);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow3,290);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow3, 310, 120, 15, "假牙");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色

	if(Tooth.indexOf("缺牙")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow3,370);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow3,370);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow3, 390, 120, 15, "缺牙");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色


lodop.ADD_PRINT_LINE(qsmzRow3+15, 60, qsmzRow3+15, 761, 0, 1);	
	lodop.ADD_PRINT_TEXT(qsmzRow4, 60, 120, 15, "气道情况:");
	lodop.ADD_PRINT_TEXT(qsmzRow4, 130, 280, 15, $("#AirwayCondition").val());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow4, 400, 150, 15, "术中特殊情况:");
	lodop.ADD_PRINT_TEXT(qsmzRow4, 490, 250, 15, $("#SurgicalCondition").val());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
lodop.ADD_PRINT_LINE(qsmzRow4+15, 60, qsmzRow4+15, 761, 0, 1);		
	lodop.ADD_PRINT_TEXT(qsmzRow5, 60, 120, 15, "术前合并症:");
	lodop.ADD_PRINT_TEXT(qsmzRow5, 140, 280, 15, $("#PreopComplication").val());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow5, 400, 150, 15, "过敏史:");
	lodop.ADD_PRINT_TEXT(qsmzRow5, 460, 250, 15, $("#AllergyHistory").val());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
lodop.ADD_PRINT_LINE(qsmzRow5+15, 60, qsmzRow5+15, 761, 0, 1);			
	lodop.ADD_PRINT_TEXT(qsmzRow6, 60, 520, 15, "查看病历、手腕带及麻醉收费单上患者的信息是否与巡回护士（手术医生）口述一致");
	///lodop.ADD_PRINT_HTM(qsmzRow6-2, 580, 80, 20, '<input type="checkbox" class="IDCheck" value="是"' + CheckBoxValue("IDCheck", "是") + '>');
	var IDCheck=CheckBoxValue("IDCheck", "是");
	if(IDCheck=="checked")
	{
		DrawRectAndRight(lodop,qsmzRow6,580);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow6,580);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow6, 600, 100, 15, "是");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
lodop.ADD_PRINT_LINE(qsmzRow6+15, 60, qsmzRow6+15, 761, 0, 1);		
	lodop.ADD_PRINT_TEXT(qsmzRow7, 60, 520, 15, "与麻醉医生交接和查对患者是否使用镇痛泵，核查泵内药物名称、剂量与使用状态情况");
	///lodop.ADD_PRINT_HTM(qsmzRow7-2, 580, 80, 20, '<input type="checkbox" class="DrugCheck" value="是"' + CheckBoxValue("DrugCheck", "是") + '>');
	var DrugCheck=CheckBoxValue("DrugCheck", "是");
	if(DrugCheck=="checked")
	{
		DrawRectAndRight(lodop,qsmzRow7,580);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow7,580);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow7, 600, 100, 15, "是");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
lodop.ADD_PRINT_LINE(qsmzRow7+15, 60, qsmzRow7+15, 761, 0, 1);		

	lodop.ADD_PRINT_TEXT(qsmzRow8, 60, 120, 15, "压疮/压红:");
	////lodop.ADD_PRINT_HTM(qsmzRow8-2, 140, 80, 20, '<input type="checkbox" class="AutoRespiration" value="有"' + CheckBoxValue("AutoRespiration", "有") + '>');
	var AutoRespiration=$("#PressureSore").val();
	if(AutoRespiration.indexOf("有")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow8,140);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow8,140);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow8, 160, 100, 15, "有");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow8-2, 180, 80, 20, '<input type="checkbox" class="AutoRespiration" value="无"' + CheckBoxValue("AutoRespiration", "无") + '>');
	if(AutoRespiration.indexOf("无")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow8,180);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow8,180);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow8, 200, 100, 15, "无");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow8, 220, 250, 15, "(如有，请填写PACU压疮交接记录本)");
	
	lodop.ADD_PRINT_TEXT(qsmzRow8, 460, 200, 15, "肢体有无血流障碍:");
	///lodop.ADD_PRINT_HTM(qsmzRow8-2, 580, 80, 20, '<input type="checkbox" class="BloodFlowDisorder" value="有"' + CheckBoxValue("BloodFlowDisorder", "有") + '>');
	var BloodFlowDisorder=$("#BloodFlowDisorder").val();
	if(BloodFlowDisorder.indexOf("有")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow8,580);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow8,580);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow8, 600, 100, 15, "有");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow8-2, 630, 80, 20, '<input type="checkbox" class="BloodFlowDisorder" value="无"' + CheckBoxValue("BloodFlowDisorder", "无") + '>');
	if(BloodFlowDisorder.indexOf("无")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow8,630);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow8,630);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow8, 650, 100, 15, "无");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_TEXT(qsmzRow9, 60, 120, 15, "输液：通畅");
	///lodop.ADD_PRINT_HTM(qsmzRow9-2, 140, 80, 20, '<input type="checkbox" class="InfusionSmooth" value="是"' + CheckBoxValue("InfusionSmooth", "是") + '>');
	var InfusionSmooth=$("#InfusionSmooth").val();
	if(InfusionSmooth.indexOf("是")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow9,140);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow9,140);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow9, 160, 100, 15, "是");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow9-2, 180, 80, 20, '<input type="checkbox" class="InfusionSmooth" value="否"' + CheckBoxValue("InfusionSmooth", "否") + '>');
	if(InfusionSmooth.indexOf("否")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow9,180);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow9,180);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow9, 200, 100, 15, "否");	
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_TEXT(qsmzRow9, 260, 120, 15, "输液部位肿胀:");
	///lodop.ADD_PRINT_HTM(qsmzRow9-2, 360, 80, 20, '<input type="checkbox" class="InfusionSiteSwelling" value="是"' + CheckBoxValue("InfusionSiteSwelling", "是") + '>');
	var InfusionSiteSwelling=$("#InfusionSiteSwelling").val();
	if(InfusionSiteSwelling.indexOf("是")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow9,360);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow9,360);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow9, 380, 100, 15, "是");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow9-2, 400, 80, 20, '<input type="checkbox" class="InfusionSiteSwelling" value="否"' + CheckBoxValue("InfusionSiteSwelling", "否") + '>');
	if(InfusionSiteSwelling.indexOf("否")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow9,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow9,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow9, 420, 100, 15, "否");	
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_TEXT(qsmzRow9, 480, 120, 15, "中心静脉置管:");
	///lodop.ADD_PRINT_HTM(qsmzRow9-2, 580, 80, 20, '<input type="checkbox" class="CVSCatheter" value="是"' + CheckBoxValue("CVSCatheter", "是") + '>');
	var CVSCatheter=CheckBoxValue("CVSCatheter","是");
	if(CVSCatheter=="checked")
	{
		DrawRectAndRight(lodop,qsmzRow9,580);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow9,580);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow9, 600, 100, 15, "是");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow9, 630, 100, 15, "置管深度:");	
	lodop.ADD_PRINT_TEXT(qsmzRow9, 690, 100, 15, $("#CVSTubeDepth").val()+" cm");	
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow10, 60, 120, 15, "切口辅料渗血:");
	///lodop.ADD_PRINT_HTM(qsmzRow10-2, 160, 80, 20, '<input type="checkbox" class="IncisionDressingOozing" value="有"' + CheckBoxValue("IncisionDressingOozing", "有") + '>');
	var IncisionDressingOozing=$("#IncisionDressingOozing").val();
	if(IncisionDressingOozing.indexOf("有")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow10,140);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow10,140);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow10, 160, 100, 15, "有");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow10-2, 200, 80, 20, '<input type="checkbox" class="IncisionDressingOozing" value="无"' + CheckBoxValue("IncisionDressingOozing", "无") + '>');
	if(IncisionDressingOozing.indexOf("无")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow10,180);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow10,180);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow10, 200, 100, 15, "无");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_TEXT(qsmzRow10, 260, 120, 15, "引流管通畅:");
	///lodop.ADD_PRINT_HTM(qsmzRow10-2, 390, 80, 20, '<input type="checkbox" class="DrainageTube" value="是"' + CheckBoxValue("DrainageTube", "是") + '>');
	var DrainageTube=$("#DrainageTube").val();
	if(DrainageTube.indexOf("是")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow10,360);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow10,360);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow10, 380, 100, 15, "是");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow10-2, 430, 80, 20, '<input type="checkbox" class="DrainageTube" value="否"' + CheckBoxValue("DrainageTube", "否") + '>');
	if(DrainageTube.indexOf("否")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow10,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow10,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow10, 420, 100, 15, "否");	
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	
	lodop.ADD_PRINT_TEXT(qsmzRow10, 450, 100, 15, "引流液:");
	var DrainageLiquids=$("#DrainageLiquids").val();
	if(DrainageLiquids.indexOf("无")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow10,500);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow10,500);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow10, 520, 100, 15, "无");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	if(DrainageLiquids.indexOf("有")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow10,540);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow10,540);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow10, 560, 100, 15, "有");	
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow10, 580, 100, 15, "性质");
	lodop.ADD_PRINT_TEXT(qsmzRow10, 610, 80, 15, $("#DrainageProperties").val());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow10, 710, 100, 15, "量");
	lodop.ADD_PRINT_TEXT(qsmzRow10, 725, 200, 15, $("#DrainageVolume").val()+"ml");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色	
	
	////表格
	lodop.ADD_PRINT_RECT(qsmzRow11-5,23,80,qsmzHeight*15,0,1);   // 前表格
	lodop.ADD_PRINT_RECT(qsmzRow11-5,23,738,qsmzHeight*15,0,1);  // 后表格
	
	qsmzRow12=qsmzRow12+5;
	lodop.ADD_PRINT_TEXT(qsmzRow12-5, 35, 70, 120, "护理评估");
	lodop.ADD_PRINT_TEXT(qsmzRow12+20, 25, 90, 120, "(Aldrete评分)");
	lodop.ADD_PRINT_TEXT(qsmzRow15, 30, 80, 220, "注：");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#ff0000"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow16-5, 40, 70, 220, "5项总分为10分，当患者评分≥9分，可以考虑转出PACU");
	lodop.SET_PRINT_STYLE("FontSize", 8);
	lodop.ADD_PRINT_LINE(qsmzRow11+15, 102, qsmzRow11+15, 761, 0, 1);
	
	lodop.ADD_PRINT_TEXT(qsmzRow11, 110, 70, 120, "活动状态");
	lodop.ADD_PRINT_TEXT(qsmzRow11, 180, 70, 120, "呼吸状态");
	lodop.ADD_PRINT_TEXT(qsmzRow11, 250, 70, 120, "循环状态");
	lodop.ADD_PRINT_TEXT(qsmzRow11, 320, 70, 120, "意识状态");
	lodop.ADD_PRINT_TEXT(qsmzRow11, 400, 70, 120, "SpO2(%)");
	lodop.ADD_PRINT_TEXT(qsmzRow11, 470, 70, 120, "总分");
	lodop.ADD_PRINT_TEXT(qsmzRow11, 515, 90, 120, "瞳孔大小mm");
	lodop.ADD_PRINT_TEXT(qsmzRow11, 600, 70, 120, "恶心呕吐");
	lodop.ADD_PRINT_TEXT(qsmzRow11, 680, 70, 120, "疼痛指数");
	
	lodop.SET_PRINT_STYLE("FontSize", 8);
	//lodop.ADD_PRINT_HTM(qsmzRow12,110, 15, "BottomMargin:0.3mm", '<sup>能自由或按指令移动四肢</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,130, 15, "BottomMargin:0.1mm", '<sup>能移动两个肢</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,150, 15, "BottomMargin:0.1mm", '<sup>无法按指令移动四肢</sup>');
	lodop.ADD_PRINT_TEXT(qsmzRow12, 110, 20, 300, "能自由或按指令移动四肢");
	lodop.ADD_PRINT_TEXT(qsmzRow12, 130, 20, 300, "能移动两个肢");
	lodop.ADD_PRINT_TEXT(qsmzRow12,150, 20, 300, "无法按指令移动四肢");
	

	//lodop.ADD_PRINT_HTM(qsmzRow12,180, 15, "BottomMargin:0.1mm", '<sup>可深呼吸、咳嗽</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,200, 15, "BottomMargin:0.1mm", '<sup>呼吸浅、快、困难</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,220, 15, "BottomMargin:0.1mm", '<sup>呼吸暂停</sup>');
	lodop.ADD_PRINT_TEXT(qsmzRow12, 180, 20, 300, "可深呼吸、咳嗽");
	lodop.ADD_PRINT_TEXT(qsmzRow12, 200, 20, 300, "呼吸浅、快、困难");
	lodop.ADD_PRINT_TEXT(qsmzRow12,220, 20, 300, "呼吸暂停");
	
	//lodop.ADD_PRINT_HTM(qsmzRow12,250, 15, "BottomMargin:0.1mm", '<sup>血压波动不超过麻醉前的20%</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,270, 15, "BottomMargin:0.1mm", '<sup>血压波动为麻醉前的20-49%</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,290, 15, "BottomMargin:0.1mm", '<sup>血压波动超过麻醉前的50%</sup>');
	lodop.ADD_PRINT_TEXT(qsmzRow12, 250, 25, 300, "血压波动不超过麻醉前的");
	lodop.ADD_PRINT_TEXT(qsmzRow12+165, 247, 30, 300, "20%");
	lodop.ADD_PRINT_TEXT(qsmzRow12, 270, 23, 300, "血压波动为麻醉前的20至");
	lodop.ADD_PRINT_TEXT(qsmzRow12+165, 268, 30, 300, "49%");
	lodop.ADD_PRINT_TEXT(qsmzRow12, 290, 20, 300, "血压波动超过麻醉前的");
	lodop.ADD_PRINT_TEXT(qsmzRow12+150, 288, 30, 300, "50%");
	
	//lodop.ADD_PRINT_HTM(qsmzRow12,320, 15, "BottomMargin:0.1mm", '<sup>完全清醒</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,340, 15, "BottomMargin:0.1mm", '<sup>呼唤时能睁眼</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,360, 15, "BottomMargin:0.1mm", '<sup>对呼唤无反应</sup>');
	lodop.ADD_PRINT_TEXT(qsmzRow12, 320, 20, 300, "完全清醒");
	lodop.ADD_PRINT_TEXT(qsmzRow12, 340, 20, 300, "呼唤时能睁眼");
	lodop.ADD_PRINT_TEXT(qsmzRow12,360, 20, 300, "对呼唤无反应");
	
	//lodop.ADD_PRINT_HTM(qsmzRow12,390, 15, "BottomMargin:0.1mm", '<sup>呼吸空气下大于92%</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,410, 15, "BottomMargin:0.1mm", '<sup>辅助给氧下氧饱和度大于90%</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,430, 15, "BottomMargin:0.1mm", '<sup>辅助给氧下氧饱和度小于90%</sup>');	
	lodop.ADD_PRINT_TEXT(qsmzRow12, 390, 23, 300, "呼吸空气下大于92");
	lodop.ADD_PRINT_TEXT(qsmzRow12, 410, 23, 300, "辅助给氧下氧饱和度大于90");
	lodop.ADD_PRINT_TEXT(qsmzRow12,430, 23, 300, "辅助给氧下氧饱和度小于90");
	
	//lodop.ADD_PRINT_HTM(qsmzRow12,600, 15, "BottomMargin:0.1mm", '<sup>无</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,620, 15, "BottomMargin:0.1mm", '<sup>观察</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,640, 15, "BottomMargin:0.1mm", '<sup>施予药物治疗</sup>');	
	lodop.ADD_PRINT_TEXT(qsmzRow12, 600, 20, 300, "无");
	lodop.ADD_PRINT_TEXT(qsmzRow12, 620, 20, 300, "观察");
	lodop.ADD_PRINT_TEXT(qsmzRow12,640, 20, 300, "施予药物治疗");
	
	//lodop.ADD_PRINT_HTM(qsmzRow12,670, 10, "BottomMargin:0.1mm", '<sup>0分为无痛</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,690, 10, "BottomMargin:0.1mm", '<sup>3分以下有轻微疼痛，可忍受</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,710, 10, "BottomMargin:0.1mm", '<sup>4-6分疼痛影响睡眠，可忍受</sup>');
	//lodop.ADD_PRINT_HTM(qsmzRow12,730, 10, "BottomMargin:0.1mm", '<sup>7-10分强烈疼痛，无法忍受</sup>');
	lodop.ADD_PRINT_TEXT(qsmzRow12, 670, 20, 300, "0分为无痛");
	lodop.ADD_PRINT_TEXT(qsmzRow12, 690, 20, 300, "3分以下有轻微疼痛可忍受");
	lodop.ADD_PRINT_TEXT(qsmzRow12, 705, 30, 300, "4-6");
	lodop.ADD_PRINT_TEXT(qsmzRow12+15, 710, 20, 300, "分疼痛影响睡眠可忍受");
	lodop.ADD_PRINT_TEXT(qsmzRow12, 730, 35, 300, "7-10")
	lodop.ADD_PRINT_TEXT(qsmzRow12+15, 730, 20, 300, "分强烈疼痛无法忍受");
	
	lodop.SET_PRINT_STYLE("FontSize", 9);
	
	var qsmzRow22=qsmzRow+qsmzHeight*22;
	var qsmzRow23=qsmzRow+qsmzHeight*23;
	var qsmzRow24=qsmzRow+qsmzHeight*24;
	var qsmzRow25=qsmzRow+qsmzHeight*25;
	var qsmzRow26=qsmzRow+qsmzHeight*26;
	var qsmzRow27=qsmzRow+qsmzHeight*27;
	var qsmzRow28=qsmzRow+qsmzHeight*28;
	var qsmzRow29=qsmzRow+qsmzHeight*29;

lodop.ADD_PRINT_LINE(qsmzRow22-8, 23, qsmzRow22-8, 761, 0, 1);
	lodop.ADD_PRINT_TEXT(qsmzRow22, 35, 70, 120, "时间/评分");
	
	var InPACUOrOutTube10=$("#InPACUOrOutTube10").val();
	if (InPACUOrOutTube10=="入室后10min")
	{
		lodop.ADD_PRINT_TEXT(qsmzRow23, 30, 110, 120, "入室后10min");
	}
	else if (InPACUOrOutTube10=="拔管后10min")
	{
		lodop.ADD_PRINT_TEXT(qsmzRow23, 30, 110, 120, "拔管后10min");
	}
	var InPACUOrOutTube60=$("#InPACUOrOutTube60").val();
	if (InPACUOrOutTube60=="入室后60min")
	{
		lodop.ADD_PRINT_TEXT(qsmzRow24, 30, 110, 120, "入室后60min");
	}
	else if (InPACUOrOutTube60=="拔管后60min")
	{
		lodop.ADD_PRINT_TEXT(qsmzRow24, 30, 110, 120, "拔管后60min");
	}
	lodop.ADD_PRINT_TEXT(qsmzRow25, 35, 70, 120, "出室时");
	
	//lodop.ADD_PRINT_TEXT(qsmzRow23, 35, 120, 120, "入室后10min");
	//lodop.ADD_PRINT_TEXT(qsmzRow24, 35, 120, 120, "拔管后10min");
	//lodop.ADD_PRINT_TEXT(qsmzRow25, 25, 120, 120, "拔管后60min");
	//lodop.ADD_PRINT_TEXT(qsmzRow26, 35, 70, 120, "出室时");
	
	lodop.SET_PRINT_STYLE("FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow22,110, 15, 30, "2");
	lodop.ADD_PRINT_TEXT(qsmzRow22,130, 15, 30, "1");
	lodop.ADD_PRINT_TEXT(qsmzRow22,150, 15, 30, "0");
	
	var InPACUOrOutTube10=$("#InPACUOrOutTube10").val();
	if (InPACUOrOutTube10=="入室后10min")
	{
		if (($('#InActivity').attr('data-score')=="")&&($('#InActivity').val()!="")) //活动能力
		{
			lodop.ADD_PRINT_TEXT(qsmzRow23,130, 30, 30, '0');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow23,130, 30, 30, $('#InActivity').attr('data-score'));
		}
		if (($('#InRespiration').attr('data-score')=="")&&($('#InRespiration').val()!="")) // 呼吸状态
		{
			lodop.ADD_PRINT_TEXT(qsmzRow23,200, 30, 30, '0');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow23,200, 30, 30, $('#InRespiration').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow23,200, 30, 30, $('#InRespiration').attr('data-score'));
		
		if (($('#InCirculation').attr('data-score')=="")&&($('#InCirculation').val()!="")) // 循环状态
		{
			lodop.ADD_PRINT_TEXT(qsmzRow23,270, 30, 30, '1');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow23,270, 30, 30, $('#InCirculation').attr('data-score'));
		}
	//lodop.ADD_PRINT_TEXT(qsmzRow23,270, 30, 30, $('#InCirculation').attr('data-score'));
	
		if (($('#InConsciousness').attr('data-score')=="")&&($('#InConsciousness').val!="")) //意识状态
		{
			lodop.ADD_PRINT_TEXT(qsmzRow23,340, 30, 30, '0');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow23,340, 30, 30, $('#InConsciousness').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow23,340, 30, 30, $('#InConsciousness').attr('data-score'));
		
		if (($('#InSPO2').attr('data-score')=="") && ($('#InSPO2').val()!="")) //SPO2
		{
			lodop.ADD_PRINT_TEXT(qsmzRow23,410, 30, 30, '1');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow23,410, 30, 30, $('#InSPO2').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow23,410, 30, 30, $('#InSPO2').attr('data-score'));
		
		if (($('#InSickVomit').attr('data-score')=="")&&($('#InSickVomit').val()!=""))  //恶心呕吐
		{
			lodop.ADD_PRINT_TEXT(qsmzRow23,620, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow23,620, 30, 30, $('#InSickVomit').attr('data-score'));
		}
	}
	else if (InPACUOrOutTube10=="拔管后10min")
	{
		if (($('#TubeOutActivity').attr('data-score')=="")&&($('#TubeOutActivity').val()!=""))  //活动能力
		{
			lodop.ADD_PRINT_TEXT(qsmzRow23,130, 30, 30, '1');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow23,130, 30, 30, $('#TubeOutActivity').attr('data-score'));
		}
		if (($('#TubeOutRespiration').attr('data-score')=="")&&($('#TubeOutRespiration').val()!="")) // 呼吸状态
		{
			lodop.ADD_PRINT_TEXT(qsmzRow23,200, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow23,200, 30, 30, $('#TubeOutRespiration').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow23,200, 30, 30, $('#TubeOutRespiration').attr('data-score'));
		
		if (($('#TubeOutCirculation').attr('data-score')=="")&&($('#TubeOutCirculation').val()!="")) //循环状态
		{
			lodop.ADD_PRINT_TEXT(qsmzRow23,270, 30, 30, '1');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow23,270, 30, 30, $('#TubeOutCirculation').attr('data-score'));
		}
		if (($('#TubeOutConscious').attr('data-score')=="")&&($('#TubeOutConscious').val()!="")) // 意识状态
		{
			lodop.ADD_PRINT_TEXT(qsmzRow23,340, 30, 30, '1');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow23,340, 30, 30, $('#TubeOutConscious').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow23,340, 30, 30, $('#TubeOutConscious').attr('data-score'));
		if (($('#TubeOutSPO2').attr('data-score')=="") &&($('#TubeOutSPO2').val()!="")) // SPO2
		{
			lodop.ADD_PRINT_TEXT(qsmzRow23,410, 30, 30, '1');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow23,410, 30, 30, $('#TubeOutSPO2').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow23,410, 30, 30, $('#TubeOutSPO2').attr('data-score'));
		if (($('#TubeOutSickVomit').attr('data-score')=="")&&($('#TubeOutSickVomit').val()!="")) //恶心呕吐
		{
			lodop.ADD_PRINT_TEXT(qsmzRow23,620, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow23,620, 30, 30, $('#TubeOutSickVomit').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow23,620, 30, 30, $('#TubeOutSickVomit').attr('data-score'));
	}
	
	var InPACUOrOutTube60=$("#InPACUOrOutTube60").val();
	if (InPACUOrOutTube60=="入室后60min")
	{
		//lodop.ADD_PRINT_TEXT(qsmzRow24, 30, 110, 120, "入室后60min");
		if (($('#InActivity60').attr('data-score')=="")&&($('#InActivity60').val()!="")) //活动能力
		{
			lodop.ADD_PRINT_TEXT(qsmzRow24,130, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow24,130, 30, 30, $('#InActivity60').attr('data-score'));
		}
		if (($('#InRespiration60').attr('data-score')=="")&&($('#InRespiration60').val()!="")) // 呼吸状态
		{
			lodop.ADD_PRINT_TEXT(qsmzRow24,200, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow24,200, 30, 30, $('#InRespiration60').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow24,200, 30, 30, $('#InRespiration').attr('data-score'));
		
		if (($('#InCirculation60').attr('data-score')=="")&&($('#InCirculation60').val()!="")) // 循环状态
		{
			lodop.ADD_PRINT_TEXT(qsmzRow24,270, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow24,270, 30, 30, $('#InCirculation60').attr('data-score'));
		}
	//lodop.ADD_PRINT_TEXT(qsmzRow24,270, 30, 30, $('#InCirculation').attr('data-score'));
	
		if (($('#InConsciousness60').attr('data-score')=="")&&($('#InConsciousness60').val()!="")) //意识状态
		{
			lodop.ADD_PRINT_TEXT(qsmzRow24,340, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow24,340, 30, 30, $('#InConsciousness60').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow24,340, 30, 30, $('#InConsciousness').attr('data-score'));
		
		if (($('#InSPO260').attr('data-score')=="")&&($('#InSPO260').val()!=""))  //SPO2
		{
			lodop.ADD_PRINT_TEXT(qsmzRow24,410, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow24,410, 30, 30, $('#InSPO260').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow24,410, 30, 30, $('#InSPO2').attr('data-score'));
		if (($('#InSickVomit60').attr('data-score')=="")&&($('#InSickVomit60').val()!=""))  // 恶心呕吐
		{
			lodop.ADD_PRINT_TEXT(qsmzRow24,620, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow24,620, 30, 30, $('#InSickVomit60').attr('data-score'));
		}
		
		
	}
	else if (InPACUOrOutTube60=="拔管后60min")
	{
		//lodop.ADD_PRINT_TEXT(qsmzRow24, 30, 110, 120, "拔管后60min");
		if (($('#TubeOutActivity15').attr('data-score')=="") &&($('#TubeOutActivity15').val()!="")) // 活动状态
		{
			lodop.ADD_PRINT_TEXT(qsmzRow24,130, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow24,130, 30, 30, $('#TubeOutActivity15').attr('data-score'));
		}
		if (($('#TubeOutRespiration15').attr('data-score')=="")&&($('#TubeOutRespiration15').val()!="")) //呼吸
		{
			lodop.ADD_PRINT_TEXT(qsmzRow24,200, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow24,200, 30, 30, $('#TubeOutRespiration15').attr('data-score'));
		}
	//lodop.ADD_PRINT_TEXT(qsmzRow24,200, 30, 30, $('#TubeOutRespiration15').attr('data-score'));
		if (($('#TubeOutCirculation15').attr('data-score')=="")&&($('#TubeOutCirculation15').val()!="")) // 循环状态
		{
			lodop.ADD_PRINT_TEXT(qsmzRow24,270, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow24,270, 30, 30, $('#TubeOutCirculation15').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow24,270, 30, 30, $('#TubeOutCirculation15').attr('data-score'));
		if (($('#TubeOutConsciousness15').attr('data-score')=="")&&($('#TubeOutConsciousness15').val()!="")) //意识状态
		{
			lodop.ADD_PRINT_TEXT(qsmzRow24,340, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow24,340, 30, 30, $('#TubeOutConsciousness15').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow25,340, 30, 30, $('#TubeOutConsciousness15').attr('data-score'));
		
		if (($('#TubeConSPO215').attr('data-score')=="") && ($('#TubeConSPO215').val()!="")) // SPO2（%）
		{
			lodop.ADD_PRINT_TEXT(qsmzRow24,410, 30, 30, '2');
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow24,410, 30, 30, $('#TubeConSPO215').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow25,410, 30, 30, $('#TubeConSPO215').attr('data-score'));
		
		if (($('#TubeOutSickVomit15').attr('data-score')=="")&&($('#TubeOutSickVomit15').val()!="")) // 恶心呕吐
		{
			lodop.ADD_PRINT_TEXT(qsmzRow24,620, 30, 30, '2'); 
		}else{
			lodop.ADD_PRINT_TEXT(qsmzRow24,620, 30, 30, $('#TubeOutSickVomit15').attr('data-score'));
		}
		//lodop.ADD_PRINT_TEXT(qsmzRow24,620, 30, 20, $('#TubeOutSickVomit15').attr('data-score'));
			
	}
	
	if (($('#OutActivity').attr('data-score')=="")&&($('#OutActivity').val()!=""))
	{
		lodop.ADD_PRINT_TEXT(qsmzRow25,130, 30, 30, '2');
	}else{
		lodop.ADD_PRINT_TEXT(qsmzRow25,130, 30, 30, $('#OutActivity').attr('data-score'));
	}
	
	lodop.ADD_PRINT_TEXT(qsmzRow22,180, 30, 30, "2");
	lodop.ADD_PRINT_TEXT(qsmzRow22,200, 30, 30, "1");
	lodop.ADD_PRINT_TEXT(qsmzRow22,220, 30, 30, "0");


	if (($('#OutRespiration').attr('data-score')=="")&&($('#OutRespiration').val()!=""))
	{
		lodop.ADD_PRINT_TEXT(qsmzRow25,200, 30, 30, '2');
	}else{
		lodop.ADD_PRINT_TEXT(qsmzRow25,200, 30, 30, $('#OutRespiration').attr('data-score'));
	}
	
	lodop.ADD_PRINT_TEXT(qsmzRow22,250, 15, 30, "2");
	lodop.ADD_PRINT_TEXT(qsmzRow22,270, 15, 30, "1");
	lodop.ADD_PRINT_TEXT(qsmzRow22,290, 15, 30, "0");
	if (($('#OutCirculation').attr('data-score')=="")&&($('#OutCirculation').val()!=""))
	{
		lodop.ADD_PRINT_TEXT(qsmzRow25,270, 30, 30, '2');
	}else{
		lodop.ADD_PRINT_TEXT(qsmzRow25,270, 30, 30, $('#OutCirculation').attr('data-score'));
	}
	
	lodop.ADD_PRINT_TEXT(qsmzRow22,320, 15, 30, "2");
	lodop.ADD_PRINT_TEXT(qsmzRow22,340, 15, 30, "1");
	lodop.ADD_PRINT_TEXT(qsmzRow22,360, 15, 30, "0");
	if (($('#OutConsciousness').attr('data-score')=="")&&($('#OutConsciousness').val()!=""))
	{
		lodop.ADD_PRINT_TEXT(qsmzRow25,340, 30, 30, '2');
	}else{
		lodop.ADD_PRINT_TEXT(qsmzRow25,340, 30, 30, $('#OutConsciousness').attr('data-score'));
	}
	
	lodop.ADD_PRINT_TEXT(qsmzRow22,390, 15, 30, "2");
	lodop.ADD_PRINT_TEXT(qsmzRow22,410, 15, 30, "1");
	lodop.ADD_PRINT_TEXT(qsmzRow22,430, 15, 30, "0");
	if (($('#OutConSPO2').attr('data-score')=="")&&($('#OutConSPO2').val()!=""))
	{
		lodop.ADD_PRINT_TEXT(qsmzRow25,410, 30, 30, '2');
	}else{
		lodop.ADD_PRINT_TEXT(qsmzRow25,410, 30, 30, $('#OutConSPO2').attr('data-score'));
	}
	
	lodop.ADD_PRINT_TEXT(qsmzRow22,600, 15, 30, "2");
	lodop.ADD_PRINT_TEXT(qsmzRow22,620, 15, 30, "1");
	lodop.ADD_PRINT_TEXT(qsmzRow22,640, 15, 30, "0");
	if (($('#OutSickVomit').attr('data-score')=="")&&($('#OutSickVomit').val()!=""))
	{
		lodop.ADD_PRINT_TEXT(qsmzRow25,620, 30, 30, '2');
	}else{
		lodop.ADD_PRINT_TEXT(qsmzRow25,620, 30, 30, $('#OutSickVomit').attr('data-score'));
	}
	//lodop.ADD_PRINT_TEXT(qsmzRow26,620, 30, 30, $('#OutSickVomit').attr('data-score'));
	
	var tmpInActivity=$('#InActivity').attr('data-score');
	if ((tmpInActivity=="")&&($('#InActivity').val()!="")) tmpInActivity=0;
	
	var tmpInRespiration=$('#InRespiration').attr('data-score');
	if ((tmpInRespiration=="")&&($('#InRespiration').val()!="")) tmpInRespiration=0;
	
	var tmpInCirculation=$('#InCirculation').attr('data-score');
	if ((tmpInCirculation=="")&&($('#InCirculation').val()!="")) tmpInCirculation=1;
	
	var tmpInConsciousness=$('#InConsciousness').attr('data-score');
	if ((tmpInConsciousness=="")&&($('#InConsciousness').val()!="")) tmpInConsciousness=0;
	
	var tmpInSPO2=$('#InSPO2').attr('data-score');
	if ((tmpInSPO2=="")&&($('#InSPO2').val()!="")) tmpInSPO2=1;
	//lodop.ADD_PRINT_TEXT(qsmzRow23,470, 30, 15, Number(tmpInActivity)+Number(tmpInRespiration)+Number(tmpInCirculation)+Number(tmpInConsciousness)+Number(tmpInSPO2));
	
	var tmpInActivity60=$('#InActivity60').attr('data-score');
	if ((tmpInActivity60=="")&&($('#InActivity60').val()!="")) tmpInActivity60=2;
	
	var tmpInRespiration60=$('#InRespiration60').attr('data-score');
	if ((tmpInRespiration60=="")&&($('#InRespiration60').val()!="")) tmpInRespiration60=2;
	
	var tmpInCirculation60=$('#InCirculation60').attr('data-score');
	if ((tmpInCirculation60=="")&&($('#InCirculation60').val()!="")) tmpInCirculation60=2;
	
	var tmpInConsciousness60=$('#InConsciousness60').attr('data-score');
	if ((tmpInConsciousness60=="")&&($('#InConsciousness60').val()!="")) tmpInConsciousness60=2;
	
	var tmpInSPO260=$('#InSPO260').attr('data-score');
	if ((tmpInSPO260=="")&&($('#InSPO260').val()!="")) tmpInSPO260=2;
	//lodop.ADD_PRINT_TEXT(qsmzRow23,470, 30, 15, Number(tmpInActivity)+Number(tmpInRespiration)+Number(tmpInCirculation)+Number(tmpInConsciousness)+Number(tmpInSPO2));
	
	
	var tmpTubeOutActivity=$('#TubeOutActivity').attr('data-score');
	if ((tmpTubeOutActivity=="")&&($('#TubeOutActivity').val()!="")) tmpTubeOutActivity=1;
	
	var tmpTubeOutRespiration=$('#TubeOutRespiration').attr('data-score');
	if ((tmpTubeOutRespiration=="")&&($('#TubeOutRespiration').val()!="")) tmpTubeOutRespiration=2;
	
	var tmpTubeOutCirculation=$('#TubeOutCirculation').attr('data-score');
	if ((tmpTubeOutCirculation=="")&&($('#TubeOutCirculation').val()!="")) tmpTubeOutCirculation=1;
	
	var tmpTubeOutConscious=$('#TubeOutConscious').attr('data-score');
	if ((tmpTubeOutConscious=="")&&($('#TubeOutConscious').val()!="")) tmpTubeOutConscious=1;
	
	var tmpTubeOutSPO2=$('#TubeOutSPO2').attr('data-score');
	if ((tmpTubeOutSPO2=="")&&($('#TubeOutSPO2').val()!="")) tmpTubeOutSPO2=1;
	
	if(LaryngealMaskAirway=="checked")
	{
		//lodop.ADD_PRINT_TEXT(qsmzRow24,470, 30, 15, (Number(tmpTubeOutActivity)+Number(tmpTubeOutRespiration)+Number(tmpTubeOutCirculation)+Number(tmpTubeOutConscious)+Number(tmpTubeOutSPO2)));
	}
	var tmpTubeOutActivity15=$('#TubeOutActivity15').attr('data-score');
	if ((tmpTubeOutActivity15=="")&&($('#TubeOutActivity15').val()!=""))  tmpTubeOutActivity15=2;
	
	var tmpTubeOutRespiration15=$('#TubeOutRespiration15').attr('data-score');
	if ((tmpTubeOutRespiration15=="")&&($('#TubeOutRespiration15').val()!="")) tmpTubeOutRespiration15=2;
	
	var tmpTubeOutCirculation15=$('#TubeOutCirculation15').attr('data-score');
	if ((tmpTubeOutCirculation15=="")&&($('#TubeOutCirculation15').val()!="")) tmpTubeOutCirculation15=2;
	
	var tmpTubeOutConsciousness15=$('#TubeOutConsciousness15').attr('data-score');
	if ((tmpTubeOutConsciousness15=="")&&($('#TubeOutConsciousness15').val()!="")) tmpTubeOutConsciousness15=2;
	
	var tmpTubeConSPO215=$('#TubeConSPO215').attr('data-score');
	if ((tmpTubeConSPO215=="")&&($('#TubeConSPO215').val()!="")) tmpTubeConSPO215=2;
	
	if(LaryngealMaskAirway=="checked")
	{
		//lodop.ADD_PRINT_TEXT(qsmzRow25,470, 30, 15, Number(tmpTubeOutActivity15)+Number(tmpTubeOutRespiration15)+Number(tmpTubeOutCirculation15)+Number(tmpTubeOutConsciousness15)+Number(tmpTubeConSPO215));
	}
	var tmpOutActivity=$('#OutActivity').attr('data-score');
	if ((tmpOutActivity=="")&&($('#OutActivity').val()!="")) tmpOutActivity=2;
	
	var tmpOutRespiration=$('#OutRespiration').attr('data-score');
	if ((tmpOutRespiration=="")&&($('#OutRespiration').val()!="")) tmpOutRespiration=2;
	
	var tmpOutCirculation=$('#OutCirculation').attr('data-score');
	if ((tmpOutCirculation=="")&&($('#OutCirculation').val()!="")) tmpOutCirculation=2;
	
	var tmpOutConsciousness=$('#OutConsciousness').attr('data-score');
	if ((tmpOutConsciousness=="")&&($('#OutConsciousness').val()!="")) tmpOutConsciousness=2;
	
	var tmpOutConSPO2=$('#OutConSPO2').attr('data-score');
	if ((tmpOutConSPO2=="")&&($('#OutConSPO2').val()!="")) tmpOutConSPO2=2;
	
	lodop.ADD_PRINT_TEXT(qsmzRow25,470, 30, 15, Number(tmpOutActivity)+Number(tmpOutRespiration)+Number(tmpOutCirculation)+Number(tmpOutConsciousness)+Number(tmpOutConSPO2));

	///瞳孔大小mm  疼痛评分
	//lodop.ADD_PRINT_TEXT(qsmzRow23,525, 50, 30,$("#InLeftPupilSize").val());
	//lodop.ADD_PRINT_TEXT(qsmzRow23,565, 50, 30,$("#InRightPupilSize").val());
	//lodop.ADD_PRINT_TEXT(qsmzRow23,700, 50, 30,$("#InPainScore").val());
	
	//lodop.ADD_PRINT_TEXT(qsmzRow24,525, 50, 30,$("#TubeOutLeftPupilSize").val());
	//lodop.ADD_PRINT_TEXT(qsmzRow24,565, 50, 30,$("#TubeOutRightPupilSize").val());
	//lodop.ADD_PRINT_TEXT(qsmzRow24,700, 50, 30,$("#TubeOutPainScore").val());
	
	//lodop.ADD_PRINT_TEXT(qsmzRow25,525, 50, 30,$("#TubeOutLeftPupilSize2").val());
	//lodop.ADD_PRINT_TEXT(qsmzRow25,565, 50, 30,$("#TubeOutRightPupilSize2").val());
	//lodop.ADD_PRINT_TEXT(qsmzRow25,700, 50, 30,$("#TubeOutPainScore2").val());
	
	lodop.ADD_PRINT_TEXT(qsmzRow25,525, 50, 30,$("#OutLeftPupilSize").val());
	lodop.ADD_PRINT_TEXT(qsmzRow25,565, 50, 30,$("#OutRightPupilSize").val());
	lodop.ADD_PRINT_TEXT(qsmzRow25,700, 50, 30,$("#OutPainScore").val());
	
	
	var InPACUOrOutTube10=$("#InPACUOrOutTube10").val();
	if (InPACUOrOutTube10=="入室后10min")
	{
		//lodop.ADD_PRINT_TEXT(qsmzRow23, 30, 110, 120, "入室后10min");
		lodop.ADD_PRINT_TEXT(qsmzRow23,525, 50, 30,$("#InLeftPupilSize").val());
		lodop.ADD_PRINT_TEXT(qsmzRow23,565, 50, 30,$("#InRightPupilSize").val());
		lodop.ADD_PRINT_TEXT(qsmzRow23,700, 50, 30,$("#InPainScore").val());
		lodop.ADD_PRINT_TEXT(qsmzRow23,470, 30, 15, Number(tmpInActivity)+Number(tmpInRespiration)+Number(tmpInCirculation)+Number(tmpInConsciousness)+Number(tmpInSPO2));

	}
	else if (InPACUOrOutTube10=="拔管后10min")
	{
		//lodop.ADD_PRINT_TEXT(qsmzRow23, 30, 110, 120, "拔管后10min");
		lodop.ADD_PRINT_TEXT(qsmzRow23,525, 50, 30,$("#TubeOutLeftPupilSize").val());
		lodop.ADD_PRINT_TEXT(qsmzRow23,565, 50, 30,$("#TubeOutRightPupilSize").val());
		lodop.ADD_PRINT_TEXT(qsmzRow23,700, 50, 30,$("#TubeOutPainScore").val());
		lodop.ADD_PRINT_TEXT(qsmzRow23,470, 30, 15, (Number(tmpTubeOutActivity)+Number(tmpTubeOutRespiration)+Number(tmpTubeOutCirculation)+Number(tmpTubeOutConscious)+Number(tmpTubeOutSPO2)));

	}
	var InPACUOrOutTube60=$("#InPACUOrOutTube60").val();
	if (InPACUOrOutTube60=="入室后60min")
	{
		//lodop.ADD_PRINT_TEXT(qsmzRow24, 30, 110, 120, "入室后60min");
		lodop.ADD_PRINT_TEXT(qsmzRow24,525, 50, 30,$("#InLeftPupilSize60").val());
		lodop.ADD_PRINT_TEXT(qsmzRow24,565, 50, 30,$("#InRightPupilSize60").val());
		lodop.ADD_PRINT_TEXT(qsmzRow24,700, 50, 30,$("#InPainScore60").val());
		lodop.ADD_PRINT_TEXT(qsmzRow24,470, 30, 15, Number(tmpInActivity60)+Number(tmpInRespiration60)+Number(tmpInCirculation60)+Number(tmpInConsciousness60)+Number(tmpInSPO260));

	}
	else if (InPACUOrOutTube60=="拔管后60min")
	{
		//lodop.ADD_PRINT_TEXT(qsmzRow24, 30, 110, 120, "拔管后60min");
		lodop.ADD_PRINT_TEXT(qsmzRow24,525, 50, 30,$("#TubeOutLeftPupilSize2").val());
		lodop.ADD_PRINT_TEXT(qsmzRow24,565, 50, 30,$("#TubeOutRightPupilSize2").val());
		lodop.ADD_PRINT_TEXT(qsmzRow24,700, 50, 30,$("#TubeOutPainScore2").val());
		lodop.ADD_PRINT_TEXT(qsmzRow24,470, 30, 15, Number(tmpTubeOutActivity15)+Number(tmpTubeOutRespiration15)+Number(tmpTubeOutCirculation15)+Number(tmpTubeOutConsciousness15)+Number(tmpTubeConSPO215));

	}
	lodop.SET_PRINT_STYLE("FontColor", "#000000"); //更换颜色
	
	///横线
	lodop.ADD_PRINT_LINE(qsmzRow22+15, 23, qsmzRow22+15, 761, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow23+15, 23, qsmzRow23+15, 761, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow24+15, 23, qsmzRow24+15, 761, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow25+15, 23, qsmzRow25+15, 761, 0, 1);
	
	//lodop.ADD_PRINT_LINE(qsmzRow26+15, 23, qsmzRow26+15, 761, 0, 1);
	//lodop.ADD_PRINT_LINE(qsmzRow27+15, 102, qsmzRow27+15, 761, 0, 1);
	//lodop.ADD_PRINT_LINE(qsmzRow28+15, 102, qsmzRow28+15, 761, 0, 1);
	
	///竖线
	lodop.ADD_PRINT_LINE(qsmzRow11-5, 170, qsmzRow25+15, 170, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow11-5, 240, qsmzRow25+15, 240, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow11-5, 310, qsmzRow25+15, 310, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow11-5, 380, qsmzRow25+15, 380, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow11-5, 450, qsmzRow25+15, 450, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow11-5, 510, qsmzRow25+15, 510, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow11-5, 590, qsmzRow25+15, 590, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow11-5, 660, qsmzRow25+15, 660, 0, 1);
	
	//短线
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 125, qsmzRow22+15, 125, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 145, qsmzRow22+15, 145, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 195, qsmzRow22+15, 195, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 215, qsmzRow22+15, 215, 0, 1);
	
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 265, qsmzRow22+15, 265, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 285, qsmzRow22+15, 285, 0, 1);
	
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 335, qsmzRow22+15, 335, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 355, qsmzRow22+15, 355, 0, 1);
	
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 404, qsmzRow22+15, 404, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 424, qsmzRow22+15, 424, 0, 1);
	
	lodop.ADD_PRINT_TEXT(qsmzRow22, 525, 70, 120, "左");
	lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 550, qsmzRow25+15, 550, 0, 1);
	lodop.ADD_PRINT_TEXT(qsmzRow22, 565, 70, 120, "右");
	lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 613, qsmzRow22+15, 613, 0, 1);
	lodop.ADD_PRINT_LINE(qsmzRow22-8, 633, qsmzRow22+15, 633, 0, 1);
	
	
	qsmzRow26=qsmzRow26+10;
	qsmzRow27=qsmzRow27+10;
	qsmzRow28=qsmzRow28+10;
	lodop.ADD_PRINT_RECT(qsmzRow26-10,23,738,qsmzHeight*4-10,0,1);
	
	lodop.ADD_PRINT_TEXT(qsmzRow26, 40, 120, 15, "1、压疮/压红:");
	////lodop.ADD_PRINT_HTM(qsmzRow26-2, 140, 80, 20, '<input type="checkbox" class="AutoRespiration" value="有"' + CheckBoxValue("AutoRespiration", "有") + '>');
	var AutoRespiration60=$("#PressureSoreAfter").val();
	if(AutoRespiration60.indexOf("有")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow26,140);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow26,140);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow26, 160, 100, 15, "有");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow26-2, 180, 80, 20, '<input type="checkbox" class="AutoRespiration" value="无"' + CheckBoxValue("AutoRespiration", "无") + '>');
	if(AutoRespiration60.indexOf("无")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow26,180);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow26,180);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow26, 200, 100, 15, "无");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow26, 220, 250, 15, "(如有，请填写PACU压疮交接记录本)");
	
	lodop.ADD_PRINT_TEXT(qsmzRow26, 460, 200, 15, "2、肢体有无血流障碍:");
	///lodop.ADD_PRINT_HTM(qsmzRow26-2, 580, 80, 20, '<input type="checkbox" class="BloodFlowDisorder" value="有"' + CheckBoxValue("BloodFlowDisorder", "有") + '>');
	var BloodFlowDisorder60=$("#BloodFlowDisorderAfter").val();
	if(BloodFlowDisorder60.indexOf("有")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow26,580);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow26,580);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow26, 600, 100, 15, "有");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow26-2, 630, 80, 20, '<input type="checkbox" class="BloodFlowDisorder" value="无"' + CheckBoxValue("BloodFlowDisorder", "无") + '>');
	if(BloodFlowDisorder60.indexOf("无")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow26,630);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow26,630);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow26, 650, 100, 15, "无");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_TEXT(qsmzRow27, 40, 120, 15, "3、输液：通畅");
	///lodop.ADD_PRINT_HTM(qsmzRow27-2, 140, 80, 20, '<input type="checkbox" class="InfusionSmooth" value="是"' + CheckBoxValue("InfusionSmooth", "是") + '>');
	var InfusionSmooth60=$("#InfusionSmoothAfter").val();
	if(InfusionSmooth60.indexOf("是")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow27,140);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow27,140);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow27, 160, 100, 15, "是");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow27-2, 180, 80, 20, '<input type="checkbox" class="InfusionSmooth" value="否"' + CheckBoxValue("InfusionSmooth", "否") + '>');
	if(InfusionSmooth60.indexOf("否")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow27,180);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow27,180);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow27, 200, 100, 15, "否");	
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_TEXT(qsmzRow27, 260, 120, 15, "输液部位肿胀:");
	///lodop.ADD_PRINT_HTM(qsmzRow27-2, 360, 80, 20, '<input type="checkbox" class="InfusionSiteSwelling" value="是"' + CheckBoxValue("InfusionSiteSwelling", "是") + '>');
	var InfusionSiteSwelling60=$("#InfusionSiteSwellingAfter").val();
	if(InfusionSiteSwelling60.indexOf("是")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow27,360);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow27,360);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow27, 380, 100, 15, "是");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow27-2, 400, 80, 20, '<input type="checkbox" class="InfusionSiteSwelling" value="否"' + CheckBoxValue("InfusionSiteSwelling", "否") + '>');
	if(InfusionSiteSwelling60.indexOf("否")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow27,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow27,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow27, 420, 100, 15, "否");	
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_TEXT(qsmzRow27, 480, 120, 15, "中心静脉置管:");
	///lodop.ADD_PRINT_HTM(qsmzRow27-2, 580, 80, 20, '<input type="checkbox" class="CVSCatheter" value="是"' + CheckBoxValue("CVSCatheter", "是") + '>');
	var CVSCatheter60=CheckBoxValue("CVSCatheterAfter","是");
	if(CVSCatheter60=="checked")
	{
		DrawRectAndRight(lodop,qsmzRow27,580);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow27,580);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow27, 600, 100, 15, "是");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow27, 630, 100, 15, "置管深度:");	
	lodop.ADD_PRINT_TEXT(qsmzRow27, 690, 100, 15, $("#CVSTubeDepthAfter").val()+" cm");	
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow28, 40, 120, 15, "4、切口辅料渗血:");
	///lodop.ADD_PRINT_HTM(qsmzRow28-2, 160, 80, 20, '<input type="checkbox" class="IncisionDressingOozing" value="有"' + CheckBoxValue("IncisionDressingOozing", "有") + '>');
	var IncisionDressingOozing60=$("#IncisionDressingOozingAfter").val();
	if(IncisionDressingOozing60.indexOf("有")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow28,140);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow28,140);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow28, 160, 100, 15, "有");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow28-2, 200, 80, 20, '<input type="checkbox" class="IncisionDressingOozing" value="无"' + CheckBoxValue("IncisionDressingOozing", "无") + '>');
	if(IncisionDressingOozing60.indexOf("无")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow28,180);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow28,180);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow28, 200, 100, 15, "无");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	lodop.ADD_PRINT_TEXT(qsmzRow28, 260, 120, 15, "5、引流管通畅:");
	///lodop.ADD_PRINT_HTM(qsmzRow28-2, 390, 80, 20, '<input type="checkbox" class="DrainageTube" value="是"' + CheckBoxValue("DrainageTube", "是") + '>');
	var DrainageTube60=$("#DrainageTubeAfter").val();
	if(DrainageTube60.indexOf("是")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow28,360);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow28,360);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow28, 380, 100, 15, "是");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow28-2, 430, 80, 20, '<input type="checkbox" class="DrainageTube" value="否"' + CheckBoxValue("DrainageTube", "否") + '>');
	if(DrainageTube60.indexOf("否")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow28,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow28,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow28, 420, 100, 15, "否");	
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	
	
	lodop.ADD_PRINT_TEXT(qsmzRow28, 450, 100, 15, "引流液:");
	var DrainageLiquids60=$("#DrainageLiquidsAfter").val();
	if(DrainageLiquids60.indexOf("无")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow28,500);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow28,500);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow28, 520, 100, 15, "无");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	if(DrainageLiquids60.indexOf("有")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow28,540);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow28,540);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow28, 560, 100, 15, "有");	
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow28, 580, 100, 15, "性质");
	lodop.ADD_PRINT_TEXT(qsmzRow28, 610, 80, 15, $("#DrainagePropertiesAfter").val());
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow28, 710, 100, 15, "量");
	lodop.ADD_PRINT_TEXT(qsmzRow28, 725, 200, 15, $("#DrainageVolumeAfter").val()+"ml");
	lodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色	
	
	
/*
	
	lodop.ADD_PRINT_TEXT(qsmzRow28, 35, 100, 120, "出入量记录");
	lodop.ADD_PRINT_TEXT(qsmzRow27, 200, 100, 120, "入室时(ml)");
	lodop.ADD_PRINT_TEXT(qsmzRow27, 330, 300, 120, "PACU期间（每次输入或倾倒时记录）(ml)");
	lodop.ADD_PRINT_TEXT(qsmzRow27, 640, 100, 120, "出室时(ml)");

	lodop.SET_PRINT_STYLE("FontColor", "#0000ff"); //更换颜色
	lodop.ADD_PRINT_TEXT(qsmzRow28, 220, 100, 120, $("#RoomInLiquidIn").val());
	
	lodop.ADD_PRINT_TEXT(qsmzRow29, 220, 100, 120, $("#RoomInLiquidOut").val());
	
	
	lodop.ADD_PRINT_TEXT(qsmzRow28, 400, 100, 120, $("#PACULiquidIn").val());
	lodop.ADD_PRINT_TEXT(qsmzRow29, 400, 100, 120, $("#PACULiquidOut").val());
	
	lodop.ADD_PRINT_TEXT(qsmzRow28, 660, 100, 120, $("#RoomOutLiquidIn").val());
	lodop.ADD_PRINT_TEXT(qsmzRow29, 660, 100, 120, $("#RoomOutLiquidOut").val());
	lodop.SET_PRINT_STYLE("FontColor", "#000000"); //更换颜色

	lodop.ADD_PRINT_TEXT(qsmzRow28, 120, 50, 120, "入量");
	lodop.ADD_PRINT_TEXT(qsmzRow29, 120, 50, 120, "出量");
*/
	var qsmzRow30=qsmzRow+qsmzHeight*30;
	var qsmzRow31=qsmzRow+qsmzHeight*31;
	var qsmzRow32=qsmzRow+qsmzHeight*32;
	var qsmzRow33=qsmzRow+qsmzHeight*33;
	var qsmzRow34=qsmzRow+qsmzHeight*34;
	var qsmzRow35=qsmzRow+qsmzHeight*35;
	var qsmzRow36=qsmzRow+qsmzHeight*36;
	var qsmzRow37=qsmzRow+qsmzHeight*37;
	var qsmzRow38=qsmzRow+qsmzHeight*38;
	var qsmzRow39=qsmzRow+qsmzHeight*39;
	var qsmzRow40=qsmzRow+qsmzHeight*40;
	var qsmzRow41=qsmzRow+qsmzHeight*41;
	var qsmzRow42=qsmzRow+qsmzHeight*42;
	var qsmzRow43=qsmzRow+qsmzHeight*43;
	
	
	
	
	lodop.ADD_PRINT_RECT(qsmzRow30-2,23,300,qsmzHeight*11,0,1);
	
	lodop.ADD_PRINT_LINE(qsmzRow30-2, 90, qsmzRow40+16, 90, 0, 1);
	
	lodop.ADD_PRINT_TEXT(qsmzRow30, 35, 50, 15, "时间");
	lodop.ADD_PRINT_TEXT(qsmzRow30, 140, 140, 15, "护理操作记录");
	
	lodop.ADD_PRINT_LINE(qsmzRow30+15, 23, qsmzRow30+15, 323, 0, 1);
	//alert($("#CareTime1").timespinner("getValue"));
	lodop.ADD_PRINT_TEXT(qsmzRow31, 25, 140, 15, $("#CareTime1").timespinner("getValue"));
	if($("#CareRecord1").val()!="")
	{
		lodop.ADD_PRINT_TEXT(qsmzRow31, 100, 200, 15, $("#CareRecord1").val());
	}
	else{
		lodop.ADD_PRINT_TEXT(qsmzRow31, 100, 140, 15, "吸痰");
	}
	
	lodop.ADD_PRINT_LINE(qsmzRow31+15, 23, qsmzRow31+15, 323, 0, 1);
	lodop.ADD_PRINT_TEXT(qsmzRow32, 25, 140, 15, $("#CareTime2").timespinner("getValue"));
	if($("#CareRecord2").val()!="")
	{
		lodop.ADD_PRINT_TEXT(qsmzRow32, 100, 200, 15, $("#CareRecord2").val());
	}
	else{
		lodop.ADD_PRINT_TEXT(qsmzRow32, 100, 140, 15, "吸痰");
	}
	lodop.ADD_PRINT_LINE(qsmzRow32+15, 23, qsmzRow32+15, 323, 0, 1);
	lodop.ADD_PRINT_TEXT(qsmzRow33, 25, 140, 15, $("#CareTime3").timespinner("getValue"));
	if($("#CareRecord3").val()!="")
	{
		lodop.ADD_PRINT_TEXT(qsmzRow33, 100, 200, 15, $("#CareRecord3").val());
	}
	else{
		lodop.ADD_PRINT_TEXT(qsmzRow33, 100, 140, 15, "吸痰");
	}
	lodop.ADD_PRINT_LINE(qsmzRow33+15, 23, qsmzRow33+15, 323, 0, 1);
	lodop.ADD_PRINT_TEXT(qsmzRow34, 25, 140, 15, $("#CareTime4").timespinner("getValue"));
	if($("#CareRecord4").val()!="")
	{
		lodop.ADD_PRINT_TEXT(qsmzRow34, 100, 200, 15, $("#CareRecord4").val());
	}
	else{
		lodop.ADD_PRINT_TEXT(qsmzRow34, 100, 200, 15, "安全护理(约束带的放置)");
	}
	lodop.ADD_PRINT_LINE(qsmzRow34+15, 23, qsmzRow34+15, 323, 0, 1);
	lodop.ADD_PRINT_TEXT(qsmzRow35, 25, 140, 15, $("#CareTime5").timespinner("getValue"));
	if($("#CareRecord5").val()!="")
	{
		lodop.ADD_PRINT_TEXT(qsmzRow35, 100, 200, 15, $("#CareRecord5").val());
	}
	else{
		lodop.ADD_PRINT_TEXT(qsmzRow35, 100, 200, 15, "放置口/鼻咽通气管");
	}
	lodop.ADD_PRINT_LINE(qsmzRow35+15, 23, qsmzRow35+15, 323, 0, 1);
	lodop.ADD_PRINT_TEXT(qsmzRow36, 25, 140, 15, $("#CareTime6").timespinner("getValue"));
	if($("#CareRecord6").val()!="")
	{
		lodop.ADD_PRINT_TEXT(qsmzRow36, 100, 200, 15, $("#CareRecord6").val());
	}
	else{
		lodop.ADD_PRINT_TEXT(qsmzRow36, 100, 200, 15, "动脉穿刺");
	}
	lodop.ADD_PRINT_LINE(qsmzRow36+15, 23, qsmzRow36+15, 323, 0, 1);
	lodop.ADD_PRINT_TEXT(qsmzRow37, 25, 140, 15, $("#CareTime7").timespinner("getValue"));
	if($("#CareRecord7").val()!="")
	{
		lodop.ADD_PRINT_TEXT(qsmzRow37, 100, 200, 15, $("#CareRecord7").val());
	}
	else{
		lodop.ADD_PRINT_TEXT(qsmzRow37, 100, 200, 15, "静脉输液不畅，重置静脉留置针");
	}
	lodop.ADD_PRINT_LINE(qsmzRow37+15, 23, qsmzRow37+15, 323, 0, 1);
	
	//alert($("#CareRecord8").val());
	lodop.ADD_PRINT_TEXT(qsmzRow38, 25, 140, 15, $("#CareTime8").timespinner("getValue"));
	if($("#CareRecord8").val()!="")
	{
		lodop.ADD_PRINT_TEXT(qsmzRow38, 100, 200, 15, $("#CareRecord8").val());
	}
	else{
		lodop.ADD_PRINT_TEXT(qsmzRow38, 100, 200, 15, "眼睛的保护护理");
	}
	
	lodop.ADD_PRINT_TEXT(qsmzRow39, 25, 140, 15, $("#CareTime9").timespinner("getValue"));
	lodop.ADD_PRINT_TEXT(qsmzRow39, 100, 200, 15, $("#CareRecord9").val());
	lodop.ADD_PRINT_TEXT(qsmzRow40, 25, 140, 15, $("#CareTime10").timespinner("getValue"));
	lodop.ADD_PRINT_TEXT(qsmzRow40, 100, 200, 15, $("#CareRecord10").val());
	
	lodop.ADD_PRINT_LINE(qsmzRow38+15, 23, qsmzRow38+15, 323, 0, 1);
	
	lodop.ADD_PRINT_LINE(qsmzRow39+15, 23, qsmzRow39+15, 323, 0, 1);
	
	lodop.ADD_PRINT_TEXT(qsmzRow42, 35, 200, 15, "责任护士：");
	lodop.ADD_PRINT_TEXT(qsmzRow43, 35, 200, 15, "接班护士：");
	
	

	lodop.ADD_PRINT_TEXT(qsmzRow30, 360, 500, 15, "麻醉复苏期并发症列表（如有并发症请在相应的口打√）");
	
	lodop.ADD_PRINT_TEXT(qsmzRow31, 370, 60, 15, "呼吸:");
	lodop.SET_PRINT_STYLE("FontColor", "#0000ff"); //更换颜色
	
	///lodop.ADD_PRINT_HTM(qsmzRow31-2, 400, 80, 20, '<input type="checkbox" class="CareResp" value="舌后坠"' + CheckBoxValue("CareResp", "舌后坠") + '>');
	var CareResp=$("#CareResp").val();
	if(CareResp.indexOf("舌后坠")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow31,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow31,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow31, 420, 100, 15, "舌后坠");
	///lodop.ADD_PRINT_HTM(qsmzRow31-2, 480, 80, 20, '<input type="checkbox" class="CareResp" value="呼吸道梗阻"' + CheckBoxValue("CareResp", "呼吸道梗阻") + '>');
	if(CareResp.indexOf("呼吸道梗阻")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow31,460);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow31,460);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow31, 480, 100, 15, "呼吸道梗阻");
	///lodop.ADD_PRINT_HTM(qsmzRow31-2, 600, 80, 20, '<input type="checkbox" class="CareResp" value="喉痉挛"' + CheckBoxValue("CareResp", "喉痉挛") + '>');
	if(CareResp.indexOf("喉痉挛")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow31,540);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow31,540);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow31, 560, 100, 15, "喉痉挛");
	///lodop.ADD_PRINT_HTM(qsmzRow31-2, 690, 80, 20, '<input type="checkbox" class="CareResp" value="肺水肿"' + CheckBoxValue("CareResp", "肺水肿") + '>');
	if(CareResp.indexOf("肺水肿")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow31,600);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow31,600);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow31, 620, 100, 15, "肺水肿");
	
	if(CareResp.indexOf("呼吸遗忘")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow31,655);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow31,655);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow31, 675, 100, 15, "呼吸遗忘");

	if(CareResp.indexOf("低氧")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow31,720);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow31,720);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow31, 740, 100, 15, "低氧");


	lodop.ADD_PRINT_TEXT(qsmzRow32, 370, 60, 15, "循环:");
	lodop.SET_PRINT_STYLEA(0, "FontColor", "#000000"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow32-2, 400, 80, 20, '<input type="checkbox" class="CareCirculation" value="术后低血压"' + CheckBoxValue("CareCirculation", "术后低血压") + '>');
	var CareCirculation=$("#CareCirculation").val();
	if(CareCirculation.indexOf("术后低血压")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow32,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow32,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow32, 420, 100, 15, "术后低血压");
	///lodop.ADD_PRINT_HTM(qsmzRow32-2, 520, 80, 20, '<input type="checkbox" class="CareCirculation" value="术后高血压"' + CheckBoxValue("CareCirculation", "术后高血压") + '>');
	if(CareCirculation.indexOf("术后高血压")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow32,520);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow32,520);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow32, 540, 100, 15, "术后高血压");
	///lodop.ADD_PRINT_HTM(qsmzRow32-2, 640, 80, 20, '<input type="checkbox" class="CareCirculation" value="心率失常"' + CheckBoxValue("CareCirculation", "心率失常") + '>');
	if(CareCirculation.indexOf("心率失常")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow32,640);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow32,640);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow32, 660, 100, 15, "心率失常");

	lodop.ADD_PRINT_TEXT(qsmzRow33, 370, 60, 15, "意识:");
	lodop.SET_PRINT_STYLEA(0, "FontColor", "#000000"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow33-2, 400, 80, 20, '<input type="checkbox" class="CareSense" value="谵妄"' + CheckBoxValue("CareSense", "谵妄") + '>');
	///var CareSense=CheckBoxValue("CareSense","谵妄")
	var CareSense=$("#CareSense").val();
	if(CareSense.indexOf("谵妄")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow33,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow33,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow33, 420, 100, 15, "谵妄");
	///lodop.ADD_PRINT_HTM(qsmzRow33-2, 480, 80, 20, '<input type="checkbox" class="CareSense" value="躁动"' + CheckBoxValue("CareSense", "躁动") + '>');
	if(CareSense.indexOf("躁动")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow33,480);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow33,480);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow33, 500, 100, 15, "躁动");
	///lodop.ADD_PRINT_HTM(qsmzRow33-2, 600, 80, 20, '<input type="checkbox" class="CareSense" value="寒战"' + CheckBoxValue("CareSense", "寒战") + '>');
	if(CareSense.indexOf("寒颤")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow33,600);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow33,600);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow33, 620, 100, 15, "寒颤");
	///lodop.ADD_PRINT_HTM(qsmzRow33-2, 690, 80, 20, '<input type="checkbox" class="CareSense" value="疼痛"' + CheckBoxValue("CareSense", "疼痛") + '>');
	if(CareSense.indexOf("疼痛")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow33,690);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow33,690);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow33, 710, 100, 15, "疼痛");
	
	///lodop.ADD_PRINT_HTM(qsmzRow34-2, 400, 80, 20, '<input type="checkbox" class="AwakeningDelay" value="苏醒延迟"' + CheckBoxValue("AwakeningDelay", "苏醒延迟") + '>');
	var AwakeningDelay=CheckBoxValue("AwakeningDelay","苏醒延迟")
	if(AwakeningDelay=="checked")
	{
		DrawRectAndRight(lodop,qsmzRow34,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow34,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow34, 420, 100, 15, "苏醒延迟 ");
	///lodop.ADD_PRINT_HTM(qsmzRow34-2, 520, 80, 20, '<input type="checkbox" class="Vomiting" value="呕吐"' + CheckBoxValue("Vomiting", "呕吐") + '>');
	var Vomiting=CheckBoxValue("Vomiting","呕吐");
	if(Vomiting=="checked")
	{
		DrawRectAndRight(lodop,qsmzRow34,520);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow34,520);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow34, 540, 100, 15, "呕吐");
	///lodop.ADD_PRINT_HTM(qsmzRow34-2, 640, 80, 20, '<input type="checkbox" class="Aspiration" value="误吸"' + CheckBoxValue("Aspiration", "误吸") + '>');
	var Aspiration=CheckBoxValue("Aspiration","误吸")
	if(Aspiration=="checked")
	{
		DrawRectAndRight(lodop,qsmzRow34,640);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow34,640);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow34, 660, 100, 15, "误吸");
	
	lodop.ADD_PRINT_TEXT(qsmzRow35, 370, 60, 15, "泌尿:");
	lodop.SET_PRINT_STYLEA(0, "FontColor", "#000000"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow35-2, 400, 80, 20, '<input type="checkbox" class="Urinary" value="少尿"' + CheckBoxValue("Urinary", "少尿") + '>');
	var Urinary=$("#Urinary").val();
	if(Urinary.indexOf("少尿")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow35,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow35,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow35, 420, 100, 15, "少尿");
	///lodop.ADD_PRINT_HTM(qsmzRow35-2, 480, 80, 20, '<input type="checkbox" class="Urinary" value="多尿"' + CheckBoxValue("Urinary", "多尿") + '>');
	if(Urinary.indexOf("多尿")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow35,480);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow35,480);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow35, 500, 100, 15, "多尿");
	///lodop.ADD_PRINT_HTM(qsmzRow35-2, 600, 80, 20, '<input type="checkbox" class="Urinary" value="尿潴留"' + CheckBoxValue("Urinary", "尿潴留") + '>');
	if(Urinary.indexOf("尿潴留")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow35,600);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow35,600);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow35, 620, 100, 15, " 尿潴留");
	
	lodop.ADD_PRINT_TEXT(qsmzRow36, 370, 60, 15, "其它:");
	lodop.SET_PRINT_STYLEA(0, "FontColor", "#000000"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow36-2, 400, 80, 20, '<input type="checkbox" class="CareOther" value="支气管痉挛"' + CheckBoxValue("CareOther", "支气管痉挛") + '>');
	var CareOther=$("#CareOther").val();
	if(CareOther.indexOf("支气管痉挛")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow36,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow36,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow36, 420, 100, 15, "支气管痉挛");
	///lodop.ADD_PRINT_HTM(qsmzRow36-2, 520, 80, 20, '<input type="checkbox" class="CareOther" value="急性肺不张"' + CheckBoxValue("CareOther", "急性肺不张") + '>');
	if(CareOther.indexOf("急性肺不张")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow36,520);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow36,520);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow36, 540, 100, 15, "急性肺不张");
	///lodop.ADD_PRINT_HTM(qsmzRow36-2, 640, 80, 20, '<input type="checkbox" class="CareOther" value="张力性气胸"' + CheckBoxValue("CareOther", "张力性气胸") + '>');
	if(CareOther.indexOf("张力性气胸")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow36,640);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow36,640);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow36, 660, 100, 15, "张力性气胸");
	
	lodop.ADD_PRINT_TEXT(qsmzRow37, 340, 100, 15, "敏感指标:");
	lodop.SET_PRINT_STYLEA(0, "FontColor", "#000000"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow37-2, 400, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="低体温"' + CheckBoxValue("SensitiveIndicator", "低体温") + '>');
	var SensitiveIndicator=$("#SensitiveIndicator").val();
	if(SensitiveIndicator.indexOf("低体温")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow37,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow37,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow37, 420, 100, 15, "低体温");
	///lodop.ADD_PRINT_HTM(qsmzRow37-2, 480, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="高体温"' + CheckBoxValue("SensitiveIndicator", "高体温") + '>');
	if(SensitiveIndicator.indexOf("高体温")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow37,480);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow37,480);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow37, 500, 100, 15, "高体温");
	///lodop.ADD_PRINT_HTM(qsmzRow37-2, 570, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="拔管后声音嘶哑"' + CheckBoxValue("SensitiveIndicator", "拔管后声音嘶哑") + '>');
	if(SensitiveIndicator.indexOf("拔管后声音嘶哑")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow37,570);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow37,570);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow37, 590, 120, 15, "拔管后声音嘶哑");
	///lodop.ADD_PRINT_HTM(qsmzRow37-2, 690, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="过敏"' + CheckBoxValue("SensitiveIndicator", "过敏") + '>');
	if(SensitiveIndicator.indexOf("过敏")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow37,690);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow37,690);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow37, 710, 100, 15, "过敏");
	
	///lodop.ADD_PRINT_HTM(qsmzRow38-2, 400, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="转出延迟(入室>3h)"' + CheckBoxValue("SensitiveIndicator", "转出延迟(入室>3h)") + '>');
	///alert(SensitiveIndicator);
	///alert("1:"+SensitiveIndicator.indexOf("转出延迟(入室＞3h)"));
	///var SensitiveIndicator=CheckBoxValue("SensitiveIndicator","转出延迟(入室＞3h)");
	if(SensitiveIndicator.indexOf("转出延迟")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow38,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow38,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow38, 420, 160, 15, "转出延迟(入室＞3h)");
	///lodop.ADD_PRINT_HTM(qsmzRow38-2, 540, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="非计划二次插管"' + CheckBoxValue("SensitiveIndicator", "非计划二次插管") + '>');
	if(SensitiveIndicator.indexOf("非计划二次插管")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow38,540);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow38,540);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow38, 560, 120, 15, "非计划二次插管");
	///lodop.ADD_PRINT_HTM(qsmzRow38-2, 660, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="非计划入ICU"' + CheckBoxValue("SensitiveIndicator", "非计划入ICU") + '>');
	if(SensitiveIndicator.indexOf("非计划入ICU")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow38,660);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow38,660);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow38, 680, 120, 15, "非计划入ICU");
	
	///lodop.ADD_PRINT_HTM(qsmzRow39-2, 400, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="非计划二次手术"' + CheckBoxValue("SensitiveIndicator", "非计划二次手术") + '>');
	if(SensitiveIndicator.indexOf("非计划二次手术")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow39,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow39,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow39, 420, 120, 15, "非计划二次手术");
	///lodop.ADD_PRINT_HTM(qsmzRow39-2, 540, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="麻醉开始后24小时内死亡"' + CheckBoxValue("SensitiveIndicator", "麻醉开始后24小时内死亡") + '>');
	if(SensitiveIndicator.indexOf("麻醉开始后24小时内死亡")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow39,540);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow39,540);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow39, 560, 180, 15, "麻醉开始后24小时内死亡");
	//lodop.ADD_PRINT_HTM(qsmzRow39-2, 640, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="喉痉挛"' + CheckBoxValue("SensitiveIndicator", "喉痉挛") + '>');
	//lodop.ADD_PRINT_TEXT(qsmzRow39, 660, 120, 15, "麻醉后新发昏迷");
	
	///lodop.ADD_PRINT_HTM(qsmzRow40-2, 400, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="麻醉后新发昏迷"' + CheckBoxValue("SensitiveIndicator", "麻醉后新发昏迷") + '>');
	if(SensitiveIndicator.indexOf("麻醉后新发昏迷")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow40,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow40,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow40, 420, 120, 15, "麻醉后新发昏迷");
	///lodop.ADD_PRINT_HTM(qsmzRow40-2, 540, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="麻醉开始后24小时内心跳骤停"' + CheckBoxValue("SensitiveIndicator", "麻醉开始后24小时内心跳骤停") + '>');
	if(SensitiveIndicator.indexOf("麻醉开始后24小时内心跳骤停")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow40,540);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow40,540);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow40, 560, 180, 15, "麻醉开始后24小时内心跳骤停");
	
	///lodop.ADD_PRINT_HTM(qsmzRow41-2, 400, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="中心静脉严重并发症"' + CheckBoxValue("SensitiveIndicator", "中心静脉严重并发症") + '>');
	if(SensitiveIndicator.indexOf("中心静脉严重并发症")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow41,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow41,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow41, 420, 160, 15, "中心静脉严重并发症");
	///lodop.ADD_PRINT_HTM(qsmzRow41-2, 540, 80, 20, '<input type="checkbox" class="SensitiveIndicator" value="椎管内麻醉神经损伤"' + CheckBoxValue("SensitiveIndicator", "椎管内麻醉神经损伤") + '>');
	if(SensitiveIndicator.indexOf("椎管内麻醉神经损伤")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow41,540);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow41,540);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow41, 560, 180, 15, "椎管内麻醉神经损伤");
	
	lodop.ADD_PRINT_TEXT(qsmzRow42, 330, 100, 15, "手术并发症:");
	lodop.SET_PRINT_STYLEA(0, "FontColor", "#000000"); //更换颜色
	///lodop.ADD_PRINT_HTM(qsmzRow42-2, 400, 80, 20, '<input type="checkbox" class="SurgicalComplications" value="切口裂开"' + CheckBoxValue("SurgicalComplications", "切口裂开") + '>');
	var SurgicalComplications=$("#SurgicalComplications").val();
	///alert(SurgicalComplications);
	if(SurgicalComplications.indexOf("切口裂开")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow42,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow42,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow42, 420, 100, 15, "切口裂开");
	///lodop.ADD_PRINT_HTM(qsmzRow42-2, 540, 80, 20, '<input type="checkbox" class="SurgicalComplications" value="术后大出血"' + CheckBoxValue("SurgicalComplications", "术后大出血") + '>');
	if(SurgicalComplications.indexOf("术后大出血")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow42,540);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow42,540);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow42, 560, 100, 15, "术后大出血");
	///lodop.ADD_PRINT_HTM(qsmzRow42-2, 660, 80, 20, '<input type="checkbox" class="SurgicalComplications" value="皮下气肿"' + CheckBoxValue("SurgicalComplications", "皮下气肿") + '>');
	if(SurgicalComplications.indexOf("皮下气肿")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow42,660);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow42,660);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow42, 680, 120, 15, "皮下气肿");
	///lodop.ADD_PRINT_HTM(qsmzRow43-2, 400, 80, 20, '<input type="checkbox" class="SurgicalComplications" value="切口血肿"' + CheckBoxValue("SurgicalComplications", "切口血肿") + '>');
	if(SurgicalComplications.indexOf("切口血肿")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow43,400);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow43,400);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow43, 420, 100, 15, "切口血肿");
	///lodop.ADD_PRINT_HTM(qsmzRow43-2, 540, 80, 20, '<input type="checkbox" class="SurgicalComplications" value="气胸"' + CheckBoxValue("SurgicalComplications", "气胸") + '>');
	if(SurgicalComplications.indexOf("气胸")>-1)
	{
		DrawRectAndRight(lodop,qsmzRow43,540);
	}else{
		DrawRectAndRightNull(lodop,qsmzRow43,540);
	}
	lodop.ADD_PRINT_TEXT(qsmzRow43, 560, 100, 15, "气胸");

	
	
	
}

function getScore()
{
	var test = 0;
    var score = Number($('#InActivity').attr('data-score'));
    test = test + score;
}

function refreshAssessmentResults() {
    var scattTriggerAssessmentScore = 0;
    $.each($('#ScattTrigger_form').find("input"), function(index, e) {
        if ($(this).prop('checked')) {
            var score = Number($(this).attr('data-score'));
            scattTriggerAssessmentScore = scattTriggerAssessmentScore + score;
        }
    });

    $("#ScattTriggerResult").val(getAssessmentResult(assessmentResultList.scattTrigger, scattTriggerAssessmentScore));

    var preoperAssessmentScore = 0;
    var inoperAssessmentScore = 0;
    var postoperAssessmentScore = 0;
    $.each($('#preoperassess_form').find("input"), function(index, e) {
        if ($(this).prop('checked')) {
            var score = Number($(this).attr('data-score'));
            preoperAssessmentScore = preoperAssessmentScore + score;
            inoperAssessmentScore = inoperAssessmentScore + score;
            postoperAssessmentScore = postoperAssessmentScore + score;
        }
    });
    $.each($('#inoperassess_form').find("input"), function(index, e) {
        if ($(this).prop('checked')) {
            var score = Number($(this).attr('data-score'));
            inoperAssessmentScore = inoperAssessmentScore + score;
            postoperAssessmentScore = postoperAssessmentScore + score;
        }
    });
    $.each($('#postoperassess_form').find("input"), function(index, e) {
        if ($(this).prop('checked')) {
            var score = Number($(this).attr('data-score'));
            postoperAssessmentScore = postoperAssessmentScore + score;
        }
    });

    $("#PreOperAssessmentResult").val(preoperAssessmentScore + "分 ~ " + getAssessmentResult(assessmentResultList.preoper, preoperAssessmentScore));
    $("#InOperAssessmentResult").val(inoperAssessmentScore + "分 ~ " + getAssessmentResult(assessmentResultList.inoper, inoperAssessmentScore));
    $("#PostOperAssessmentResult").val(postoperAssessmentScore + "分 ~ " + getAssessmentResult(assessmentResultList.postoper, postoperAssessmentScore));

}

function getAssessmentResult(resultList, score) {
    var length = resultList.length;
    var item;
    for (var i = 0; i < length; i++) {
        item = resultList[i];
        if (score >= item.range.min && score <= item.range.max) {
            return item.result;
        }
    }

    return "";
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
	tmplodop.ADD_PRINT_RECT(tmptop-2,tmpleft+5,"3.3mm","3.3mm",0,1);
	tmplodop.SET_PRINT_STYLEA(0,"FontColor", "#0000ff"); //更换颜色
	tmplodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
	tmplodop.SET_PRINT_STYLEA(0, "FontSize", 15);
}
function loadPatInfo(appData) {
    if(!appData) return;
    $.each($("#patientInfo").find(".form-item"), function(index, item) {
        var field = $(item).attr('id');
        $(item).text(appData[field] || '');
    });
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

function SetDefaultValue()
{
	if ($("#SurgicalCondition").val()=="")
	{
		$("#SurgicalCondition").val("无");
	}
	if ($("#AllergyHistory").val()=="")
	{
		$("#AllergyHistory").val("无");
	}

	if ($("#PreopComplication").val()=="")
	{
		$("#PreopComplication").val("无");
	}

	if ($("#TubeOutLeftPupilSize").val()=="")
	{
		$("#TubeOutLeftPupilSize").val("2.5");
	}
	if ($("#TubeOutRightPupilSize").val()=="")
	{
		$("#TubeOutRightPupilSize").val("2.5");
	}

	if ($("#TubeOutLeftPupilSize2").val()=="")
	{
		$("#TubeOutLeftPupilSize2").val("3.0");
	}
	if ($("#TubeOutRightPupilSize2").val()=="")
	{
		$("#TubeOutRightPupilSize2").val("3.0");
	}

	if ($("#OutLeftPupilSize").val()=="")
	{
		$("#OutLeftPupilSize").val("3.0");
	}
	if ($("#OutRightPupilSize").val()=="")
	{
		$("#OutRightPupilSize").val("3.0");
	}

	if ($("#InPainScore").val()=="")
	{
		$("#InPainScore").val("0");
	}
	if ($("#TubeOutPainScore").val()=="")
	{
		$("#TubeOutPainScore").val("2");
	}
	if ($("#TubeOutPainScore2").val()=="")
	{
		$("#TubeOutPainScore2").val("2");
	}

	if ($("#OutPainScore").val()=="")
	{
		$("#OutPainScore").val("2");
	}
}

function GetPatVital(opsId) {
	var data=dhccl.getDatas(ANCSP.MethodService, {
		 ClassName: ANCLS.BLL.AnaestRecord,
		 MethodName: "GetPacuRecordData",
		 Arg1: opsId,
		 ArgCnt: 1
	 },'text',false, function(data) {

		 if ($("#TidalVolume").val()=="") $("#TidalVolume").val(data.split("^")[0]);
		 if ($("#RespRate").val()=="") $("#RespRate").val(data.split("^")[1]);
		 if ($("#TubeDepth").val()=="")  $("#TubeDepth").val(data.split("^")[2]);
		 var teeth=data.split("^")[3];
		 if (teeth=="固定"){
			$("#固定").checkbox("setValue",true);
		 }
		 else{
			$("#松动").checkbox("setValue",true);
		 }
		 $("#AirwayCondition").val(data.split("^")[4]);

		 var inTubeType=data.split("^")[5];
		 if (inTubeType.indexOf("气管插管")>-1){
			$("#TracheaCannula").checkbox("setValue",true);
			if ($("#InLeftPupilSize").val()=="")
			{
				$("#InLeftPupilSize").val("2.0");
			}
			if ($("#InRightPupilSize").val()=="")
			{
				$("#InRightPupilSize").val("2.0");
			}
		 }
		 else if (inTubeType.indexOf("喉罩")>-1)
		 {
			$("#LaryngealMaskAirway").checkbox("setValue",true);
			if ($("#InLeftPupilSize").val()=="")
			{
				$("#InLeftPupilSize").val("3.0");
			}
			if ($("#InRightPupilSize").val()=="")
			{
				$("#InRightPupilSize").val("3.0");
			}
		 }else{
			$("#Extubation").checkbox("setValue",true);

			// 拔管时 10min
			/*
			$("#TubeOutActivity1").checkbox("setValue",false);
			$("#TubeOutRespiration1").checkbox("setValue",false);
			$("#TubeOutCirculation1").checkbox("setValue",false);
			$("#TubeOutConscious2").checkbox("setValue",false);
			$("#TubeOutSPO21").checkbox("setValue",false);
			$("#TubeOutSickVomit1").checkbox("setValue",false);
			
			$("#TubeOutLeftPupilSize").val("");
			$("#TubeOutRightPupilSize").val("");
			$("#TubeOutPainScore").val("");
			*/
			// 拔管时 60min
			/*
			$("#TubeOutActivity151").checkbox("setValue",false);
			$("#TubeOutRespiration151").checkbox("setValue",false);
			$("#TubeOutCirculation151").checkbox("setValue",false);
			$("#TubeOutConsciousness151").checkbox("setValue",false);
			$("#TubeConSPO2151").checkbox("setValue",false);
			$("#TubeOutSickVomit151").checkbox("setValue",false);
			
			$("#TubeOutRightPupilSize2").val("");
			$("#TubeOutLeftPupilSize2").val("");
			$("#TubeOutPainScore2").val("");
			*/

			if ($("#InLeftPupilSize").val()=="")
			{
				$("#InLeftPupilSize").val("3.0");
			}
			if ($("#InRightPupilSize").val()=="")
			{
				$("#InRightPupilSize").val("3.0");
			}
		 }
	 });
 }

 function GetPatOutInVolume() {
	var opsId = dhccl.getQueryString("opsId");
	var data=dhccl.getDatas(ANCSP.MethodService, {
		 ClassName: ANCLS.BLL.AnaestRecord,
		 MethodName: "GetPACUinOutVolume",
		 Arg1: opsId,
		 ArgCnt: 1
	 },'text',false, function(data) {

		 if ($("#RoomInLiquidIn").val()=="") $("#RoomInLiquidIn").val(data.split("^")[0]);
		 if ($("#RoomInLiquidOut").val()=="") $("#RoomInLiquidOut").val(data.split("^")[1]);
		 if ($("#PACULiquidIn").val()=="")  $("#PACULiquidIn").val(data.split("^")[2]);

		 if ($("#PACULiquidOut").val()=="") $("#PACULiquidOut").val(data.split("^")[3]);
		 if ($("#RoomOutLiquidIn").val()=="") $("#RoomOutLiquidIn").val(data.split("^")[4]);
		 if ($("#RoomOutLiquidOut").val()=="")  $("#RoomOutLiquidOut").val(data.split("^")[5]);
	 });
 }