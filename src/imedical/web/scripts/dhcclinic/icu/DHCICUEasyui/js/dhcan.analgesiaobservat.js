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

/**
 * 加载手术病人默认信息
 */
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
    console.log(operApplicationInfo[0]);
    $("#patientForm").form("load", operApplicationInfo[0]);
}
/**
 * yq 20171108 获取要保存的信息
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
                dataValue = $(this).datatimebox("getValue");
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
/**
 * yq 20171108加载DHCAN.OperData表的信息
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

/**
 * chechbox20171109不可多选设置
 */
$(".form-item").each(function() {
    var id = $(this).attr("id"),
        clsSelector = "." + id,
        selector = "#" + id,
        multiple = $(this).attr("data-multiple");
    if ($(clsSelector).length > 0) {
        $(clsSelector).click(function() {
            var thisValue = $(this).val(),
                checked = $(this).prop("checked"),
                selector = "#" + $(this)[0].className.replace(".", "#"),
                multiple = $(selector).attr("data-multiple");
            if (multiple == "false" && checked) {
                $(clsSelector).each(function() {
                    if ($(this).val() != thisValue) {
                        $(this).prop("checked", false);
                    }
                });
            }
        });
    }
});
/**
 * yq 20171109输入工号回车显示姓名
 */
$(".sign").each(function(i, obj) {
    $(this).keypress(function(e) {
        if (e.keyCode == 13) {
            $.post(dhccl.csp.methodService, {
                ClassName: "DHCCL.Admission",
                MethodName: "GetUserInfoByInitials",
                Arg1: $(this).val(),
                ArgCnt: 1
            }, function(data) {
                var datalist = data.split("^")
                var type = $.trim(datalist[0]);
                type = type.toLowerCase();
                if ($("#" + obj.id).hasClass(type)) {
                    $("#" + obj.id).val(datalist[4]);
                } else {
                    $.messager.alert("错误", "用户类型不对应！", "error", function() {
                        $("#" + obj.id).val("");
                        $("#" + obj.id).focus();
                    })
                }

            })
        }
    })
})

/**
 * yq 20171109 lodop打印
 */
function createPrintOnePage() {
    var lodop = getLodop();
    lodop.PRINT_INIT("打印镇痛观察记录单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    var printStyleCss = '<link rel="stylesheet" type="text/css" href="../service/dhcanop/css/analgesiaobservat.css"/>'
    printStyleCss += '<link rel="stylesheet" type="text/css" href="../service/dhcanop/css/analgesiaobservatprint.css"/>'
        //var style='<style>.line-textbox {border-left: none;border-right: none;border-top: none;border-bottom: 1px solid;background-color: transparent;style}</style>'
    $(".line-textbox").each(function(i, obj) {
        $(".line-textbox").eq(i).attr("value", obj.value);
    });
    $(":checkbox").each(function(i, obj) {
        $(":checkbox").eq(i).attr("checked", obj.checked);
    });
    $("span.textbox.combo.datebox").find("input.textbox-text.validatebox-text").attr("value", $("span.textbox.combo.datebox").find("input.textbox-value").val());
    // $("span.textbox.combo.datebox").find("input.textbox-value").val();
    /*$("span.textbox.combo.datebox").prop("hidden",true);
    $(".print-textbox,.print-text").attr("type","text");
    $(".print-textbox,.print-text").each(function(){
        var name=$(this).attr("name");
        $(this).attr("value",$("input[type!='checkbox'][name='"+name+"']").val());

    })*/
    var html = $(".sheet").html();
    var html1 = $("#dataForm").find("thead").html();
    console.log(html1);
    lodop.ADD_PRINT_HTML(0, 0, "100%", "100%", printStyleCss + html);
    lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
    lodop.SET_PREVIEW_WINDOW(1, 0, 0, 0, 0, "");
    lodop.PREVIEW();
}