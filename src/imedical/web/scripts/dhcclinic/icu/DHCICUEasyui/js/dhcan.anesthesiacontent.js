$(function() {
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
                        dhccl.showMessage(data, "保存", null, null, function() {
                            window.location.reload();
                        });
                    }
                });
            }
        }
    });
    $("#btnPrint").linkbutton({
        onClick: function() {
            createPrintOnePage();
        }
    })

})

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
    // console.log(operApplicationInfo[0]);
    $("#patientForm").form("load", operApplicationInfo[0]);
}

function loadOperDatas() {
    var opsId = dhccl.getQueryString("opsId"),
        moduleId = dhccl.getQueryString("moduleId");
    var operDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: "DHCAN.BLL.DataQuery",
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
                        } else if ($(selector).hasClass("textarea")) {
                            $(selector).text(operData.DataValue);
                        } else if ($(selector).hasClass("easyui-datetimebox")) {
                            $(selector).datetimebox("setValue", operData.DataValue);

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
                if ($(this)[0].type == "checkbox" && $(this).prop("checked") == true) {
                    if (dataValue != "") {
                        dataValue += splitChar
                    }
                    dataValue += $(this).val();
                }
            });
        } else {
            if ($(this)[0].type == "checkbox") {
                if ($(this).prop("checked") == true) {
                    dataValue = $(this).val();
                } else {
                    dataValue = "";
                }
            } else if ($(selector).hasClass("textarea")) {
                dataValue = $(this).text();
            } else if ($(selector).hasClass("easyui-datetimebox")) {
                dataValue = $(this).datetimebox("getValue");
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

function createPrintOnePage() {
    var lodop = getLodop();
    lodop.PRINT_INIT("打印手术知情同意书");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    var printStyleCss = '<link rel="stylesheet" type="text/css" href="../service/dhcanop/css/anesthesiaconsent.css"/>'
    $(".line-textbox").each(function(i, obj) {
        $(".line-textbox").eq(i).attr("value", obj.value);
    });
    $(":checkbox").each(function(i, obj) {
        $(":checkbox").eq(i).attr("checked", obj.checked);
    });
    var html = $(".sheet").html();
    lodop.ADD_PRINT_HTM(0, 0, "100%", "100%", printStyleCss + html);
    lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
    lodop.SET_PREVIEW_WINDOW(1, 0, 0, 0, 0, "");
    lodop.PREVIEW();
}