$(initPage);

function initPage() {
    var moduleId = dhccl.getQueryString("moduleId");
    var opsId =  dhccl.getQueryString("opsId");
    var recordSheetId = dhccl.getQueryString("recordSheetId");
    if (moduleId && opsId && recordSheetId) {
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
                let result = $.trim(data);
                if (result) {
                    templateId = result.split("^")[0];
                    let sheetData = $.parseJSON(result.split("^")[1]);
                    initTemplate(sheetData, opsId, recordSheetId);
                } else {
                    $.messager.alert("错误", "未配置打印模板!", "error");
                }
            }
        });
    }else{
        $.messager.alert("错误", "moduleId、opsId、recordSheetId均不能为空!", "error");
    } 
}

function initTemplate(data, opsId, recordSheetId){
    var sheet = data.Sheet;

    var valueObject = getPrintValue(opsId, recordSheetId);
    var canvas = document.getElementById("myCanvas");
    var displaySheet = new DisplaySheet({
        canvas: canvas,
        sheet: sheet,
        editMode: false,
        valueObject: valueObject,
        onPageResize: function(){
            HIDPI();
        },
        ratio: {
            x: 14 / 12,
            y: 14 / 12,
            fontRatio: 14 / 12
        }
    });

    if(displaySheet.getPageCount() > 1){
        setPageButtonState();

        $("#btnNextPage").linkbutton({
            onClick: function() {
                var nextPageNo = displaySheet.getNextPageNo();
                if(nextPageNo){
                    displaySheet.setCurrentPage(nextPageNo);
                }
                var currentPageNo = displaySheet.getCurrentPageNo();
                displaySheet.editPluginManager.showCurrentPageEditPlugin(currentPageNo);
                setPageButtonState();
            }
        });

        $("#btnPrePage").linkbutton({
            onClick: function() {
                var prePageNo = displaySheet.getPrePageNo();
                if(prePageNo){
                    displaySheet.setCurrentPage(prePageNo);
                }
                var currentPageNo = displaySheet.getCurrentPageNo();
                displaySheet.editPluginManager.showCurrentPageEditPlugin(currentPageNo);
                setPageButtonState();
            }
        });
    }else{
        $("#pageInfo").hide();
        $("#btnNextPage").hide();
        $("#btnPrePage").hide();
    }

    $("#btnPrint").linkbutton({
        onClick: function(){
            var lodopPrintView = window.LodopPrintView.instance;
            if (!lodopPrintView) {
                lodopPrintView = window.LodopPrintView.init({
                    sheetData: sheet,
                    valueObject: valueObject
                });
            }
            lodopPrintView.print();
        }
    });

    $("#btnRefresh").linkbutton({
        onClick: function() {
            window.location.reload();
        }
    });

    function setPageButtonState(){
        var pageInfo = "当前第" +displaySheet.getCurrentPageNo()+ "页,共" + displaySheet.getPageCount() + "页";
        $("#pageInfo").html(pageInfo);
        if(displaySheet.isFirstPage()){
            $("#btnNextPage").linkbutton("enable");
            $("#btnPrePage").linkbutton("disable");
        }else if(displaySheet.isLastPage()){
            $("#btnNextPage").linkbutton("disable");
            $("#btnPrePage").linkbutton("enable");
        }else{
            $("#btnNextPage").linkbutton("enable");
            $("#btnPrePage").linkbutton("enable");
        }
    }

    function getPrintValue(opsId, recordSheetId){
        var operAppData = getOperAppData(opsId);
        var operDatas = getOperDatas(recordSheetId);
        var signatureList = getSignatureList(recordSheetId);

        var valueObject = $.extend({}, operAppData);
        for (var i = 0; i < operDatas.length; i++) {
            var operData = operDatas[i];
            valueObject[operData.DataItem] = operData.DataValue;
            if(operData.DataNote) valueObject[operData.DataItem] = operData.DataNote;
        }

        if (signatureList && signatureList.length > 0) {
            for (var i = 0; i < signatureList.length; i++) {
                var signature = signatureList[i];
                var signCode = signature.SignCode;
                var fullName = signature.FullName;
                valueObject[signCode] = fullName;
            }
        }
        return valueObject;
    }

    function getOperAppData(opsId) {
        var operAppDataArr = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.OperScheduleList,
            QueryName: "FindOperScheduleList",
            Arg1: "",
            Arg2: "",
            Arg3: "",
            Arg4: opsId,
            ArgCnt: 4
        }, "json");
        var appData = null;
        if (operAppDataArr && operAppDataArr.length && operAppDataArr.length > 0) {
            appData = operAppDataArr[0];
        }
        return appData;
    }

    function getOperDatas(recordSheetId) {
        var operDatas = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.OperData,
            QueryName: "FindOperDataBySheet",
            Arg1: recordSheetId,
            ArgCnt: 1
        }, "json");
        return operDatas;
    }

    function getSignatureList(recordSheetId){
        var signatureList = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.CA.SignatureService,
            QueryName: "FindSignature",
            Arg1: recordSheetId,
            ArgCnt: 1
        }, "json");
        return signatureList;
    }

    function HIDPI() {
        var ratio = window.devicePixelRatio || 1;
        var canvas = document.getElementById("myCanvas");
        var context = canvas.getContext("2d");
        var oldWidth = canvas.width;
        var oldHeight = canvas.height;
        canvas.width = oldWidth * ratio;
        canvas.height = oldHeight * ratio;
        canvas.style.width = oldWidth + "px";
        canvas.style.height = oldHeight + "px";
        context.scale(ratio, ratio);
    }
}
