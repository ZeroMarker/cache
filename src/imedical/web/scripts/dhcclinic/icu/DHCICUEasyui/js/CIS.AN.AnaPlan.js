var page = {
    OperSchedule: null
};
$(document).ready(function() {
    initPage();
    operDataManager.initFormData(loadPatInfo);
    operDataManager.setCheckChange();
    //signCommon.loadSignature();
    SignTool.loadSignature(function(){
        return operDataManager.getOperDatas();
    });
});

function initPage() {
    dhccl.parseDateFormat();
    dhccl.parseDateTimeFormat();
    $("#dataForm").form("clear");
    //loadApplicationData();
    setTestData();
    //loadOperDatas();

    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
        }
    });

    $("#btnPrint").linkbutton({
        onClick: printPreAnesthetic
    });

    $("#btnPrintView").linkbutton({
        onClick: printPreAnestheticvisit
    });

    $("#btnGetPreMethod").linkbutton({
        onClick: loadOperDatas
    });

    $("#btnRefresh").linkbutton({
        onClick: function() {
            window.location.reload();
        }
    });

    $("#btnAnaDoctorSign").linkbutton({
        onClick: function() {
            var dataIntegrity = operDataManager.isDataIntegrity(".operdata");
            if (dataIntegrity === false) {
                $.messager.alert("提示", "数据不完整，不能签名。", "warning");
                return;
            }
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

function getOperDatas() {
    var operDatas = new Array(),
        opsId = dhccl.getQueryString("opsId"),
        moduleId = dhccl.getQueryString("moduleId");

    // 病人身高和体重，保存在手术明细表中
    var patHeight = $("#PatHeight").val(),
        patWeight = $("#PatWeight").val();
    operDatas.push({
        RowId: opsId,
        PatHeight: patHeight,
        PatWeight: patWeight,
        ClassName: ANCLS.Model.OperSchedule
    });

    // 其他数据保存在手术数据表中
    $(".form-item").each(function() {
        var id = $(this).attr("id"),
            selector = "." + id,
            dataValue = "",
            splitChar = ",";
        if ($(selector).length > 0) {
            $(selector).each(function() {
                if (($(this)[0].type == "checkbox" || $(this)[0].type == "radio") && $(this).prop("checked") == true) {
                    if (dataValue != "") {
                        dataValue += splitChar
                    }
                    dataValue += $(this).val();
                }
            });
            $(selector).val(dataValue);
        } else {
            if ($(this).hasClass("textbox")) {
                dataValue = $(this).val();
            } else if ($(this).hasClass("hisui-numberbox")) {
                dataValue = $(this).numberbox("getValue");
            } else if ($(this).hasClass("hisui-combobox")) {
                var options = $(this).combobox("options");
                if (options.multiple == true) {
                    var dataValueArray = $(this).combobox("getValues");
                    dataValue = dataValueArray.toString();
                } else {
                    dataValue = $(this).combobox("getValue");
                }

            } else if ($(this)[0].type == "checkbox") {
                if ($(this).prop("checked") == true) {
                    dataValue = $(this).val();
                } else {
                    dataValue = "";
                }
            } else if ($(this).hasClass("hisui-datebox")) {
                dataValue = $(this).datebox("getValue");
            } else {
                dataValue = $(this).val();
            }
        }
        if ($(this).attr("data-rowid") != "" || dataValue != "") {
            operDatas.push({
                RowId: $(this).attr("data-rowid"),
                RecordSheet: session.RecordSheetID,
                DataItem: id,
                DataValue: dataValue,
                UpdateUserID: session.UserID,
                DataModule: moduleId,
                ClassName: ANCLS.Model.OperData
            });
        }

    });
    return operDatas;
}

/*
function loadApplicationData() {
    var opsId = dhccl.getQueryString("opsId"),
        moduleId = dhccl.getQueryString("moduleId");
    var operApplicationInfo = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperSchedule,
        QueryName: "FindOperScheduleList",
        Arg1: "",
        Arg2: "",
        Arg3: "",
        Arg4: opsId,
        ArgCnt: 4
    }, "json");
    var patient = operApplicationInfo[0];
    if (patient) {
        $.each($("#patientInfo").find(".form-item"), function(index, item) {
            var field = $(item).attr('id');
            $(item).text(patient[field] || '');
        });
    }
}*/

/**
 * 加载病人信息
 * @param {*} appData 
 */
function loadPatInfo(appData) {
    if (!appData) return;
    page.OperSchedule = appData;
    $.each($("#patientInfo").find(".form-item"), function(index, item) {
        var field = $(item).attr('id');
        $(item).text(appData[field] || '');
    });
    var WSQdefaultValue = "维持术中生命体征平稳。";
    if ($("#OpdateProblemsAndSolutions").val() == "") {
        $("#OpdateProblemsAndSolutions").val(WSQdefaultValue);
    }

    //loadOperDatas(); //标准版暂时先不考虑多个表单信息联动的处理
}

function loadOperDatas() {
    var opsId = dhccl.getQueryString("opsId");
    var moduleCode = "PreAnaVisit";
    //moduleCode = dhccl.getQueryString("moduleCode");
    var operDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperData,
        QueryName: "FindOperDataPlan",
        Arg1: opsId,
        ArgCnt: 1
    }, "json");

    if (!operDatas || operDatas.length <= 0) return;
    $.each(operDatas, function(index, operData) {
        if (!operData.DataItem || operData.DataItem === "") return;
        if ($("input[data-formitem='" + "Plan" + operData.DataItem + "']").length > 0) {
            setAnaMethodPlan(operData);
        } else {
            operDataManager.setControlValue($("#Plan" + operData.DataItem), operData.DataValue);
        }
        $("#" + operData.DataItem).attr("data-rowId", operData.RowId);
        $("#" + operData.DataItem).attr("data-value", operData.DataValue);
        $("#" + operData.DataItem).attr("data-score", operData.DataScore ? operData.DataScore : "");
    });
}


function setAnaMethodPlan(operData) {
    if (!operData || !operData.DataItem || operData.DataItem === "") return;
    var idSelector = "#Plan" + operData.DataItem;
    $(idSelector).val(operData.DataValue);
    var checkSelector = "input[data-formitem='" + "Plan" + operData.DataItem + "']";
    if ($(idSelector).length <= 0 || $(checkSelector).length <= 0) return;
    var compareValue = "," + operData.DataValue + ",";
    $(checkSelector).each(function(index, item) {
        var curLabel = $(this).attr("label");
        if (!curLabel || curLabel === "") {
            curLabel = $(this).attr("value");
        }
        var curValue = "," + curLabel + ",";
        var checked = compareValue.indexOf(curValue) >= 0;
        if ($(this).hasClass(Controls.CheckBox)) {
            $(this).checkbox("setValue", checked);
            $(this).checkbox("options").checked = checked;
        } else if ($(this).hasClass(Controls.Radio)) {
            $(this).radio("setValue", checked);
            $(this).radio("options").checked = checked;
        }
    });
}

function setTestData() {
    //$.ajaxSettings.async = false;
    $.post(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Test,
        QueryName: "FindLastestTestResult",
        Arg1: dhccl.getQueryString("EpisodeID"),
        ArgCnt: 1
    }, function(data) {
        if (data && data.length > 0) {
            $.each(data, function(index, dataItem) {
                var selector = "#" + dataItem.DataField;
                if ($(selector).hasClass("hisui-combobox")) {
                    $(selector).combobox("setValue", dataItem.Result);
                } else if ($(selector).hasClass("textbox")) {
                    //$(selector).textbox("setValue", dataItem.Result);
                    $(selector).val(dataItem.Result);
                    if (dataItem.IsNormal != "Y") {

                        $(selector).textbox("textbox").css("color", "red");
                    }
                } else if ($(selector).hasClass("hisui-numberspinner")) {
                    $(selector).numberspinner("setValue", dataItem.Result);
                } else {
                    $(selector).val(dataItem.Result);
                }
            });
        }
    }, "json");
    //$.ajaxSettings.async = true;
}

function printPreAnestheticvisit() {
    var lodop = getLodop();
    drawPreAnestheticvisitPage(lodop);
    //lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    //lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
    //lodop.SET_PREVIEW_WINDOW(1, 0, 0, 0, 0, "");
    lodop.PREVIEW();
    //lodop.PRINT();
    //$.messager.popover({ msg: "打印完成！！", type: "success", timeout: 2000 });
}

function printPreAnesthetic() {
    //var testMath=Math.pow(Math.E,1);
    //alert(testMath);
    //var testMath=Math.exp
    var lodop = getLodop();
    drawPreAnestheticvisitPage(lodop);
    //lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    //lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
    //lodop.SET_PREVIEW_WINDOW(1, 0, 0, 0, 0, "");
    //lodop.PREVIEW();
    lodop.PRINT();
    $.messager.popover({ msg: "打印完成！！", type: "success", timeout: 2000 });
}

function getPageData() {
    var opsId = session.OPSID;
    var operDataList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperData,
        QueryName: 'FindOperData',
        Arg1: opsId,
        Arg2: session.ModuleCode,
        ArgCnt: 2
    }, 'json', false);

    var pageData = {};
    var length = operDataList.length;
    for (var i = 0; i < length; i++) {
        pageData[operDataList[i].DataItem] = operDataList[i].DataValue;
    }

    return pageData;
}

function drawPreAnestheticvisitPage(lodop) {
    var operSchedule = page.OperSchedule;
    var pageData = getPageData();

    lodop.PRINT_INIT("创建打印麻醉计划");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    //lodop.SET_PRINT_STYLE("FontName", "微软雅黑");
    lodop.SET_PRINT_STYLE("FontSize", 9);

    //lodop.ADD_PRINT_TEXT(30, 300, 300, 30, "东华标准版医院");
    lodop.ADD_PRINT_TEXT(30, 30, 740, 30, session.ExtHospDesc || "东华标准版医院");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 15);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);

    lodop.ADD_PRINT_TEXT(60, 30, 740, 30, "麻 醉 计 划");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);

    lodop.ADD_PRINT_TEXT(110, 30, 80, 15, "姓名:");
    lodop.ADD_PRINT_LINE(125, 65, 125, 180, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 70, 170, 15, operSchedule.PatName || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    lodop.ADD_PRINT_TEXT(110, 185, 50, 15, "性别:");
    lodop.ADD_PRINT_LINE(125, 220, 125, 250, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 225, 80, 15, operSchedule.PatGender || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    lodop.ADD_PRINT_TEXT(110, 255, 50, 15, "年龄:");
    lodop.ADD_PRINT_LINE(125, 290, 125, 330, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 295, 80, 15, operSchedule.PatAge || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    lodop.ADD_PRINT_TEXT(110, 335, 80, 15, "住院号:");
    lodop.ADD_PRINT_LINE(125, 385, 125, 450, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 390, 140, 15, operSchedule.MedcareNo || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    lodop.ADD_PRINT_TEXT(110, 465, 80, 15, "ID:");
    lodop.ADD_PRINT_LINE(125, 485, 125, 570, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 490, 140, 15, operSchedule.RegNo || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色


    lodop.ADD_PRINT_TEXT(110, 580, 50, 15, "床号:");
    lodop.ADD_PRINT_LINE(125, 620, 125, 680, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 630, 80, 15, operSchedule.PatBedCode || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    lodop.ADD_PRINT_TEXT(140, 30, 80, 15, "科室:");
    lodop.ADD_PRINT_LINE(155, 65, 155, 310, 0, 1);
    lodop.ADD_PRINT_TEXT(140, 70, 230, 15, operSchedule.PatDeptDesc || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    lodop.ADD_PRINT_TEXT(140, 320, 80, 15, "拟施手术:");
    lodop.ADD_PRINT_LINE(155, 370, 155, 720, 0, 1);
    lodop.ADD_PRINT_TEXT(140, 375, 400, 15, operSchedule.OperDesc || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    //lodop.ADD_PRINT_TEXT(140, 320, 90, 15, "身份证号码:");
    //lodop.ADD_PRINT_LINE(155, 400, 155, 580, 0, 1);
    //lodop.ADD_PRINT_TEXT(140, 405, 230, 15, operSchedule.PatDeptDesc||"");

    lodop.ADD_PRINT_TEXT(180, 30, 700, 15, "患者基本信息、既往病史、相关检查、术前诊断、拟行手术、风险评估等见术前访视。");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    /*
    lodop.ADD_PRINT_TEXT(170, 30, 80, 15, "术前诊断:");
    lodop.ADD_PRINT_LINE(185, 100, 185, 700, 0, 1);
    lodop.ADD_PRINT_TEXT(170, 105, 330, 15, operSchedule.PrevDiagnosisDesc||"");

    lodop.ADD_PRINT_TEXT(200, 30, 80, 15, "拟施手术:");
    lodop.ADD_PRINT_LINE(215, 100, 215, 700, 0, 1);
    lodop.ADD_PRINT_TEXT(200, 105, 330, 15, operSchedule.OperationDesc||"");
	*/

    lodop.ADD_PRINT_TEXT(210, 30, 300, 15, "麻醉方式");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗

    var PreAnaMethodAllBodyValue = pageData["PlanPreAnaMethodAllBody"] || '';
    if (PreAnaMethodAllBodyValue == "全身麻醉") {
        DrawRectAndRight(lodop, 235, 60);
    } else {
        DrawRectAndRightNull(lodop, 235, 60);
    }
    ///lodop.ADD_PRINT_HTM(232, 60, 100, 20, '<input type="checkbox" class="PreAnaMethodAllBody" value="全身麻醉"' + CheckBoxValue("PreAnaMethodAllBody", "全身麻醉") + '>');
    lodop.ADD_PRINT_TEXT(235, 80, 100, 15, "全身麻醉")
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗

    var PreAnaMethodAllBodyYD = pageData["PlanPreAnaMethodAllBodyYD"] || "";
    if ((PreAnaMethodAllBodyYD != "") && (PreAnaMethodAllBodyYD != "无")) {
        lodop.ADD_PRINT_TEXT(235, 170, 100, 15, "诱导方法:")
        lodop.ADD_PRINT_TEXT(235, 240, 120, 15, pageData["PlanPreAnaMethodAllBodyYD"] || "");
        lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
        lodop.ADD_PRINT_LINE(250, 230, 250, 370, 0, 1);
    }
    var PreAnaMethodAllBodyGL = pageData["PlanPreAnaMethodAllBodyGL"] || "";
    if ((PreAnaMethodAllBodyGL != "") && (PreAnaMethodAllBodyGL != "无")) {
        lodop.ADD_PRINT_TEXT(235, 400, 120, 15, "气道管理方法:")
        lodop.ADD_PRINT_TEXT(235, 490, 240, 15, pageData["PlanPreAnaMethodAllBodyGL"] || "");
        lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
        lodop.ADD_PRINT_LINE(250, 485, 250, 720, 0, 1);
    }


    ///lodop.ADD_PRINT_HTM(257, 60, 100, 20, '<input type="checkbox" class="PreIntraspinalAnesthesia" value="椎管内麻醉"' + CheckBoxValue("PreIntraspinalAnesthesia", "椎管内麻醉") + '>');

    var PreIntraspinalAnesthesiaValue = pageData["PlanPreIntraspinalAnesthesia"] || "";
    if (PreIntraspinalAnesthesiaValue == "椎管内麻醉") {
        DrawRectAndRight(lodop, 260, 60);
    } else {
        DrawRectAndRightNull(lodop, 260, 60);
    }
    lodop.ADD_PRINT_TEXT(260, 80, 100, 15, "椎管内麻醉")
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    var PreIntraspinalAnesthesia = pageData["PlanPreIntraspinalAnesthesiaMZ"] || "";
    if ((PreIntraspinalAnesthesia != "无") && (PreIntraspinalAnesthesia != "")) {
        lodop.ADD_PRINT_TEXT(260, 170, 200, 15, PreIntraspinalAnesthesia)
        lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
        lodop.ADD_PRINT_LINE(275, 160, 275, 700, 0, 1);
    }

    ///lodop.ADD_PRINT_HTM(282, 60, 100, 20, '<input type="checkbox" class="NerveBlock" value="神经阻滞"' + CheckBoxValue("NerveBlock", "神经阻滞") + '>');
    var NerveBlockValue = pageData["PlanNerveBlock"] || "";
    if (NerveBlockValue == "神经阻滞") {
        DrawRectAndRight(lodop, 285, 60);
    } else {
        DrawRectAndRightNull(lodop, 285, 60);
    }
    lodop.ADD_PRINT_TEXT(285, 80, 100, 15, "神经阻滞")
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    var NerveBlock = pageData["PlanNerveBlockMZ"] || "";
    if ((NerveBlock != "无") && (NerveBlock != "")) {
        lodop.ADD_PRINT_TEXT(285, 170, 200, 15, NerveBlock)
        lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
        lodop.ADD_PRINT_LINE(300, 160, 300, 700, 0, 1);
    }

    ///lodop.ADD_PRINT_HTM(307, 60, 100, 20, '<input type="checkbox" class="PreAnaMAC" value="麻醉性监护"' + CheckBoxValue("PreAnaMAC", "麻醉性监护") + '>');

    var PreAnaMACValue = pageData["PlanPreAnaMAC"] || "";
    if (PreAnaMACValue == "麻醉性监护") {
        DrawRectAndRight(lodop, 310, 60);
    } else {
        DrawRectAndRightNull(lodop, 310, 60);
    }
    lodop.ADD_PRINT_TEXT(310, 80, 100, 15, "麻醉性监护")
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    var PreAnaMAC = pageData["PlanPreAnaMACMZ"] || "";
    if ((PreAnaMAC != "无") && (PreAnaMAC != "")) {
        lodop.ADD_PRINT_TEXT(310, 170, 200, 15, PreAnaMAC)
        lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
        lodop.ADD_PRINT_LINE(325, 160, 325, 700, 0, 1);
    }

    ///lodop.ADD_PRINT_HTM(332, 60, 100, 20, '<input type="checkbox" class="PreAanMethodOthers" value="其它"' + CheckBoxValue("PreAanMethodOthers", "其它") + '>');
    var PreAanMethodOthersValue = pageData["PlanPreAanMethodOthers"] || "";
    if (PreAanMethodOthersValue == "其它") {
        DrawRectAndRight(lodop, 335, 60);
    } else {
        DrawRectAndRightNull(lodop, 335, 60);
    }
    lodop.ADD_PRINT_TEXT(335, 80, 100, 15, "其他麻醉");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    var PreAanMethodOthers = pageData["PlanPreAanMethodOthersText"] || "";
    if (PreAnaMAC != "") {
        lodop.ADD_PRINT_TEXT(335, 170, 200, 15, PreAanMethodOthers);
        lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
        lodop.ADD_PRINT_LINE(350, 160, 350, 700, 0, 1);
    }

    lodop.ADD_PRINT_TEXT(360, 50, 100, 15, "监护项目");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.ADD_PRINT_TEXT(360, 110, 700, 15, "必备项目包括心电图、无创血压、指脉氧饱和度、体温、呼吸参数(如呼吸频率，全身麻醉下增加监测潮气量、");
    lodop.ADD_PRINT_TEXT(385, 110, 400, 15, "分钟通气量、气道压、呼末CO2分压等)；");

    lodop.ADD_PRINT_TEXT(410, 70, 100, 15, "可选");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLE("FontColor", "#0000ff"); //更换颜色

    var CustodyItemsFirstValue = pageData["CustodyItemsFirst"] || "";
    ///lodop.ADD_PRINT_HTM(407, 110, 30, 20, '<input type="checkbox" class="CustodyItemsFirst" value="连续有创血压"' + CheckBoxValue("CustodyItemsFirst", "连续有创血压") + '>');
    if (CustodyItemsFirstValue.indexOf("连续有创血压") > -1) {
        DrawRectAndRight(lodop, 410, 110);
    } else {
        DrawRectAndRightNull(lodop, 410, 110);
    }
    lodop.ADD_PRINT_TEXT(410, 130, 100, 15, "连续有创血压");

    ///lodop.ADD_PRINT_HTM(407, 225, 30, 20, '<input type="checkbox" class="CustodyItemsFirst" value="血气分析"' + CheckBoxValue("CustodyItemsFirst", "血气分析") + '>');
    if (CustodyItemsFirstValue.indexOf("血气分析") > -1) {
        DrawRectAndRight(lodop, 410, 225);
    } else {
        DrawRectAndRightNull(lodop, 410, 225);
    }
    lodop.ADD_PRINT_TEXT(410, 245, 80, 15, "血气分析");

    ///lodop.ADD_PRINT_HTM(407, 305, 30, 20, '<input type="checkbox" class="CustodyItemsFirst" value="中心静脉压"' + CheckBoxValue("CustodyItemsFirst", "中心静脉压") + '>');
    if (CustodyItemsFirstValue.indexOf("中心静脉压") > -1) {
        DrawRectAndRight(lodop, 410, 305);
    } else {
        DrawRectAndRightNull(lodop, 410, 305);
    }
    lodop.ADD_PRINT_TEXT(410, 325, 80, 15, "中心静脉压");

    ///lodop.ADD_PRINT_HTM(407, 410, 30, 20, '<input type="checkbox" class="CustodyItemsFirst" value="PiCCO监测系统"' + CheckBoxValue("CustodyItemsFirst", "PiCCO监测系统") + '>');
    if (CustodyItemsFirstValue.indexOf("PiCCO监测系统") > -1) {
        DrawRectAndRight(lodop, 410, 410);
    } else {
        DrawRectAndRightNull(lodop, 410, 410);
    }
    lodop.ADD_PRINT_TEXT(410, 430, 100, 15, "PiCCO监测系统");

    ///lodop.ADD_PRINT_HTM(407, 520, 30, 20, '<input type="checkbox" class="CustodyItemsFirst" value="肌松监测"' + CheckBoxValue("CustodyItemsFirst", "肌松监测") + '>');
    if (CustodyItemsFirstValue.indexOf("肌松监测") > -1) {
        DrawRectAndRight(lodop, 410, 520);
    } else {
        DrawRectAndRightNull(lodop, 410, 520);
    }
    lodop.ADD_PRINT_TEXT(410, 540, 80, 15, "肌松监测");

    ///lodop.ADD_PRINT_HTM(407, 600, 30, 20, '<input type="checkbox" class="CustodyItemsFirst" value="中心静脉压"' + CheckBoxValue("CustodyItemsFirst", "中心静脉压") + '>');
    ///lodop.ADD_PRINT_TEXT(410, 620, 80, 15,"中心静脉压");

    ///lodop.ADD_PRINT_HTM(432, 110, 30, 20, '<input type="checkbox" class="CustodyItemsFirst" value="经食道心脏超声"' + CheckBoxValue("CustodyItemsFirst", "经食道心脏超声") + '>');
    if (CustodyItemsFirstValue.indexOf("经食道心脏超声") > -1) {
        DrawRectAndRight(lodop, 435, 110);
    } else {
        DrawRectAndRightNull(lodop, 435, 110);
    }
    lodop.ADD_PRINT_TEXT(435, 130, 110, 15, "经食道心脏超声");

    var CustodyItemsSecondValue = pageData["CustodyItemsSecond"] || "";

    ///lodop.ADD_PRINT_HTM(432, 245, 30, 20, '<input type="checkbox" class="CustodyItemsSecond" value="Vigileo-FloTrac监测系统"' + CheckBoxValue("CustodyItemsSecond", "Vigileo-FloTrac监测系统") + '>');
    if (CustodyItemsSecondValue.indexOf("FloTrac监测系统") > -1) {
        DrawRectAndRight(lodop, 435, 245);
    } else {
        DrawRectAndRightNull(lodop, 435, 245);
    }
    lodop.ADD_PRINT_TEXT(435, 265, 180, 15, "Vigileo-FloTrac监测系统");

    ///lodop.ADD_PRINT_HTM(432, 440, 30, 20, '<input type="checkbox" class="CustodyItemsSecond" value="脑电监测"' + CheckBoxValue("CustodyItemsSecond", "脑电监测") + '>');
    if (CustodyItemsSecondValue.indexOf("脑电监测") > -1) {
        DrawRectAndRight(lodop, 435, 440);
    } else {
        DrawRectAndRightNull(lodop, 435, 440);
    }
    lodop.ADD_PRINT_TEXT(435, 460, 80, 15, "脑电监测");

    //lodop.ADD_PRINT_HTM(432, 440, 30, 20, '<input type="checkbox" class="CustodyItemsSecond" value="血糖"' + CheckBoxValue("CustodyItemsSecond", "血糖") + '>');
    //lodop.ADD_PRINT_TEXT(435, 460, 80, 15,"血糖");

    //lodop.ADD_PRINT_HTM(432, 520, 30, 20, '<input type="checkbox" class="CustodyItemsSecond" value="连续心输出量监测"' + CheckBoxValue("CustodyItemsSecond", "连续心输出量监测") + '>');
    //lodop.ADD_PRINT_TEXT(435, 540, 140, 15,"连续心输出量监测");

    ///lodop.ADD_PRINT_HTM(457, 110, 30, 20, '<input type="checkbox" class="CustodyItemsThird" value="其他项目"' + CheckBoxValue("CustodyItemsThird", "其他项目") + '>');
    var CustodyItemsThirdValue = pageData["CustodyItemsThird"] || "";
    if (CustodyItemsThirdValue.indexOf("其他项目") > -1) {
        DrawRectAndRight(lodop, 460, 110);
    } else {
        DrawRectAndRightNull(lodop, 460, 110);
    }
    lodop.ADD_PRINT_TEXT(460, 130, 60, 15, "其他");

    lodop.ADD_PRINT_TEXT(460, 170, 600, 15, pageData["CustodyItemsThirdText"] || "");
    lodop.SET_PRINT_STYLE("FontColor", "#000000"); //更换颜色

    lodop.ADD_PRINT_LINE(475, 165, 475, 700, 0, 1);

    lodop.ADD_PRINT_TEXT(485, 50, 100, 15, "特殊操作");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    var SpecialOperations = pageData["SpecialOperations"] || "";
    var SpecialOperationsOthersText = pageData["SpecialOperationsOthersText"] || "";
    if (SpecialOperationsOthersText != "") {
        SpecialOperationsOthersText = "," + SpecialOperationsOthersText;
    }
    lodop.ADD_PRINT_TEXT(485, 110, 600, 15, SpecialOperations + SpecialOperationsOthersText);
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    lodop.ADD_PRINT_LINE(500, 105, 500, 700, 0, 1);

    lodop.ADD_PRINT_TEXT(510, 40, 100, 15, "麻醉前用药");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    //lodop.ADD_PRINT_TEXT(510, 120, 700, 15, "长托宁、阿托品、东莨菪碱、地西泮、咪达唑仑");
    var preUsedAnaDrugsValue = pageData["preUsedAnaDrugs"] || "";
    if (preUsedAnaDrugsValue.indexOf("长托宁") > -1) {
        DrawRectAndRight(lodop, 510, 110);
    } else {
        DrawRectAndRightNull(lodop, 510, 110);
    }
    lodop.ADD_PRINT_TEXT(510, 130, 50, 15, "长托宁");

    if (preUsedAnaDrugsValue.indexOf("阿托品") > -1) {
        DrawRectAndRight(lodop, 510, 190);
    } else {
        DrawRectAndRightNull(lodop, 510, 190);
    }
    lodop.ADD_PRINT_TEXT(510, 210, 50, 15, "阿托品");

    if (preUsedAnaDrugsValue.indexOf("东莨菪碱") > -1) {
        DrawRectAndRight(lodop, 510, 270);
    } else {
        DrawRectAndRightNull(lodop, 510, 270);
    }
    lodop.ADD_PRINT_TEXT(510, 290, 70, 15, "东莨菪碱");

    if (preUsedAnaDrugsValue.indexOf("地西泮") > -1) {
        DrawRectAndRight(lodop, 510, 370);
    } else {
        DrawRectAndRightNull(lodop, 510, 370);
    }
    lodop.ADD_PRINT_TEXT(510, 390, 50, 15, "地西泮");

    if (preUsedAnaDrugsValue.indexOf("咪达唑仑") > -1) {
        DrawRectAndRight(lodop, 510, 450);
    } else {
        DrawRectAndRightNull(lodop, 510, 450);
    }
    lodop.ADD_PRINT_TEXT(510, 470, 70, 15, "咪达唑仑");

    var preUsedAnaDrugsSecondValue = pageData["preUsedAnaDrugsSecond"] || "";
    if (preUsedAnaDrugsSecondValue.indexOf("其他麻药") > -1) {
        DrawRectAndRight(lodop, 510, 550);
    } else {
        DrawRectAndRightNull(lodop, 510, 550);
    }
    lodop.ADD_PRINT_TEXT(510, 570, 70, 15, "其他麻药");
    var preUsedAnaDrugsSecondTextValue = pageData["preUsedAnaDrugsSecondText"] || "";
    lodop.ADD_PRINT_TEXT(510, 650, "100%", 15, preUsedAnaDrugsSecondTextValue);


    lodop.ADD_PRINT_TEXT(535, 50, 100, 15, "麻醉器械");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗

    lodop.ADD_PRINT_TEXT(535, 120, 700, 15, "必备器械：麻醉机、多功能监护仪、螺纹管、面罩、吸痰用具、口咽通气道、鼻咽通气道、直视喉镜、可视喉镜、");
    lodop.ADD_PRINT_TEXT(560, 120, 700, 15, "气管导管、喉罩、静脉注射泵、输液管路、动静脉穿刺针、压力测量、传感器、充气加温毯与加温机");
    //lodop.ADD_PRINT_TEXT(585, 110, 160, 15,"充气加温毯与加温机");

    lodop.ADD_PRINT_TEXT(585, 70, 60, 15, "可选");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLE("FontColor", "#0000ff"); //更换颜色
    var CustodyMachinesFirstValue = pageData["CustodyMachinesFirst"] || "";
    ///lodop.ADD_PRINT_HTM(582, 110, 30, 20, '<input type="checkbox" class="CustodyMachinesFirst" value="椎管内穿刺包"' + CheckBoxValue("CustodyMachinesFirst", "椎管内穿刺包") + '>');
    if (CustodyMachinesFirstValue.indexOf("椎管内穿刺包") > -1) {
        DrawRectAndRight(lodop, 585, 110);
    } else {
        DrawRectAndRightNull(lodop, 585, 110);
    }
    lodop.ADD_PRINT_TEXT(585, 130, 100, 15, "椎管内穿刺包");

    ///lodop.ADD_PRINT_HTM(582, 230, 30, 20, '<input type="checkbox" class="CustodyMachinesFirst" value="支气管镜"' + CheckBoxValue("CustodyMachinesFirst", "支气管镜") + '>');
    if (CustodyMachinesFirstValue.indexOf("支气管镜") > -1) {
        DrawRectAndRight(lodop, 585, 230);
    } else {
        DrawRectAndRightNull(lodop, 585, 230);
    }
    lodop.ADD_PRINT_TEXT(585, 250, 80, 15, "支气管镜");

    ///lodop.ADD_PRINT_HTM(582, 330, 30, 20, '<input type="checkbox" class="CustodyMachinesFirst" value="双腔气管导管"' + CheckBoxValue("CustodyMachinesFirst", "双腔气管导管") + '>');
    if (CustodyMachinesFirstValue.indexOf("双腔气管导管") > -1) {
        DrawRectAndRight(lodop, 585, 330);
    } else {
        DrawRectAndRightNull(lodop, 585, 330);
    }
    lodop.ADD_PRINT_TEXT(585, 350, 100, 15, "双腔气管导管");

    ///lodop.ADD_PRINT_HTM(582, 430, 30, 20, '<input type="checkbox" class="CustodyMachinesFirst" value="超声机"' + CheckBoxValue("CustodyMachinesFirst", "超声机") + '>');
    if (CustodyMachinesFirstValue.indexOf("超声机") > -1) {
        DrawRectAndRight(lodop, 585, 430);
    } else {
        DrawRectAndRightNull(lodop, 585, 430);
    }
    lodop.ADD_PRINT_TEXT(585, 450, 100, 15, "超声机");

    ///lodop.ADD_PRINT_HTM(607, 110, 30, 20, '<input type="checkbox" class="CustodyMachinesFirst" value="神经阻滞套件"' + CheckBoxValue("CustodyMachinesFirst", "神经阻滞套件") + '>');
    if (CustodyMachinesFirstValue.indexOf("神经阻滞套件") > -1) {
        DrawRectAndRight(lodop, 610, 110);
    } else {
        DrawRectAndRightNull(lodop, 610, 110);
    }
    lodop.ADD_PRINT_TEXT(610, 130, 100, 15, "神经阻滞套件");

    ///lodop.ADD_PRINT_HTM(607, 230, 30, 20, '<input type="checkbox" class="CustodyMachinesFirst" value="神经刺激仪"' + CheckBoxValue("CustodyMachinesFirst", "神经刺激仪") + '>');
    if (CustodyMachinesFirstValue.indexOf("神经刺激仪") > -1) {
        DrawRectAndRight(lodop, 610, 230);
    } else {
        DrawRectAndRightNull(lodop, 610, 230);
    }
    lodop.ADD_PRINT_TEXT(610, 250, 90, 15, "神经刺激仪");

    var CustodyMachinesSecondValue = pageData["CustodyMachinesSecond"] || "";
    ///lodop.ADD_PRINT_HTM(607, 330, 30, 20, '<input type="checkbox" class="CustodyMachinesSecond" value="气管插管钳"' + CheckBoxValue("CustodyMachinesSecond", "气管插管钳") + '>');
    if (CustodyMachinesSecondValue.indexOf("气管插管钳") > -1) {
        DrawRectAndRight(lodop, 610, 330);
    } else {
        DrawRectAndRightNull(lodop, 610, 330);
    }
    lodop.ADD_PRINT_TEXT(610, 350, 90, 15, "气管插管钳");

    ///lodop.ADD_PRINT_HTM(607, 430, 30, 20, '<input type="checkbox" class="CustodyMachinesSecond" value="困难喉镜"' + CheckBoxValue("CustodyMachinesSecond", "困难喉镜") + '>');
    if (CustodyMachinesSecondValue.indexOf("困难喉镜") > -1) {
        DrawRectAndRight(lodop, 610, 430);
    } else {
        DrawRectAndRightNull(lodop, 610, 430);
    }
    lodop.ADD_PRINT_TEXT(610, 450, 90, 15, "困难喉镜");


    ///lodop.ADD_PRINT_HTM(582, 520, 30, 20, '<input type="checkbox" class="CustodyMachinesSecond" value="肌松监测仪"' + CheckBoxValue("CustodyMachinesSecond", "肌松监测仪") + '>');
    if (CustodyMachinesSecondValue.indexOf("肌松监测仪") > -1) {
        DrawRectAndRight(lodop, 585, 520);
    } else {
        DrawRectAndRightNull(lodop, 585, 520);
    }
    lodop.ADD_PRINT_TEXT(585, 540, 100, 15, "肌松监测仪");

    ///lodop.ADD_PRINT_HTM(607, 520, 30, 20, '<input type="checkbox" class="CustodyMachinesSecond" value="支气管堵塞导管"' + CheckBoxValue("CustodyMachinesSecond", "支气管堵塞导管") + '>');
    lodop.ADD_PRINT_TEXT(610, 540, 130, 15, "支气管堵塞导管");

    ///lodop.ADD_PRINT_HTM(582, 650, 30, 20, '<input type="checkbox" class="CustodyMachinesFirst" value="镇痛泵"' + CheckBoxValue("CustodyMachinesFirst", "镇痛泵") + '>');
    if (CustodyMachinesFirstValue.indexOf("镇痛泵") > -1) {
        DrawRectAndRight(lodop, 585, 650);
    } else {
        DrawRectAndRightNull(lodop, 585, 650);
    }
    lodop.ADD_PRINT_TEXT(585, 670, 110, 15, "镇痛泵");

    ///lodop.ADD_PRINT_HTM(632, 110, 30, 20, '<input type="checkbox" class="CustodyMachinesSecond" value="高流量温液管路"' + CheckBoxValue("CustodyMachinesSecond", "高流量温液管路") + '>');
    if (CustodyMachinesSecondValue.indexOf("高流量温液管路") > -1) {
        DrawRectAndRight(lodop, 635, 110);
    } else {
        DrawRectAndRightNull(lodop, 635, 110);
    }
    lodop.ADD_PRINT_TEXT(635, 130, 110, 15, "高流量温液管路");

    ///lodop.ADD_PRINT_HTM(632, 230, 30, 20, '<input type="checkbox" class="CustodyMachinesSecond" value="自体血回收器械"' + CheckBoxValue("CustodyMachinesSecond", "自体血回收器械") + '>');
    if (CustodyMachinesSecondValue.indexOf("自体血回收器械") > -1) {
        DrawRectAndRight(lodop, 635, 230);
    } else {
        DrawRectAndRightNull(lodop, 635, 230);
    }
    lodop.ADD_PRINT_TEXT(635, 250, 110, 15, "自体血回收器械");


    var otherMachineValue = pageData["CustodyMachinesThird"] || "";
    ///lodop.ADD_PRINT_HTM(632, 370, 30, 20, '<input type="checkbox" class="CustodyMachinesThird" value="其他设备"' + CheckBoxValue("CustodyMachinesThird", "其他设备") + '>');
    if (otherMachineValue.indexOf("其他设备") > -1) {
        DrawRectAndRight(lodop, 635, 370);
    } else {
        DrawRectAndRightNull(lodop, 635, 370);
    }
    lodop.ADD_PRINT_TEXT(635, 390, 60, 15, "其他设备");
    lodop.ADD_PRINT_TEXT(635, 450, 600, 15, pageData["CustodyMachinesThirdText"] || "");
    lodop.SET_PRINT_STYLE("FontColor", "#000000"); //更换颜色
    lodop.ADD_PRINT_LINE(650, 445, 650, 720, 0, 1);

    lodop.ADD_PRINT_TEXT(655, 30, 100, 15, "麻醉药品:");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "FontSize", 12);

    lodop.ADD_PRINT_TEXT(685, 40, 100, 15, "静脉全麻药");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    //lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    lodop.ADD_PRINT_TEXT(685, 120, 700, 15, "丙泊酚、依托咪酯、咪达唑仑、右美托咪啶");

    lodop.ADD_PRINT_TEXT(710, 40, 100, 15, "吸入全麻药");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    //lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    lodop.ADD_PRINT_TEXT(710, 120, 700, 15, "七氟烷、异氟烷");

    lodop.ADD_PRINT_TEXT(735, 40, 100, 15, "局部麻醉药");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    //lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    lodop.ADD_PRINT_TEXT(735, 120, 700, 15, "利多卡因、罗哌卡因、布比卡因");

    lodop.ADD_PRINT_TEXT(760, 50, 75, 15, "镇 痛 药");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    //lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    lodop.ADD_PRINT_TEXT(760, 120, 700, 15, "芬太尼、瑞芬太尼、舒芬太尼、氢吗啡酮、布托啡诺、地佐辛、氟比洛芬、帕瑞昔布");

    lodop.ADD_PRINT_TEXT(785, 50, 75, 15, "肌 松 药");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    //lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    lodop.ADD_PRINT_TEXT(785, 120, 700, 15, "罗库溴铵、顺阿曲库铵");

    lodop.ADD_PRINT_TEXT(810, 50, 75, 15, "辅助用药");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    //lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    lodop.ADD_PRINT_TEXT(810, 120, 700, 15, "托烷司琼、长托宁、东莨菪碱、肝素、新斯的明、纳洛酮、速尿、地塞米松、甲强龙、潘妥洛克、西米替丁、");
    lodop.ADD_PRINT_TEXT(835, 120, 700, 15, "乌司他汀、氨茶碱");

    lodop.ADD_PRINT_TEXT(860, 40, 100, 15, "血管活性药");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    //lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    lodop.ADD_PRINT_TEXT(860, 120, 700, 15, "麻黄素、阿托品、多巴胺、去氧肾上腺素、肾上腺素、去甲肾上腺素、乌拉地尔、硝酸甘油、硝普钠、艾司洛尔、");
    lodop.ADD_PRINT_TEXT(885, 120, 700, 15, "胺碘酮、酚妥拉明、西地兰、多巴酚丁胺");

    lodop.ADD_PRINT_TEXT(910, 60, 75, 15, "输  液");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    //lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    lodop.ADD_PRINT_TEXT(910, 120, 700, 15, "生理盐水、林格氏液、5%葡萄糖、钠钾镁钙葡萄糖注射液、琥珀酰明胶、羟乙基淀粉");

    lodop.ADD_PRINT_TEXT(935, 50, 75, 15, "备血制品");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    //lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);

    lodop.ADD_PRINT_TEXT(935, 120, 75, 15, "红细胞");
    lodop.ADD_PRINT_LINE(950, 165, 950, 210, 0, 1);
    lodop.ADD_PRINT_TEXT(935, 170, 40, 15, pageData["BloodUsedRBC"] || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    lodop.ADD_PRINT_TEXT(935, 210, 40, 15, "U");

    lodop.ADD_PRINT_TEXT(935, 260, 75, 15, "血浆");
    lodop.ADD_PRINT_LINE(950, 290, 950, 330, 0, 1);
    lodop.ADD_PRINT_TEXT(935, 295, 40, 15, pageData["BloodUsedXJ"] || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    lodop.ADD_PRINT_TEXT(935, 330, 40, 15, "ml");


    lodop.ADD_PRINT_TEXT(935, 380, 75, 15, "冷沉淀");
    lodop.ADD_PRINT_LINE(950, 425, 950, 470, 0, 1);
    lodop.ADD_PRINT_TEXT(935, 430, 40, 15, pageData["BloodUsedLCD"] || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    lodop.ADD_PRINT_TEXT(935, 470, 40, 15, "U");

    lodop.ADD_PRINT_TEXT(935, 520, 75, 15, "血小板");
    lodop.ADD_PRINT_LINE(950, 565, 950, 610, 0, 1);
    lodop.ADD_PRINT_TEXT(935, 570, 40, 15, pageData["BloodUsedXXB"] || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    lodop.ADD_PRINT_TEXT(935, 610, 40, 15, "U");

    lodop.ADD_PRINT_TEXT(960, 50, 75, 15, "其他药品");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    //lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1);
    lodop.ADD_PRINT_LINE(975, 120, 975, 710, 0, 1);
    lodop.ADD_PRINT_TEXT(960, 120, 600, 15, pageData["OPPlanMaybeUsedDrug"] || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色

    lodop.ADD_PRINT_TEXT(985, 50, 400, 15, "镇痛泵配方：见麻醉记录。");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗

    lodop.ADD_PRINT_TEXT(1010, 30, 230, 15, "围术期可能出的问题和对策：");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    //lodop.ADD_PRINT_LINE(1000, 220, 1000, 710, 0, 1);
    lodop.ADD_PRINT_TEXT(1010, 200, 520, 60, pageData["OpdateProblemsAndSolutions"] || "");
    lodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    lodop.ADD_PRINT_TEXT(1065, 400, 300, 15, "麻醉医生签名：");
    lodop.ADD_PRINT_TEXT(1065, 510, "100%", 20, $("#AnaDoctorSign").val());
    lodop.ADD_PRINT_TEXT(1065, 600, 300, 15, "日期：");
    lodop.ADD_PRINT_TEXT(1065, 660, "100%", 20, $("#AnaDoctorSignDate").datebox("getValue"));

}

/// 画打勾选框
function DrawRectAndRight(tmplodop, tmptop, tmpleft) {
    tmplodop.ADD_PRINT_RECT(tmptop, tmpleft + 5, "3.3mm", "3.3mm", 0, 1);
    tmplodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    tmplodop.ADD_PRINT_TEXT(tmptop - 5, tmpleft, 30, 15, "√");
    tmplodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
    tmplodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    tmplodop.SET_PRINT_STYLEA(0, "FontSize", 15);
}

/// 画空白方框
function DrawRectAndRightNull(tmplodop, tmptop, tmpleft) {
    tmplodop.ADD_PRINT_RECT(tmptop, tmpleft + 5, "3.3mm", "3.3mm", 0, 1);
    tmplodop.SET_PRINT_STYLEA(0, "FontColor", "#0000ff"); //更换颜色
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