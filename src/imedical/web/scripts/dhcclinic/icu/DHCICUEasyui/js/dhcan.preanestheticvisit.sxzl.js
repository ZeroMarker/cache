$(document).ready(function() {
    initPage();
    operDataManager.initFormData(loadPatInfo);
    operDataManager.setCheckChange();
    signCommon.loadSignature();
});

function initPage() {
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
        onClick: printPreAnestheticvisit
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
    $.each($("#patientInfo").find(".form-item"), function(index, item) {
        var field = $(item).attr('id');
        $(item).text(appData[field] || '');
    });

    var signDate = $('#AnaDoctorSignDate').datebox('getValue');
    if (!signDate) {
        var operdate = new Date(appData.OperDate);
        signDate = operdate.addDays(-1).format(constant.dateFormat);
        $('#AnaDoctorSignDate').datebox('setValue', signDate);
    }
}

function loadOperDatas() {
    var opsId = dhccl.getQueryString("opsId"),
        moduleCode = dhccl.getQueryString("moduleCode");
    var operDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperData,
        QueryName: "FindOperData",
        Arg1: opsId,
        Arg2: moduleCode,
        ArgCnt: 2
    }, "json");
    if (operDatas && operDatas.length > 0) {
        $.each(operDatas, function(index, operData) {
            if (operData.DataItem && operData.DataItem != "") {
                var selector = "#" + operData.DataItem,
                    clsSelector = "." + operData.DataItem,
                    dataValue = "," + operData.DataValue + ",";
                if ($(selector).length > 0) {
                    if ($(clsSelector).length > 0) {
                        $(clsSelector).each(function() {
                            if ($(this)[0].type == "checkbox" && dataValue.indexOf("," + $(this).val() + ",") >= 0) {
                                $(this).checkbox("setValue", true);
                            }
                            if ($(this)[0].type == "radio" && dataValue.indexOf("," + $(this).val() + ",") >= 0) {
                                $(this).radio("setValue", true);
                            }
                        });
                        $(selector).val(operData.DataValue);
                    } else {
                        if ($(selector).hasClass("textbox")) {
                            //$(selector).textbox("setValue", operData.DataValue);
                            $(selector).val(operData.DataValue);
                        } else if ($(selector).hasClass("hisui-numberbox")) {
                            $(selector).numberbox("setValue", operData.DataValue);
                        } else if ($(selector).hasClass("hisui-combobox")) {
                            $(selector).combobox("setValue", operData.DataValue);
                        } else if ($(selector)[0].type == "checkbox") {
                            if (operData.DataValue == $(selector).val()) {
                                //$(selector).prop("checked", true);
                                //$(this).checkbox("check",true);
                                $(selector).checkbox("setValue", true);
                            }
                        } else if ($(selector).hasClass("hisui-datebox")) {
                            $(selector).datebox("setValue", operData.DataValue);
                        } else {
                            $(selector).val(operData.DataValue);
                        }
                    }

                    $(selector).attr("data-rowId", operData.RowId);
                }
            }
        });
    }
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
    lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();
    //lodop.PRINT();
}

function drawPreAnestheticvisitPage(lodop) {
    lodop.PRINT_INIT("创建打印术前麻醉访视记录单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontName", "微软雅黑");
    lodop.SET_PRINT_STYLE("FontSize", 10);
    lodop.ADD_PRINT_TEXT(20, 240, 300, 30, "山 西 肿 瘤 医 院");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 21); //设置字体
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_TEXT(60, 200, 400, 20, "术  前  麻  醉  访  视  记  录  单");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 18); //设置字体
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_TEXT(110, 60, 80, 15, "患者姓名");
    lodop.ADD_PRINT_LINE(125, 130, 125, 310, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 135, 230, 15, $("#PatName").text());

    lodop.ADD_PRINT_TEXT(110, 330, 40, 15, "性别");
    lodop.ADD_PRINT_LINE(125, 360, 125, 440, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 375, 80, 15, $("#PatGender").text());

    lodop.ADD_PRINT_TEXT(110, 460, 40, 15, "年龄");
    lodop.ADD_PRINT_LINE(125, 490, 125, 570, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 505, 80, 15, $("#PatAge").text());

    lodop.ADD_PRINT_TEXT(110, 590, 50, 15, "住院号");
    lodop.ADD_PRINT_LINE(125, 640, 125, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 645, 140, 15, $("#MedcareNo").text());

    lodop.ADD_PRINT_TEXT(150, 60, 80, 15, "科室名称");
    lodop.ADD_PRINT_LINE(165, 130, 165, 310, 0, 1);
    lodop.ADD_PRINT_TEXT(150, 135, 230, 15, $("#PatDeptDesc").text());

    lodop.ADD_PRINT_TEXT(150, 330, 40, 15, "床号");
    lodop.ADD_PRINT_LINE(165, 360, 165, 440, 0, 1);
    lodop.ADD_PRINT_TEXT(150, 375, 80, 15, $("#PatBedCode").text());

    lodop.ADD_PRINT_TEXT(190, 60, 80, 15, "术前诊断");
    lodop.ADD_PRINT_LINE(205, 130, 205, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(190, 135, 330, 15, $("#PrevDiagnosisDesc").text());

    lodop.ADD_PRINT_TEXT(230, 60, 80, 15, "拟施手术");
    lodop.ADD_PRINT_LINE(245, 130, 245, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(230, 135, 330, 15, $("#PlanOperationDesc").text());

    lodop.ADD_PRINT_TEXT(270, 60, 280, 15, "病人重要器官功能、疾病情况：");

    lodop.ADD_PRINT_TEXT(310, 60, 120, 15, "基本生命体征：");
    lodop.ADD_PRINT_TEXT(310, 180, 40, 15, "血压");
    lodop.ADD_PRINT_LINE(325, 210, 325, 340, 0, 1);
    lodop.ADD_PRINT_TEXT(310, 235, 120, 15, $("#BloodPressure").val());
    lodop.ADD_PRINT_TEXT(310, 340, 60, 15, "mmHg");

    lodop.ADD_PRINT_TEXT(310, 440, 40, 15, "心率");
    lodop.ADD_PRINT_LINE(325, 470, 325, 540, 0, 1);
    lodop.ADD_PRINT_TEXT(310, 475, 90, 15, $("#Pulse").val());
    lodop.ADD_PRINT_TEXT(310, 540, 60, 15, "次/分");

    lodop.ADD_PRINT_TEXT(310, 620, 40, 15, "呼吸");
    lodop.ADD_PRINT_LINE(325, 650, 325, 730, 0, 1);
    lodop.ADD_PRINT_TEXT(310, 665, 80, 15, $("#Respiration").val());
    lodop.ADD_PRINT_TEXT(310, 730, 60, 15, "次/分");

    lodop.ADD_PRINT_TEXT(350, 60, 120, 15, "神经系统：");
    lodop.ADD_PRINT_TEXT(350, 180, 40, 15, "意识");
    lodop.ADD_PRINT_LINE(365, 210, 365, 790, 0, 1);
    var value = CheckBoxValue("ConsciousnessOpt", "清醒") == 'checked' ? "清醒 " : "";
    if (!value) value = CheckBoxValue("ConsciousnessOpt", "瞌睡") == 'checked' ? "瞌睡 " : "";
    if (!value) value = CheckBoxValue("ConsciousnessOpt", "昏迷") == 'checked' ? "昏迷 " : "";
    value = value + $("#Consciousness").val();
    lodop.ADD_PRINT_TEXT(350, 225, 580, 15, value);

    lodop.ADD_PRINT_TEXT(390, 60, 120, 15, "神经系统并发症：");
    lodop.ADD_PRINT_HTM(390, 180, 80, 20, '<input type="checkbox" class="NervousSystem" value="脑出血"' + CheckBoxValue("NervousSystem", "脑出血") + '>脑出血');
    lodop.ADD_PRINT_HTM(390, 280, 80, 20, '<input type="checkbox" class="NervousSystem" value="脑梗塞"' + CheckBoxValue("NervousSystem", "脑梗塞") + '>脑梗塞');
    lodop.ADD_PRINT_HTM(390, 380, 80, 20, '<input type="checkbox" class="NervousSystem" value="癫痫"' + CheckBoxValue("NervousSystem", "癫痫") + '>癫痫');
    lodop.ADD_PRINT_TEXT(390, 480, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(405, 510, 405, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(390, 515, 270, 15, $("#AddNervousSystem").val());

    lodop.ADD_PRINT_TEXT(430, 60, 120, 15, "心血管系统：");
    lodop.ADD_PRINT_TEXT(430, 180, 90, 15, "心功能评级");
    lodop.ADD_PRINT_LINE(445, 260, 445, 340, 0, 1);
    lodop.ADD_PRINT_TEXT(430, 285, 90, 15, $("#HeartFunctionClass").val());

    lodop.ADD_PRINT_TEXT(470, 60, 140, 15, "心血管系统并发症：");
    lodop.ADD_PRINT_HTM(470, 180, 80, 20, '<input type="checkbox" class="CardiovascularSystem" value="高血压"' + CheckBoxValue("CardiovascularSystem", "高血压") + '>高血压');
    lodop.ADD_PRINT_HTM(470, 280, 80, 20, '<input type="checkbox" class="CardiovascularSystem" value="冠心病"' + CheckBoxValue("CardiovascularSystem", "冠心病") + '>冠心病');
    lodop.ADD_PRINT_TEXT(470, 380, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(485, 410, 485, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(470, 425, 400, 15, $("#AddCardiovascularSystem").val());

    lodop.ADD_PRINT_TEXT(510, 60, 80, 15, "肺功能：");
    lodop.ADD_PRINT_LINE(525, 110, 525, 790, 0, 1);
    var value = CheckBoxValue("PulmonaryFunctionOpt", "正常") == 'checked' ? "正常 " : "";
    if (!value) value = CheckBoxValue("PulmonaryFunctionOpt", "未见明显异常") == 'checked' ? "未见明显异常 " : "";
    if (!value) value = CheckBoxValue("PulmonaryFunctionOpt", "异常") == 'checked' ? "异常 " : "";
    value = value + $("#PulmonaryFunction").val();
    lodop.ADD_PRINT_TEXT(510, 115, 650, 15, value);

    lodop.ADD_PRINT_TEXT(550, 60, 80, 15, "肺部疾患：");
    lodop.ADD_PRINT_LINE(565, 120, 565, 790, 0, 1);
    var value = CheckBoxValue("PulmonaryDiseaseOpt", "正常") == 'checked' ? "正常 " : "";
    if (!value) value = CheckBoxValue("PulmonaryDiseaseOpt", "未见明显异常") == 'checked' ? "未见明显异常 " : "";
    if (!value) value = CheckBoxValue("PulmonaryDiseaseOpt", "异常") == 'checked' ? "异常 " : "";
    value = value + $("#PulmonaryDisease").val();
    lodop.ADD_PRINT_TEXT(550, 125, 650, 15, value);

    lodop.ADD_PRINT_TEXT(590, 60, 80, 15, "肝功能：");
    lodop.ADD_PRINT_LINE(605, 110, 605, 790, 0, 1);
    var value = CheckBoxValue("LiverFunctionOpt", "正常") == 'checked' ? "正常 " : "";
    if (!value) value = CheckBoxValue("LiverFunctionOpt", "未见明显异常") == 'checked' ? "未见明显异常 " : "";
    if (!value) value = CheckBoxValue("LiverFunctionOpt", "异常") == 'checked' ? "异常 " : "";
    value = value + $("#LiverFunction").val();
    lodop.ADD_PRINT_TEXT(590, 115, 650, 15, value);

    lodop.ADD_PRINT_TEXT(630, 60, 80, 15, "肾功能：");
    lodop.ADD_PRINT_LINE(645, 110, 645, 790, 0, 1);
    var value = CheckBoxValue("RenalFunctionOpt", "正常") == 'checked' ? "正常 " : "";
    if (!value) value = CheckBoxValue("RenalFunctionOpt", "未见明显异常") == 'checked' ? "未见明显异常 " : "";
    if (!value) value = CheckBoxValue("RenalFunctionOpt", "异常") == 'checked' ? "异常 " : "";
    value = value + $("#RenalFunction").val();
    lodop.ADD_PRINT_TEXT(630, 115, 650, 15, value);

    lodop.ADD_PRINT_TEXT(670, 60, 120, 15, "特殊检验指标：");
    lodop.ADD_PRINT_LINE(685, 160, 685, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(670, 175, 650, 15, $("#SpecialInspection").val());

    lodop.ADD_PRINT_TEXT(710, 60, 120, 15, "病人体格情况：");
    lodop.ADD_PRINT_TEXT(710, 180, 70, 15, "ASA分级");
    lodop.ADD_PRINT_LINE(725, 240, 725, 340, 0, 1);
    lodop.ADD_PRINT_TEXT(710, 255, 120, 15, $("#ASAClass").val());
    lodop.ADD_PRINT_HTM(710, 380, 80, 20, '<input type="checkbox" class="SourceType" value="E"' + CheckBoxValue("SourceType", "E") + '>E');

    lodop.ADD_PRINT_TEXT(750, 60, 280, 15, "病人重要器官功能、疾病情况：");
    lodop.ADD_PRINT_TEXT(790, 60, 120, 15, "全身麻醉：");
    lodop.ADD_PRINT_HTM(790, 180, 120, 20, '<input type="checkbox" class="GeneralAnesthesia" value="静吸复合麻醉"' + CheckBoxValue("GeneralAnesthesia", "静吸复合麻醉") + '>静吸复合麻醉');
    lodop.ADD_PRINT_HTM(790, 320, 120, 20, '<input type="checkbox" class="GeneralAnesthesia" value="静脉麻醉"' + CheckBoxValue("GeneralAnesthesia", "静脉麻醉") + '>静脉麻醉');
    lodop.ADD_PRINT_HTM(790, 460, 120, 20, '<input type="checkbox" class="GeneralAnesthesia" value="吸入麻醉"' + CheckBoxValue("GeneralAnesthesia", "吸入麻醉") + '>吸入麻醉');

    lodop.ADD_PRINT_TEXT(830, 60, 120, 15, "椎管内麻醉：");
    lodop.ADD_PRINT_HTM(830, 180, 120, 20, '<input type="checkbox" class="IntraspinalAnesthesia" value="硬膜外麻醉"' + CheckBoxValue("IntraspinalAnesthesia", "硬膜外麻醉") + '>硬膜外麻醉');
    lodop.ADD_PRINT_HTM(830, 320, 120, 20, '<input type="checkbox" class="IntraspinalAnesthesia" value="腰麻"' + CheckBoxValue("IntraspinalAnesthesia", "腰麻") + '>腰麻');

    lodop.ADD_PRINT_TEXT(870, 60, 120, 15, "神经阻滞：");
    lodop.ADD_PRINT_HTM(870, 180, 120, 20, '<input type="checkbox" class="NerveBlock" value="臂神经丛阻滞"' + CheckBoxValue("NerveBlock", "臂神经丛阻滞") + '>臂神经丛阻滞');
    lodop.ADD_PRINT_HTM(870, 320, 120, 20, '<input type="checkbox" class="NerveBlock" value="颈神经丛阻滞"' + CheckBoxValue("NerveBlock", "颈神经丛阻滞") + '>颈神经丛阻滞');

    lodop.ADD_PRINT_TEXT(910, 60, 120, 15, "其它：");
    lodop.ADD_PRINT_HTM(910, 180, 120, 20, '<input type="checkbox" class="Strengthen" value="强化"' + CheckBoxValue("Strengthen", "强化") + '>强化');

    lodop.ADD_PRINT_TEXT(950, 60, 80, 15, "插管条件：");
    lodop.ADD_PRINT_LINE(965, 120, 965, 790, 0, 1);
    var value = CheckBoxValue("IntubationConditionOpt", "Ⅰ级") == 'checked' ? "Ⅰ级 " : "";
    if (!value) value = CheckBoxValue("IntubationConditionOpt", "Ⅱ级") == 'checked' ? "Ⅱ级 " : "";
    if (!value) value = CheckBoxValue("IntubationConditionOpt", "Ⅲ级") == 'checked' ? "Ⅲ级 " : "";
    if (!value) value = CheckBoxValue("IntubationConditionOpt", "Ⅳ级") == 'checked' ? "Ⅳ级 " : "";
    value = value + $("#IntubationCondition").val();
    lodop.ADD_PRINT_TEXT(950, 135, 690, 15, value);

    lodop.ADD_PRINT_TEXT(1020, 60, 80, 15, "麻醉医师：");
    //lodop.ADD_PRINT_LINE(925, 590, 925, 790, 0, 1);
    //lodop.ADD_PRINT_TEXT(910, 595, 200, 15, $("#AnaDoctorSign").val());
    //lodop.ADD_PRINT_IMAGE(910, 595, "100%", "100%", $("#AnaDoctorSign").attr("src"));
    var imgSrc = $("#AnaDoctorSign").attr("src");
    var imgHtml = "<img " + ((imgSrc && imgSrc != "") ? ("src='" + imgSrc + "'") : "") + ">";
    lodop.ADD_PRINT_IMAGE(990, 145, 140, "100%", imgHtml);

    lodop.ADD_PRINT_TEXT(1010, 530, 50, 15, "日期：");
    lodop.ADD_PRINT_LINE(1025, 590, 1025, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(1010, 595, 200, 15, $("#AnaDoctorSignDate").datebox("getValue"));
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