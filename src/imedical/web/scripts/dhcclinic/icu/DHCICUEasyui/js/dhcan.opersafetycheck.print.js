function getPrintOperDatas(dataModuleCode) {
    var operDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperData,
        QueryName: "FindOperData",
        Arg1: session.OPSID,
        Arg2: dataModuleCode,
        ArgCnt: 2
    }, "json");
    return operDatas;
}

function createOperRiskAssessmentPage(lodop) {
    var printDatas = getPrintOperDatas("OperRiskAssessment");
    var operSchedule = operDataManager.operScheduleData;
    var bladeTypeValue = getDataValueByCode("OpBladeClean", printDatas);
    var bladeTypeValueArr = bladeTypeValue.split(',');
    var bladeTypeScore = getDataScoreByCode("OpBladeClean", printDatas);
    var ASAClassValue = getDataValueByCode("ASAClass", printDatas);
    var ASAClassScore = getDataScoreByCode("ASAClass", printDatas);
    var durationTimesValue = getDataValueByCode("OpDurationTimes", printDatas);
    var durationTimesScore = getDataScoreByCode("OpDurationTimes", printDatas);
    var operTypeValue = getDataValueByCode("OperationType", printDatas);
    var emergencyValue = getDataValueByCode("EmergencyOper", printDatas)
        // lodop.PRINT_INIT("OperRiskAssessment" + session.OPSID);
        // lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontName", "宋体");
    lodop.SET_PRINT_STYLE("FontSize", 11);

    var startPos = {
        x: 20,
        y: 50
    };
    var linePos = {
        x: startPos.x,
        y: startPos.y
    };
    var contentLineHeight = 30,
        titleLineHeight = 40,
        contentLineMargin = 20;
    lodop.ADD_PRINT_TEXT(50, 300, "100%", 60, "山西省肿瘤医院手术风险评估记录");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    startPos.y += titleLineHeight;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "日期：" + operSchedule.OperDate);
    lodop.ADD_PRINT_TEXT(startPos.y, 160, 200, 15, "科别：" + operSchedule.PatDeptDesc);
    lodop.ADD_PRINT_TEXT(startPos.y, 360, 200, 15, "姓名：" + operSchedule.PatName);
    lodop.ADD_PRINT_TEXT(startPos.y, 500, 200, 15, "住院号：" + operSchedule.MedcareNo);

    startPos.y += contentLineHeight;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, "100%", 15, "实施手术名称：" + operSchedule.OperationDesc);

    var textPadding = { left: 5, top: 10 };
    startPos.y += contentLineHeight;
    var cellSize = { width: 240, height: 40 };
    var basePos = { x: 20, y: startPos.y };
    drawRectAndTitle(lodop, {
        startPos: startPos,
        rectSize: cellSize,
        title: "1.手术切口清洁程度"
    });
    drawRectAndTitle(lodop, {
        startPos: {
            x: startPos.x + cellSize.width,
            y: startPos.y
        },
        rectSize: cellSize,
        title: "2.麻醉分级(ASA分级)"
    });
    drawRectAndTitle(lodop, {
        startPos: {
            x: startPos.x + cellSize.width * 2,
            y: startPos.y
        },
        rectSize: cellSize,
        title: "3.手术持续时间"
    });

    startPos.y += cellSize.height;
    var rectStartPos = { x: startPos.x, y: startPos.y }; //每个矩形起始坐标
    var checkboxSize = { width: 12, height: 12 };
    var textWidth = cellSize.width - checkboxSize.width - textPadding.left - 3,
        textHeight = "100%";
    var lineStyle = 0,
        lineWidth = 1;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 60, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (bladeTypeValueArr.indexOf("I") > -1),
        text: "I类手术切口(清洁手术)",
        textSize: { width: textWidth, height: textHeight }
    });

    rectStartPos.x = startPos.x + cellSize.width;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 60, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (ASAClassValue === "P1"),
        text: "P1:正常的患者除局部病变外，无系统性病变",
        textSize: { width: textWidth, height: textHeight }
    });

    rectStartPos.x = startPos.x + cellSize.width * 2;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 60, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (durationTimesValue === "T1"),
        text: "T1:手术在3小时内完成",
        textSize: { width: textWidth, height: textHeight }
    });

    startPos.y += 60;
    rectStartPos.x = startPos.x;
    rectStartPos.y = startPos.y;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 75, 0, 1);
    lodop.ADD_PRINT_TEXT(rectStartPos.y + textPadding.top, rectStartPos.x + textPadding.left, cellSize.width - textPadding.left, textHeight, "手术野无污染：手术切口周边无炎症；患者没有进行气道、食道和/或尿道插管；患者没有意识障碍。");

    rectStartPos.x = startPos.x + cellSize.width;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 75, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (ASAClassValue === "P2"),
        text: "P2:患者有轻微的临床症状：有轻度或中度系统性疾病",
        textSize: { width: textWidth, height: textHeight }
    });

    rectStartPos.x = startPos.x + cellSize.width * 2;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 75, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (durationTimesValue === "T2"),
        text: "T2:完成手术超过3小时",
        textSize: { width: textWidth, height: textHeight }
    });

    startPos.y += 75;
    rectStartPos.x = startPos.x;
    rectStartPos.y = startPos.y;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 50, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (bladeTypeValueArr.indexOf("II") > -1),
        text: "II类手术切口(相对清洁手术)",
        textSize: { width: textWidth, height: textHeight }
    });

    rectStartPos.x = startPos.x + cellSize.width;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 50, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (ASAClassValue === "P3"),
        text: "P3:有严重的系统性疾病，日常活动受限，但未丧失工作能力。",
        textSize: { width: textWidth, height: textHeight }
    });
    rectStartPos.x = startPos.x + cellSize.width * 2;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, 240, 370, 0, 1);

    startPos.y += 50;
    rectStartPos.x = startPos.x;
    rectStartPos.y = startPos.y;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 120, lineStyle, lineWidth);
    lodop.ADD_PRINT_TEXT(rectStartPos.y + textPadding.top, rectStartPos.x + textPadding.left, cellSize.width - textPadding.left, textHeight, "上、下呼吸道，上、下消化道，泌尿生殖道或经以上器官的手术；患者进行气道、食道和/或尿道插管；患者病情稳定；行胆囊、阴道、阑尾、耳鼻手术的患者。");

    rectStartPos.x = startPos.x + cellSize.width;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 60, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (ASAClassValue === "P4"),
        text: "P4:有严重的系统性疾病，已丧失工作能力，威胁生命安全。",
        textSize: { width: textWidth, height: textHeight }
    });

    rectStartPos.y += 60;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 60, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (ASAClassValue === "P5"),
        text: "P5:病情危重，生命难以维持的濒死病人。",
        textSize: { width: textWidth, height: textHeight }
    });

    startPos.y += 120;
    rectStartPos.x = startPos.x;
    rectStartPos.y = startPos.y;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 40, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (bladeTypeValueArr.indexOf("III") > -1),
        text: "III类手术切口(清洁-污染手术)",
        textSize: { width: textWidth, height: textHeight }
    });

    rectStartPos.x = startPos.x + cellSize.width;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 40, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (ASAClassValue === "P6"),
        text: "P6:脑死亡的患者",
        textSize: { width: textWidth, height: textHeight }
    });

    startPos.y += 40;
    rectStartPos.x = startPos.x;
    rectStartPos.y = startPos.y;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 80, 0, 1);
    lodop.ADD_PRINT_TEXT(rectStartPos.y + textPadding.top, rectStartPos.x + textPadding.left, cellSize.width - textPadding.left, textHeight, "开放、新鲜且不干净的伤口，前次手术后感染的切口；手术中需采取消毒措施的切口。");

    rectStartPos.x = startPos.x + cellSize.width;
    drawRectAndTitle(lodop, {
        startPos: {
            x: rectStartPos.x,
            y: rectStartPos.y
        },
        rectSize: { width: cellSize.width, height: 40 },
        title: "4.手术类别"
    });

    rectStartPos.y += 40;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 40, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (operTypeValue.indexOf("浅层组织手术") >= 0),
        text: "4.1.浅层组织手术",
        textSize: { width: textWidth, height: textHeight }
    });

    startPos.y += 80;
    rectStartPos.x = startPos.x;
    rectStartPos.y = startPos.y;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 40, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (bladeTypeValueArr.indexOf("IV") > -1),
        text: "IV类手术切口(污染手术)",
        textSize: { width: textWidth, height: textHeight }
    });

    rectStartPos.x = startPos.x + cellSize.width;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 40, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (operTypeValue.indexOf("深部组织手术") >= 0),
        text: "4.2.深部组织手术",
        textSize: { width: textWidth, height: textHeight }
    });

    startPos.y += 40;
    rectStartPos.x = startPos.x;
    rectStartPos.y = startPos.y;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 80, 0, 1);
    lodop.ADD_PRINT_TEXT(rectStartPos.y + textPadding.top, rectStartPos.x + textPadding.left, cellSize.width - textPadding.left, textHeight, "严重的外伤，手术切口有炎症、组织坏死，或有内脏引流管。");

    rectStartPos.x = startPos.x + cellSize.width;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 40, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (operTypeValue.indexOf("器官类别") >= 0),
        text: "4.3.器官类别",
        textSize: { width: textWidth, height: textHeight }
    });

    rectStartPos.y += 40;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 40, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (operTypeValue.indexOf("腔隙手术") >= 0),
        text: "4.4.腔隙手术",
        textSize: { width: textWidth, height: textHeight }
    });

    rectStartPos.x = startPos.x + cellSize.width * 2;
    lodop.ADD_PRINT_RECT(rectStartPos.y, rectStartPos.x, cellSize.width, 40, lineStyle, lineWidth);
    drawCheckBoxAndValue(lodop, {
        startPos: { x: rectStartPos.x + textPadding.left, y: rectStartPos.y + textPadding.top },
        checked: (emergencyValue === "急诊"),
        text: "急诊手术",
        textSize: { width: textWidth, height: textHeight }
    });

    startPos.y += 80;
    var bladeTypeScoreValue = Number(bladeTypeScore),
        ASAClassScoreValue = Number(ASAClassScore),
        durationTimesScoreValue = Number(durationTimesScore);
    if (isNaN(bladeTypeScoreValue)) {
        bladeTypeScoreValue = 0;
    }
    if (isNaN(ASAClassScoreValue)) {
        ASAClassScoreValue = 0;
    }
    if (isNaN(durationTimesScoreValue)) {
        durationTimesScoreValue = 0;
    }
    var totalScore = bladeTypeScoreValue + ASAClassScoreValue + durationTimesScoreValue;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, 720, 40, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + textPadding.top, 25, 720, "100%", "手术风险评估分数：手术切口清洁度(" + bladeTypeScoreValue + "分)+麻醉ASA分级(" + ASAClassScoreValue + "分)+手术持续时间(" + durationTimesScoreValue + "分)=" + totalScore + "分");

    startPos.y += 60;
    var signatureList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.Signature,
        QueryName: "FindSignatureForModule",
        Arg1: session.OPSID,
        Arg2: "OperRiskAssessment",
        ArgCnt: 2
    }, "json", false);
    if (signatureList && signatureList.length > 0) {
        for (var i = 0; i < signatureList.length; i++) {
            var signature = signatureList[i];
            //if (!signature.SignImage || signature.SignImage === "") continue;
            var signCode = signature.SignCode;
            if (!signCode || signCode === "") continue;
            var signImage = dhccl.runServerMethod(ANCLS.BLL.Signature, "GetSignImageBySSUserID", signature.SignUser);
            if (signImage.success === false || signImage.result === '') continue;
            var imgHtml = "";
            imgHtml = "<img src='data:image/png;base64," + signImage.result + "' width='140' height='40'>"
            if (signCode === "PreanSurgeonSign") {
                lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 5, 240, 30, "手术医生：");
                lodop.ADD_PRINT_IMAGE(startPos.y + 30, startPos.x + 10, 140, 50, imgHtml);
            } else if (signCode === "PreanAnesthetistSign") {
                lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 245, 240, 30, "麻醉医生：");
                lodop.ADD_PRINT_IMAGE(startPos.y + 30, startPos.x + 250, 140, 50, imgHtml);
            } else if (signCode === "PreanOperNurseSign") {
                lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 485, 240, 30, "手术护士：");
                lodop.ADD_PRINT_IMAGE(startPos.y + 30, startPos.x + 490, 140, 50, imgHtml);
            }
        }
        lodop.SET_PRINT_STYLEA(0, "HtmlWaitMilSecs", 500);
    }
}

function drawCheckBoxAndValue(lodop, opts) {
    var boxSize = { width: 12, height: 12 };
    var lineStyle = 0,
        lineWidth = 1;
    var startPos = opts.startPos;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, boxSize.width, boxSize.height, lineStyle, lineWidth);
    var checkValue = opts.checked ? "√" : (opts.emptyValue?opts.emptyValue:"/");
    var offSetX = opts.checked ? 3 : (-2),
        offSetY = opts.checked ? 5 : 3;
    var checkTextMargin = 3;
    lodop.ADD_PRINT_TEXT(startPos.y - offSetY, startPos.x - offSetX, "100%", "100%", checkValue);
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);
    lodop.SET_PRINT_STYLEA(0, "Bold", 1);
    var textSize = opts.textSize;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + boxSize.width + checkTextMargin, textSize.width, textSize.height, opts.text);
}

function drawRectAndTitle(lodop, opts) {
    var rectSize = opts.rectSize,
        startPos = opts.startPos,
        lineStyle = 0,
        lineWidth = 1;
    var offSetY = (rectSize.height - 12) / 2;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, rectSize.width, rectSize.height, lineStyle, lineWidth);
    lodop.ADD_PRINT_TEXT(startPos.y + offSetY, startPos.x, rectSize.width, rectSize.height, opts.title);
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
}

function getDataValueByCode(dataCode, operDatas) {
    var dataValue = "";
    for (var i = 0; i < operDatas.length; i++) {
        var operData = operDatas[i];
        if (operData.DataItem === dataCode) {
            dataValue = operData.DataValue;
        }
    }
    return dataValue;
}

function getDataScoreByCode(dataCode, operDatas) {
    var dataValue = "";
    for (var i = 0; i < operDatas.length; i++) {
        var operData = operDatas[i];
        if (operData.DataItem === dataCode) {
            dataValue = operData.DataScore;
        }
    }
    return dataValue;
}