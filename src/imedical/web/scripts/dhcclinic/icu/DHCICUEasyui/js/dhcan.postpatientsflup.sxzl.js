var patientflup = {
    OperSchedule: null
}
$(function() {
    loadApplicationData();
    loadOperDatas();

    $("#btnSave").linkbutton({
        onClick: function() {
            var operDatas = getOperDatas();
            if (operDatas && operDatas.length > 0) {
                var jsonData = dhccl.formatObjects(operDatas);
                $.ajax({
                    url: ANCSP.DataListService,
                    data: {
                        jsonData: jsonData
                    },
                    type: "post",
                    async: false,
                    success: function(data) {
                        dhccl.showMessage(data, "保存", null, null, function() {
                            window.location.reload();
                        });
                    }
                });
            }
        }
    });

    $("#btnPrint").linkbutton({
        onClick: print
    });

    $("#btnRefresh").linkbutton({
        onClick: function() {
            window.location.reload();
        }
    });
})

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
        patientflup.OperSchedule = patient;
        $.each($("#patientInfo").find(".form-item"), function(index, item) {
            var field = $(item).attr('id');
            $(item).text(patient[field] || '');
        });
    }
}

function getOperDatas() {
    var operDatas = new Array(),
        opsId = dhccl.getQueryString("opsId"),
        moduleCode = dhccl.getQueryString("moduleCode");
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
                ClassName: ANCLS.Model.OperData
            });
        }

    });
    return operDatas;
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

function print() {
    var lodop = getLodop();
    createPrintOnePage(lodop);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();
}

function createPrintOnePage(lodop) {
    lodop.PRINT_INIT("打印术后患者随访表");
    lodop.SET_PRINT_PAGESIZE(2, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontName", "宋体");
    lodop.SET_PRINT_STYLE("FontSize", 10);
    lodop.ADD_PRINT_TEXT(20, 20, 1000, 30, "山西省肿瘤医院麻醉科术后患者随访表");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 21); //设置字体
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2) //居中

    var startPos = {
        x: 70,
        y: 80
    }

    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 300, 30, "基本信息");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 13); //设置字体

    startPos.x = 670;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 300, 30, "止疼泵种类：");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 13); //设置字体

    startPos.x += 100;
    lodop.ADD_PRINT_ELLIPSE(startPos.y, startPos.x, 15, 15, 0, 1);
    if (RadioBoxValue("PainPumpType", "普通泵") == 'checked') {
        lodop.ADD_PRINT_TEXT(startPos.y - 5, startPos.x, 20, 20, "√");
        lodop.SET_PRINT_STYLEA(0, "FontSize", 15); //设置字体
        lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    }
    startPos.x += 20;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 300, 30, "普通泵");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 13); //设置字体

    startPos.x += 60;
    lodop.ADD_PRINT_ELLIPSE(startPos.y, startPos.x, 15, 15, 0, 1);
    if (RadioBoxValue("PainPumpType", "电子泵") == 'checked') {
        lodop.ADD_PRINT_TEXT(startPos.y - 5, startPos.x, 20, 20, "√");
        lodop.SET_PRINT_STYLEA(0, "FontSize", 15); //设置字体
        lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    }

    startPos.x += 20;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 300, 30, "电子泵");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 13); //设置字体

    startPos.x += 70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 300, 30, "出室时间：");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 13); //设置字体

    var gridHtml = [];
    var operSchedule = patientflup.OperSchedule;
    gridHtml = [
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:14px;}",
        "th {font-size:14px;font-weight:bold;text-align:center;} tr>td {text-align:center} tr {height:24px;} ",
        "tr {height:35px;} .cell-operation {text-align:left;} table {table-layout:fixed;} .item-desc {width:200px;overflow:hidden;}</style>"
    ];
    gridHtml.push('<table>');
    gridHtml.push('<thead><tr>');
    gridHtml.push('<td style="width:40px;">日期</td>');
    gridHtml.push('<td style="width:60px;">病历号</td>');
    gridHtml.push('<td style="width:70px;">科室</td>');
    gridHtml.push('<td style="width:30px;">床号</td>');
    gridHtml.push('<td style="width:50px;">姓名</td>');
    gridHtml.push('<td style="width:30px;">性别</td>');
    gridHtml.push('<td style="width:30px;">年龄</td>');
    gridHtml.push('<td style="width:40px;">体重(Kg)</td>');
    gridHtml.push('<td style="width:150px;">诊断</td>');
    gridHtml.push('<td style="width:220px;">手术</td>');
    gridHtml.push('<td style="width:40px;">时长(h)</td>');
    gridHtml.push('<td style="width:80px;">术者</td>');
    gridHtml.push('<td style="width:60px;">麻醉师</td>');
    gridHtml.push('</tr></thead>');
    gridHtml.push('<tbody>');
    gridHtml.push('<tr>');
    gridHtml.push('<td>' + operSchedule.OperDate + '</td>');
    gridHtml.push('<td>' + operSchedule.MedcareNo + '</td>');
    gridHtml.push('<td>' + operSchedule.PatDeptDesc + '</td>');
    gridHtml.push('<td>' + operSchedule.PatBedCode + '</td>');
    gridHtml.push('<td>' + operSchedule.PatName + '</td>');
    gridHtml.push('<td>' + operSchedule.PatGender + '</td>');
    gridHtml.push('<td>' + operSchedule.PatAge + '</td>');
    gridHtml.push('<td>' + operSchedule.PatWeight + '</td>');
    gridHtml.push('<td>' + operSchedule.PrevDiagnosisDesc + '</td>');
    gridHtml.push('<td>' + operSchedule.OperationDesc + '</td>');
    gridHtml.push('<td>' + operSchedule.OperDuration + '</td>');
    gridHtml.push('<td>' + operSchedule.SurCareProv + '</td>');
    gridHtml.push('<td>' + operSchedule.AnesthesiologistDesc + '</td>');
    gridHtml.push('</tr>');
    gridHtml.push('</tbody></table>');

    startPos.x = 70;
    startPos.y += 40;
    lodop.ADD_PRINT_TABLE(startPos.y, startPos.x, "RightMargin:0.8cm", 850, gridHtml.join(''));

    startPos.y += 120;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 300, 30, "用药信息");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 13); //设置字体

    gridHtml = [
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:14px;}",
        "th {font-size:14px;font-weight:bold;text-align:center;} tr>td {text-align:center} tr {height:24px;} ",
        "tr {height:35px;} .cell-operation {text-align:left;} table {table-layout:fixed;} .item-desc {width:200px;overflow:hidden;}</style>"
    ];
    gridHtml.push('<table>');
    gridHtml.push('<thead><tr>');
    gridHtml.push('<td style="width:200px;">麻醉前</td>');
    gridHtml.push('<td style="width:200px;">诱导</td>');
    gridHtml.push('<td style="width:200px;">维持</td>');
    gridHtml.push('<td style="width:200px;">术后负荷剂量</td>');
    gridHtml.push('<td style="width:200px;">止疼泵配方（   ）</td>');
    gridHtml.push('</tr></thead>');
    gridHtml.push('<tbody>');
    gridHtml.push('<tr style="height:100px;">');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('</tr>');
    gridHtml.push('</tbody></table>');

    startPos.y += 40;
    lodop.ADD_PRINT_TABLE(startPos.y, startPos.x, "RightMargin:0.8cm", 850, gridHtml.join(''));

    startPos.y += 180;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 300, 30, "随访信息");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 13); //设置字体

    gridHtml = [
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:14px;}",
        "th {font-size:14px;font-weight:bold;text-align:center;} tr>td {text-align:center} tr {height:24px;} ",
        "tr {height:35px;} .cell-operation {text-align:left;} table {table-layout:fixed;} .item-desc {width:200px;overflow:hidden;}</style>"
    ];
    gridHtml.push('<table>');
    gridHtml.push('<thead><tr>');
    gridHtml.push('<td style="width:60px;" rowspan=2>术后时间</td>');
    gridHtml.push('<td colspan=3>生命体征</td>');
    gridHtml.push('<td style="width:60px;" rowspan=2>疼痛评分<br/>(0-10分)</td>');
    gridHtml.push('<td style="width:60px;" rowspan=2>镇静评分<br/>(1-5分)</td>');
    gridHtml.push('<td colspan=7>不<span style="width:30px;"/>良<span style="width:30px;"/>反<span style="width:30px;"/>应</td>');
    gridHtml.push('<td style="width:90px;" rowspan=2>术中知晓<br/>【无 (0)；<br/>听觉 (1)；<br/>痛觉 (2)】</td>');
    gridHtml.push('</tr></tr>');
    gridHtml.push('<td style="width:80px;">血压<br/>(mmHg)</td>');
    gridHtml.push('<td style="width:60px;">脉搏<br/>(次/min)</td>');
    gridHtml.push('<td style="width:60px;">氧饱和度</td>');
    gridHtml.push('<td style="width:70px;">头晕<br/> 【有 (1)；<br/>无 (0)】</td>');
    gridHtml.push('<td style="width:70px;">恶心呕吐<br/>（0-10分）</td>');
    gridHtml.push('<td style="width:70px;">瘙痒<br/>（0-10分）</td>');
    gridHtml.push('<td style="width:70px;">出汗<br/>【有 (1)；<br/>无 (0)】</td>');
    gridHtml.push('<td style="width:70px;">尿潴留<br/>【有 (1)；<br/>无 (0)】</td>');
    gridHtml.push('<td style="width:70px;">运动障碍<br/>(0-2分)</td>');
    gridHtml.push('<td style="width:70px;">感觉异常<br/>【有 (1)；<br/>无 (0)】</td>');
    gridHtml.push('</tr></thead>');
    gridHtml.push('<tbody>');
    gridHtml.push('<tr style="height:50px;">');
    gridHtml.push('<td>术后__小时</td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('</tr>');
    gridHtml.push('<tr style="height:50px;">');
    gridHtml.push('<td>术后__小时</td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('<td></td>');
    gridHtml.push('</tr>');
    gridHtml.push('</tbody></table>');

    startPos.y += 40;
    lodop.ADD_PRINT_TABLE(startPos.y, startPos.x, "RightMargin:0.8cm", 850, gridHtml.join(''));
}

function RadioBoxValue(ClassName, value) {
    var result = "unchecked";
    var length = $("." + ClassName).size();
    for (var i = 0; i < length; i++) {
        if (($("." + ClassName).eq(i).val() == value) && ($("." + ClassName).eq(i).radio("getValue"))) {
            result = "checked";
            break;
        }
    }
    return result;
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