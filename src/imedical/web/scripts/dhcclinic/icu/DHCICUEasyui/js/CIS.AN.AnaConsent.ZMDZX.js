$(document).ready(function () {
    operDataManager.initFormData(loadApplicationData);
    initPage();
    operDataManager.setCheckChange();
    signCommon.loadSignature();
});
/**
 * 调用所有页面元素初始化函数
 */
function initPage() {
    initDelegates();
}

/**
 * 初始化所有按钮单击事件
 */
function initDelegates() {
    $("#btnSave").linkbutton({
        onClick: function () {
            operDataManager.saveOperDatas();
        }
    });

    $("#btnPrint").linkbutton({
        onClick: print
    });

    $("#btnRefresh").linkbutton({
        onClick: function () {
            window.location.reload();
        }
    });
}

/**
 * 签名按钮触发事件
 */
function msg(value, name) {
    var signCode = $(this).attr("id");
    var originalData = JSON.stringify(operDataManager.getOperDatas());
    var signView = new SignView({
        container: "#signContainer",
        originalData: originalData,
        signCode: signCode
    });
    signView.initView();
    signView.open();
    signCommon.loadSignature();
}

/**
 * 根据手术申请数据，设置病人信息表单元素的值。
 * @param {object} operApplication 手术申请数据对象
 */
var operSchedule;
function loadApplicationData(appData) {
    if (!appData) return;
    // $("#PatName").text(appData.PatName);
    // $("#PatGender").text(appData.PatGender);
    // $("#PatAge").text(appData.PatAge);
    // $("#PatDept").text(appData.PatDeptDesc);
    // $("#PatMedCareNo").text(appData.MedcareNo);
    // $("#OperationDesc").text(appData.OperationDesc);
    // $("#SurgeonDesc").text(appData.SurgeonDesc);
    // $("#OperDate").text(appData.OperDate);
    // $("#AnaMethodDesc").text(appData.PrevAnaMethodDesc);
    operSchedule = appData;
}

function print() {
    /*
    var lodop = getLodop();
    createPrintOnePage(lodop, anaestConsent.operSchedule);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();
    */
    var curOperSchedule = operSchedule;
    var valueObject = $.extend({}, curOperSchedule);
    var operDatas = operDataManager.getOperDatas();
    $.each(operDatas, function (index, operData) {
        if (!operData.DataItem || operData.DataItem === "") return;
        var controlValue = operDataManager.getControlValue($("#" + operData.DataItem));
        valueObject[operData.DataItem] = controlValue;
    });

    var moduleId = session.ModuleID;
    if (moduleId) {
        $.ajax({
            url: ANCSP.MethodService,
            async: true,
            data: {
                ClassName: "CIS.AN.BL.PrintTemplate",
                MethodName: "GetPrintTemplate",
                Arg1: moduleId,
                ArgCnt: 1
            },
            type: "post",
            success: function (data) {
                var result = $.trim(data);
                if (result) {
                    var templateId = result.split("^")[0];
                    var sheetData = JSON.parse(result.split("^")[1]);
                    printPage(sheetData, valueObject);
                }else{
                    $.messager.alert("错误", "未配置打印模板!", "error");
                }
            }
        });
    }
}

function printPage(sheetData, valueObject) {
    var lodopPrintView = window.LodopPrintView.instance;
    if (!lodopPrintView) {
        lodopPrintView = window.LodopPrintView.init({
            sheetData: sheetData.Sheet,
            valueObject: valueObject
        });
    }
    lodopPrintView.print();    //直接打印
    //lodopPrintView.printView(); //打印预览
    //lodopPrintView.imagePrint(); //直接图片打印
}