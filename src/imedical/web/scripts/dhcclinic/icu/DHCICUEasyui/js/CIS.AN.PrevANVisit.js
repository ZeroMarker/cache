var anaestConsent = {
    operSchedule: null
};

$(document).ready(function() {
    dhccl.parseDateFormat();
    dhccl.parseDateTimeFormat();
	initPage();
    operDataManager.initFormData(loadApplicationData);
    
    operDataManager.setCheckChange();
});

/**
 * 调用所有页面元素初始化函数
 */
function initPage() {
    initDelegates();
    initDefaultValue();
    //signCommon.loadSignature();
    SignTool.loadSignature();
    if (readonly()) disableAllInput();

    initASAClass();
}

function readonly() {
    var readonly = dhccl.getQueryString('readonly');
    if (readonly && readonly == 'true') return true;
    return false;
}

function initASAClass() {
    $("#ASAClass").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindASAClass";
            param.ArgCnt = 0;
        },
        onLoadSuccess: function() {
            //$("#ASAClass").combobox('setValue', $("#ASAClass").attr('data-value'));
        }
    });

    $("#ASAClass").combobox({
        validType: "validCareProv['ASAClass']"
    });
}

$.extend($.fn.validatebox.defaults.rules, {
    validCareProv: {
        validator: function(value, param) {
            var curValue = $("#" + param[0]).combobox("getValue");
            var curText = $("#" + param[0]).combobox("getText");
            if (curValue && curValue !== "/") {
                return parseInt(curValue) > 0
            }
            if (!curValue && curText && curText !== "/") {
                return false;
            }

            return true;
        },
        message: "请从下拉框选项中选择"

    }
});

function disableAllInput() {
    $('input:visible').attr('disabled', true);
    $('span.combo-arrow').hide();
    $('span.triggerbox-button').hide();
    $('input[type="checkbox"]').checkbox('disable');
    $('#btnSave').hide();
}

/**
 * 初始化所有按钮单击事件
 */
function initDelegates() {
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
			var ASA=$("#ASAClass").combobox('getValue')
			var ret = dhccl.runServerMethod("CIS.AN.BL.Anaesthesia", "SaveASAClass", session.OPSID,ASA);
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

    $("#btnSelectTemplate").linkbutton({
        onClick: function() {
            var template = new SheetTemplate({
                title: "选择模板",
                showBox: true,
                showForm: false,
                moduleID: session.ModuleID,
                userID: session.UserID
            });
            template.open();
        }
    });

    $("#btnSaveTemplate").linkbutton({
        onClick: function() {
            var template = new SheetTemplate({
                title: "保存模板",
                showBox: false,
                showForm: true,
                moduleID: session.ModuleID,
                userID: session.UserID
            });
            template.open();
        }
    });
	
	$("#btnArchive").linkbutton({
        onClick: function () {
            archive()
        }
    });
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
    signCommon.loadSignature();
}

function initDefaultValue() {
    var temperDataArr = dhccl.runServerMethod(ANCLS.BLL.OperData, "GetLastTemperatureData", session.EpisodeID);
    if (temperDataArr && temperDataArr.length > 0) {
        var temperatureData = temperDataArr[0];
        if (temperatureData.Temperature && $("#Temperature").val() === "") {
            $("#Temperature").val(temperatureData.Temperature)
        }
        if (temperatureData.Pulse && $("#Pulse").val() === "") {
            $("#Pulse").val(temperatureData.Pulse)
        }
        if (temperatureData.RespRate && $("#Respiration").val() === "") {
            $("#Respiration").val(temperatureData.RespRate)
        }
        if (temperatureData.BloodPressure && $("#BloodPressure").val() === "") {
            $("#BloodPressure").val(temperatureData.BloodPressure)
        }
        if (temperatureData.Height && $("#PatHeight").val() === "") {
            $("#PatHeight").val(temperatureData.Height)
        }
        if (temperatureData.Weight && $("#PatWeight").val() === "") {
            $("#PatWeight").val(temperatureData.Weight)
        }
        if (temperatureData.SPO2 && $("#SPO2").val() === "") {
            $("#SPO2").val(temperatureData.SPO2)
        }
    }

    var testDataArr = dhccl.runServerMethod(ANCLS.BLL.OperData, "GetLastLabData", session.EpisodeID);
    if (testDataArr && testDataArr.length > 0) {
        var testData = testDataArr[0];
        if (testData.WBC && $("#WBC").val() === "") {
            $("#WBC").val(testData.WBC);
        }
        if (testData.HGB && $("#HGB").val() === "") {
            $("#HGB").val(testData.HGB);
        }
        if (testData.HCT && $("#HCT").val() === "") {
            $("#HCT").val(testData.HCT);
        }
        if (testData.PLT && $("#PLT").val() === "") {
            $("#PLT").val(testData.PLT);
        }
        if (testData.PT && $("#PT").val() === "") {
            $("#PT").val(testData.PT);
        }
        if (testData.APTT && $("#APTT").val() === "") {
            $("#APTT").val(testData.APTT);
        }
        if (testData.K && $("#K").val() === "") {
            $("#K").val(testData.K);
        }
        if (testData.NA && $("#Na").val() === "") {
            $("#Na").val(testData.NA);
        }
        if (testData.Cl && $("#Cl").val() === "") {
            $("#Cl").val(testData.Cl);
        }
        if (testData.GLU && $("#GLU").val() === "") {
            $("#GLU").val(testData.GLU);
        }
    }

    if (anaestConsent.operSchedule) {
        $("#SourceType").combobox("setValue", anaestConsent.operSchedule.SourceType);
    }
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
    $("#PlanOperationDesc").text(operApplication.PlanOperInfo);
    $("#PrevDiagnosisDesc").text(operApplication.PrevDiagnosisDesc);
    $("#PrevAnaMethodDesc").text(operApplication.PrevAnaMethodDesc);
	$("#ASAClass").combobox('setValue',operApplication.ASAClass)
	
}

function print() {
    var lodop = getLodop();
    createPrintOnePage(lodop, anaestConsent.operSchedule);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();

}

function printNoData() {
    var lodop = getLodop();
    createPrintOnePage(lodop, anaestConsent.operSchedule, true);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();

}

function createPrintOnePage(lodop, operSchedule, nodata) {
    lodop.PRINT_INIT("PreAnaVisit" + operSchedule.RowId);
    var prtConfig = sheetPrintConfig,
        logoMargin = prtConfig.logo.margin,
        logoSize = prtConfig.logo.size,
        titleFont = prtConfig.title.font,
        titleSize = prtConfig.title.size,
        titleMargin = prtConfig.title.margin,
        contentSize = prtConfig.content.size,
        contentFont = prtConfig.content.font;
    lodop.SET_PRINT_PAGESIZE(prtConfig.paper.direction, 0, 0, prtConfig.paper.name);
    lodop.SET_PRINT_STYLE("FontSize", contentFont.size);
    lodop.SET_PRINT_STYLE("FontName", contentFont.name);

    // lodop.ADD_PRINT_IMAGE(logoMargin.top,logoMargin.left,logoSize.width,logoSize.height,"<img src='"+prtConfig.logo.imgSrc+"'>");
    // lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
    // lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

    // var startPos = {
    //     x: prtConfig.paper.margin.left,
    //     y: logoMargin.top + logoSize.height + logoMargin.bottom
    // };

    var startPos = {
        x: prtConfig.paper.margin.left,
        y: logoMargin.top
    };


    //lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 620, 30, "东华标准版数字化医院");
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 620, 30, session.ExtHospDesc || "");
    lodop.SET_PRINT_STYLEA(0, "FontName", "宋体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Bold",1);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);

    startPos.y += titleSize.height;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 620, 30, "术前麻醉访视记录");
    lodop.SET_PRINT_STYLEA(0, "FontName", "宋体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Bold",1);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

    var linePaddingTop = 16,
        linePaddingRight = 5,
        textMarginLeft = prtConfig.paper.margin.left,
        areaWidth = 700;
    var width = 50,
        height = 24;
    startPos.y += titleSize.height;

    lodop.ADD_PRINT_RECT(startPos.y + 14, startPos.x - 10, areaWidth, 106, 0, 1);
    width = 35;
    startPos.x = textMarginLeft;
    startPos.y += height;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "姓名");
    startPos.x += width;
    width = 70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, (nodata === true) ? "" : operSchedule.PatName);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "性别");
    startPos.x += width;
    width = 30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, (nodata === true) ? "" : operSchedule.PatGender);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "年龄");
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, (nodata === true) ? "" : operSchedule.PatAge);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "科室");
    startPos.x += width;
    width = 110;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, (nodata === true) ? "" : operSchedule.PatDeptDesc);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "床号");
    startPos.x += width;
    width = 30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, (nodata === true) ? "" : operSchedule.PatBedCode);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "住院号");
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, (nodata === true) ? "" : operSchedule.MedcareNo);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "登记号");
    startPos.x += width;
    width = 85;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width + 20, 15, (nodata === true) ? "" : operSchedule.RegNo);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    var padding = {
        top: 8,
        left: 5
    }
    startPos.x = textMarginLeft;
    startPos.y += height;
    width = 65;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "术前诊断");

    startPos.x += width;
    width = 200;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, (nodata === true) ? "" : operSchedule.PrevDiagnosisDesc);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 65;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "拟施手术");

    startPos.x += width;
    width = 360;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, (nodata === true) ? "" : operSchedule.PlanOperDesc);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x = textMarginLeft;
    startPos.y += height;
    width = 65;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "拟施麻醉");

    startPos.x += width;
    width = 200;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, (nodata === true) ? "" : operSchedule.PrevAnaMethodDesc);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 55;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 20, "ASA分级");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#ASAClass").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#SourceType").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 20, "禁食");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#FullFeeding").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "身高");
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PatHeight").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "cm");




    startPos.x = textMarginLeft;
    startPos.y += height;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "体重");
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PatWeight").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "kg");

    startPos.x += width;
    width = 20;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "BP");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#BloodPressure").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 45;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "mmHg");

    startPos.x += width;
    width = 15;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "R");
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#Respiration").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "次/分");

    startPos.x += width;
    width = 15;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "P");
    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#Pulse").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "次/分");

    startPos.x += width;
    width = 15;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "T");
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#Temperature").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 20;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "℃");

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_HTM(startPos.y, startPos.x, width, 20, "<span style='font-size:13px'>SpO<sub>2</sub></span>");
    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#SPO2").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 25;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "%");

    startPos.x += width;
    width = 30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "MET");
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#MET").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x += width;
    // width = 35;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "其它");
    // startPos.x += width;
    // width = 420;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 30, $("#OtherVitalSign").val());
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x = textMarginLeft;
    // startPos.y += height+10;
    // lodop.ADD_PRINT_RECT(startPos.y,startPos.x-10,areaWidth,24,0,1);

    // width=80;
    // lodop.ADD_PRINT_TEXT(startPos.y+5, startPos.x, width, 20, "系统情况");
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");

    // startPos.x+=250;
    // lodop.ADD_PRINT_TEXT(startPos.y+5, startPos.x, width, 20, "现在情况");
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");

    // startPos.x+=250;
    // width=160;
    // lodop.ADD_PRINT_TEXT(startPos.y+5, startPos.x, width, 20, "过去或其他情况");
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");

    startPos.x = textMarginLeft;
    startPos.y += 24;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x - 10, areaWidth, 308, 0, 1);
    var nextRectY = startPos.y + 308;

    startPos.x = textMarginLeft;
    startPos.y += 10;
    var rowTitleWidth = 180,
        rowTitleMargin = 10;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "心血管疾病:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;

    var checkBoxValue = $("#Cardiovascular").val(),
        compareValue = "无",
        emptyValue = "";
    var checkBoxSize = { width: 12, height: 12, padding: 5, margin: 10 },
        textSize = { width: 15, height: 15, padding: 3 };
    var yesnoWidth = checkBoxSize.width * 2 + checkBoxSize.padding + textSize.width * 2 + checkBoxSize.margin + rowTitleMargin,
        titleYesNoWidth = rowTitleWidth + yesnoWidth;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "有";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "胸痛";
    checkBoxValue = $("#CardiovascularCurrent").val();
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "心悸";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "瓣膜病变";
    textSize.width = 70;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "杂音";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    var otherConditionTitleWidth = 110,
        lineWidth = 160,
        otherConditionText = "过去或其他情况";
    var otherStartPos = { x: startPos.x, y: startPos.y };
    var startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#CardiovascularOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + lineWidth - linePaddingRight, 0, 1);

    startPos.x = textMarginLeft;
    startPos.y += height;
    startPos.x += titleYesNoWidth;
    compareValue = "高血压";
    checkBoxValue = $("#CardiovascularCurrent").val();
    textSize.width = 50;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "心梗";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "易疲劳";
    textSize.width = 50;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "气紧";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "呼吸疾病:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#LungResp").val();
    compareValue = "无";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "有";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "COPD";
    checkBoxValue = $("#LungRespCurrent").val();
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "肺炎";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "气管炎";
    textSize.width = 50;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "哮喘";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    var startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#LungRespOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.x = textMarginLeft;
    startPos.y += height;
    startPos.x += titleYesNoWidth;
    textSize.width = 70;
    compareValue = "皮质激素";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "TB";
    textSize.width = 30;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });


    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "泌尿疾病:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#Genitourinary").val();
    compareValue = "无";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "有";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "尿毒症";
    checkBoxValue = $("#GenitourinaryCurrent").val();
    textSize.width = 50;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "血尿";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "肾功不全";
    textSize.width = 70;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#GenitourinaryOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "消化疾病:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#LGS").val();
    compareValue = "无";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "有";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "肝病";
    checkBoxValue = $("#LGSCurrent").val();
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "反流";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "胃潴留";
    textSize.width = 50;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "溃疡";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#LGSOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "神经疾病:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#Nervous").val();
    compareValue = "无";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "有";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "中风";
    checkBoxValue = $("#NervousCurrent").val();
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "抽搐";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "神经肌肉病变";
    textSize.width = 100;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#NervousOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "血液疾病:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#Blood").val();
    compareValue = "无";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "有";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    checkBoxValue = $("#BloodCurrent").val();
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, lineWidth, 15, checkBoxValue);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, otherStartPos.x - checkBoxSize.margin, 0, 1);

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#BloodOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "内分泌/代谢疾病:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#Endocrine").val();
    compareValue = "无";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "有";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "糖尿";
    checkBoxValue = $("#EndocrineCurrent").val();
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "甲亢/低";
    textSize.width = 60;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "胰岛素";
    textSize.width = 50;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "皮质";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#EndocrineOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "肌肉疾病:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#Muscle").val();
    compareValue = "无";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "有";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "重症肌无力";
    checkBoxValue = $("#MuscleCurrent").val();
    textSize.width = 80;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "瘫痪";
    textSize.width = 60;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#MuscleOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "精神疾病:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#Spirit").val();
    compareValue = "无";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "有";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "精神分裂症";
    checkBoxValue = $("#SpiritCurrent").val();
    textSize.width = 80;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "抑郁症";
    textSize.width = 50;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#SpiritOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "怀孕:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#Pregnant").val();
    compareValue = "无";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "有";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 20, "绝经:");

    startPos.x += width;
    checkBoxValue = $("#Knot").val();
    compareValue = "否";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "是";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    checkBoxValue = $("#LastMenstruationDT").datetimebox("getValue");
    textSize.width = 70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, textSize.width, 15, "末次月经");
    startPos.x += textSize.width;

    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, 100, 15, checkBoxValue);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + 100, 0, 1);

    // startPosX=otherStartPos.x;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#PregnantOther").val());
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX+ lineWidth - linePaddingRight, 0, 1);

    startPos.x = textMarginLeft;
    startPos.y = nextRectY;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x - 10, areaWidth, 300, 0, 1);
    nextRectY = startPos.y + 300;

    startPos.y += 10;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x - 20, rowTitleWidth + 20, 20, "吸烟,嗜酒,药物成瘾:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#SSDD").val();
    compareValue = "否";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "是";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "吸烟";
    checkBoxValue = $("#SSDDCurrent").val();
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + textSize.width;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, 30, 15, $("#SmokingCount").numberbox("getValue"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + 30, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 30, 50, 15, "支/天");

    startPos.x += 70 + checkBoxSize.padding;
    compareValue = "嗜酒";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "药物成瘾";
    textSize.width = 70;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#SSDDOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x - 20, rowTitleWidth + 20, 20, "过敏史:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#AllergyHistory").val();
    compareValue = "否";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "是";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    var currentPosX = startPos.x;
    compareValue = "药物过敏";
    checkBoxValue = $("#AllergyHistoryCurrent").val();
    textSize.width = 70;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + textSize.width;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, 120, 15, $("#AllergyDrug").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + 120, 0, 1);

    startPos.x += 130;
    compareValue = "食物过敏";
    textSize.width = 70;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });
    startPos.x += checkBoxSize.width + textSize.width;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, 120, 15, $("#AllergyFood").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + 120, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "麻醉手术史:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#AnaHistory").val();
    compareValue = "否";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "是";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "插管困难";
    checkBoxValue = $("#AnaHistoryCurrent").val();
    textSize.width = 70;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "恶性高热";
    textSize.width = 80;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#AnaHistoryOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "家族史：");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#FamilyHistory").val();
    compareValue = "否";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "是";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
	lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, lineWidth, 15, $("#FamilyHistoryCurrent").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, otherStartPos.x - checkBoxSize.margin, 0, 1);

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#FamilyHistoryOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "现在用特殊药物:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#SpecialDrug").val();
    compareValue = "否";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "是";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    checkBoxValue = $("#SpecialDrugCurrent").val();
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, lineWidth, 15, checkBoxValue);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, otherStartPos.x - checkBoxSize.margin, 0, 1);

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#SpecialDrugOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "全身情况好:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#BodyCondition").val();
    compareValue = "否";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "是";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    checkBoxValue = $("#BodyConditionCurrent").val();
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, lineWidth, 15, checkBoxValue);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, otherStartPos.x - checkBoxSize.margin, 0, 1);

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#BodyConditionOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "气道是否通畅:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#AirwayPatency").val();
    compareValue = "否";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "是";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "张口度";
    checkBoxValue = $("#AirwayPatencyCurrent").val();
    textSize.width = 60;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + textSize.width;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, 30, 15, $("#MouseOpenDegree").numberbox("getValue"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + 30, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 30, 50, 15, "指");

    var startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#AirwayPatencyOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "牙齿是否正常:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#Tooth").val();
    compareValue = "否";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "是";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "松动";
    checkBoxValue = $("#ToothCurrent").val();
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "缺失";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "戴冠";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#ToothOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "麻醉穿刺部位是否正常:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#AnPunctureSite").val();
    compareValue = "否";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "是";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    compareValue = "感染";
    checkBoxValue = $("#AnPunctureSiteCurrent").val();
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "畸形";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "外伤";
    textSize.width = 40;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#AnPunctureSiteOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "胸部X片是否正常:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#XRayPicture").val();
    compareValue = "否";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "是";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    checkBoxValue = $("#XRayPictureCurrent").val();
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, lineWidth, 15, checkBoxValue);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, otherStartPos.x - checkBoxSize.margin, 0, 1);

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#XRayPictureOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "心电图是否正常:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);
    startPos.x += rowTitleWidth + rowTitleMargin;
    checkBoxValue = $("#ECG").val();
    compareValue = "否";
    textSize.width = 15;
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.padding + textSize.width;
    compareValue = "是";
    drawCheckBoxAndValue(lodop, {
        startPos: {
            x: startPos.x,
            y: startPos.y
        },
        checked: (checkBoxValue.indexOf(compareValue) > -1),
        text: compareValue,
        textSize: textSize,
        emptyValue: emptyValue
    });

    startPos.x += checkBoxSize.width + checkBoxSize.margin + textSize.width;
    checkBoxValue = $("#ECGCurrent").val();
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, lineWidth, 15, checkBoxValue);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, otherStartPos.x - checkBoxSize.margin, 0, 1);

    startPosX = otherStartPos.x;
    lodop.ADD_PRINT_TEXT(startPos.y, startPosX + padding.left, lineWidth, 15, $("#ECGOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPosX, startPos.y + linePaddingTop, startPosX + lineWidth - linePaddingRight, 0, 1);

    startPos.y += height;
    startPos.x = textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, rowTitleWidth, 20, "其他:");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);

    startPos.x += rowTitleWidth;
    checkBoxValue = $("#OtherCurrent").val();
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, lineWidth, 15, checkBoxValue);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, otherStartPos.x - checkBoxSize.margin, 0, 1);


    startPos.x = textMarginLeft;
    startPos.y = nextRectY;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x - 10, areaWidth, 92, 0, 1);
    nextRectY = startPos.y + 92;

    startPos.y += 10;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "WBC");
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#WBC").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_HTM(startPos.y, startPos.x, width, 20, "<span style='font-size:12px;'><small>X</small>10<sup>-9</sup>/L</span>");

    startPos.x += width;
    width = 30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "Hb");
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#HGB").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "g/L");

    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "HCT");
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#HCT").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "%");

    startPos.x += width;
    width = 30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "PLT");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#PLT").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_HTM(startPos.y, startPos.x, width, 20, "<span style='font-size:12px;'><small>X</small>10<sup>-9</sup>/L</span>");

    startPos.x += width;
    width = 25;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "PT");
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#PT").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "sec");






    startPos.y += height;
    startPos.x = textMarginLeft;

    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "APTT");
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#APTT").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "sec");

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "肝功");
    startPos.x += width;
    width = 100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#GanGong").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "肾功");
    startPos.x += width;
    width = 100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#ShenGong").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "血糖");
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#GLU").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "mmol/L");

    startPos.x += width;
    width = 20;
    lodop.ADD_PRINT_HTM(startPos.y, startPos.x, width, 20, "<span style='font-size:12px;'>K<sup>+</sup></span>");
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#K").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 55;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "mmol/L");

    startPos.y += height;
    startPos.x = textMarginLeft;




    width = 25;
    lodop.ADD_PRINT_HTM(startPos.y, startPos.x, width, 20, "<span style='font-size:12px;'>Na<sup>+</sup></span>");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#Na").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "mmol/L");

    startPos.x += width;
    width = 25;
    lodop.ADD_PRINT_HTM(startPos.y, startPos.x, width, 20, "<span style='font-size:12px;'>Cl<sup>-</sup></span>");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, $("#Cl").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "mmol/L");

    startPos.y += height * 2;
    startPos.x = textMarginLeft + 200;
    width = 70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 20, "麻醉医生:");
    startPos.x += width;
    width = 150;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 20, $("#AnaDoctorSign").triggerbox("getValue"));
    //lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width + 30;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 20, "日期:");
    startPos.x += width;
    width = 150;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 20, $("#AnaDoctorSignDate").datebox("getValue"));
    //lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);


    // ======================================================================
    // 第二页
    // lodop.NEWPAGE();
    // lodop.ADD_PRINT_TEXT(30, -105, 620, 30, "厦门大学附属翔安医院");
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    // lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    // lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    // lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    // lodop.ADD_PRINT_TEXT(60, 333, 620, 30, "麻  醉  前  访  视  单");
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    // lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    // lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    // lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    // startPos.x=textMarginLeft;
    // startPos.y=80;
    // lodop.ADD_PRINT_RECT(startPos.y+14,startPos.x-10,720,212,0,1);
    // nextRectY=startPos.y+212;
    // startPos.y+=24;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "总体评估");

    // startPos.y+=height;
    // startPos.x=textMarginLeft;
    // width=100;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "麻醉风险评估");

    // startPos.x+=width;
    // width=50;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "ASA分级");
    // startPos.x+=width;
    // width=60;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#ASAClass").combobox("getText"));
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x+=width;
    // width=70;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "是否饱喂?");
    // startPos.x+=width;
    // width=60;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#FullFeeding").combobox("getText"));
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);


    // startPos.x+=width;
    // width=70;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "是否急诊");
    // startPos.x+=width;
    // width=60;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#SourceType").combobox("getText"));
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x = textMarginLeft+100;
    // startPos.y += height;
    // width=50;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "心功能");
    // startPos.x+=width;
    // width=60;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#ASAClass").combobox("getText"));
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    // startPos.x+=width;
    // width=20;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "级");

    // startPos.x+=width;
    // width=90;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "呼吸困难评级");
    // startPos.x+=width;
    // width=60;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#FullFeeding").combobox("getText"));
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    // startPos.x+=width;
    // width=20;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "级");


    // startPos.y+=height;
    // startPos.x=textMarginLeft;
    // width=100;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "麻醉评分");

    // startPos.x+=width;
    // width=40;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "Mets");
    // startPos.x+=width;
    // width=60;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#MetsScore").val());
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x+=width;
    // width=40;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "心功");
    // startPos.x+=width;
    // width=60;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#HeartFunctionScore").val());
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x+=width;
    // width=80;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "Sofar评分");
    // startPos.x+=width;
    // width=60;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#SofarScore").val());
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.y+=height;
    // startPos.x=textMarginLeft+100;
    // width=100;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "goldman评分");
    // startPos.x+=width;
    // width=60;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#GoldmanScore").val());
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x+=width;
    // width=70;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "屏气Test");
    // startPos.x+=width;
    // width=60;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PQTestScore").val());
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x+=width;
    // width=50;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "Allens");
    // startPos.x+=width;
    // width=60;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#AllensScore").val());
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.y+=height;
    // startPos.x=textMarginLeft;
    // width=130;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "目前存在的问题和建议");
    // startPos.x+=width;
    // width=500;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#Suggestion").val());
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);


    // startPos.y+=height+5;
    // startPos.x=textMarginLeft;
    // width=100;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "麻醉计划");

    // startPos.x+=width;
    // compareValue="全身麻醉";
    // checkBoxValue=$("#AnaPlan").val();
    // textSize.width=70;
    // drawCheckBoxAndValue(lodop,{
    //     startPos:{
    //         x:startPos.x,
    //         y:startPos.y
    //     },
    //     checked:(checkBoxValue.indexOf(compareValue)>-1),
    //     text:compareValue,
    //     textSize:textSize,
    //     emptyValue:emptyValue
    // });

    // startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    // compareValue="椎管内麻醉";
    // textSize.width=90;
    // drawCheckBoxAndValue(lodop,{
    //     startPos:{
    //         x:startPos.x,
    //         y:startPos.y
    //     },
    //     checked:(checkBoxValue.indexOf(compareValue)>-1),
    //     text:compareValue,
    //     textSize:textSize,
    //     emptyValue:emptyValue
    // });

    // startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    // compareValue="区域阻滞";
    // textSize.width=70;
    // drawCheckBoxAndValue(lodop,{
    //     startPos:{
    //         x:startPos.x,
    //         y:startPos.y
    //     },
    //     checked:(checkBoxValue.indexOf(compareValue)>-1),
    //     text:compareValue,
    //     textSize:textSize,
    //     emptyValue:emptyValue
    // });

    // startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    // compareValue="局部麻醉";
    // textSize.width=70;
    // drawCheckBoxAndValue(lodop,{
    //     startPos:{
    //         x:startPos.x,
    //         y:startPos.y
    //     },
    //     checked:(checkBoxValue.indexOf(compareValue)>-1),
    //     text:compareValue,
    //     textSize:textSize,
    //     emptyValue:emptyValue
    // });

    // startPos.y+=height;
    // startPos.x=textMarginLeft+100;
    // compareValue="按计划安排手术";
    // checkBoxValue=$("#AnaPlan").val();
    // textSize.width=120;
    // drawCheckBoxAndValue(lodop,{
    //     startPos:{
    //         x:startPos.x,
    //         y:startPos.y
    //     },
    //     checked:(checkBoxValue.indexOf(compareValue)>-1),
    //     text:compareValue,
    //     textSize:textSize,
    //     emptyValue:emptyValue
    // });

    // startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    // compareValue="安排当日，但需要延迟手术";
    // textSize.width=200;
    // drawCheckBoxAndValue(lodop,{
    //     startPos:{
    //         x:startPos.x,
    //         y:startPos.y
    //     },
    //     checked:(checkBoxValue.indexOf(compareValue)>-1),
    //     text:compareValue,
    //     textSize:textSize,
    //     emptyValue:emptyValue
    // });

    // startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    // compareValue="继续术前准备，另期安排手术";
    // textSize.width=200;
    // drawCheckBoxAndValue(lodop,{
    //     startPos:{
    //         x:startPos.x,
    //         y:startPos.y
    //     },
    //     checked:(checkBoxValue.indexOf(compareValue)>-1),
    //     text:compareValue,
    //     textSize:textSize,
    //     emptyValue:emptyValue
    // });


    // startPos.y=nextRectY+14;
    // startPos.x=textMarginLeft;
    // lodop.ADD_PRINT_RECT(startPos.y,startPos.x-10,720,68,0,1);

    // startPos.y+=10;
    // width=120;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "麻醉住院/主治医师:");
    // startPos.x+=width;
    // width=150;
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x+=width+230;
    // width=40;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "日期:");
    // startPos.x+=width;
    // width=100;
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.y+=height;
    // startPos.x=textMarginLeft;
    // width=120;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "实施麻醉主治医师:");
    // startPos.x+=width;
    // width=150;
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x+=width+230;
    // width=40;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 20, "日期:");
    // startPos.x+=width;
    // width=100;
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);


}

function archive() {
    var curOperSchedule = anaestConsent.operSchedule;
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