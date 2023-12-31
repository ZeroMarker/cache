$(document).ready(function() {
    var columns = [
        [
            {
                field: "CheckStatus",checkbox: true
            },
            { field: "PatName", title: "患者姓名", width: 120 },
            { field: "PatGender", title: "性别", width: 60 },
            { field: "PatAge", title: "年龄", width: 60 },
            { field: "MedcareNo", title: "住院号", width: 80 },
            { field: "PatWardDesc", title: "病区", width: 120 },
            { field: "PatBedCode", title: "床号", width: 80 },
            { field: "RegDate", title: "登记日期", width: 100 },
            { field: "SpecDesc", title: "标本名称", width: 120 },
            
            { field: "OutDateTime", title: "组织离体时间", width: 180 },
            { field: "FixDateTime", title: "组织固定时间", width: 180 },
            { field: "HandleDesc", title: "标本处理", width: 120 },
            { field: "SpecNo", title: "标本号", width: 180 }
            // {
            //     field: "BarCode",
            //     title: "标本条码",
            //     width: 300,
            //     formatter: function(value, row, index) {
            //         var imgID = "barcode" + row.SpecNo;
            //         var ret = "<div id='" + imgID + "' class='barcode' data-code='" + row.SpecNo + "' ";
            //         ret += "data-desc='" + row.SpecDesc + " " + row.SpecNo + "' ></div>"
            //         return ret;
            //     }
            // }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#specimenBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#specimenTools",
        form: $("#specimenForm"),
        modelType: ANCLS.Model.SpecimenReg,
        queryType: ANCLS.BLL.SpecimenManager,
        queryName: "FindSpecimenRegList",
        dialog: null,
        addButton: $("#btnAddSpecimen"),
        editButton: $("#btnEditSpecimen"),
        delButton: $("#btnDelSpecimen"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        onSubmitCallBack: UpdateFormValue,
        openCallBack: initDefaultValue,
        closeCallBack: null,
        datagridSelectCallBack:selectSpecimen,
        submitAction:saveSpecimen,
        delAction:delSpecimen
    });
    dataForm.initDataForm();
    dataForm.datagrid.datagrid({
        headerCls: "panel-header",
        border: false,
        onBeforeLoad: function(param) {
            param.Arg1 = session.RecordSheetID;
            param.ArgCnt = 1;
        },
        onLoadSuccess: function(data) {
            $(".barcode").each(function(index, el) {
                var specNo = $(this).attr("data-code");
                $(this).qrcode({size:64,text:specNo});
                // JsBarcode("#" + $(this).attr("id"), specNo, {
                //     height: 60,
                //     text: $(this).attr("data-desc"),
                //     fontSize: 12,
                //     format: "CODE128B"
                // });
            });
        },
        singleSelect:false
    });

    $("#Specimen").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSpecimen";
            param.ArgCnt = 0;
        }
    });

    $("#btnVideoCall").linkbutton({
        onClick: function() {
            openSpecimenVideo();
        }
    });

    $("#btnPrintBarCode").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected(dataForm.datagrid, true)) {
                var selectedRow = dataForm.datagrid.datagrid("getSelected");
                // var selector = "#barcode" + selectedRow.SpecNo;
                // var image = $(selector).prop("outerHTML");
                var lodop = getLodop();
                lodop.SET_PRINT_PAGESIZE(1, 0, 0, PrintSetting.SpecimenManager.BarCodePaper);
                lodop.ADD_PRINT_BARCODE("2mm", "4mm", "52mm", "21mm", "128B", selectedRow.SpecNo);
                lodop.PREVIEW();
            }
        }
    });

    $("#btnPrintTag").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected(dataForm.datagrid, true)) {
                var selectedRows = dataForm.datagrid.datagrid("getSelections");
                for(var i=0;i<selectedRows.length;i++){
                    printSpecimenTag(selectedRows[i]);
                }
            }
        }
    });
});

function printSpecimenTag(specimenData){
    selectedRow=specimenData;
    var selector = "#barcode" + selectedRow.SpecNo;
    var image = $(selector).prop("outerHTML");
    var lodop = getLodop();
    if(lodop.SET_PRINTER_INDEX(PrintSetting.SpecimenManager.BarCodePrinter)){
        lodop.SET_PRINT_PAGESIZE(1, "80mm","40mm","");
        // lodop.ADD_PRINT_IMAGE(0, 0, "100%", "100%", image);
        var htmlArr = [];
        htmlArr.push("<style> ");
        htmlArr.push("div.form-row {margin: 3px 3px 0 3px;} ")
        htmlArr.push("div.form-row .form-title {display: inline-block;width: 58px;text-align: right;} ");
        htmlArr.push("div.form-row:last-child {margin-bottom: 5px;} ");
        htmlArr.push("div.form-row .form-item {display: inline-block;width: 85px;} ");
        htmlArr.push("* {font-size:14px;} ");
        htmlArr.push("</style>");
        htmlArr.push("<div class='form-row'>")
        htmlArr.push("<span class='form-title'>患者姓名</span>：<span>");
        htmlArr.push(selectedRow.PatName+" "+selectedRow.PatGender+" "+selectedRow.PatAge);
        htmlArr.push("</span></div>");
        htmlArr.push("<div class='form-row'>")
        htmlArr.push("<span class='form-title'>住&nbsp;&nbsp;院&nbsp;&nbsp;号</span>：<span class='form-item'>");
        htmlArr.push(selectedRow.MedcareNo);
        htmlArr.push("</span></div>");
        htmlArr.push("<div class='form-row'>")
        htmlArr.push("<span class='form-title'>送检标本</span>：<span>");
        htmlArr.push(selectedRow.SpecDesc);
        htmlArr.push("</span></div>");
        htmlArr.push("<div class='form-row'>")
        htmlArr.push("<span class='form-title'>病&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;室</span>：<span class='form-item'>");
        htmlArr.push(selectedRow.PatWardDesc);
        htmlArr.push("</span><span class='form-title'>床&nbsp;&nbsp;&nbsp;&nbsp;号</span>：<span class='form-item'>");
        htmlArr.push(selectedRow.PatBedCode);
        htmlArr.push("</span></div>");
        htmlArr.push("<div class='form-row'>")
        htmlArr.push("<span>组织离体时间</span>：<span>");
        htmlArr.push(selectedRow.OutDateTime);
        htmlArr.push("</span></div>");
        htmlArr.push("<div class='form-row'>")
        htmlArr.push("<span>组织固定时间</span>：<span>");
        htmlArr.push(selectedRow.FixDateTime);
        htmlArr.push("</span></div>");
        var html = htmlArr.join("");
        lodop.ADD_PRINT_HTM(5, 10, "100mm", "40mm", html);
        lodop.ADD_PRINT_BARCODE(5,220,80,80,"QRCode",selectedRow.SpecNo);
        // lodop.PREVIEW();
        lodop.PRINT();
    }else{
        $.messager.alert("提示","未发现条码打印机","error");
    }
    
}

function saveSpecimen(param){
    param.RowId=$("#RowId").val();
    if(!param.RowId) param.RowId="";
    var ret=dhccl.saveDatas(ANCSP.DataListService,{
        ClassName:ANCLS.BLL.SpecimenManager,
        MethodName:"SaveSpecimen",
        jsonData:dhccl.formatObjects(param)
    },function(data){
        if(data.indexOf("S^")===0){
            $("#specimenBox").datagrid("reload");
            $("#specimenForm").form("clear");
        }else{
            $.messager.alert("提示","标本保存失败，原因："+data,"error");
        }
    })
}

function delSpecimen(){
    if (dhccl.hasRowSelected($("#specimenBox"), true)) {
        var selectedRows = $("#specimenBox").datagrid("getSelections");
        var idArr=[];
        for(var i=0;i<selectedRows.length;i++){
            idArr.push(selectedRows[i].RowId);
        }
        var idStr=idArr.join(",");
        var ret=dhccl.runServerMethod(ANCLS.BLL.SpecimenManager,"DelSpecimen",idStr);
        if(ret.success){
            $("#specimenBox").datagrid("reload");
        }else{
            $.messager.alert("提示","标本删除失败，原因："+ret.result,"error");
        }
    }
}

function selectSpecimen(rowData){
    $("#Specimen").combobox("setText",rowData.SpecDesc);
}

function initDefaultValue(dataForm) {

}

function UpdateFormValue(param) {
    var outDateTimeStr = $("#OutDateTime").datetimebox("getValue");
    var outDateTimeArr = outDateTimeStr.split(" ");
    $("#OutDate").val(outDateTimeArr[0]);
    $("#OutTime").val(outDateTimeArr[1]);
    var fixDateTimeStr = $("#FixDateTime").datetimebox("getValue");
    var fixDateTimeArr = fixDateTimeStr.split(" ");
    $("#FixDate").val(fixDateTimeArr[0]);
    $("#FixTime").val(fixDateTimeArr[1]);
    $("#OperSchedule").val(dhccl.getQueryString("opsId"));
    $("#RecordSheet").val(session.RecordSheetID);
    param.FixDate=fixDateTimeArr[0];
    param.FixTime=fixDateTimeArr[1]?fixDateTimeArr[1]:"";
    param.OutDate=outDateTimeArr[0];
    param.OutTime=outDateTimeArr[1]?outDateTimeArr[1]:"";
    param.RecordSheet=session.RecordSheetID;
    param.SpecimenNote=$("#Specimen").combobox("getText");
    param.Handle=$("#Handle").combobox("getValue");
}

function openSpecimenVideo() {
    var linkUrl = "https://111.111.116.244:8080/";
    linkUrl = "chrome.exe --disable-infobars --test-type --ignore-certificate-errors " + linkUrl;
    var wsh = new ActiveXObject("WScript.Shell");
    wsh.Run(linkUrl);
    window.close();
}