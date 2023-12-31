$(document).ready(function() {
    $("#dataForm").form("clear");
    loadApplicationData();
    setTestData();
    loadOperDatas();
    //alert($("#PrevDiagnosisDesc").width());
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
                        showOperMessage(data, "保存", function() {
                            window.location.reload();
                        });
                    }
                });
            }
        }
    });

    $("#btnPrint").linkbutton({
        onClick: printPreAnestheticvisit
    });
});

function getOperDatas() {
    var operDatas = new Array(),
        opsId = dhccl.getQueryString("opsId"),
        moduleId = dhccl.getQueryString("moduleId");

    // 病人身高和体重，保存在手术明细表中
    var patHeight = $("#PatHeight").textbox("getValue"),
        patWeight = $("#PatWeight").textbox("getValue");
    operDatas.push({
        RowId: opsId,
        PatHeight: patHeight,
        PatWeight: patWeight,
        ClassName: "DHCAN.OperSchedule"
    });

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
            if ($(this).hasClass("easyui-textbox")) {
                dataValue = $(this).textbox("getValue");
            } else if ($(this).hasClass("easyui-numberbox")) {
                dataValue = $(this).numberbox("getValue");
            } else if ($(this).hasClass("easyui-combobox")) {
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
    var operDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: dhcan.bll.dataQuery,
        QueryName: "FindOperData",
        Arg1: opsId,
        Arg2: moduleId,
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
                                $(this).prop("checked", true);
                            }
                        });
                    } else {
                        if ($(selector).hasClass("easyui-textbox")) {
                            $(selector).textbox("setValue", operData.DataValue);
                        } else if ($(selector).hasClass("easyui-numberbox")) {
                            $(selector).numberbox("setValue", operData.DataValue);
                        } else if ($(selector).hasClass("easyui-combobox")) {
                            $(selector).combobox("setValue", operData.DataValue);
                        } else if ($(selector)[0].type == "checkbox") {
                            if (operData.DataValue == $(selector).val()) {
                                $(selector).prop("checked", true);
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

function setTestData() {
    //$.ajaxSettings.async = false;
    $.post(ANCSP.DataQuery, {
        ClassName: "DHCCL.Test",
        QueryName: "FindLastestTestResult",
        Arg1: dhccl.getQueryString("EpisodeID"),
        ArgCnt: 1
    }, function(data) {
        if (data && data.length > 0) {
            $.each(data, function(index, dataItem) {
                var selector = "#" + dataItem.DataField;
                if ($(selector).hasClass("easyui-combobox")) {
                    $(selector).combobox("setValue", dataItem.Result);
                } else if ($(selector).hasClass("easyui-textbox")) {
                    $(selector).textbox("setValue", dataItem.Result);
                    if (dataItem.IsNormal != "Y") {

                        $(selector).textbox("textbox").css("color", "red");
                    }
                } else if ($(selector).hasClass("easyui-numberspinner")) {
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
    //createPrintOnePage(lodop);
    drawPreAnestheticvisitPage(lodop);
    //lodop.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Page");
    lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
    lodop.SET_PREVIEW_WINDOW(1, 0, 0, 0, 0, "");
    lodop.PREVIEW();
    //lodop.PRINT();
}

function createPrintOnePage(lodop) {
    lodop.PRINT_INIT("打印术前访视记录单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    var printStyleCss = '<meta http-equiv="X-UA-Compatible content="IE=edge"><link rel="stylesheet" type="text/css" href="../service/dhcanop/css/preanestheticvisitprint.css" />';
    var title = '<h2 style="text-align:center;">XXX人民医院<br><h3 style="text-align:center">麻&nbsp;&nbsp;&nbsp;&nbsp;醉&nbsp;&nbsp;&nbsp;&nbsp;前&nbsp;&nbsp;&nbsp;&nbsp;访&nbsp;&nbsp;&nbsp;&nbsp;视&nbsp;&nbsp;&nbsp;&nbsp;记&nbsp;&nbsp;&nbsp;&nbsp;录</h3></h2>';
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
    var html = printStyleCss + '<body id="printBody">' + title + $("#patientForm").html() + $("#dataForm").html() + '</body>';
    lodop.ADD_PRINT_HTML(0, 0, "110%", "110%", "<!DOCTYPE html><html>" + html + "<br><br></html>");
    lodop.SET_PREVIEW_WINDOW(1, 0, 0, 0, 0, "");

}

function drawPreAnestheticvisitPage(lodop) {
    lodop.PRINT_INIT("创建打印麻醉前访视记录单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontName", "微软雅黑");
    lodop.SET_PRINT_STYLE("FontSize", 10);
    lodop.ADD_PRINT_TEXT(0, 250, 300, 20, "X X X 医 院");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 21); //设置字体
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_TEXT(40, 200, 400, 20, "麻  醉  前  访  视  记  录  单");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 18); //设置字体
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_TEXT(90, 10, 40, 15, "姓名");
    lodop.ADD_PRINT_LINE(105, 40, 105, 150, 0, 1);
    lodop.ADD_PRINT_TEXT(90, 45, 110, 15, $("#PatName").val());

    lodop.ADD_PRINT_TEXT(90, 160, 40, 15, "性别");
    lodop.ADD_PRINT_LINE(105, 190, 105, 230, 0, 1);
    lodop.ADD_PRINT_TEXT(90, 195, 40, 15, $("#PatGender").val());

    lodop.ADD_PRINT_TEXT(90, 240, 40, 15, "年龄");
    lodop.ADD_PRINT_LINE(105, 270, 105, 310, 0, 1);
    lodop.ADD_PRINT_TEXT(90, 275, 40, 15, $("#PatAge").val());

    lodop.ADD_PRINT_TEXT(90, 320, 40, 15, "体重");
    lodop.ADD_PRINT_LINE(105, 350, 105, 390, 0, 1);
    lodop.ADD_PRINT_TEXT(90, 355, 40, 20, $("#PatWeight").val());
    lodop.ADD_PRINT_TEXT(90, 392, 28, 15, "kg");

    lodop.ADD_PRINT_TEXT(90, 420, 40, 15, "身高");
    lodop.ADD_PRINT_LINE(105, 450, 105, 490, 0, 1);
    lodop.ADD_PRINT_TEXT(90, 455, 40, 20, $("#PatHeight").val());
    lodop.ADD_PRINT_TEXT(90, 492, 28, 15, "cm");

    lodop.ADD_PRINT_TEXT(90, 520, 40, 15, "科别");
    lodop.ADD_PRINT_LINE(105, 550, 105, 670, 0, 1);
    lodop.ADD_PRINT_TEXT(90, 555, 120, 15, $("#PatDeptDesc").val());

    lodop.ADD_PRINT_TEXT(90, 680, 40, 15, "床号");
    lodop.ADD_PRINT_LINE(105, 710, 105, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(90, 715, 60, 15, $("#PatBedCode").val());

    lodop.ADD_PRINT_TEXT(120, 10, 60, 15, "术前诊断");
    lodop.ADD_PRINT_LINE(135, 70, 135, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(120, 75, 590, 15, $("#PrevDiagnosisDesc").val());

    lodop.ADD_PRINT_TEXT(150, 10, 60, 15, "拟施手术");
    lodop.ADD_PRINT_LINE(165, 70, 165, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(150, 75, 590, 15, $("#OperationDesc").val());

    lodop.ADD_PRINT_TEXT(180, 10, 60, 15, "简要病史");
    lodop.ADD_PRINT_LINE(195, 70, 195, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(180, 75, 590, 15, $("#IllnessHistory").val());

    lodop.ADD_PRINT_TEXT(210, 10, 100, 15, "生命体征：");

    lodop.ADD_PRINT_TEXT(210, 110, 40, 15, "血压");
    lodop.ADD_PRINT_LINE(225, 140, 225, 180, 0, 1);
    lodop.ADD_PRINT_TEXT(210, 145, 40, 15, $("#SystolicPressure").val());
    lodop.ADD_PRINT_TEXT(210, 180, 10, 15, "/");
    lodop.ADD_PRINT_LINE(225, 190, 225, 230, 0, 1);
    lodop.ADD_PRINT_TEXT(210, 195, 40, 15, $("#DiastolicPressure").val());
    lodop.ADD_PRINT_TEXT(210, 230, 60, 15, "mmHg");

    lodop.ADD_PRINT_TEXT(210, 290, 40, 15, "呼吸");
    lodop.ADD_PRINT_LINE(225, 320, 225, 360, 0, 1);
    lodop.ADD_PRINT_TEXT(210, 325, 40, 15, $("#Respiration").val());
    lodop.ADD_PRINT_TEXT(210, 360, 60, 15, "次/分");

    lodop.ADD_PRINT_TEXT(210, 420, 40, 15, "体温");
    lodop.ADD_PRINT_LINE(225, 450, 225, 490, 0, 1);
    lodop.ADD_PRINT_TEXT(210, 455, 40, 15, $("#Respiration").val());
    lodop.ADD_PRINT_TEXT(210, 490, 40, 15, "℃");

    lodop.ADD_PRINT_TEXT(210, 530, 40, 15, "心率");
    lodop.ADD_PRINT_LINE(225, 560, 225, 600, 0, 1);
    lodop.ADD_PRINT_TEXT(210, 565, 40, 15, $("#Respiration").val());
    lodop.ADD_PRINT_TEXT(210, 600, 60, 15, "次/分");

    lodop.ADD_PRINT_TEXT(240, 10, 100, 15, "全身情况：");
    lodop.ADD_PRINT_HTM(240, 110, 70, 20, '<input type="checkbox" class="BodyConditions" value="无异常" ' + CheckBoxValue("BodyConditions", "无异常") + '>无异常');
    lodop.ADD_PRINT_HTM(240, 180, 60, 20, '<input type="checkbox" class="BodyConditions" value="昏迷" ' + CheckBoxValue("BodyConditions", "昏迷") + '>昏迷');
    lodop.ADD_PRINT_HTM(240, 230, 60, 20, '<input type="checkbox" class="BodyConditions" value="贫血" ' + CheckBoxValue("BodyConditions", "贫血") + '>贫血');
    lodop.ADD_PRINT_HTM(240, 280, 60, 20, '<input type="checkbox" class="BodyConditions" value="脱水" ' + CheckBoxValue("BodyConditions", "脱水") + '>脱水');
    lodop.ADD_PRINT_HTM(240, 330, 60, 20, '<input type="checkbox" class="BodyConditions" value="卧床" ' + CheckBoxValue("BodyConditions", "卧床") + '>卧床');
    lodop.ADD_PRINT_HTM(240, 380, 60, 20, '<input type="checkbox" class="BodyConditions" value="消瘦" ' + CheckBoxValue("BodyConditions", "消瘦") + '>消瘦');
    lodop.ADD_PRINT_HTM(240, 430, 90, 20, '<input type="checkbox" class="BodyConditions" value="过渡肥胖" ' + CheckBoxValue("BodyConditions", "过渡肥胖") + '>过渡肥胖');
    lodop.ADD_PRINT_TEXT(240, 520, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(255, 550, 255, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(240, 555, 220, 15, $("#AddlBodyConditions").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(270, 10, 100, 15, "循环系统：");
    lodop.ADD_PRINT_HTM(270, 110, 70, 20, '<input type="checkbox" class="CirculatorySytem" value="无异常" ' + CheckBoxValue("CirculatorySytem", "无异常") + '>无异常');
    lodop.ADD_PRINT_HTM(270, 180, 90, 20, '<input type="checkbox" class="CirculatorySytem" value="高血压病"' + CheckBoxValue("CirculatorySytem", "高血压病") + '>高血压病');
    lodop.ADD_PRINT_HTM(270, 270, 70, 20, '<input type="checkbox" class="CirculatorySytem" value="冠心病"' + CheckBoxValue("CirculatorySytem", "冠心病") + '>冠心病');
    lodop.ADD_PRINT_HTM(270, 340, 90, 20, '<input type="checkbox" class="CirculatorySytem" value="心律失常"' + CheckBoxValue("CirculatorySytem", "心律失常") + '>心律失常');
    lodop.ADD_PRINT_TEXT(270, 520, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(285, 550, 285, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(270, 555, 220, 15, $("#AddlCirculatorySytem").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(300, 10, 100, 15, "呼吸系统：");
    lodop.ADD_PRINT_HTM(300, 110, 70, 20, '<input type="checkbox" class="RespiratorySystem" value="无异常" ' + CheckBoxValue("RespiratorySystem", "无异常") + '>无异常');
    lodop.ADD_PRINT_HTM(300, 180, 60, 20, '<input type="checkbox" class="RespiratorySystem" value="嗜烟"' + CheckBoxValue("RespiratorySystem", "嗜烟") + '>嗜烟');
    lodop.ADD_PRINT_HTM(300, 240, 70, 20, '<input type="checkbox" class="RespiratorySystem" value="COPD"' + CheckBoxValue("RespiratorySystem", "COPD") + '>COPD');
    lodop.ADD_PRINT_HTM(300, 310, 90, 20, '<input type="checkbox" class="RespiratorySystem" value="肺部感染"' + CheckBoxValue("RespiratorySystem", "肺部感染") + '>肺部感染');
    lodop.ADD_PRINT_HTM(300, 400, 60, 20, '<input type="checkbox" class="RespiratorySystem" value="哮喘"' + CheckBoxValue("RespiratorySystem", "哮喘") + '>哮喘');
    lodop.ADD_PRINT_TEXT(300, 520, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(315, 550, 315, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(300, 555, 220, 15, $("#AddlRespiratorySystem").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(330, 10, 100, 15, "泌尿生殖：");
    lodop.ADD_PRINT_HTM(330, 110, 70, 20, '<input type="checkbox" class="UrogenitalSystem" value="无异常" ' + CheckBoxValue("UrogenitalSystem", "无异常") + '>无异常');
    lodop.ADD_PRINT_HTM(330, 180, 100, 20, '<input type="checkbox" class="UrogenitalSystem" value="肾功能不全"' + CheckBoxValue("UrogenitalSystem", "肾功能不全") + '>肾功能不全');
    lodop.ADD_PRINT_HTM(330, 280, 60, 20, '<input type="checkbox" class="UrogenitalSystem" value="血尿"' + CheckBoxValue("UrogenitalSystem", "血尿") + '>血尿');
    lodop.ADD_PRINT_HTM(330, 340, 70, 20, '<input type="checkbox" class="UrogenitalSystem" value="蛋白质"' + CheckBoxValue("UrogenitalSystem", "蛋白质") + '>蛋白质');
    lodop.ADD_PRINT_HTM(330, 410, 100, 20, '<input type="checkbox" class="UrogenitalSystem" value="妊娠/临产"' + CheckBoxValue("UrogenitalSystem", "妊娠/临产") + '>妊娠/临产');
    lodop.ADD_PRINT_TEXT(330, 520, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(345, 550, 345, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(330, 555, 220, 15, $("#AddlUrogenitalSystem").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(360, 10, 100, 15, "消化系统：");
    lodop.ADD_PRINT_HTM(360, 110, 70, 20, '<input type="checkbox" class="DigestiveSystem" value="无异常" ' + CheckBoxValue("DigestiveSystem", "无异常") + '>无异常');
    lodop.ADD_PRINT_HTM(360, 180, 100, 20, '<input type="checkbox" class="DigestiveSystem" value="病毒性肝炎"' + CheckBoxValue("DigestiveSystem", "病毒性肝炎") + '>病毒性肝炎');
    lodop.ADD_PRINT_HTM(360, 280, 70, 20, '<input type="checkbox" class="DigestiveSystem" value="肝硬化"' + CheckBoxValue("DigestiveSystem", "肝硬化") + '>肝硬化');
    lodop.ADD_PRINT_HTM(360, 350, 60, 20, '<input type="checkbox" class="DigestiveSystem" value="腹水"' + CheckBoxValue("DigestiveSystem", "腹水") + '>腹水');
    lodop.ADD_PRINT_HTM(360, 410, 60, 20, '<input type="checkbox" class="DigestiveSystem" value="反流"' + CheckBoxValue("DigestiveSystem", "反流") + '>反流');
    lodop.ADD_PRINT_TEXT(360, 520, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(375, 550, 375, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(360, 555, 220, 15, $("#AddlDigestiveSystem").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(400, 10, 100, 15, "神经肌肉：");
    lodop.ADD_PRINT_HTM(390, 110, 70, 20, '<input type="checkbox" class="NervousSystem" value="无异常"' + CheckBoxValue("NervousSystem", "无异常") + '>无异常');
    lodop.ADD_PRINT_HTM(390, 180, 120, 20, '<input type="checkbox" class="NervousSystem" value="出血性脑卒中"' + CheckBoxValue("NervousSystem", "出血性脑卒中") + '>出血性脑卒中');
    lodop.ADD_PRINT_HTM(390, 300, 70, 20, '<input type="checkbox" class="NervousSystem" value="脑梗塞"' + CheckBoxValue("NervousSystem", "脑梗塞") + '>脑梗塞');
    lodop.ADD_PRINT_HTM(390, 370, 100, 20, '<input type="checkbox" class="NervousSystem" value="重症肌无力"' + CheckBoxValue("NervousSystem", "重症肌无力") + '>重症肌无力');
    lodop.ADD_PRINT_HTM(410, 110, 70, 20, '<input type="checkbox" class="NervousSystem" value="癫痫"' + CheckBoxValue("NervousSystem", "癫痫") + '>癫痫');
    lodop.ADD_PRINT_HTM(410, 180, 120, 20, '<input type="checkbox" class="NervousSystem" value="脊柱畸形/外伤"' + CheckBoxValue("NervousSystem", "脊柱畸形/外伤") + '>脊柱畸形/外伤');
    lodop.ADD_PRINT_HTM(410, 300, 70, 20, '<input type="checkbox" class="NervousSystem" value="偏瘫"' + CheckBoxValue("NervousSystem", "偏瘫") + '>偏瘫');
    lodop.ADD_PRINT_HTM(410, 370, 100, 20, '<input type="checkbox" class="NervousSystem" value="截瘫"' + CheckBoxValue("NervousSystem", "截瘫") + '>截瘫');
    lodop.ADD_PRINT_TEXT(400, 520, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(415, 550, 415, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(400, 555, 220, 15, $("#AddlNervousSystem").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(440, 10, 100, 15, "内分泌/代谢：");
    lodop.ADD_PRINT_HTM(440, 110, 70, 20, '<input type="checkbox" class="EndocrineSytem" value="无异常" ' + CheckBoxValue("EndocrineSytem", "无异常") + '>无异常');
    lodop.ADD_PRINT_HTM(440, 180, 70, 20, '<input type="checkbox" class="EndocrineSytem" value="糖尿病"' + CheckBoxValue("EndocrineSytem", "糖尿病") + '>糖尿病');
    lodop.ADD_PRINT_HTM(440, 250, 90, 20, '<input type="checkbox" class="EndocrineSytem" value="甲亢/低"' + CheckBoxValue("EndocrineSytem", "甲亢/低") + '>甲亢/低');
    lodop.ADD_PRINT_HTM(440, 340, 100, 20, '<input type="checkbox" class="EndocrineSytem" value="肾上腺腺瘤"' + CheckBoxValue("EndocrineSytem", "肾上腺腺瘤") + '>肾上腺腺瘤');
    lodop.ADD_PRINT_HTM(440, 440, 60, 20, '<input type="checkbox" class="EndocrineSytem" value="原醛"' + CheckBoxValue("EndocrineSytem", "原醛") + '>原醛');
    lodop.ADD_PRINT_TEXT(440, 520, 40, 15, "其他");
    lodop.ADD_PRINT_LINE(455, 550, 455, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(440, 555, 220, 15, $("#AddlDigestiveSystem").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(470, 10, 100, 15, "烟酒及药物");
    lodop.ADD_PRINT_TEXT(490, 10, 100, 15, "依赖：");
    lodop.ADD_PRINT_HTM(470, 110, 40, 20, '<input type="checkbox" class="DrugDependence" value="无"' + CheckBoxValue("DrugDependence", "无") + '>无');
    lodop.ADD_PRINT_HTM(470, 180, 60, 20, '<input type="checkbox" class="DrugDependence" value="嗜烟"' + CheckBoxValue("DrugDependence", "嗜烟") + '>嗜烟');
    lodop.ADD_PRINT_HTM(470, 250, 60, 20, '<input type="checkbox" class="DrugDependence" value="嗜酒"' + CheckBoxValue("DrugDependence", "嗜酒") + '>嗜酒');
    lodop.ADD_PRINT_HTM(470, 340, 90, 20, '<input type="checkbox" class="DrugDependence" value="药物成瘾"' + CheckBoxValue("DrugDependence", "药物成瘾") + '>药物成瘾');
    //lodop.ADD_PRINT_TEXT(490,110,40,15,"其他");
    lodop.ADD_PRINT_LINE(505, 110, 505, 430, 0, 1);
    lodop.ADD_PRINT_TEXT(490, 115, 280, 15, $("#AddlDrugDependence").combobox("getValue"));
    lodop.ADD_PRINT_TEXT(470, 520, 100, 15, "麻醉手术史：");
    lodop.ADD_PRINT_HTM(470, 620, 40, 20, '<input type="checkbox" class="AnopHistory" value="无"' + CheckBoxValue("AnopHistory", "无") + '>无');
    lodop.ADD_PRINT_HTM(470, 660, 40, 20, '<input type="checkbox" class="AnopHistory" value="有"' + CheckBoxValue("AnopHistory", "有") + '>有');
    lodop.ADD_PRINT_LINE(505, 520, 505, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(490, 525, 250, 15, $("#AddlAnopHistory").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(520, 10, 100, 15, "特殊药物使");
    lodop.ADD_PRINT_TEXT(540, 10, 100, 15, "用史：");
    lodop.ADD_PRINT_HTM(520, 110, 40, 20, '<input type="checkbox" class="SpecialDrugHistory" value="无"' + CheckBoxValue("SpecialDrugHistory", "无") + '>无');
    lodop.ADD_PRINT_HTM(520, 180, 60, 20, '<input type="checkbox" class="SpecialDrugHistory" value="嗜烟"' + CheckBoxValue("SpecialDrugHistory", "嗜烟") + '>嗜烟');
    lodop.ADD_PRINT_HTM(520, 250, 60, 20, '<input type="checkbox" class="SpecialDrugHistory" value="嗜酒"' + CheckBoxValue("SpecialDrugHistory", "嗜酒") + '>嗜酒');
    lodop.ADD_PRINT_HTM(520, 340, 90, 20, '<input type="checkbox" class="SpecialDrugHistory" value="药物成瘾"' + CheckBoxValue("SpecialDrugHistory", "药物成瘾") + '>药物成瘾');
    //lodop.ADD_PRINT_TEXT(540,110,40,15,"其他");
    lodop.ADD_PRINT_LINE(555, 110, 555, 430, 0, 1);
    lodop.ADD_PRINT_TEXT(540, 115, 280, 15, $("#AddlDrugDependence").combobox("getValue"));
    lodop.ADD_PRINT_TEXT(520, 520, 100, 15, "过敏史：");
    lodop.ADD_PRINT_HTM(520, 620, 40, 20, '<input type="checkbox" class="AllergicHistory" value="无"' + CheckBoxValue("AllergicHistory", "无") + '>无');
    lodop.ADD_PRINT_HTM(520, 660, 40, 20, '<input type="checkbox" class="AllergicHistory" value="有"' + CheckBoxValue("AllergicHistory", "有") + '>有');
    lodop.ADD_PRINT_LINE(555, 520, 555, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(540, 525, 250, 15, $("#AddlAllergicHistory").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(570, 10, 100, 15, "心电图：");
    lodop.ADD_PRINT_HTM(570, 110, 60, 20, '<input type="checkbox" class="ECG" value="未做"' + CheckBoxValue("ECG", "未做") + '>未做');
    lodop.ADD_PRINT_HTM(570, 170, 60, 20, '<input type="checkbox" class="ECG" value="正常"' + CheckBoxValue("ECG", "正常") + '>正常');
    lodop.ADD_PRINT_HTM(570, 230, 90, 20, '<input type="checkbox" class="ECG" value="异常诊断"' + CheckBoxValue("ECG", "异常诊断") + '>异常诊断');
    lodop.ADD_PRINT_LINE(585, 320, 585, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(570, 325, 450, 15, $("#AddlECG").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(600, 10, 100, 15, "胸片：");
    lodop.ADD_PRINT_HTM(600, 110, 60, 20, '<input type="checkbox" class="ChestRadiography" value="未做"' + CheckBoxValue("ChestRadiography", "未做") + '>未做');
    lodop.ADD_PRINT_HTM(600, 170, 60, 20, '<input type="checkbox" class="ChestRadiography" value="正常"' + CheckBoxValue("ChestRadiography", "正常") + '>正常');
    lodop.ADD_PRINT_HTM(600, 230, 90, 20, '<input type="checkbox" class="ChestRadiography" value="异常诊断"' + CheckBoxValue("ChestRadiography", "异常诊断") + '>异常诊断');
    lodop.ADD_PRINT_LINE(615, 320, 615, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(600, 325, 450, 15, $("#AddlChestRadiography").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(630, 10, 100, 15, "肝功能：");
    lodop.ADD_PRINT_HTM(630, 110, 60, 20, '<input type="checkbox" class="LiverFunction" value="未做"' + CheckBoxValue("LiverFunction", "未做") + '>未做');
    lodop.ADD_PRINT_HTM(630, 170, 60, 20, '<input type="checkbox" class="LiverFunction" value="正常"' + CheckBoxValue("LiverFunction", "正常") + '>正常');
    lodop.ADD_PRINT_HTM(630, 230, 70, 20, '<input type="checkbox" class="LiverFunction" value="异常值"' + CheckBoxValue("LiverFunction", "异常值") + '>异常值');
    lodop.ADD_PRINT_TEXT(630, 300, 30, 15, "ALT");
    lodop.ADD_PRINT_LINE(645, 330, 645, 360, 0, 1);
    lodop.ADD_PRINT_TEXT(630, 335, 30, 15, $("#ALT").val());
    lodop.ADD_PRINT_TEXT(630, 360, 30, 15, "u/L");
    lodop.ADD_PRINT_TEXT(630, 390, 40, 15, "AST");
    lodop.ADD_PRINT_LINE(645, 420, 645, 450, 0, 1);
    lodop.ADD_PRINT_TEXT(630, 425, 30, 15, $("#AST").val());
    lodop.ADD_PRINT_TEXT(630, 450, 30, 15, "u/L");
    lodop.ADD_PRINT_TEXT(630, 480, 30, 15, "TP");
    lodop.ADD_PRINT_LINE(645, 500, 645, 530, 0, 1);
    lodop.ADD_PRINT_TEXT(630, 505, 30, 15, $("#TP").val());
    lodop.ADD_PRINT_TEXT(630, 530, 30, 15, "g/L");
    lodop.ADD_PRINT_TEXT(630, 560, 40, 15, "ALB");
    lodop.ADD_PRINT_LINE(645, 590, 645, 620, 0, 1);
    lodop.ADD_PRINT_TEXT(630, 595, 30, 15, $("#ALB").val());
    lodop.ADD_PRINT_TEXT(630, 620, 30, 15, "g/L");
    lodop.ADD_PRINT_TEXT(630, 650, 40, 15, "TBIL");
    lodop.ADD_PRINT_LINE(645, 680, 645, 710, 0, 1);
    lodop.ADD_PRINT_TEXT(630, 685, 30, 15, $("#TBIL").val());
    lodop.ADD_PRINT_TEXT(630, 710, 60, 15, "umol/L");

    lodop.ADD_PRINT_TEXT(660, 10, 100, 15, "肾功能：");
    lodop.ADD_PRINT_HTM(660, 110, 60, 20, '<input type="checkbox" class="RenalFunction" value="未做"' + CheckBoxValue("RenalFunction", "未做") + '>未做');
    lodop.ADD_PRINT_HTM(660, 170, 60, 20, '<input type="checkbox" class="RenalFunction" value="正常"' + CheckBoxValue("RenalFunction", "正常") + '>正常');
    lodop.ADD_PRINT_HTM(660, 230, 70, 20, '<input type="checkbox" class="RenalFunction" value="异常值"' + CheckBoxValue("RenalFunction", "异常值") + '>异常值');
    lodop.ADD_PRINT_TEXT(660, 300, 50, 15, "UREA");
    lodop.ADD_PRINT_LINE(675, 340, 675, 380, 0, 1);
    lodop.ADD_PRINT_TEXT(660, 345, 40, 15, $("#UREA").val());
    lodop.ADD_PRINT_TEXT(660, 380, 60, 15, "mmol/L");
    lodop.ADD_PRINT_TEXT(660, 440, 50, 15, "CREA");
    lodop.ADD_PRINT_LINE(675, 480, 675, 520, 0, 1);
    lodop.ADD_PRINT_TEXT(660, 485, 40, 15, $("#CREA").val());
    lodop.ADD_PRINT_TEXT(660, 520, 60, 15, "mmol/L");
    lodop.ADD_PRINT_TEXT(660, 580, 30, 15, "UA");
    lodop.ADD_PRINT_LINE(675, 600, 675, 640, 0, 1);
    lodop.ADD_PRINT_TEXT(660, 605, 40, 15, $("#UA").val());
    lodop.ADD_PRINT_TEXT(660, 640, 60, 15, "mmol/L");

    lodop.ADD_PRINT_TEXT(690, 10, 100, 15, "凝血功能：");
    lodop.ADD_PRINT_HTM(690, 110, 60, 20, '<input type="checkbox" class="BloodCoagulation" value="未做"' + CheckBoxValue("BloodCoagulation", "未做") + '>未做');
    lodop.ADD_PRINT_HTM(690, 170, 60, 20, '<input type="checkbox" class="BloodCoagulation" value="正常"' + CheckBoxValue("BloodCoagulation", "正常") + '>正常');
    lodop.ADD_PRINT_HTM(690, 230, 70, 20, '<input type="checkbox" class="BloodCoagulation" value="异常值"' + CheckBoxValue("BloodCoagulation", "异常值") + '>异常值');
    lodop.ADD_PRINT_TEXT(690, 300, 30, 15, "PT");
    lodop.ADD_PRINT_LINE(705, 320, 705, 350, 0, 1);
    lodop.ADD_PRINT_TEXT(690, 325, 30, 15, $("#PT").val());
    lodop.ADD_PRINT_TEXT(690, 350, 30, 15, "sec");
    lodop.ADD_PRINT_TEXT(690, 390, 40, 15, "FIB");
    lodop.ADD_PRINT_LINE(705, 420, 705, 450, 0, 1);
    lodop.ADD_PRINT_TEXT(690, 425, 30, 15, $("#FIB").val());
    lodop.ADD_PRINT_TEXT(690, 450, 30, 15, "g/L");
    lodop.ADD_PRINT_TEXT(690, 480, 30, 15, "PTT");
    lodop.ADD_PRINT_LINE(705, 500, 705, 530, 0, 1);
    lodop.ADD_PRINT_TEXT(690, 505, 30, 15, $("#PTT").val());
    lodop.ADD_PRINT_TEXT(690, 530, 30, 15, "sec");
    lodop.ADD_PRINT_TEXT(690, 560, 30, 15, "TT");
    lodop.ADD_PRINT_LINE(705, 580, 705, 610, 0, 1);
    lodop.ADD_PRINT_TEXT(690, 585, 30, 15, $("#TT").val());
    lodop.ADD_PRINT_TEXT(690, 610, 30, 15, "sec");

    lodop.ADD_PRINT_TEXT(720, 10, 100, 15, "血常规：");
    lodop.ADD_PRINT_HTM(720, 110, 60, 20, '<input type="checkbox" class="CBC" value="未做"' + CheckBoxValue("CBC", "未做") + '>未做');
    lodop.ADD_PRINT_HTM(720, 170, 60, 20, '<input type="checkbox" class="CBC" value="正常"' + CheckBoxValue("CBC", "正常") + '>正常');
    lodop.ADD_PRINT_HTM(720, 230, 70, 20, '<input type="checkbox" class="CBC" value="异常值"' + CheckBoxValue("CBC", "异常值") + '>异常值');
    lodop.ADD_PRINT_TEXT(720, 300, 40, 20, "WBC");
    lodop.ADD_PRINT_LINE(735, 330, 735, 360, 0, 1);
    lodop.ADD_PRINT_TEXT(720, 335, 30, 15, $("#WBC").val());
    lodop.ADD_PRINT_HTM(720, 360, 50, 20, '<small>x10<sup>9</sup>/L</small>')
    lodop.ADD_PRINT_TEXT(720, 410, 30, 15, "HB");
    lodop.ADD_PRINT_LINE(735, 430, 735, 460, 0, 1);
    lodop.ADD_PRINT_TEXT(720, 435, 30, 15, $("#HB").val());
    lodop.ADD_PRINT_TEXT(720, 460, 30, 15, "g/L");
    lodop.ADD_PRINT_TEXT(720, 490, 40, 15, "HCT");
    lodop.ADD_PRINT_LINE(735, 520, 735, 550, 0, 1);
    lodop.ADD_PRINT_TEXT(720, 525, 30, 15, $("#HCT").val());
    //lodop.ADD_PRINT_TEXT(720,530,30,15,"sec");
    lodop.ADD_PRINT_TEXT(720, 560, 30, 15, "PLT");
    lodop.ADD_PRINT_LINE(735, 590, 735, 620, 0, 1);
    lodop.ADD_PRINT_TEXT(720, 595, 30, 15, $("#PLT").val());
    lodop.ADD_PRINT_HTM(720, 620, 50, 20, '<small>x10<sup>9</sup>/L</small>')

    lodop.ADD_PRINT_TEXT(750, 10, 100, 15, "生化：");
    lodop.ADD_PRINT_HTM(750, 110, 60, 20, '<input type="checkbox" class="Biochemistry" value="未做"' + CheckBoxValue("Biochemistry", "未做") + '>未做');
    lodop.ADD_PRINT_HTM(750, 170, 60, 20, '<input type="checkbox" class="Biochemistry" value="正常"' + CheckBoxValue("Biochemistry", "正常") + '>正常');
    lodop.ADD_PRINT_HTM(750, 230, 70, 20, '<input type="checkbox" class="Biochemistry" value="异常值"' + CheckBoxValue("Biochemistry", "异常值") + '>异常值');
    lodop.ADD_PRINT_TEXT(750, 300, 40, 15, "GLU");
    lodop.ADD_PRINT_LINE(765, 330, 765, 360, 0, 1);
    lodop.ADD_PRINT_TEXT(750, 335, 40, 15, $("#GLU").val());
    lodop.ADD_PRINT_TEXT(750, 360, 60, 15, "mmol/L");
    lodop.ADD_PRINT_TEXT(750, 420, 20, 15, "K");
    lodop.ADD_PRINT_LINE(765, 430, 765, 460, 0, 1);
    lodop.ADD_PRINT_TEXT(750, 435, 40, 15, $("#K").val());
    lodop.ADD_PRINT_TEXT(750, 460, 60, 15, "mmol/L");
    lodop.ADD_PRINT_TEXT(750, 520, 30, 15, "Ca");
    lodop.ADD_PRINT_LINE(765, 540, 765, 570, 0, 1);
    lodop.ADD_PRINT_TEXT(750, 545, 40, 15, $("#Ca").val());
    lodop.ADD_PRINT_TEXT(750, 570, 60, 15, "mmol/L");
    lodop.ADD_PRINT_TEXT(750, 630, 30, 15, "Na");
    lodop.ADD_PRINT_LINE(765, 650, 765, 680, 0, 1);
    lodop.ADD_PRINT_TEXT(750, 655, 30, 15, $("#Na").val());
    lodop.ADD_PRINT_TEXT(750, 680, 60, 15, "mmol/L");

    lodop.ADD_PRINT_TEXT(780, 10, 80, 15, "ASA分级");
    lodop.ADD_PRINT_LINE(795, 70, 795, 180, 0, 1);
    lodop.ADD_PRINT_TEXT(780, 75, 110, 15, $("#ASAClass").combobox("getValue"));
    lodop.ADD_PRINT_HTM(780, 190, 60, 20, '<input type="checkbox" id="SourceType" name="SourceType" value="E"' + $("#SourceType").attr("checked") + '>E');
    lodop.ADD_PRINT_TEXT(780, 250, 90, 15, "心功能评级");
    lodop.ADD_PRINT_LINE(795, 320, 795, 430, 0, 1);
    lodop.ADD_PRINT_TEXT(780, 325, 110, 15, $("#HeartFunctionClass").combobox("getValue"));
    lodop.ADD_PRINT_TEXT(780, 460, 50, 15, "血型");
    lodop.ADD_PRINT_LINE(795, 490, 795, 600, 0, 1);
    lodop.ADD_PRINT_TEXT(780, 495, 110, 15, $("#BloodType").combobox("getValue"));
    lodop.ADD_PRINT_TEXT(780, 610, 50, 15, "RH");
    lodop.ADD_PRINT_LINE(795, 630, 795, 740, 0, 1);
    lodop.ADD_PRINT_TEXT(780, 635, 110, 15, $("#RHBloodType").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(810, 10, 100, 15, "Mallampati分级");
    lodop.ADD_PRINT_LINE(825, 100, 825, 210, 0, 1);
    lodop.ADD_PRINT_TEXT(810, 105, 110, 15, $("#MallampatiClass").combobox("getValue"));
    lodop.ADD_PRINT_TEXT(810, 230, 60, 15, "牙齿：");
    lodop.ADD_PRINT_HTM(810, 290, 60, 20, '<input type="checkbox" class="Tooth" value="正常"' + CheckBoxValue("Tooth", "正常") + '>正常');
    lodop.ADD_PRINT_HTM(810, 350, 60, 20, '<input type="checkbox" class="Tooth" value="松动"' + CheckBoxValue("Tooth", "松动") + '>松动');
    lodop.ADD_PRINT_HTM(810, 410, 60, 20, '<input type="checkbox" class="Tooth" value="缺失"' + CheckBoxValue("Tooth", "缺失") + '>缺失');
    lodop.ADD_PRINT_HTM(810, 470, 60, 20, '<input type="checkbox" class="Tooth" value="戴冠"' + CheckBoxValue("Tooth", "戴冠") + '>戴冠');

    lodop.ADD_PRINT_HTM(840, 10, 100, 20, '<input type="checkbox" id="MouseOpen" name="MouseOpen" value="张口小于3cm"' + $("#MouseOpen").attr("checked") + '>张口&lt;3cm');
    lodop.ADD_PRINT_HTM(840, 100, 60, 20, '<input type="checkbox" id="Brevicollis" name="Brevicollis" value="短颈"' + $("#Brevicollis").attr("checked") + '>短颈');
    lodop.ADD_PRINT_HTM(840, 150, 90, 20, '<input type="checkbox" id="Hypsokinesis" name="Hypsokinesis" value="后仰受限"' + $("#Hypsokinesis").attr("checked") + '>后仰受限');
    lodop.ADD_PRINT_HTM(840, 230, 70, 20, '<input type="checkbox" id="Micromandible" name="Micromandible" value="小下颌"' + $("#Micromandible").attr("checked") + '>小下颌');
    lodop.ADD_PRINT_HTM(840, 290, 120, 20, '<input type="checkbox" id="TrachealDisplacement" name="TrachealDisplacement" value="气管移位/受压" ' + $("#TrachealDisplacement").attr("checked") + '>气管移位/受压');
    lodop.ADD_PRINT_HTM(840, 400, 120, 20, '<input type="checkbox" id="AirwayTumor" name="AirwayTumor" value="气道肿瘤/异物" class="form-item" ' + $("#AirwayTumor").attr("checked") + '>气道肿瘤/异物');
    lodop.ADD_PRINT_HTM(840, 510, 60, 20, '<input type="checkbox" id="OtherIllness" name="OtherIllness" value="其他"' + $("#OtherIllness").attr("checked") + '>其他');
    lodop.ADD_PRINT_LINE(855, 560, 855, 770, 0, 1);
    lodop.ADD_PRINT_TEXT(840, 565, 200, 15, $("#AddlIllness").combobox("getValue"));

    lodop.ADD_PRINT_TEXT(870, 10, 100, 20, "麻醉方案：")
    lodop.ADD_PRINT_HTM(870, 110, 100, 20, '<input type="checkbox" class="AnaestMethod" value="全身麻醉"' + CheckBoxValue("AnaestMethod", "全身麻醉") + '>全身麻醉 (');
    lodop.ADD_PRINT_HTM(870, 210, 140, 20, '<input type="checkbox" class="AnaestMethod" value="气管插管"' + CheckBoxValue("AnaestMethod", "气管插管") + '>气管/支气管插管');
    lodop.ADD_PRINT_HTM(870, 350, 60, 20, '<input type="checkbox" class="AnaestMethod" value="喉罩"' + CheckBoxValue("AnaestMethod", "喉罩") + '>喉罩)');
    lodop.ADD_PRINT_HTM(870, 410, 100, 20, '<input type="checkbox" class="AnaestMethod" value="椎管内麻醉"' + CheckBoxValue("AnaestMethod", "椎管内麻醉") + '>椎管内麻醉');
    lodop.ADD_PRINT_HTM(870, 510, 120, 20, '<input type="checkbox" class="AnaestMethod" value="神经阻滞麻醉"' + CheckBoxValue("AnaestMethod", "神经阻滞麻醉") + '>神经阻滞麻醉');
    lodop.ADD_PRINT_HTM(870, 630, 60, 20, '<input type="checkbox" class="AnaestMethod" value="MAC"' + CheckBoxValue("AnaestMethod", "MAC") + '>MAC');
    lodop.ADD_PRINT_HTM(870, 680, 60, 20, '<input type="checkbox" class="AnaestMethod" value="局麻"' + CheckBoxValue("AnaestMethod", "局麻") + '>局麻');

    lodop.ADD_PRINT_TEXT(900, 10, 130, 15, "其他特殊情况：");
    lodop.ADD_PRINT_HTM(920, 10, 770, 60, '<textarea id="SpecialConditions" name="SpecialConditions" class="form-item" data-rowId="" style="width:100%;height:100%">' + $("#SpecialConditions").text() + '</textarea>');
    lodop.ADD_PRINT_TEXT(980, 10, 180, 15, "术中可能出现的情况及处理");
    lodop.ADD_PRINT_HTM(1000, 10, 770, 60, '<textarea id="OperatingConditions" name="OperatingConditions" class="form-item" data-rowId="" style="width:100%;height:100%">' + $("#OperatingConditions").text() + '</textarea>');

}