$(document).ready(function() {
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
                        jsonData: jsonData,
                        ClassName: ANCLS.BLL.OperData,
                        MethodName: "SaveOperDatas"
                    },
                    type: "post",
                    async: false,
                    success: function(data) {
                        dhccl.showMessage(data, "保存", null, null, function() {
                            // window.location.reload();
                            loadOperDatas();
                        });
                    }
                });
            }
        }
    });

    $("#btnPrint").linkbutton({
        onClick: printpatienthandover
    });

    $("#DrugUom").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindUom";
            param.Arg1 = param.q ? param.q : "";
            param.ArgCnt = 0;
        }
    });

    $("#DrugDataOption").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataOptions";
            param.Arg1 = "SurgeonDrug";
            param.ArgCnt = 1;
        }
    });

    $("#SkinSite").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataOptions";
            param.Arg1 = "PressureSoreSite";
            param.ArgCnt = 1;
        }
    });

    $("#btnPreDrugOther").linkbutton({
        onClick: function() {
            $("#drugDialog").dialog("open");
        }
    });

    $("#btnPreSkinOther").linkbutton({
        onClick: function() {
            $("#skinDialog").dialog("open");
        }
    });

    $("#btnPostDrugOther").linkbutton({
        onClick: function() {
            $("#drugDialog").dialog("open");
        }
    });

    $("#btnPostSkinOther").linkbutton({
        onClick: function() {
            $("#skinDialog").dialog("open");
        }
    });

    var drugColumns = [
        [
            { field: "DrugItem", title: "名称", width: 200 },
            { field: "Qty", title: "数量", width: 80 },
            { field: "UomDesc", title: "单位", width: 80 }
        ]
    ];

    var drugDataForm = new DataForm({
        datagrid: $("#drugBox"),
        gridColumns: drugColumns,
        gridTitle: "",
        gridTool: "#drugTools",
        form: $("#drugForm"),
        modelType: ANCLS.Model.OperDrugData,
        queryType: ANCLS.BLL.DataQueries,
        queryName: "FindOperDrugData",
        dialog: null,
        addButton: $("#btnAddDrug"),
        editButton: $("#btnEditDrug"),
        delButton: $("#btnDelDrug"),
        onSubmitCallBack: initDrugParam,
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    drugDataForm.initDataForm();
    drugDataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = session.RecordSheetID;
            param.Arg2 = "PreDrugOther";
            param.ArgCnt = 2;
        },
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length > 0) {
                var drugDataInfo = [];
                for (var i = 0; i < data.rows.length; i++) {
                    var drugData = data.rows[i];
                    if (drugDataInfo.length > 0) {
                        drugDataInfo.push("；");
                    }
                    drugDataInfo.push(drugData.DrugItem + " " + drugData.Qty + drugData.UomDesc);
                }
                $("#PreDrugOther").val(drugDataInfo.join(""));
            }
        }
    });

    //皮肤情况
    var skinColumns = [
        [
            { field: "BodySiteDesc", title: "部位", width: 120 },
            { field: "Area", title: "面积", width: 120 },
            { field: "Period", title: "分期", width: 120 }
        ]
    ];
    var skinDataForm = new DataForm({
        datagrid: $("#skinBox"),
        gridColumns: skinColumns,
        gridTitle: "",
        gridTool: "#skinTools",
        form: $("#skinForm"),
        modelType: ANCLS.Model.SkinCondition,
        queryType: ANCLS.BLL.DataQueries,
        queryName: "FindSkinCondition",
        dialog: null,
        addButton: $("#btnAddSkinCondition"),
        editButton: $("#btnEditSkinCondition"),
        delButton: $("#btnDelSkinCondition"),
        onSubmitCallBack: initSkinParam,
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    skinDataForm.initDataForm();
    skinDataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = session.RecordSheetID;
            param.Arg2 = "PreSkinOther";
            param.ArgCnt = 2;
        },
        onLoadSuccess: function(data) {
            // 如果取到数据，为皮肤其他情况文本框赋值。
            if (data && data.rows && data.rows.length > 0) {
                var skinDataInfo = [];
                for (var i = 0; i < data.rows.length; i++) {
                    var skinData = data.rows[i];
                    if (skinDataInfo.length > 0) {
                        skinDataInfo.push("；");
                    }
                    skinDataInfo.push("部位：" + skinData.BodySiteDesc + " 面积：" + skinData.Area + " 分期：" + skinData.Period);
                }
                $("#PreSkinOther").val(skinDataInfo.join(""));
            }
        }
    });

    $(".operdata").each(function() {
        var id = $(this).attr("id"),
            clsSelector = "input[data-formitem='" + id + "']",
            selector = "#" + id,
            multiple = $(this).attr("data-multiple");
        if ($(clsSelector).length > 0) {
            $(clsSelector).checkbox({
                onCheckChange: function(e, value) {
                    var thisValue = $(this).attr("label"),
                        checked = value,
                        selector = "#" + $(this).attr("data-formitem"),
                        multiple = $(selector).attr("data-multiple");
                    if (multiple === "N" && checked) {
                        $(clsSelector).each(function() {
                            if ($(this).attr("label") != thisValue) {
                                $(this).checkbox("setValue", false);
                            }
                        });
                    }
                    if ($(this).attr("data-text")) {
                        if (value) {
                            $("#" + $(this).attr("data-text")).show();
                        } else {
                            $("#" + $(this).attr("data-text")).hide();
                        }
                    }
                }
            });
        }
    });
});

function initDrugParam(param) {
    param.RecordSheet = session.RecordSheetID;
    param.DrugItem = $("#DrugDataOption").combobox("getText");
    param.UpdateUser = session.UserID;
    param.ElementID = "PreDrugOther";
}

function initSkinParam(param) {
    param.RecordSheet = session.RecordSheetID;
    param.UpdateUser = session.UserID;
    param.ElementID = "PreSkinOther";
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
    var operApplication = operApplicationInfo[0];

    $("#PatName").text(operApplication.PatName);
    $("#PatGender").text(operApplication.PatGender);
    $("#PatAge").text(operApplication.PatAge);
    $("#PatDeptDesc").text(operApplication.PatDeptDesc);
    $("#PatWardBed").text(operApplication.PatBedCode);
    $("#MedcareNo").text(operApplication.MedcareNo);
    $("#OperationDesc").text(operApplication.OperationDesc);
    $("#OperDate").text(operApplication.OperDate);
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
                    clsSelector = "input[data-formitem='" + operData.DataItem + "']",
                    dataValue = "," + operData.DataValue + ",";
                if ($(selector).length > 0) {
                    if ($(clsSelector).length > 0) {
                        $(clsSelector).each(function() {
                            if ($(this)[0].type == "checkbox" && dataValue.indexOf("," + $(this).attr("label") + ",") >= 0) {
                                $(this).checkbox("setValue", true);
                                $(this).checkbox("options").checked = true;
                            }
                        });
                    } else {
                        dhccl.setControlValue($(selector), operData.DataValue);
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
    $(".operdata").each(function() {
        var id = $(this).attr("id"),
            selector = "input[data-formitem='" + id + "']",
            dataValue = "",
            splitChar = ",";
        if ($(selector).length > 0) {
            $(selector).each(function() {
                if ($(this)[0].type == "checkbox" && $(this).checkbox("getValue") == true) {
                    if (dataValue != "") {
                        dataValue += splitChar
                    }
                    dataValue += $(this).attr("label");
                }
            });
        } else {
            dataValue = dhccl.getControlValue($(this))
        }
        if ($(this).attr("data-rowid") != "" || dataValue != "" || dataValue != "undefined") {
            operDatas.push({
                RowId: $(this).attr("data-rowid"),
                OPSID: opsId,
                ModuleCode: dhccl.getQueryString("moduleCode"),
                DataItem: id,
                DataValue: dataValue,
                UpdateUserID: session.UserID,
                ClassName: ANCLS.Model.OperData,
                RecordSheet: ""
            });
        }
    });
    return operDatas;
}

function printpatienthandover() {
    var lodop = getLodop();
    createPrintOnePage(lodop);
    lodop.PREVIEW();

}

function createPrintOnePage(lodop) {
    lodop.PRINT_INIT("打印手术患者交接记录单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Auto-Width");
    var printStyleCss = '<link rel="stylesheet" type="text/css" href="../service/dhcanop/css/operriskassessment.css" />';
    var style = '<link rel="stylesheet" type="text/css" href="../service/dhcanop/css/operriskassessmentprint.css" />';
    var title = '<h2 style="text-align:center;">山西省肿瘤医院<br><h3 style="text-align:center">手&nbsp;&nbsp;&nbsp;&nbsp;术&nbsp;&nbsp;&nbsp;&nbsp;患&nbsp;&nbsp;&nbsp;&nbsp;者&nbsp;&nbsp;&nbsp;&nbsp;交&nbsp;&nbsp;&nbsp;&nbsp;接&nbsp;&nbsp;&nbsp;&nbsp;记&nbsp;&nbsp;&nbsp;&nbsp;录&nbsp;&nbsp;&nbsp;&nbsp;单</h3></h2>';
    $(":text").each(function(i, obj) {
        $(":text").eq(i).attr("value", obj.value);
    })
    $(":checkbox").each(function(i, obj) {
        $(":checkbox").eq(i).attr("checked", obj.checked);
    });
    var html = "<head>" + printStyleCss + style + "</head>" + "<body>" + title + $("#patientForm").html() + $("#dataForm").html() + "</body>";
    //lodop.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Full-Page");
    lodop.ADD_PRINT_HTML(0, 0, "100%", "100%", html);

}