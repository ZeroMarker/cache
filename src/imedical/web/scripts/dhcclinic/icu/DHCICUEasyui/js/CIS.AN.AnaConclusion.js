var page = {
    operSchedule: null
};

$(document).ready(function () {
    operDataManager.initFormData(loadApplicationData);
    initPage();
    operDataManager.setCheckChange();
});

/**
 * 调用所有页面元素初始化函数
 */
function initPage() {
    initDelegates();
    //signCommon.loadSignature();
    //SignTool.loadSignature();
    SignTool.loadSignature(function () {
        return operDataManager.getOperDatas();
    });
    if (readonly()) disableAllInput();
}

function readonly() {
    var readonly = dhccl.getQueryString('readonly');
    if (readonly && readonly == 'true') return true;
    return false;
}

function disableAllInput() {
    $('input:visible').attr('disabled', true);
    $('span.combo-arrow').hide();
    $('span.triggerbox-button').hide();
    $('input[type="checkbox"]').checkbox('disable');
    $('#btnSave').hide();
}

function checked24() {
    $(".form-item-checkboxlist").each(function () {
        var num = $(this).find("input[type='checkbox']:checked").length;
        if (num > 0) {} else {
            var a = $(this).prev()[0].innerText; //父节点上一个节点
            $.messager.alert("提示", a + "--为必填信息", "warning");
            return false;
        }
    });
    var checkednums = $(".form-item-checkboxlist").find("input[type='checkbox']:checked").length;
    return checkednums >= "23";
}
/**
 * 初始化所有按钮单击事件
 */
function initDelegates() {
    $("#btnSave").linkbutton({
        onClick: function () {
            if (checked24()) {
                operDataManager.saveOperDatas();
            } else {
                $.messager.alert("提示", "信息未填写完整", "warning");
            }
        }
    });

    $("#btnPrint").linkbutton({
        onClick: print
    });

    $("#btnPrintNoData").linkbutton({
        onClick: printNoData
    });

    $("#btnRefresh").linkbutton({
        onClick: function () {
            window.location.reload();
        }
    });
    $("#btnSelectTemplate").linkbutton({
        onClick: function () {
            var template = new SheetTemplate({
                title: "选择模板",
                showBox: true,
                showForm: false,
                moduleID: session.ModuleID,
                userID: session.UserID
            });
            template.open();
        }
    });



    $("#btnSaveTemplate").linkbutton({
        onClick: function () {
            var template = new SheetTemplate({
                title: "保存模板",
                showBox: false,
                showForm: true,
                moduleID: session.ModuleID,
                userID: session.UserID
            });
            template.open();
        }
    });
    $("#btnAnaDocSign").linkbutton({
        onClick: function () {
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
function loadApplicationData(operApplication) {
    page.operSchedule = operApplication;
    $("#PatName").val(operApplication.PatName);
    $("#PatGender").val(operApplication.PatGender);
    $("#PatAge").val(operApplication.PatAge);
    $("#PatDeptDesc").val(operApplication.PatDeptDesc);
    $("#PatBedCode").val(operApplication.PatBedCode);
    $("#MedcareNo").val(operApplication.MedcareNo);
    $("#RegNo").val(operApplication.RegNo);
    $("#OperationDesc").val(operApplication.OperDesc);
    $("#PostDiagnosisDesc").val(operApplication.PostDiagnosisDesc);
    $("#AnaMethodDesc").val(operApplication.AnaestMethod);
    $("#RoomDesc").val(operApplication.RoomDesc);
    $("#OperDate").val(operApplication.OperDate);
    $("#SourceTypeDesc").val(operApplication.SourceTypeDesc);
    $("#BloodType").val(operApplication.BloodTypeDesc);
    $("#TheatreInDT").val(operApplication.TheatreInDT);
    $("#SurgeonDesc").val(operApplication.SurgeonDesc);
}

function print() {
    var lodop = getLodop();
    createPrintOnePage(lodop, page.operSchedule);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();

}

function printNoData() {
    var lodop = getLodop();
    createPrintOnePage(lodop, page.operSchedule, true);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();

}

function createPrintOnePage(lodop, operSchedule, nodata) {
    lodop.PRINT_INIT("PostAnaVisit" + operSchedule.RowId);
    var prtConfig = sheetPrintConfig,
        logoMargin = prtConfig.logo.margin,
        logoSize = prtConfig.logo.size,
        titleFont = prtConfig.title.font,
        titleSize = prtConfig.title.size,
        titleMargin = prtConfig.title.margin,
        contentSize = prtConfig.content.size,
        contentFont = prtConfig.content.font;

    var startPos = {
        x: prtConfig.paper.margin.left,
        y: logoMargin.top
    };
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 620, 30, session.ExtHospDesc || "");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 21);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);
    startPos.y = startPos.y + 30;

    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 620, 30, "麻醉总结交接及随访单");
    lodop.SET_PRINT_STYLEA(0, "FontName", titleFont.name);
    lodop.SET_PRINT_STYLEA(0, "FontSize", titleFont.size);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

    var htmlArr = [];

    startPos.y += titleSize.height + titleMargin.bottom;
    lodop.ADD_PRINT_HTM(startPos.y, startPos.x, contentSize.width, contentSize.height, htmlArr.join(""));
}