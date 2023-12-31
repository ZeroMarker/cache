$(document).ready(function() {
    loadApplicationData();
    loadOperDatas();
    $("#btnSave").linkbutton({
        onClick: function() {
            var operDatas = getOperDatas();
            if (operDatas && operDatas.length > 0) {
                var jsonData = dhccl.formatObjects(operDatas);
                $.ajax({
                    url: dhccl.csp.dataListService,
                    data: {
                        jsonData: jsonData
                    },
                    type: "post",
                    async: false,
                    success: function(data) {
                        // showOperMessage(data, "保存", function() {
                        //     window.location.reload();
                        // });
                        dhccl.showMessage(data, "保存", null, null, function() {
                        window.location.reload();
                    });
                    }
                });
            }
        }
    });
    $("#btnPrint").linkbutton({
        onClick: printPosAnestheticvisit
    });

});

function getOperDatas() {
    var operDatas = new Array(),
        opsId = dhccl.getQueryString("opsId"),
        moduleId = dhccl.getQueryString("moduleId");

    // 病人身高和体重，保存在手术明细表中
    // var patHeight = $("#PatHeight").textbox("getValue"),
    //     patWeight = $("#PatWeight").textbox("getValue");
    // operDatas.push({
    //     RowId: opsId,
    //     PatHeight: patHeight,
    //     PatWeight: patWeight,
    //     ClassName: "DHCClinic.OperSchedule"
    // });

    // 其他数据保存在手术数据表中
    $(".form-item").each(function() {
        var id = $(this).attr("id"),
            selector = "." + id,
            dataValue = "",
            splitChar = ",";
        if ($(selector).length > 0) {
            $(selector).each(function() {
                if ($(this)[0].type == "checkbox" && $(this).prop("checked") == true) {
                    if (dataValue != "") {
                        dataValue += splitChar
                    }
                    dataValue += $(this).val();
                }
            });
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
                OperSchedule: opsId,
                DataItem: id,
                DataValue: dataValue,
                UpdateUserID: session.UserID,
                DataModule: moduleId,
                ClassName: "DHCAN.OperData"
            });
        }

    });
    return operDatas;
}

function loadApplicationData() {
    var opsId = dhccl.getQueryString("opsId"),
        moduleId = dhccl.getQueryString("moduleId");
    var operApplicationInfo = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: "DHCAN.BLL.OperSchedule",
        QueryName: "FindOperScheduleList",
        Arg1: "",
        Arg2: "",
        Arg3: "",
        Arg4: opsId,
        ArgCnt: 4
    }, "json");

    $("#patientForm").form("load", operApplicationInfo[0]);
}

function loadOperDatas() {
    var opsId = dhccl.getQueryString("opsId"),
        moduleId = dhccl.getQueryString("moduleId");
    var operDatas = dhccl.getDatas(dhcan.bll.dataQuery, {
        ClassName: dhcan.bll.dataQuery,
        QueryName: "FindOperData",
        Arg1: opsId,
        Arg2: moduleId,
        ArgCnt: 2
    }, "json");
    //console.log(operDatas);
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
                                $(this).checkbox("check",true);
                            }
                        });
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
                                $(this).checkbox("check",true);
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
    //createPrintOnePage(lodop);
    lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
    lodop.SET_PREVIEW_WINDOW(1, 0, 0, 0, 0, "");
    lodop.PREVIEW();
    //lodop.PRINT();
    //lodop.PRINT_SETUP();
}

function createPrintOnePage(lodop) {
    lodop.PRINT_INIT("打印麻醉后访视记录单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    var title = '<h2 style="text-align:center;">XXX人民医院<br><h3 style="text-align:center">麻&nbsp;&nbsp;&nbsp;&nbsp;醉&nbsp;&nbsp;&nbsp;&nbsp;后&nbsp;&nbsp;&nbsp;&nbsp;访&nbsp;&nbsp;&nbsp;&nbsp;视&nbsp;&nbsp;&nbsp;&nbsp;记&nbsp;&nbsp;&nbsp;&nbsp;录</h3></h2>';
    $(":text").each(function(i, obj) {
        $(":text").eq(i).attr("value", obj.value);
    })
    $(":checkbox").each(function(i, obj) {
        $(":checkbox").eq(i).attr("checked", obj.checked);
    });
    $("#dataForm").find("textarea").each(function(i, obj) {
        $("#dataForm").find("textarea").eq(i).width(858);
        $("#dataForm").find("textarea").eq(i).height(50);
    })
    var html = '<body>' + title + $("#patientInfo").html() + $("#dataForm").html() + '</body>';
    lodop.ADD_PRINT_HTML(20, 0, "100%", "100%", "<!DOCTYPE html><html>" + html + "<br><br></html>");
    lodop.SET_PREVIEW_WINDOW(1, 0, 0, 0, 0, "");
}

function drawPrintOnePage(lodop) {
    lodop.PRINT_INIT("创建打印麻醉后访视记录单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontName", "微软雅黑");
    lodop.SET_PRINT_STYLE("FontSize", 10);
    lodop.ADD_PRINT_TEXT(10, 250, 300, 30, "X X X 医 院");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 21); //设置字体
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_TEXT(50, 200, 400, 20, "麻  醉  后  访  视  记  录  单");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 18); //设置字体
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_TEXT(100, 10, 40, 15, "姓名");
    lodop.ADD_PRINT_LINE(115, 40, 115, 180, 0, 1);
    lodop.ADD_PRINT_TEXT(100, 45, 140, 15, $("#PatName").val());

    lodop.ADD_PRINT_TEXT(100, 190, 40, 15, "性别");
    lodop.ADD_PRINT_LINE(115, 220, 115, 270, 0, 1);
    lodop.ADD_PRINT_TEXT(100, 225, 40, 15, $("#PatGender").val());

    lodop.ADD_PRINT_TEXT(100, 280, 40, 15, "年龄");
    lodop.ADD_PRINT_LINE(115, 310, 115, 360, 0, 1);
    lodop.ADD_PRINT_TEXT(100, 315, 40, 15, $("#PatAge").val());

    lodop.ADD_PRINT_TEXT(100, 370, 40, 15, "体重");
    lodop.ADD_PRINT_LINE(115, 400, 115, 450, 0, 1);
    lodop.ADD_PRINT_TEXT(100, 405, 40, 20, $("#PatWeight").val());
    lodop.ADD_PRINT_TEXT(100, 452, 28, 15, "kg");

    lodop.ADD_PRINT_TEXT(100, 480, 40, 15, "科别");
    lodop.ADD_PRINT_LINE(115, 510, 115, 660, 0, 1);
    lodop.ADD_PRINT_TEXT(100, 515, 140, 15, $("#PatDeptDesc").val());

    lodop.ADD_PRINT_TEXT(100, 670, 40, 15, "床号");
    lodop.ADD_PRINT_LINE(115, 700, 115, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(100, 705, 60, 15, $("#PatBedCode").val());

    lodop.ADD_PRINT_TEXT(130, 10, 60, 15, "术后诊断");
    lodop.ADD_PRINT_LINE(145, 70, 145, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(130, 75, 590, 15, $("#PrevDiagnosisDesc").val());

    lodop.ADD_PRINT_TEXT(160, 10, 60, 15, "手术名称");
    lodop.ADD_PRINT_LINE(175, 70, 175, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(160, 75, 590, 15, $("#OperationDesc").val());

    lodop.ADD_PRINT_TEXT(190, 10, 60, 15, "麻醉方式");
    lodop.ADD_PRINT_LINE(205, 70, 205, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(190, 75, 590, 15, $("#PrevAnaMethodDesc").val());

    $(":checkbox").each(function(i, obj) {
        $(":checkbox").eq(i).attr("checked", obj.checked);
    });
    //lodop.ADD_PRINT_LINE(220,10,220,760,0,0); //外边框横线
    //lodop.ADD_PRINT_LINE(220,10,620,10,0,0);  //左边框竖线

    lodop.ADD_PRINT_TEXT(230, 10, 120, 15, "访视时所在病区：");
    lodop.ADD_PRINT_HTM(230, 130, 70, 20, '<input type="checkbox" class="PatLocation" value="原病房"' + CheckBoxValue("PatLocation", "原病房") + '>原病房');
    lodop.ADD_PRINT_HTM(230, 200, 130, 20, '<input type="checkbox" class="PatLocation" value="原科室重症病房"' + CheckBoxValue("PatLocation", "原科室重症病房") + '>原科室重症病房');
    lodop.ADD_PRINT_HTM(230, 330, 60, 20, '<input type="checkbox" class="PatLocation" value="ICU" ' + CheckBoxValue("PatLocation", "ICU") + '>ICU');
    lodop.ADD_PRINT_HTM(230, 390, 90, 20, '<input type="checkbox" class="PatLocation" value="离院" ' + CheckBoxValue("PatLocation", "离院") + '>离院');

    lodop.ADD_PRINT_TEXT(270, 10, 120, 15, "生命体征：");
    lodop.ADD_PRINT_TEXT(270, 130, 40, 15, "血压");
    lodop.ADD_PRINT_LINE(285, 160, 285, 200, 0, 1);
    lodop.ADD_PRINT_TEXT(270, 165, 40, 15, $("#SystolicPressure").val());
    lodop.ADD_PRINT_TEXT(270, 200, 10, 15, "/");
    lodop.ADD_PRINT_LINE(285, 210, 285, 250, 0, 1);
    lodop.ADD_PRINT_TEXT(270, 215, 40, 15, $("#DiastolicPressure").val());
    lodop.ADD_PRINT_TEXT(270, 250, 60, 15, "mmHg");

    lodop.ADD_PRINT_TEXT(270, 320, 40, 15, "呼吸");
    lodop.ADD_PRINT_LINE(285, 350, 285, 390, 0, 1);
    lodop.ADD_PRINT_TEXT(270, 355, 40, 15, $("#Respiration").val());
    lodop.ADD_PRINT_TEXT(270, 390, 60, 15, "次/分");

    lodop.ADD_PRINT_TEXT(270, 460, 40, 15, "体温");
    lodop.ADD_PRINT_LINE(285, 490, 285, 530, 0, 1);
    lodop.ADD_PRINT_TEXT(270, 495, 40, 15, $("#Respiration").val());
    lodop.ADD_PRINT_TEXT(270, 530, 40, 15, "℃");

    lodop.ADD_PRINT_TEXT(270, 580, 40, 15, "心率");
    lodop.ADD_PRINT_LINE(285, 610, 285, 650, 0, 1);
    lodop.ADD_PRINT_TEXT(270, 615, 40, 15, $("#Respiration").val());
    lodop.ADD_PRINT_TEXT(270, 650, 60, 15, "次/分");

    lodop.ADD_PRINT_TEXT(310, 10, 120, 15, "精神状态：");
    lodop.ADD_PRINT_HTM(310, 130, 60, 20, '<input type="checkbox" class="MentalState" value="清醒" ' + CheckBoxValue("MentalState", "清醒") + '>清醒');
    lodop.ADD_PRINT_HTM(310, 190, 120, 20, '<input type="checkbox" class="MentalState" value="模糊" ' + CheckBoxValue("MentalState", "模糊") + '>模糊');
    lodop.ADD_PRINT_HTM(310, 310, 90, 20, '<input type="checkbox" class="MentalState" value="嗜睡" ' + CheckBoxValue("MentalState", "嗜睡") + '>嗜睡');
    lodop.ADD_PRINT_HTM(310, 400, 90, 20, '<input type="checkbox" class="MentalState" value="昏迷" ' + CheckBoxValue("MentalState", "昏迷") + '>昏迷');
    lodop.ADD_PRINT_HTM(310, 490, 60, 20, '<input type="checkbox" class="MentalState" value="镇静" ' + CheckBoxValue("MentalState", "镇静") + '>镇静');
    lodop.ADD_PRINT_TEXT(310, 550, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(325, 580, 325, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(310, 585, 180, 15, $("#AddlMentalState").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(350, 10, 120, 15, "呼吸系统：");
    lodop.ADD_PRINT_HTM(350, 130, 60, 20, '<input type="checkbox" class="RespiratorySystem" value="正常" ' + CheckBoxValue("RespiratorySystem", "正常") + '>正常');
    lodop.ADD_PRINT_HTM(350, 190, 90, 20, '<input type="checkbox" class="RespiratorySystem" value="声势/咽痛" ' + CheckBoxValue("RespiratorySystem", "声势/咽痛") + '>声势/咽痛');
    lodop.ADD_PRINT_HTM(350, 310, 90, 20, '<input type="checkbox" class="RespiratorySystem" value="呼吸困难" ' + CheckBoxValue("RespiratorySystem", "呼吸困难") + '>呼吸困难');
    lodop.ADD_PRINT_HTM(350, 400, 90, 20, '<input type="checkbox" class="RespiratorySystem" value="辅助通气" ' + CheckBoxValue("RespiratorySystem", "辅助通气") + '>辅助通气');
    lodop.ADD_PRINT_TEXT(350, 550, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(365, 580, 365, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(350, 585, 180, 15, $("#AddlRespiratorySystem").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(390, 10, 120, 15, "循环系统：");
    lodop.ADD_PRINT_HTM(390, 130, 60, 20, '<input type="checkbox" class="CirculatorySytem" value="正常" ' + CheckBoxValue("CirculatorySytem", "正常") + '>正常');
    lodop.ADD_PRINT_HTM(390, 190, 90, 20, '<input type="checkbox" class="CirculatorySytem" value="低血压" ' + CheckBoxValue("CirculatorySytem", "低血压") + '>低血压');
    lodop.ADD_PRINT_HTM(390, 310, 90, 20, '<input type="checkbox" class="CirculatorySytem" value="高血压" ' + CheckBoxValue("CirculatorySytem", "高血压") + '>高血压');
    lodop.ADD_PRINT_HTM(390, 400, 90, 20, '<input type="checkbox" class="CirculatorySytem" value="心律失常" ' + CheckBoxValue("CirculatorySytem", "心律失常") + '>心律失常');
    lodop.ADD_PRINT_TEXT(390, 550, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(405, 580, 405, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(390, 585, 180, 15, $("#AddlCirculatorySytem").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(430, 10, 120, 15, "四肢感觉/活动：");
    lodop.ADD_PRINT_HTM(430, 130, 60, 20, '<input type="checkbox" class="Meropresthesia" value="正常" ' + CheckBoxValue("Meropresthesia", "正常") + '>正常');
    lodop.ADD_PRINT_HTM(430, 190, 120, 20, '<input type="checkbox" class="Meropresthesia" value="不清醒/不合作" ' + CheckBoxValue("Meropresthesia", "不清醒/不合作") + '>不清醒/不合作');
    lodop.ADD_PRINT_TEXT(430, 550, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(445, 580, 445, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(430, 585, 180, 15, $("#AddlUrogenitalSystem").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(470, 10, 60, 15, "穿刺点(");
    lodop.ADD_PRINT_HTM(470, 60, 70, 20, '<input type="checkbox" class="PunctureSite" value="硬膜外" ' + CheckBoxValue("PunctureSite", "硬膜外") + '>硬膜外');
    lodop.ADD_PRINT_HTM(470, 130, 70, 20, '<input type="checkbox" class="PunctureSite" value="深静脉" ' + CheckBoxValue("PunctureSite", "深静脉") + '>深静脉');
    lodop.ADD_PRINT_HTM(470, 200, 100, 20, '<input type="checkbox" class="PunctureSite" value="桡动脉" ' + CheckBoxValue("PunctureSite", "桡动脉") + '>桡动脉)：');
    lodop.ADD_PRINT_HTM(470, 310, 90, 20, '<input type="checkbox" class="PunctureSiteCondition" value="正常" ' + CheckBoxValue("PunctureSiteCondition", "正常") + '>正常');
    lodop.ADD_PRINT_HTM(470, 400, 90, 20, '<input type="checkbox" class="PunctureSiteCondition" value="疼痛" ' + CheckBoxValue("PunctureSiteCondition", "疼痛") + '>疼痛');
    lodop.ADD_PRINT_HTM(470, 490, 60, 20, '<input type="checkbox" class="PunctureSiteCondition" value="红肿" ' + CheckBoxValue("PunctureSiteCondition", "红肿") + '>红肿');
    lodop.ADD_PRINT_TEXT(470, 550, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(485, 580, 485, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(470, 585, 180, 15, $("#AddlPunctureSiteCondition").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(510, 10, 130, 15, "其他特殊情况及处理");
    lodop.ADD_PRINT_HTM(530, 10, 770, 60, '<textarea id="AddSpecialSituations" name="AddSpecialSituations" class="form-item" style="width:100%;height:100%">' + $("#AddSpecialSituations").text() + '</textarea>');

    lodop.ADD_PRINT_TEXT(620, 10, 200, 15, "围手术期严重并发症：");
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗

    lodop.ADD_PRINT_HTM(650, 10, 210, 20, '<input type="checkbox" id="CVPComplication" name="CVPComplication" class="form-item" value="中心静脉穿刺严重并发症" ' + $("#CVPComplication").attr("checked") + '>中心静脉穿刺严重并发症：');
    lodop.ADD_PRINT_TEXT(650, 210, 80, 15, "穿刺位置");
    lodop.ADD_PRINT_LINE(665, 270, 665, 480, 0, 1);
    lodop.ADD_PRINT_TEXT(650, 275, 210, 15, $("#CVPSite").combobox("getValue"));
    lodop.ADD_PRINT_HTM(650, 490, 60, 20, '<input type="checkbox" class="CVPComplicationCondition" value="血胸" ' + CheckBoxValue("CVPComplicationCondition", "血胸") + '>血胸');
    lodop.ADD_PRINT_HTM(650, 540, 60, 20, '<input type="checkbox" class="CVPComplicationCondition" value="气胸" ' + CheckBoxValue("CVPComplicationCondition", "气胸") + '>气胸');
    lodop.ADD_PRINT_HTM(650, 590, 90, 20, '<input type="checkbox" class="CVPComplicationCondition" value="局部血肿" ' + CheckBoxValue("CVPComplicationCondition", "局部血肿") + '>局部血肿');
    lodop.ADD_PRINT_HTM(650, 670, 100, 20, '<input type="checkbox" class="CVPComplicationCondition" value="需外科干预" ' + CheckBoxValue("CVPComplicationCondition", "需外科干预") + '>需外科干预');

    lodop.ADD_PRINT_HTM(690, 10, 140, 20, '<input type="checkbox" id="UnplannedTransferToICU" name="UnplannedTransferToICU" class="form-item" value="非计划转入ICU"' + $("#UnplannedTransferToICU").attr("checked") + '>非计划转入ICU：');
    lodop.ADD_PRINT_TEXT(690, 150, 80, 15, "转入原因");
    lodop.ADD_PRINT_LINE(705, 210, 705, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(690, 215, 560, 15, $("#TransferReason").combobox("getValue"));

    lodop.ADD_PRINT_HTM(730, 10, 190, 20, '<input type="checkbox" id="AllergyDuringAnesthesia" name="AllergyDuringAnesthesia" class="form-item" value="麻醉期间严重过敏反应" ' + $("#AllergyDuringAnesthesia").attr("checked") + '>麻醉期间严重过敏反应：');
    lodop.ADD_PRINT_TEXT(730, 200, 90, 15, "可能过敏原");
    lodop.ADD_PRINT_LINE(745, 270, 745, 480, 0, 1);
    lodop.ADD_PRINT_TEXT(730, 275, 210, 15, $("#PossibleAllergen").combobox("getValue"));
    lodop.ADD_PRINT_TEXT(730, 490, 40, 15, "结局");
    lodop.ADD_PRINT_LINE(745, 520, 745, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(730, 525, 250, 15, $("#AllergyResult").combobox("getValue"));

    lodop.ADD_PRINT_HTM(770, 10, 190, 20, '<input type="checkbox" id="IAComplication" name="IAComplication" class="form-item" value="椎管内麻醉严重并发症" ' + $("#IAComplication").attr("checked") + '>椎管内麻醉严重并发症：');
    lodop.ADD_PRINT_HTM(770, 200, 90, 20, '<input type="checkbox" class="IAComplicationCondition" value="重度头痛" ' + CheckBoxValue("IAComplicationCondition", "重度头痛") + '>重度头痛');
    lodop.ADD_PRINT_HTM(770, 290, 120, 20, '<input type="checkbox" class="IAComplicationCondition" value="局部感觉异常" ' + CheckBoxValue("IAComplicationCondition", "局部感觉异常") + '>局部感觉异常');
    lodop.ADD_PRINT_HTM(770, 400, 90, 20, '<input type="checkbox" class="IAComplicationCondition" value="运动异常" ' + CheckBoxValue("IAComplicationCondition", "运动异常") + '>运动异常');
    lodop.ADD_PRINT_TEXT(770, 490, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(785, 520, 785, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(770, 525, 250, 15, $("#AddlIAComplicationCondition").combobox("getValue"));

    lodop.ADD_PRINT_HTM(810, 10, 190, 20, '<input type="checkbox" id="OperCancelAfterAnaStart" name="OperCancelReason" class="form-item" value="麻醉开始后取消手术"' + $("#OperCancelAfterAnaStart").attr("checked") + '>麻醉开始后取消手术：');
    lodop.ADD_PRINT_TEXT(810, 180, 40, 15, "原因");
    lodop.ADD_PRINT_LINE(825, 220, 825, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(810, 225, 550, 15, $("#OperCancelReason").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(850, 10, 130, 15, "其他严重并发症：");
    lodop.ADD_PRINT_HTM(870, 10, 770, 60, '<textarea id="addlComplication" name="addlComplication" class="form-item" data-rowId="" style="width:100%;height:100%">' + $("#addlComplication").text() + '</textarea>');


}