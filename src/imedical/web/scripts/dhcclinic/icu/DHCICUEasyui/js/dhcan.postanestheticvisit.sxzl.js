$(document).ready(function() {
    operDataManager.initFormData(loadPatInfo);
    initPage();
    operDataManager.setCheckChange();
    signCommon.loadSignature();
});

function initPage() {
    //loadApplicationData();
    //loadOperDatas();
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
        }
    });

    $("#btnPrint").linkbutton({
        onClick: printPosAnestheticvisit
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
}

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
        signDate = appData.OperDate;
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
                                // $(this).prop("checked", true);
                                //$(this).checkbox("check",true);
                                $(this).checkbox("setValue", true);
                            }
                            if ($(this)[0].type == "radio" && dataValue.indexOf("," + $(this).val() + ",") >= 0) {
                                $(this).radio("setValue", true);
                            }
                        });
                        $(selector).val(operData.DataValue);
                    } else {
                        if ($(selector).hasClass("textbox")) {
                            $(selector).val(operData.DataValue);
                        } else if ($(selector).hasClass("hisui-numberbox")) {
                            $(selector).numberbox("setValue", operData.DataValue);
                        } else if ($(selector).hasClass("hisui-combobox")) {
                            $(selector).combobox("setValue", operData.DataValue);
                        } else if ($(selector)[0].type == "checkbox") {
                            if (operData.DataValue == $(selector).val()) {
                                // $(selector).prop("checked", true);
                                // $(this).checkbox("check",true);
                                $(selector).checkbox("setValue", true);
                            }
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

function printPosAnestheticvisit() {
    var lodop = getLodop();
    drawPrintOnePage(lodop);
    lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();
    //lodop.PRINT();
    //lodop.PRINT_SETUP();
}

function drawPrintOnePage(lodop) {
    lodop.PRINT_INIT("创建打印麻醉后访视记录单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontName", "微软雅黑");
    lodop.SET_PRINT_STYLE("FontSize", 10);
    lodop.ADD_PRINT_TEXT(20, 220, 300, 30, "山 西 肿 瘤 医 院");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 21); //设置字体
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_TEXT(60, 180, 400, 20, "麻  醉  后  访  视  记  录  单");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 18); //设置字体
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_TEXT(110, 60, 80, 15, "患者姓名");
    lodop.ADD_PRINT_LINE(125, 130, 125, 220, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 135, 150, 15, $("#PatName").text());

    lodop.ADD_PRINT_TEXT(110, 250, 40, 15, "性别");
    lodop.ADD_PRINT_LINE(125, 280, 125, 400, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 295, 120, 15, $("#PatGender").text());

    lodop.ADD_PRINT_TEXT(110, 420, 40, 15, "年龄");
    lodop.ADD_PRINT_LINE(125, 450, 125, 570, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 465, 120, 15, $("#PatAge").text());

    lodop.ADD_PRINT_TEXT(110, 590, 50, 15, "住院号");
    lodop.ADD_PRINT_LINE(125, 640, 125, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(110, 645, 140, 15, $("#MedcareNo").text());

    lodop.ADD_PRINT_TEXT(150, 60, 80, 15, "科室名称");
    lodop.ADD_PRINT_LINE(165, 130, 165, 400, 0, 1);
    lodop.ADD_PRINT_TEXT(150, 135, 330, 15, $("#PatDeptDesc").text());

    lodop.ADD_PRINT_TEXT(150, 420, 40, 15, "床号");
    lodop.ADD_PRINT_LINE(165, 450, 165, 570, 0, 1);
    lodop.ADD_PRINT_TEXT(150, 465, 120, 15, $("#PatBedCode").text());

    lodop.ADD_PRINT_TEXT(190, 60, 80, 15, "手术日期");
    lodop.ADD_PRINT_LINE(205, 130, 205, 400, 0, 1);
    lodop.ADD_PRINT_TEXT(190, 135, 330, 15, $("#OperDate").text());

    lodop.ADD_PRINT_TEXT(190, 420, 100, 15, "手术结束时间");
    lodop.ADD_PRINT_LINE(205, 520, 205, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(190, 525, 290, 15, $("#OperFinishDT").text());

    lodop.ADD_PRINT_TEXT(230, 60, 100, 15, "已施麻醉名称");
    lodop.ADD_PRINT_LINE(245, 150, 245, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(230, 155, 620, 15, $("#AnaestMethodInfo").text());

    lodop.ADD_PRINT_TEXT(270, 60, 40, 15, "术后");
    lodop.ADD_PRINT_LINE(285, 80, 285, 120, 0, 1);
    lodop.ADD_PRINT_TEXT(270, 95, 70, 15, $("#overFinish").val());
    lodop.ADD_PRINT_TEXT(270, 120, 100, 15, "小时患者情况：");

    lodop.ADD_PRINT_TEXT(310, 60, 100, 15, "一般情况：");
    lodop.ADD_PRINT_HTM(310, 150, 80, 20, '<input type="checkbox" class="GeneralSituation" value="尚可"' + CheckBoxValue("GeneralSituation", "尚可") + '>尚可');
    lodop.ADD_PRINT_HTM(310, 250, 80, 20, '<input type="checkbox" class="GeneralSituation" value="危重"' + CheckBoxValue("GeneralSituation", "危重") + '>危重');
    lodop.ADD_PRINT_HTM(310, 350, 80, 20, '<input type="checkbox" class="GeneralSituation" value="抢救"' + CheckBoxValue("GeneralSituation", "抢救") + '>抢救');
    lodop.ADD_PRINT_HTM(310, 450, 80, 20, '<input type="checkbox" class="GeneralSituation" value="死亡"' + CheckBoxValue("GeneralSituation", "死亡") + '>死亡');

    lodop.ADD_PRINT_TEXT(350, 60, 100, 15, "循环系统：");
    lodop.ADD_PRINT_TEXT(350, 150, 40, 15, "血压");
    lodop.ADD_PRINT_LINE(365, 180, 365, 300, 0, 1);
    lodop.ADD_PRINT_TEXT(350, 205, 150, 15, $("#BloodPressure").val());
    lodop.ADD_PRINT_TEXT(350, 330, 80, 15, "mmHg");

    lodop.ADD_PRINT_TEXT(350, 480, 40, 15, "心率");
    lodop.ADD_PRINT_LINE(365, 510, 365, 660, 0, 1);
    lodop.ADD_PRINT_TEXT(350, 535, 150, 15, $("#HR").val());
    lodop.ADD_PRINT_TEXT(350, 660, 80, 15, "次/分");

    lodop.ADD_PRINT_TEXT(390, 60, 100, 15, "呼吸系统：");
    lodop.ADD_PRINT_TEXT(390, 150, 40, 15, "呼吸");
    lodop.ADD_PRINT_LINE(405, 180, 405, 300, 0, 1);
    lodop.ADD_PRINT_TEXT(390, 205, 150, 15, $("#Respiration").val());
    lodop.ADD_PRINT_TEXT(390, 330, 80, 15, "次/分");

    lodop.ADD_PRINT_TEXT(430, 150, 100, 15, "咽喉疼痛：");
    lodop.ADD_PRINT_HTM(430, 250, 60, 20, '<input type="checkbox" class="ThroatPain" value="有"' + CheckBoxValue("ThroatPain", "有") + '>有');
    lodop.ADD_PRINT_HTM(430, 330, 60, 20, '<input type="checkbox" class="ThroatPain" value="无"' + CheckBoxValue("ThroatPain", "无") + '>无');

    lodop.ADD_PRINT_TEXT(430, 480, 100, 15, "声音嘶哑：");
    lodop.ADD_PRINT_HTM(430, 580, 60, 20, '<input type="checkbox" class="ThroatPain" value="有"' + CheckBoxValue("ThroatPain", "有") + '>有');
    lodop.ADD_PRINT_HTM(430, 660, 60, 20, '<input type="checkbox" class="ThroatPain" value="无"' + CheckBoxValue("ThroatPain", "无") + '>无');

    lodop.ADD_PRINT_TEXT(470, 60, 100, 15, "神经系统：");
    lodop.ADD_PRINT_TEXT(470, 150, 60, 15, "意识：");
    lodop.ADD_PRINT_HTM(470, 210, 80, 20, '<input type="checkbox" class="Consciousness" value="清醒"' + CheckBoxValue("Consciousness", "清醒") + '>清醒');
    lodop.ADD_PRINT_HTM(470, 310, 80, 20, '<input type="checkbox" class="Consciousness" value="瞌睡"' + CheckBoxValue("Consciousness", "瞌睡") + '>瞌睡');
    lodop.ADD_PRINT_HTM(470, 410, 80, 20, '<input type="checkbox" class="Consciousness" value="昏迷"' + CheckBoxValue("Consciousness", "昏迷") + '>昏迷');

    lodop.ADD_PRINT_TEXT(510, 150, 60, 15, "头痛：");
    lodop.ADD_PRINT_HTM(510, 210, 60, 20, '<input type="checkbox" class="Headache" value="有"' + CheckBoxValue("Headache", "有") + '>有');
    lodop.ADD_PRINT_HTM(510, 310, 60, 20, '<input type="checkbox" class="Headache" value="无"' + CheckBoxValue("Headache", "无") + '>无');

    lodop.ADD_PRINT_TEXT(550, 150, 120, 15, "四肢肌力及感觉：");
    lodop.ADD_PRINT_LINE(565, 270, 565, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(550, 285, 550, 15, $("#Extremities").val());

    lodop.ADD_PRINT_TEXT(590, 60, 100, 15, "泌尿系统：");
    lodop.ADD_PRINT_TEXT(590, 150, 80, 15, "尿潴留：");
    lodop.ADD_PRINT_HTM(590, 230, 60, 20, '<input type="checkbox" class="RetentionUrine" value="有"' + CheckBoxValue("RetentionUrine", "有") + '>有');
    lodop.ADD_PRINT_HTM(590, 330, 60, 20, '<input type="checkbox" class="RetentionUrine" value="无"' + CheckBoxValue("RetentionUrine", "无") + '>无');
    lodop.ADD_PRINT_TEXT(590, 480, 80, 15, "留置尿管:");
    lodop.ADD_PRINT_HTM(590, 580, 60, 20, '<input type="checkbox" class="IndwellingCatheter" value="有"' + CheckBoxValue("IndwellingCatheter", "有") + '>有');
    lodop.ADD_PRINT_HTM(590, 660, 60, 20, '<input type="checkbox" class="IndwellingCatheter" value="无"' + CheckBoxValue("IndwellingCatheter", "无") + '>无');

    lodop.ADD_PRINT_TEXT(630, 60, 100, 15, "穿刺点：");
    lodop.ADD_PRINT_HTM(630, 150, 80, 20, '<input type="checkbox" class="RetentionUrine" value="疼痛"' + CheckBoxValue("RetentionUrinePain", "疼痛") + '>疼痛');
    lodop.ADD_PRINT_HTM(630, 250, 80, 20, '<input type="checkbox" class="RetentionUrine" value="不痛"' + CheckBoxValue("RetentionUrinePain", "不痛") + '>不痛');
    lodop.ADD_PRINT_HTM(630, 350, 80, 20, '<input type="checkbox" class="RetentionUrine" value="红肿"' + CheckBoxValue("RetentionUrineSwell", "红肿") + '>红肿');
    lodop.ADD_PRINT_HTM(630, 450, 80, 20, '<input type="checkbox" class="RetentionUrine" value="无红肿"' + CheckBoxValue("RetentionUrineSwell", "无红肿") + '>无红肿');

    lodop.ADD_PRINT_TEXT(670, 60, 100, 15, "其他：");
    lodop.ADD_PRINT_LINE(685, 150, 685, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(670, 165, 670, 15, $("#OtherInformation").val());

    lodop.ADD_PRINT_TEXT(730, 60, 80, 15, "麻醉医师：");
    //lodop.ADD_PRINT_LINE(730, 590, 730, 790, 0, 1);
    //lodop.ADD_PRINT_IMAGE(710, 595, "100%", "100%", $("#AnaDoctorSign").attr("src"));
    var imgSrc = $("#AnaDoctorSign").attr("src");
    var imgHtml = "<img " + ((imgSrc && imgSrc != "") ? ("src='" + imgSrc + "'") : "") + ">";
    lodop.ADD_PRINT_IMAGE(710, 145, 140, "100%", imgHtml);

    lodop.ADD_PRINT_TEXT(730, 530, 50, 15, "日期：");
    lodop.ADD_PRINT_LINE(745, 590, 745, 790, 0, 1);
    lodop.ADD_PRINT_TEXT(730, 595, 200, 15, $("#AnaDoctorSignDate").datebox("getValue"));
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