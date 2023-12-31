$(function() {
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
                        dhccl.showMessage(data, "淇濆瓨", null, null, function() {
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

});

/**
 * yq 20171108 鑾峰彇瑕佷繚瀛樼殑淇℃伅
 */
function getOperDatas() {
    var operDatas = new Array(),
        opsId = dhccl.getQueryString("opsId"),
        moduleId = dhccl.getQueryString("moduleId");
    $(".form-item").each(function() {
        var id = $(this).attr("id"),
            selector = "." + id,
            dataValue = "",
            splitChar = ",";
        var idselector = "#" + id;
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
            } else if ($(idselector).hasClass("textarea")) {
                dataValue = $(this).text();
            } else if ($(idselector).hasClass("easyui-datetimebox")) {
                dataValue = $(this).datetimebox("getValue");
            } else if ($(idselector).hasClass("easyui-combobox")) {
                dataValue = $(this).combobox("getValue");
            } else if ($(idselector).hasClass("easyui-timespinner")) {
                dataValue = $(this).timespinner("getValue");
            } else {
                dataValue = $(this).val();
            }
        }
        if ($(this).attr("data-rowid") != "" || (dataValue != "") && (dataValue != null)) {
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

/**
 * yq 20171108鍔犺浇DHCAN.OperData琛ㄧ殑淇℃伅
 */
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
                    if (($(clsSelector).length > 0) && ($(clsSelector).length < 2)) {
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
                        } else if ($(selector).hasClass("easyui-timespinner")) {
                            $(selector).timespinner("setValue", operData.DataValue);
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

/**
 * yq 20171109 lodop鎵撳嵃
 */
function createPrintOnePage() {
    var lodop = getLodop();
    lodop.PRINT_INIT("鎵撳嵃鎵嬫湳鎶ょ悊璁板綍鍗?);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    var printStyleCss = '<link rel="stylesheet" type="text/css" href="../service/dhcanop/css/nurserecord.css"/>'
    printStyleCss += '<link rel="stylesheet" type="text/css" href="../service/dhcanop/css/nurserecordprint.css"/>'
        //var style='<style>.line-textbox {border-left: none;border-right: none;border-top: none;border-bottom: 1px solid;background-color: transparent;style}</style>'
        /*$(".line-textbox").each(function(i,obj){
            $(".line-textbox").eq(i).attr("value",obj.value);
        });*/
    $(":checkbox").each(function(i, obj) {
        $(":checkbox").eq(i).attr("checked", obj.checked);
    });
    //$("span.textbox.combo.datebox").find("input.textbox-text.validatebox-text").attr("value",$("span.textbox.combo.datebox").find("input.textbox-value").val());
    $("span.textbox").each(function() {
        console.log($(this));
        $(this).find("input.textbox-text.validatebox-text").attr("value", $(this).find("input.textbox-value").val());
    });

    var html = $("#dataTools").html();
    lodop.ADD_PRINT_HTML(0, 0, "100%", "100%", printStyleCss + html);
    lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
    lodop.SET_PREVIEW_WINDOW(1, 0, 0, 0, 0, "");
    lodop.PREVIEW();
}