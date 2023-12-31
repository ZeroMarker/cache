$(document).ready(function() {
    operDataManager.initFormData(loadApplicationData);
    initPage();
    operDataManager.setCheckChange();
    signCommon.loadSignature();
    dhccl.disableEditControls("#btnPrint,#btnRefresh");
    $("#btnHandOverNurseSign").linkbutton('enable');
});

/**
 * 调用所有页面元素初始化函数
 */
function initPage() {
    initDelegates();
    initDataOptions();
    initDrugDataForm();
    initPostDrugDataForm();
    initSkinDataForm();
    initPostSkinDataForm();
    initSurgicalItem();
    initSkinCondition();
}

/**
 * 初始化所有按钮单击事件
 */
function initDelegates() {
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
        }
    });

    $("#btnPrint").linkbutton({
        onClick: printpatienthandover
    });

    $("#btnRefresh").linkbutton({
        onClick: function() {
            window.location.reload();
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
            $("#postDrugDialog").dialog("open");
        }
    });

    $("#btnPostSkinOther").linkbutton({
        onClick: function() {
            $("#postSkinDialog").dialog("open");
        }
    });

    $("#btnHandOverNurseSign,#btnCircuitNurseSign,#btnPACUWardICUNurseSign,#btnPACUWardICUNurseSign").linkbutton({
        onClick: function() {
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

/**
 * 初始化所有combobox下拉选择项
 */
function initDataOptions() {
    $("#DrugUom,#PostDrugUom").combobox({
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

    $("#DrugDataOption,#PostDrugDataOption").combobox({
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

    $("#SkinSite,#PostSkinSite").combobox({
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


}

function initSurgicalItem() {
    var surgicalItems = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: "FindSurgicalItems",
        Arg1: session.RecordSheetID,
        ArgCnt: 1
    }, "json");
    var preSurgicalItems = [],
        postSurgicalItems = [];
    if (surgicalItems && surgicalItems.length > 0) {
        for (var i = 0; i < surgicalItems.length; i++) {
            var surgicalItem = surgicalItems[i];
            if (surgicalItem.ElementID === "PreSurItem") {
                preSurgicalItems.push(surgicalItem.ItemName);
            } else if (postSurgicalItems === "PostSurItem") {
                postSurgicalItems.push(surgicalItem.ItemName);
            }
        }
        var surgicalItemStr = preSurgicalItems.join(",");
        $("#PreSurItem").val(surgicalItemStr);
        $("#PostSurItem").val(postSurgicalItems.join(","));
    }
}

function initSkinCondition() {
    var skinConditions = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: "FindSkinCondition",
        Arg1: session.RecordSheetID,
        ArgCnt: 1
    }, "json");
    var preSurgicalItems = [],
        postSurgicalItems = [];
    if (skinConditions && skinConditions.length > 0) {
        for (var i = 0; i < skinConditions.length; i++) {
            var surgicalItem = skinConditions[i];
            if (surgicalItem.ElementID === "PreSkinCondition") {
                preSurgicalItems.push(surgicalItem.BodySiteDesc + "(面积:" + surgicalItem.Area + ",分期:" + surgicalItem.Period + ")");
            } else if (postSurgicalItems === "PostSkinCondition") {
                postSurgicalItems.push(surgicalItem.BodySiteDesc + "(面积:" + surgicalItem.Area + ",分期:" + surgicalItem.Period + ")");
            }
        }
        var surgicalItemStr = preSurgicalItems.join(",");
        $("#PreSkinCondition").val(surgicalItemStr);
        $("#PostSkinCondition").val(postSurgicalItems.join(","));
    }
}

/**
 * 初始化术前交接时手术患者用药情况
 */
function initDrugDataForm() {
    // var drugColumns = [
    //     [{
    //             field: "DrugItem",
    //             title: "名称",
    //             width: 200
    //         },
    //         {
    //             field: "Qty",
    //             title: "数量",
    //             width: 80
    //         },
    //         {
    //             field: "UomDesc",
    //             title: "单位",
    //             width: 80
    //         }
    //     ]
    // ];

    // var drugDataForm = new DataForm({
    //     datagrid: $("#drugBox"),
    //     gridColumns: drugColumns,
    //     gridTitle: "",
    //     gridTool: "#drugTools",
    //     form: $("#drugForm"),
    //     modelType: ANCLS.Model.OperDrugData,
    //     queryType: ANCLS.BLL.DataQueries,
    //     queryName: "FindOperDrugData",
    //     dialog: null,
    //     addButton: $("#btnAddDrug"),
    //     editButton: $("#btnEditDrug"),
    //     delButton: $("#btnDelDrug"),
    //     onSubmitCallBack: initDrugParam,
    //     submitCallBack: null,
    //     openCallBack: null,
    //     closeCallBack: null
    // });
    // drugDataForm.initDataForm();
    // drugDataForm.datagrid.datagrid({
    //     onBeforeLoad: function (param) {
    //         param.Arg1 = session.RecordSheetID;
    //         param.Arg2 = "PreDrugOther";
    //         param.ArgCnt = 2;
    //     },
    //     onLoadSuccess: function (data) {
    //         if (data && data.rows && data.rows.length > 0) {
    //             var drugDataInfo = [];
    //             for (var i = 0; i < data.rows.length; i++) {
    //                 var drugData = data.rows[i];
    //                 if (drugDataInfo.length > 0) {
    //                     drugDataInfo.push("；");
    //                 }
    //                 drugDataInfo.push(drugData.DrugItem + " " + drugData.Qty + drugData.UomDesc);
    //             }
    //             $("#PreDrugOther").val(drugDataInfo.join(""));
    //         }
    //     }
    // });

    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: "FindOperDrugData",
        Arg1: session.RecordSheetID,
        Arg2: "PreDrugOther",
        ArgCnt: 2
    }, "json", true, function(datas) {
        if (datas && datas.length > 0) {
            var drugDataInfo = [];
            for (var i = 0; i < datas.length; i++) {
                var drugData = datas[i];
                if (drugDataInfo.length > 0) {
                    drugDataInfo.push("；");
                }
                drugDataInfo.push(drugData.DrugItem + " " + drugData.Qty + (drugData.UomDesc === "" ? drugData.Uom : drugData.UomDesc));
            }
            $("#PreDrugOther").val(drugDataInfo.join(""));
        }
    });
}

/**
 * 初始化术后交接时手术患者用药情况
 */
function initPostDrugDataForm() {
    // var postDrugColumns = [
    //     [{
    //             field: "DrugItem",
    //             title: "名称",
    //             width: 200
    //         },
    //         {
    //             field: "Qty",
    //             title: "数量",
    //             width: 80
    //         },
    //         {
    //             field: "UomDesc",
    //             title: "单位",
    //             width: 80
    //         }
    //     ]
    // ];

    // var postDrugDataForm = new DataForm({
    //     datagrid: $("#postDrugBox"),
    //     gridColumns: postDrugColumns,
    //     gridTitle: "",
    //     gridTool: "#postDrugTools",
    //     form: $("#postDrugForm"),
    //     modelType: ANCLS.Model.OperDrugData,
    //     queryType: ANCLS.BLL.DataQueries,
    //     queryName: "FindOperDrugData",
    //     dialog: null,
    //     addButton: $("#btnAddPostDrug"),
    //     editButton: $("#btnEditPostDrug"),
    //     delButton: $("#btnDelPostDrug"),
    //     onSubmitCallBack: initPostDrugParam,
    //     submitCallBack: null,
    //     openCallBack: null,
    //     closeCallBack: null
    // });
    // postDrugDataForm.initDataForm();
    // postDrugDataForm.datagrid.datagrid({
    //     onBeforeLoad: function (param) {
    //         param.Arg1 = session.RecordSheetID;
    //         param.Arg2 = "PostDrugOther";
    //         param.ArgCnt = 2;
    //     },
    //     onLoadSuccess: function (data) {
    //         if (data && data.rows && data.rows.length > 0) {
    //             var drugDataInfo = [];
    //             for (var i = 0; i < data.rows.length; i++) {
    //                 var drugData = data.rows[i];
    //                 if (drugDataInfo.length > 0) {
    //                     drugDataInfo.push("；");
    //                 }
    //                 drugDataInfo.push(drugData.DrugItem + " " + drugData.Qty + drugData.UomDesc);
    //             }
    //             $("#PostDrugOther").val(drugDataInfo.join(""));
    //         }
    //     }
    // });

    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: "FindOperDrugData",
        Arg1: session.RecordSheetID,
        Arg2: "PostDrugOther",
        ArgCnt: 2
    }, "json", true, function(datas) {
        if (datas && datas.length > 0) {
            var drugDataInfo = [];
            for (var i = 0; i < datas.length; i++) {
                var drugData = datas[i];
                if (drugDataInfo.length > 0) {
                    drugDataInfo.push("；");
                }
                drugDataInfo.push(drugData.DrugItem + " " + drugData.Qty + (drugData.UomDesc === "" ? drugData.Uom : drugData.UomDesc));
            }
            $("#PostDrugOther").val(drugDataInfo.join(""));
        }
    });
}

/**
 * 初始化术前交接时手术患者皮肤情况
 */
function initSkinDataForm() {
    //皮肤情况
    // var skinColumns = [
    //     [{
    //             field: "BodySiteDesc",
    //             title: "部位",
    //             width: 120
    //         },
    //         {
    //             field: "Area",
    //             title: "面积",
    //             width: 120
    //         },
    //         {
    //             field: "Period",
    //             title: "分期",
    //             width: 120
    //         }
    //     ]
    // ];
    // var skinDataForm = new DataForm({
    //     datagrid: $("#skinBox"),
    //     gridColumns: skinColumns,
    //     gridTitle: "",
    //     gridTool: "#skinTools",
    //     form: $("#skinForm"),
    //     modelType: ANCLS.Model.SkinCondition,
    //     queryType: ANCLS.BLL.DataQueries,
    //     queryName: "FindSkinCondition",
    //     dialog: null,
    //     addButton: $("#btnAddSkinCondition"),
    //     editButton: $("#btnEditSkinCondition"),
    //     delButton: $("#btnDelSkinCondition"),
    //     onSubmitCallBack: initSkinParam,
    //     submitCallBack: null,
    //     openCallBack: null,
    //     closeCallBack: null
    // });
    // skinDataForm.initDataForm();
    // skinDataForm.datagrid.datagrid({
    //     onBeforeLoad: function (param) {
    //         param.Arg1 = session.RecordSheetID;
    //         param.Arg2 = "PreSkinOther";
    //         param.ArgCnt = 2;
    //     },
    //     onLoadSuccess: function (data) {
    //         // 如果取到数据，为皮肤其他情况文本框赋值。
    //         if (data && data.rows && data.rows.length > 0) {
    //             var skinDataInfo = [];
    //             for (var i = 0; i < data.rows.length; i++) {
    //                 var skinData = data.rows[i];
    //                 if (skinDataInfo.length > 0) {
    //                     skinDataInfo.push("；");
    //                 }
    //                 skinDataInfo.push("部位：" + skinData.BodySiteDesc + " 面积：" + skinData.Area + " 分期：" + skinData.Period);
    //             }
    //             $("#PreSkinOther").val(skinDataInfo.join(""));
    //         }
    //     }
    // });

    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: "FindSkinCondition",
        Arg1: session.RecordSheetID,
        Arg2: "PreSkinOther",
        ArgCnt: 2
    }, "json", true, function(datas) {
        if (datas && datas.length > 0) {
            var skinDataInfo = [];
            for (var i = 0; i < datas.length; i++) {
                var skinData = datas[i];
                if (skinDataInfo.length > 0) {
                    skinDataInfo.push("；");
                }
                skinDataInfo.push(skinData.BodySiteDesc + "(" + skinData.Area + "，" + skinData.Period + "期)");
            }
            $("#SkinCondition").val(skinDataInfo.join(""));
        } else {
            $("#SkinCondition").val("无特殊情况");
        }
    });
}

/**
 * 初始化术后交接时手术患者皮肤情况
 */
function initPostSkinDataForm() {
    // var postSkinColumns = [
    //     [{
    //             field: "BodySiteDesc",
    //             title: "部位",
    //             width: 120
    //         },
    //         {
    //             field: "Area",
    //             title: "面积",
    //             width: 120
    //         },
    //         {
    //             field: "Period",
    //             title: "分期",
    //             width: 120
    //         }
    //     ]
    // ];
    // var postSkinDataForm = new DataForm({
    //     datagrid: $("#postSkinBox"),
    //     gridColumns: postSkinColumns,
    //     gridTitle: "",
    //     gridTool: "#postSkinTools",
    //     form: $("#postSkinForm"),
    //     modelType: ANCLS.Model.SkinCondition,
    //     queryType: ANCLS.BLL.DataQueries,
    //     queryName: "FindSkinCondition",
    //     dialog: null,
    //     addButton: $("#btnAddPostSkinCondition"),
    //     editButton: $("#btnEditPostSkinCondition"),
    //     delButton: $("#btnDelPostSkinCondition"),
    //     onSubmitCallBack: initPostSkinParam,
    //     submitCallBack: null,
    //     openCallBack: null,
    //     closeCallBack: null
    // });
    // postSkinDataForm.initDataForm();
    // postSkinDataForm.datagrid.datagrid({
    //     onBeforeLoad: function (param) {
    //         param.Arg1 = session.RecordSheetID;
    //         param.Arg2 = "PostSkinOther";
    //         param.ArgCnt = 2;
    //     },
    //     onLoadSuccess: function (data) {
    //         // 如果取到数据，为皮肤其他情况文本框赋值。
    //         if (data && data.rows && data.rows.length > 0) {
    //             var skinDataInfo = [];
    //             for (var i = 0; i < data.rows.length; i++) {
    //                 var skinData = data.rows[i];
    //                 if (skinDataInfo.length > 0) {
    //                     skinDataInfo.push("；");
    //                 }
    //                 skinDataInfo.push("部位：" + skinData.BodySiteDesc + " 面积：" + skinData.Area + " 分期：" + skinData.Period);
    //             }
    //             $("#PostSkinOther").val(skinDataInfo.join(""));
    //         }
    //     }
    // });

    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: "FindSkinCondition",
        Arg1: session.RecordSheetID,
        Arg2: "PostSkinOther",
        ArgCnt: 2
    }, "json", true, function(datas) {
        if (datas && datas.length > 0) {
            var skinDataInfo = [];
            for (var i = 0; i < datas.length; i++) {
                var skinData = datas[i];
                if (skinDataInfo.length > 0) {
                    skinDataInfo.push("；");
                }
                skinDataInfo.push(skinData.BodySiteDesc + "(" + skinData.Area + "," + skinData.Period + "期)");
            }
            $("#PostSkinOther").val(skinDataInfo.join(""));
        }
    });
}

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

function initPostDrugParam(param) {
    param.RecordSheet = session.RecordSheetID;
    param.DrugItem = $("#PostDrugDataOption").combobox("getText");
    param.UpdateUser = session.UserID;
    param.ElementID = "PostDrugOther";
}

function initPostSkinParam(param) {
    param.RecordSheet = session.RecordSheetID;
    param.UpdateUser = session.UserID;
    param.ElementID = "PostSkinOther";
}

/**
 * 根据手术申请数据，设置病人信息表单元素的值。
 * @param {object} operApplication 手术申请数据对象
 */
function loadApplicationData(operApplication) {
    if (!operApplication) return;
    $("#PatName").text(operApplication.PatName);
    $("#PatGender").text(operApplication.PatGender);
    $("#PatAge").text(operApplication.PatAge);
    $("#PatDeptDesc").text(operApplication.PatDeptDesc);
    $("#PatWardBed").text(operApplication.PatBedCode);
    $("#MedcareNo").text(operApplication.MedcareNo);
    $("#OperationDesc").text(operApplication.OperInfo);
    $("#OperDate").text(operApplication.OperDate);
}

function printpatienthandover() {
    var lodop = getLodop();
    createPrintOnePage(lodop);
    lodop.PREVIEW();

}

function getChecked(checkboxID) {
    return $("#" + checkboxID).checkbox("getValue") ? "checked" : "";
}

function createPrintOnePage(LODOP) {
    // lodop.PRINT_INIT("打印手术患者交接记录单");
    // lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    // lodop.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Auto-Width");
    // var printStyleCss = '<link rel="stylesheet" type="text/css" href="../service/dhcanop/css/operriskassessment.css" />';
    // var style = '<link rel="stylesheet" type="text/css" href="../service/dhcanop/css/operriskassessmentprint.css" />';
    // var title = '<h2 style="text-align:center;">山西省肿瘤医院<br><h3 style="text-align:center">手&nbsp;&nbsp;&nbsp;&nbsp;术&nbsp;&nbsp;&nbsp;&nbsp;患&nbsp;&nbsp;&nbsp;&nbsp;者&nbsp;&nbsp;&nbsp;&nbsp;交&nbsp;&nbsp;&nbsp;&nbsp;接&nbsp;&nbsp;&nbsp;&nbsp;记&nbsp;&nbsp;&nbsp;&nbsp;录&nbsp;&nbsp;&nbsp;&nbsp;单</h3></h2>';
    // $(":text").each(function(i, obj) {
    //     $(":text").eq(i).attr("value", obj.value);
    // })
    // $(":checkbox").each(function(i, obj) {
    //     $(":checkbox").eq(i).attr("checked", obj.checked);
    // });
    // var html = "<head>" + printStyleCss + style + "</head>" + "<body>" + title + $("#patientForm").html() + $("#dataForm").html() + "</body>";
    // //lodop.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Full-Page");
    // lodop.ADD_PRINT_HTML(0, 0, "100%", "100%", html);
    LODOP.PRINT_INIT("打印麻醉记录单");
    LODOP.SET_PRINT_PAGESIZE(2, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(11, 333, 240, 58, "山西省肿瘤医院\r\n手术患者交接记录单");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(80, 20, 45, 20, "科室:");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXTA("PatDeptDesc", 80, 65, 80, 20, $("#PatDeptDesc").text());
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXT(80, 151, 45, 20, "床号:");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXTA("PatBedCode", 80, 196, 50, 20, $("#PatBedCode").text());
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXT(80, 251, 45, 20, "姓名:");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXTA("PatName", 80, 296, 80, 20, $("#PatName").text());
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXT(80, 378, 60, 20, "住院号:");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXTA("MedcareNo", 80, 439, 80, 20, $("#MedcareNo").text());
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXT(80, 523, 45, 20, "性别:");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXTA("PatGender", 80, 568, 50, 20, $("#PatGender").text());
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXT(80, 622, 45, 20, "年龄:");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXTA("PatAge", 80, 667, 50, 20, $("#PatAge").text());
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXT(80, 717, 80, 20, "手术日期:");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXTA("OperDate", 80, 797, 80, 20, $("#OperDate").text());
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXT(108, 21, 80, 20, "拟施手术:");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);
    LODOP.ADD_PRINT_TEXTA("OperationDesc", 108, 99, 460, 20, $("#OperationDesc").text());
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 11);


    var tableArr = [
        '<style> .print-row {margin:2px 0;} ',
        '.form-row {margin:5px 0;display:flex} ',
        'table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} ',
        '.line-text-short {border:none;border-bottom:1px solid #000;text-align:center;width:40px;}',
        '.line-text {border:none;border-bottom:1px solid #000;text-align:center;width:120px;}',
        '.line-text-long {border:none;border-bottom:1px solid #000;width:300px;}',
        'th {font-size:18px;font-weight:bold;text-align:center}</style>',
        '<table><thead><tr><th colspan="2">术前交接</th><th colspan="2">术后交接</td></tr></thead>',
        '<tbody><tr><td>项目</td><td>病房</td><td>项目</td>',
        '<td><input type="checkbox" ' + getChecked("PostShiftLoc1") + '>麻醉恢复室',
        '<input type="checkbox" ' + getChecked("PostShiftLoc2") + '>病房',
        '<input type="checkbox" ' + getChecked("PostShiftLoc3") + '>监护室</td></tr>',
        '<tr><td>患者身份核查</td><td><input type="checkbox" ' + getChecked("PreCheckWristband") + '>腕带正确</td>',
        '<td>患者身份核查</td><td><input type="checkbox" ' + getChecked("PostCheckWristband") + '>腕带正确</td></tr>',
        '<tr><td>药物</td><td><div class="print-row"><input type="checkbox" ' + getChecked("PreDrug2") + '>抗生素',
        '<input type="text" class="line-text-short" value="' + $("#PreAntibioticQty").numberbox("getValue") + '">支</div>',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PreDrug3") + '>其他',
        '<input type="text" class="line-text-long" value="' + $("#PreDrugOther").val() + '">',
        '<input type="checkbox" ' + getChecked("PreDrug1") + '>无</div></td>',
        '<td>药物</td><td><div class="print-row"><input type="checkbox" ' + getChecked("PostDrug2") + '>抗生素',
        '<input type="text" class="line-text-short" value="' + $("#PostAntibioticQty").numberbox("getValue") + '">支</div>',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PostDrug3") + '>其他',
        '<input type="text" class="line-text-long" value="' + $("#PostDrugOther").val() + '">',
        '<input type="checkbox" ' + getChecked("PostDrug1") + '>无</div></td></tr>',
        '<tr><td>液路情况</td><td><div class="print-row"><input type="checkbox" ' + getChecked("PreLiquidPath2") + '>锁穿',
        '<input type="checkbox" ' + getChecked("PreLiquidPath3") + '>PICC',
        '<input type="checkbox" ' + getChecked("PreLiquidPath4") + '>输液港',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PreLiquidPath6") + '>留置针(',
        '<input type="checkbox" ' + getChecked("PreIndwellingNeedle1") + '>右上肢',
        '<input type="checkbox" ' + getChecked("PreIndwellingNeedle2") + '>左上肢',
        '<input type="checkbox" ' + getChecked("PreIndwellingNeedle3") + '>右下肢',
        '<input type="checkbox" ' + getChecked("PreIndwellingNeedle4") + '>左下肢)</div>',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PreLiquidPath5") + '>其他',
        '<input type="text" class="line-text-long" value="' + $("#PostDrugOther").val() + '">',
        '<input type="checkbox" ' + getChecked("PreLiquidPath1") + '>无</div></td>',
        '<td>液路情况</td><td><div class="print-row"><input type="checkbox" ' + getChecked("PostLiquidPath2") + '>锁穿',
        '<input type="checkbox" ' + getChecked("PostLiquidPath3") + '>PICC',
        '<input type="checkbox" ' + getChecked("PostLiquidPath4") + '>输液港',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PreLiquidPath6") + '>留置针(',
        '<input type="checkbox" ' + getChecked("PostIndwellingNeedle1") + '>右上肢',
        '<input type="checkbox" ' + getChecked("PostIndwellingNeedle2") + '>左上肢',
        '<input type="checkbox" ' + getChecked("PostIndwellingNeedle3") + '>右下肢',
        '<input type="checkbox" ' + getChecked("PostIndwellingNeedle4") + '>左下肢)</div>',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PostLiquidPath5") + '>其他',
        '<input type="text" class="line-text-long" value="' + $("#PostDrugOther").val() + '">',
        '<input type="checkbox" ' + getChecked("PostLiquidPath1") + '>无</div></td></tr>',
        '<tr><td>管路</td><td><div class="print-row"><input type="checkbox" ' + getChecked("PreCatherChecking2") + '>有(',
        '<input type="checkbox" ' + getChecked("PreCather1") + '>尿管',
        '<input type="checkbox" ' + getChecked("PreCather2") + '>胃管',
        '<input type="checkbox" ' + getChecked("PreCather3") + '>营养管',
        '<input type="checkbox" ' + getChecked("PreCather4") + '>引流管',
        '<input type="checkbox" ' + getChecked("PreCather5") + '>气管插管)</div>',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PreCatherChecking1") + '>无</div></td>',
        '<td>管路</td><td><div class="print-row"><input type="checkbox" ' + getChecked("PostCatherChecking2") + '>有(',
        '<input type="checkbox" ' + getChecked("PostCather1") + '>尿管',
        '<input type="checkbox" ' + getChecked("PostCather2") + '>胃管',
        '<input type="checkbox" ' + getChecked("PostCather3") + '>营养管',
        '<input type="checkbox" ' + getChecked("PostCather4") + '>引流管',
        '<input type="checkbox" ' + getChecked("PostCather5") + '>气管插管)</div>',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PostCatherChecking1") + '>无</div></td></tr>',
        '<tr><td>皮肤</td><td><div class="print-row">完好<input type="checkbox" ' + getChecked("PreSkin1") + '>是</div>',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PreSkin2") + '>否',
        '<input type="text" class="line-text-long" value="' + $("#PreSkinOther").val() + '"></div>',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PreHighRiskPressureSore") + '>上报高危压疮',
        '<input type="checkbox" ' + getChecked("PrePressureSore") + '>上报压疮</div></td>',
        '<td>皮肤</td><td><div class="print-row">完好<input type="checkbox" ' + getChecked("PostSkin1") + '>是</div>',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PostSkin2") + '>否',
        '<input type="text" class="line-text-long" value="' + $("#PostSkinOther").val() + '"></div></td></tr>',
        '<tr><td>物品</td><td><div class="print-row"><input type="checkbox" ' + getChecked("PreMaterials1") + '>影像片',
        '<input type="checkbox" ' + getChecked("PreMaterials2") + '>病历',
        '<input type="checkbox" ' + getChecked("PreMaterials3") + '>胃管',
        '<input type="checkbox" ' + getChecked("PreMaterials4") + '>营养管',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PreMaterials5") + '>引流袋',
        '<input type="checkbox" ' + getChecked("PreMaterials6") + '>导尿包',
        '<input type="checkbox" ' + getChecked("PreMaterials7") + '>胸瓶胸管</div>',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PreMaterials8") + '>负压球/壶',
        '<input type="checkbox" ' + getChecked("PreMaterials9") + '>其他',
        '<input type="text" class="line-text" value="' + $("#PreElseGoodsDesc").val() + '"></div></td>',
        '<td>物品</td><td><div class="print-row"><input type="checkbox" ' + getChecked("PostMaterials1") + '>影像片',
        '<input type="checkbox" ' + getChecked("PostMaterials2") + '>病历',
        '<input type="checkbox" ' + getChecked("PostMaterials3") + '>胃管',
        '<input type="checkbox" ' + getChecked("PostMaterials4") + '>营养管',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PostMaterials5") + '>引流袋',
        '<input type="checkbox" ' + getChecked("PostMaterials6") + '>导尿包',
        '<input type="checkbox" ' + getChecked("PostMaterials7") + '>胸瓶胸管</div>',
        '<div class="print-row"><input type="checkbox" ' + getChecked("PostMaterials8") + '>负压球/壶',
        '<input type="checkbox" ' + getChecked("PostMaterials9") + '>其他',
        '<input type="text" class="line-text" value="' + $("#PostElseGoodsDesc").val() + '"></div></td></tr>',
        '<tr><td>过敏史</td><td><div class="print-row"><input type="checkbox" ' + getChecked("AllergicHistory1") + '>有',
        '<input type="checkbox" ' + getChecked("AllergicHistory2") + '>无</div></td>',
        '<td>血制品</td><td><div class="print-row"><input type="checkbox" ' + getChecked("BloodProducts1") + '>有',
        '<input type="checkbox" ' + getChecked("BloodProducts2") + '>无</div></td></tr>',
        '<tr><td>手术部位标识</td><td><div class="print-row"><input type="checkbox" ' + getChecked("SurgicalSite1") + '>有',
        '<input type="checkbox" ' + getChecked("SurgicalSite2") + '>无</div></td><td></td><td></td></tr>',
        '<tr><td>传染病系列</td><td><div class="print-row"><input type="checkbox" ' + getChecked("InfectiousDiseases1") + '>正常',
        '<input type="checkbox" ' + getChecked("InfectiousDiseases2") + '>异常</div></td><td></td><td></td></tr>',
        '<tr><td>禁食水</td><td><div class="print-row"><input type="checkbox" ' + getChecked("NoWaterDrinking1") + '>是',
        '<input type="checkbox" ' + getChecked("NoWaterDrinking2") + '>否</div></td><td></td><td></td></tr>',
        '<tr><td>活动性假牙/首饰</td><td><div class="print-row"><input type="checkbox" ' + getChecked("PreJewelry2") + '>有',
        '<input type="checkbox" ' + getChecked("PreJewelry1") + '>无</div></td><td></td><td></td></tr>',
        '<tr><td>交接时间</td><td>' + $("#PreHandoverTime").datetimebox("getValue") + '</td>',
        '<td>交接时间</td><td>' + $("#PostHandoverTime").datetimebox("getValue") + '</td></tr>',
        '<tr><td>签名</td><td><div class="form-row"><div>外接护士签名</div><img src="' + $("#HandOverNurseSign").attr("src") + '">',
        '<div>病房护士签名</div><img src="' + $("#WardNurseSign").attr("src") + '"></div></td>',
        '<td>签名</td><td><div class="form-row"><div>巡回护士签名</div><img src="' + $("#CircuitNurseSign").attr("src") + '">',
        '<div>麻醉恢复室/病房护士/监护室护士</div><img src="' + $("#PACUWardICUNurseSign").attr("src") + '"></div></td></tr>',
        '</tbody></table>'
    ];
    LODOP.ADD_PRINT_TABLE(136, 20, "100%", "100%", tableArr.join(""));
}