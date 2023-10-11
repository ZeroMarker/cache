/**
***************************
功能js，可以被覆盖掉
***************************
**/
var kongbiaotou = "空表头";

/**
     *记录单新建
     @method New
**/
function New(gatherFun, callbackFun, templateEmrCode, windowsInfo, attachTable, conditionFunc) {
  
    var _msg = IsPermission(GetTopTempletGuid(), "new");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ",_msg.errMsg,"info");
        return;
    }

    if (!!conditionFunc && $.type(window[conditionFunc]) === "function") {
        if (!window[conditionFunc]())
            return;
    }

    if (!templateEmrCode) {
        $.messager.alert(" ",$g("请检查设计器，此方法必须绑定打开一个模板"),"info");
        return;
    }

    if (!__VerifyParentChildForm(attachTable, gatherFun))
        return;
    
    var urlPartParam = null;
    urlPartParam = "IsNewFlag=true";
    OpenWindow(templateEmrCode, callbackFun, gatherFun, urlPartParam, windowsInfo);
}

/**
     *记录单导入新建，通过采集表格带入某条选中记录
     @method NewImport
**/
function NewImport(gatherFun, callbackFun, templateEmrCode, windowsInfo, attachTable, conditionFunc, filterItemHtmlIDs) {

    var _msg = IsPermission(GetTopTempletGuid(), "new");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!!conditionFunc && $.type(window[conditionFunc]) === "function") {
        if (!window[conditionFunc]())
            return;
    }

    if (!templateEmrCode) {
        $.messager.alert(" ",$g("请检查设计器，此方法必须绑定打开一个模板"),"info");
        return;
    }

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }

    var SpecifyFiledsData = window[gatherFun]();


    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ",$g("请检查设计器,此方法需采集指定的表格"),"info");
        return;
    }
    var checkedIds = DataTableCheckRowIds(tableID);
    if (!!checkedIds && checkedIds.split(",").length > 1) {
        $.messager.alert(" ",$g("只能导入一条记录"),"info");
        return;
    }
    if (!!checkedIds && IsHisUIDataTable(tableID)) {
        var selectRowData = $('#' + tableID + '').datagrid('getChecked')[0];
        if (IsStatisticsRow(selectRowData))
        {
            $.messager.alert(" ",$g("统计数据不能导入"),"info");
            return;
        }           
    }

    if (!__VerifyParentChildForm(attachTable, gatherFun))
        return;

    var urlPartParam = "IsNewFlag=true"
    if (!!checkedIds)
        urlPartParam += "&NurMPDataID=" + checkedIds;
    if (!!filterItemHtmlIDs)
        urlPartParam += "&FilterImportItems=" + filterItemHtmlIDs;
    OpenWindow(templateEmrCode, callbackFun, gatherFun, urlPartParam, windowsInfo);
}

/**
     *动态表头记录单新建
     @method DynamicTableTitleNew
**/
function DynamicTableTitleNew(gatherFun, callbackFun, templateEmrCode, windowsInfo, attachTable, conditionFunc) {

    var _msg = IsPermission(GetTopTempletGuid(), "new");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!!conditionFunc && $.type(window[conditionFunc]) === "function") {
        if (!window[conditionFunc]())
            return;
    }

    if (!templateEmrCode) {
        $.messager.alert(" ",$g("请检查设计器，此方法必须绑定打开一个模板"),"info");
        return;
    }

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集下拉动态表头进行辅助！"),"info");
        return;
    }

    if (!__VerifyParentChildForm(attachTable, gatherFun))
        return;

    var tableID = null;
    if (!!attachTable)
        tableID = attachTable;
    else{
        var SpecifyFiledsData = window[gatherFun]();
        tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    }
   
    var urlPartParam = "IsDynamicTableTitle=true" + GetDynamicTableTitleParentTitleBanding(tableID);
    OpenWindow(templateEmrCode, callbackFun, gatherFun, urlPartParam, windowsInfo);
}

/**
     *记录单修改
     @method Update
**/
function Update(gatherFun, callbackFun, templateEmrCode, windowsInfo) {

    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!templateEmrCode)
    {
        $.messager.alert(" ",$g("请检查设计器，此方法必须绑定打开一个模板"),"info");
        return;
    }
    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }

    var SpecifyFiledsData = window[gatherFun]();


    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID)
    {
        $.messager.alert(" ",$g("请检查设计器,此方法需采集指定的表格"),"info");
        return;
    }
    var checkedIds = DataTableCheckRowIds(tableID);
    if (!checkedIds)
    {
        $.messager.alert(" ",$g("请选择要修改的记录","info"));
        return;
    }
    if (checkedIds.split(",").length > 1)
    {
        $.messager.alert(" ",$g("只能选择一条记录进行修改"),"info");
        return;
    }

    if (IsHisUIDataTable(tableID))
    {
        var opts = $('#' + tableID).datagrid('options');
        var updateVerifyRelatedSignField = opts.updateVerifyRelatedSignField;
        var selectRowData = $('#' + tableID + '').datagrid('getChecked')[0];
        if (!!updateVerifyRelatedSignField) {
            var isOK = IsVerifyEditPermission(checkedIds, updateVerifyRelatedSignField);
            if (!isOK)
                return;
        }

        if (IsStatisticsRow(selectRowData))
            return;
    }
    else {
        var BasicInfo = $("#" + tableID).attr("BasicInfo");
        BasicInfo = BasicInfo.replace(/'/g, '"');
        var json = jQuery.parseJSON(BasicInfo);
        var updateVerifyRelatedSignField = json.UpdateVerifyRelatedSignField;
        if (!!updateVerifyRelatedSignField) {
            var isOK = IsVerifyEditPermission(checkedIds, updateVerifyRelatedSignField);
            if (!isOK)
                return;
        }
    }
    
    var urlPartParam = "NurMPDataID=" + checkedIds;
    OpenWindow(templateEmrCode, callbackFun, gatherFun, urlPartParam, windowsInfo);
}

/**
     *动态表头记录单修改
     @method Update
**/
function DynamicTableTitleUpdate(gatherFun, callbackFun, templateEmrCode, windowsInfo) {

    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!templateEmrCode) {
        $.messager.alert(" ",$g("请检查设计器，此方法必须绑定打开一个模板"),"info");
        return;
    }
    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }

    var SpecifyFiledsData = window[gatherFun]();
    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ",$g("请检查设计器,此方法需采集指定的表格"),"info");
        return;
    }

    var checkedIds = DataTableCheckRowIds(tableID);
    if (!checkedIds) {
        $.messager.alert(" ",$g("请选择要修改的记录"),"info");
        return;
    }
    if (checkedIds.split(",").length > 1) {
        $.messager.alert(" ",$g("只能选择一条记录进行修改"),"info");
        return;
    }

    if (IsHisUIDataTable(tableID)) {

        var opts = $('#' + tableID).datagrid('options');
        var updateVerifyRelatedSignField = opts.updateVerifyRelatedSignField;
        var selectRowData = $('#' + tableID + '').datagrid('getChecked')[0];
        if (!!updateVerifyRelatedSignField) {
            var isOK = IsVerifyEditPermission(selectRowData.ID, updateVerifyRelatedSignField);
            if (!isOK)
                return;
        }
        
        if (IsStatisticsRow(selectRowData))
            return;
    }

    var urlPartParam = "IsDynamicTableTitle=true" + GetDynamicTableTitleParentTitleBanding(tableID) + "&NurMPDataID=" + checkedIds;
    OpenWindow(templateEmrCode, callbackFun, gatherFun, urlPartParam, windowsInfo);
}

/**
     *打开新窗口
     @method OpenNewWindow
**/
function OpenNewWindow(gatherFun, callbackFun, templateEmrCode, windowsInfo) {
    if (!templateEmrCode) {
        $.messager.alert(" ",$g("请检查设计器，此方法必须绑定打开一个模板"),"info");
        return;
    }
    OpenWindow(templateEmrCode, callbackFun, gatherFun,"", windowsInfo);
}

/**
     *以指定的记录号打开新窗口
     @method OpenNewWindowByNurMPDataID
**/
function OpenNewWindowByNurMPDataID(gatherFun, callbackFun, templateEmrCode, windowsInfo) {

    var _msg = IsPermission(GetTopTempletGuid(), "new");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!templateEmrCode) {
        $.messager.alert(" ",$g("请检查设计器，此方法必须绑定打开一个模板"),"info");
        return;
    }

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }

    var SpecifyFiledsData = window[gatherFun]();
    var nurMPDataID = undefined;
    if (SpecifyFiledsData.keys.length == 1)//兼容2.3.2之前的
        nurMPDataID = SpecifyFiledsData.vals[0];
    else
    {
        $.each(SpecifyFiledsData.keys, function (i, n) {
            if (n === "NurMPDataID") {
                nurMPDataID = SpecifyFiledsData.vals[i];
                return false;
            }
        });
    }
    var urlPartParam = "";
    if (!!nurMPDataID)
        urlPartParam = "NurMPDataID=" + nurMPDataID;

    OpenWindow(templateEmrCode, callbackFun, gatherFun, urlPartParam, windowsInfo);
}

/**
     *关闭当前窗口
     @method CloseWindow
**/
function CloseWindow()
{
    var resultReturnObj = GetResultReturn();
    WindowBeforeCloseProxy(resultReturnObj, true);
}

/**
     *保存不关闭当前窗口
     @method Save
**/
function Save(gatherFun, callbackFun, templateEmrCode, windowsInfo, conditionFunc, customCallback) {
    if (!!conditionFunc && $.type(window[conditionFunc]) === "function") {
        if (!window[conditionFunc]())
            return;
    }

    var sender = $(arguments.callee.caller.arguments[0].target).parent().parent();//按钮本身
    var validSuccess = __FormVerify(gatherFun);
    
    if (validSuccess)
        Throttle(__SaveCore, null, [gatherFun, callbackFun, null, false, false, sender, 1, window.HideSavedAlter, customCallback]);
}

/**
     *暂存
     @method TemporarySave
**/
function TemporarySave(gatherFun, callbackFun) {
    var sender = $(arguments.callee.caller.arguments[0].target).parent().parent();//按钮本身

    Throttle(__SaveCore, null, [gatherFun, callbackFun, null, false, false, sender, 0, window.HideSavedAlter,null]);
}

/**
     *避免丢失数据，实时保存
     @method RealTimeSave
**/
function RealTimeSave(time) {
    var button = $("a[buttonType='savebutton']");
    var gatherFun = "";
    if (button.length > 0) {
        gatherFun = $(button).attr("gatherFun");
    }
    if (time >=1000) {
        setTimeout(
       function () {
           var dataIsChanged = FormIsChanged();
           if (dataIsChanged) {
               __RealTimeSave(gatherFun, null);
           }          
           RealTimeSave(time);//结束后在调用下一次
       },
         time
        );
    }
}

function __RealTimeSave(gatherFun, callbackFun) {
    Throttle(__SaveCore, null, [gatherFun, callbackFun, null, false, false, null, 0, window.HideSavedAlter,null]);
}
/**
     *保存并关闭当前窗口
     @method SaveAndCloseWindow
**/
function SaveAndCloseWindow(gatherFun, callbackFun, templateEmrCode, windowsInfo, conditionFunc, customCallback) {
    if (!!conditionFunc && $.type(window[conditionFunc]) === "function") {
        if (!window[conditionFunc]())
            return;
    }

    var sender = $(arguments.callee.caller.arguments[0].target).parent().parent();//按钮本身
    var validSuccess = __FormVerify(gatherFun);

    if (validSuccess)
        Throttle(__SaveCore, null, [gatherFun, callbackFun, null, true, false, sender, 1, window.HideSavedAlter, customCallback]);
}

/**
     *保存并生成图片，但不关闭当前窗口
     @method SaveAndGeneratePic
**/
function SaveAndGeneratePic(gatherFun, callbackFun, printTemplateEmrCode, windowsInfo, conditionFunc, generatePicType) {
    if (!!conditionFunc && $.type(window[conditionFunc]) === "function") {
        if (!window[conditionFunc]())
            return;
    }
    if (!printTemplateEmrCode){
        $.messager.alert(" ", $g("生成图片需要绑定打印模板"), "info");
        return;
    }

    var sender = $(arguments.callee.caller.arguments[0].target).parent().parent();//按钮本身
    var validSuccess = __FormVerify(gatherFun);
    if (generatePicType === undefined)
        generatePicType = 0;
    if (validSuccess)
        Throttle(__SaveCore, null, [gatherFun, callbackFun, printTemplateEmrCode, false, true, sender, 1, window.HideSavedAlter, null, generatePicType]);
}

/**
     *保存并生成图片，并关闭当前窗口
     @method SaveAndGeneratePicAndCloseWindow
**/
function SaveAndGeneratePicAndCloseWindow(gatherFun, callbackFun, printTemplateEmrCode, windowsInfo, conditionFunc, generatePicType) {
    if (!!conditionFunc && $.type(window[conditionFunc]) === "function") {
        if (!window[conditionFunc]())
            return;
    }
    if (!printTemplateEmrCode) {
        $.messager.alert(" ", $g("生成图片需要绑定打印模板"), "info");
        return;
    }

    var sender = $(arguments.callee.caller.arguments[0].target).parent().parent();//按钮本身
    var validSuccess = __FormVerify(gatherFun);
    if (generatePicType === undefined)
        generatePicType = 0;
    if (validSuccess)
        Throttle(__SaveCore, null, [gatherFun, callbackFun, printTemplateEmrCode, true, true, sender, 1, window.HideSavedAlter, null, generatePicType]);
}

/**
     *打印(续打)
     @method Print
**/
function Print(gatherFun, callbackFun, templateEmrCode, windowsInfo) {

    var _msg = IsPermission(GetTopTempletGuid(), "print");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!templateEmrCode) {
        $.messager.alert(" ",$g("请检查设计器，此方法必须绑定一个打印模板"),"info");
        return;
    }

    var hisURI = window.WebIp;
    var printTemplateEmrCode = templateEmrCode;
    var episodeID = window.EpisodeID;

    if (!printTemplateEmrCode) {
        $.messager.alert(" ",$g("没有配置打印模板"),"info");
        return;
    }

    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要刷新表格！"),"info");
        return;
    }

    var queryParam = "";
    if ($.type(window[gatherFun]) === "function") {
        var SpecifyFiledsData = window[gatherFun]();
        queryParam = ObjectToUrlParams(SpecifyFiledsData, "^");
    }

    var msg = tkMakeServerCall("NurMp.DHCNurRecorderPrintinfo", "PrintMsgInfo", episodeID, printTemplateEmrCode, queryParam);
    var reMsg = JSON.parse(msg);
    if (!MsgIsOK(reMsg)) {
        $.messager.alert(" ", $g("获取续打信息失败") + reMsg.msg, "info");
        return;
    }

    var printRowId = "";
    var printStartPageNo = "1";
    var printStartIndex = "0";
    var careDate = "";
    var careTime = "";

    if (reMsg.data.Flag == "0") {
        $.messager.confirm($g("提示"), $g("没有续打记录，是否打印？<p>确定：全部打印</p><p>取消：退出打印</p>"), function (r) {
            if (r) {
                ____print(0);
            }
        });

    }
    else if (reMsg.data.Flag == "1") {
        var printTrace = StringObjectToObject(reMsg.data.PrintTrace[0], "^", "|");
        printRowId = printTrace.RowId;
        printStartPageNo = printTrace.StartPageNo;
        printStartIndex = printTrace.StartIndex;
        careDate = printTrace.CareDate;
        careTime = printTrace.CareTime;

        var hint = "上次打印到第{0}页，第{1}";
        hint += "<p>记录明细（{2} {3} {4}）</p>"
        hint += "<p>是否放入正确的纸张？</p>";
        hint += "<p>确定：全部打印</p>";
        hint += "<p>取消：退出打印</p>";
        hint = $g(hint.format(printStartPageNo, printStartIndex, careDate, careTime, printRowId));
        $.messager.confirm($g("提示"), hint, function (r) {
            if (r) {
                ____print(1);
            }
        });
    }
    else if (reMsg.data.Flag == "2") {
        var printTrace = StringObjectToObject(reMsg.data.PrintTrace[0], "^", "|");
        printRowId = printTrace.RowId;
        printStartPageNo = printTrace.StartPageNo;
        printStartIndex = printTrace.StartIndex;
        careDate = printTrace.CareDate;
        careTime = printTrace.CareTime;

        var hint = "续打位置之前有记录增加或修改";
        hint += "<p>记录明细（{0} {1} {2}）</p>"
        hint += "<p>是否从这条记录开始打印？</p>";
        hint += "<p>确定：从修改痕迹位置打印</p>";
        hint += "<p>取消：从续打痕迹位置打印</p>";
        hint = $g(hint.format(careDate, careTime, printRowId));
        $.messager.confirm("提示", hint, function (r) {
            if (r) {
                ____print(2);
            }
            else {
                var printTrace = StringObjectToObject(reMsg.data.PrintTrace[1], "^", "|");
                printRowId = printTrace.RowId;
                printStartPageNo = printTrace.StartPageNo;
                printStartIndex = printTrace.StartIndex;
                ____print(1);
            }
        });
    }
    else if (reMsg.data.Flag == "3") {
        $.messager.alert($g("提示"), $g("没有要续打的记录"), "info");
        return;
    }
    else {
        $.messager.alert(" ",$g("未处理的状态"),"error");
        return;
    }
    //是否弹出了打印预览对话框
    var PrintViewIsOpen = 0;

    function ____print(flag) {//____print

        var intStartPageNo = 1;
        var intStartIndex = 0;
        if (printStartPageNo != "") {
            intStartPageNo = parseInt(printStartPageNo);
        }
        if (printStartIndex != "") {
            intStartIndex = parseInt(printStartIndex);
        }
        function PrintCallBackFun(ret) {
            PrintViewIsOpen = 0;
            if (ret.msg == "success") {
                var msg = ret.rtn;
                var reMsg = JSON.parse(msg);
                if (MsgIsOK(reMsg)) {
                    if (reMsg.msg) {                     
                        $.messager.alert($g("提示"), $g(reMsg.msg), "info");
                        window[callbackFun]();
                    }
                }
                else {                  
                    $.messager.alert($g("提示"), $g(reMsg.msg), "info");
                }
            }
            else {
                var text = $g("错误原因:")+ $g(ret.msg) + ",状态:"+ ret.status;
                $.messager.alert($g("提示"), text, "info");
            }
        }//PrintCallBackFun
        if (PrintViewIsOpen == 0) {
            PrintViewIsOpen = 1;
            try {
                var sessionJson = GetLogAuxiliaryInfo();
                PrintProvider.Print(hisURI, printTemplateEmrCode, episodeID, true, printRowId, intStartPageNo, intStartIndex, flag, window.CADisplayPic, PrintCallBackFun, queryParam, sessionJson);
                RefreshMiddleFrameTemplateTree();//刷新右侧的模板列表上的是否打印过的标记
            } catch (ex) {           
                $.messager.alert($g("提示"), $g("打印插件Print无法使用") + ex.Description, "info");
            }
        } else {           
          ///  $.messager.alert($g("提示"), $g("打印预览的界面未关闭"), "info");
        }
    }//____print
}
//是否弹出了打印预览对话框
var PrintAllViewIsOpen = 0;
/**
     *打印全部
     @method PrintAll
**/
function PrintAll(gatherFun, callbackFun, templateEmrCode, windowsInfo) {

    var _msg = IsPermission(GetTopTempletGuid(), "print");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!templateEmrCode) {
        $.messager.alert(" ",$g("请检查设计器，此方法必须绑定一个打印模板"),"info");
        return;
    }
    var printRequiredType = "Ignore";//Ignore,Always,Remind

    var msg = tkMakeServerCall("NurMp.Print.PrintTempConfig", "printRequiredFlag", templateEmrCode);
    var reMsg = JSON.parse(msg);
    if (!MsgIsOK(reMsg)) {
        $.messager.alert(" ", $g("获取打印模板验证类型失败") + reMsg.msg, "info");
        return;
    } else {
        printRequiredType = reMsg.data;
    }

    var ____print = function () {

        var RowIDs = "";
        var queryParam = "";
        var isPrintAll = "1";
        if ($.type(window[gatherFun]) === "function") {
            var SpecifyFiledsData = window[gatherFun]();
            var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
            if (!!tableID) {//记录单
                var checkedIds = DataTableCheckRowIds(tableID);
                if (!!checkedIds) {
                    var firstRowID = checkedIds.split(",")[0]; //作废记录和正常记录，是互相切换显示的。
                    if (IsCancelDataTableRow(tableID, firstRowID)) {
                        $.messager.alert(" ", $g("作废记录不能打印"), "info");
                        return false;
                    }
                    RowIDs = checkedIds;
                }
            }
            else if (SpecifyFiledsData.keys.length == 1)//评估单
            {
                if (SpecifyFiledsData.keys[0] != "StartPageNo") {
                    var queryObj = GetQueryObject();
                    RowIDs = SpecifyFiledsData.vals[0];
                    if (!!queryObj.IsNewFlag && queryObj.IsNewFlag == "true")//只有新建按钮，打开的录入模板里的打印全部，才需要考虑设置0，否则都为1
                        isPrintAll = "0";
                }
            }
            queryParam = ObjectToUrlParams(SpecifyFiledsData, "^");
        }



        var hisURI = window.WebIp;
        var printTemplateEmrCode = templateEmrCode;
        var episodeID = window.EpisodeID;

        if (!printTemplateEmrCode) {
            $.messager.alert(" ", $g("没有配置打印模板"), "info");
            return;
        }      
        function PrintALLCallBackFun(ret) {
            PrintAllViewIsOpen = 0;
            if (ret.msg == "success") {
                var msg = ret.rtn;
                var reMsg = JSON.parse(msg);
                if (MsgIsOK(reMsg)) {
                    if (reMsg.msg) {
                        $.messager.alert($g("提示"), reMsg.msg, "info");
                        if (!($.type(window[callbackFun]) === "function")) {

                        }
                        else {
                            window[callbackFun]();
                        }                                       
                    }
                }
                else {
                    if (reMsg.data&&reMsg.data.ListPrintRequire&&reMsg.data.ListPrintRequire.length > 0) {
                        if (printRequiredType == "Always") {
                            $.messager.alert($g("提示"), $g("存在必填项没有填写，请确认已经填写并保存后在打印。"), "info");
                            SetPrintPrintRequired(reMsg.data.ListPrintRequire);
                        }                       
                    }
                    else {
                        $.messager.alert($g("提示"), reMsg.msg, "info");
                    }                  
                }
            }
            else {
                var text = $g("错误原因:") + $g(ret.msg) + ",状态:" + ret.status;
                $.messager.alert($g("提示"), text, "info");
            }
        }
        if (PrintAllViewIsOpen == 0) {
            PrintAllViewIsOpen = 1;
            try {
                var sessionJson = GetLogAuxiliaryInfo();
                PrintProvider.PrintALL(hisURI, printTemplateEmrCode, episodeID, RowIDs, window.CADisplayPic, PrintALLCallBackFun, queryParam, isPrintAll, sessionJson);
                RefreshMiddleFrameTemplateTree();//刷新右侧的模板列表上的是否打印过的标记
            } catch (ex) {
                $.messager.alert($g("提示"), $g("打印插件PrintALL无法使用") + ex.Description, "info");
                PrintAllViewIsOpen = 0;
            }
        }
        else {
            // $.messager.alert($g("提示"), $g("打印预览的界面未关闭"), "info");
        }
    }
   

    if (printRequiredType == "Always") {
        var msg = checkPrintPrintRequired();
        if (!!msg) {
            $.messager.alert(" ", $g("存在必填项，" + msg + "没有填写，不能打印。"), "info");
            return;
        }
        else 
            ____print();
    }
    else if (printRequiredType == "Remind") {
        var msg = checkPrintPrintRequired();
        var hint = $g("存在必填项，" + msg + "没有填写，是否继续打印。");
        hint += "<p>确定：全部打印</p>";
        hint += "<p>取消：退出打印</p>";
        if (!!msg) {
            $.messager.confirm($g("提示"), hint, function (r) {
                if (r) {
                    ____print();
                }
            });
        }
        else {
            ____print();
        }
    }
    else {
        ____print();
    }
}
/**
     界面模板配置了打印必填的优先，否则为全部表单元素
**/
function checkPrintPrintRequired()
{
    var text = "";
    var getRequiredMsg = function () {
        if (eleIDs.length > 0) {
            for (var i = 0; i < eleIDs.length; i++) {
                var id = eleIDs[i];                
                var helper = GetElementHelper(id);
                var type = GetElementStringType(id);
                var fieldValue = "";
                if (type == "CheckElement" || type == "RadioElement")//单选多选需要判断name
                {
                    var name = id;
                    fieldValue = helper.getValueByName(name);
                }
                else {//部分元素的name由于HISUI的处理，是不存在的，
                    fieldValue = helper.getValueById(id);
                }
               
                if (fieldValue == "") {
                    var eleLabelFor = $("#" + id).attr("dhccLableFor");
                    
                    if (!!eleLabelFor) {
                        var labelFor = "";
                        $.each(eleLabelFor.split("!"), function (i, n) {
                            labelFor += $("#" + n).text();
                        });
                    }                        
                    text += "[" + labelFor + "],";
                    helper.focus(id);
                }
            }
        }
    }
    var eleIDs =$.map( $("[PrintRequired='true']"), function(n){
        return $(n).attr("id");
    });

    if (eleIDs.length > 0) {
        getRequiredMsg(eleIDs);
    }
    else {
        eleIDs = window.LoadFormElements;
        getRequiredMsg(eleIDs);
    }
    return text;
}
function SetPrintPrintRequired(eleIDs) {
    if (eleIDs.length > 0) {
        for (var i = 0; i < eleIDs.length; i++) {
            var id = eleIDs[i];
            var helper = GetElementHelper(id);
            var type = GetElementStringType(id);
            var fieldValue = "";
            if (type == "CheckElement" || type == "RadioElement")//单选多选需要判断name
            {
                var name = id;
                fieldValue = helper.getValueByName(name);
            }
            else {//部分元素的name由于HISUI的处理，是不存在的，
                fieldValue = helper.getValueById(id);
            }
            helper.focus(id);
        }
    } 
}


/**
     *生成全部图片
     @method GeneratePicAll
     @param {generatePicType} 0:表示生成图片  1:表示生产图片痕迹，以HTML形式展示
**/
function GeneratePicAll(gatherFun, callbackFun, templateEmrCode, windowsInfo, conditionFunc, generatePicType) {

    var _msg = IsPermission(GetTopTempletGuid(), "print");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!templateEmrCode) {
        $.messager.alert(" ",$g("请检查设计器，此方法必须绑定一个打印模板"),"info");
        return;
    }

    var hisURI = window.WebIp;
    var printTemplateEmrCode = templateEmrCode;
    var episodeID = window.EpisodeID;
    var queryParam = "";

    if (!printTemplateEmrCode) {
        $.messager.alert(" ",$g("没有配置打印模板"),"info");
        return;
    }

    if ($.type(window[gatherFun]) === "function") {//只有父子单，第2个页面，如果配置了全部生成图片，那么需要采集
        var SpecifyFiledsData = window[gatherFun]();
        if (SpecifyFiledsData.keys.length == 1 && SpecifyFiledsData.vals.length == 1) {
            queryParam = ObjectToUrlParams(SpecifyFiledsData, "^");
        }
        else {
            $.messager.alert(" ", $g("没有数据！请先保存，再生成图片"), "info");
            return;
        }
    }
    function MakePicAllCallBackFun(ret) {      
        if (ret.msg == "success") {
            var msg = ret.rtn;
            var reMsg = JSON.parse(msg);
            if (MsgIsOK(reMsg)) {
                if (reMsg.msg) {
                    $.messager.alert($g("提示"), $g(reMsg.msg), "info");
                }
            }
            else {
                $.messager.alert($g("提示"), $g(reMsg.msg), "error");
            }
        }
        else {
            var text = $g("错误原因:") + $g(ret.msg) + ",状态:" + ret.status;
            $.messager.alert($g("提示"), text, "info");
        }
    }
    if (generatePicType === undefined)
        generatePicType = 0;
    try {
        var sessionJson = GetLogAuxiliaryInfo();
        PrintProvider.MakePicAll(hisURI, printTemplateEmrCode, episodeID, window.CADisplayPic, queryParam, sessionJson, generatePicType, MakePicAllCallBackFun);
        
    } catch (ex) {       
        $.messager.alert($g("提示"), $g("打印插件MakePicAll无法使用"), "error");
    }
}

/**
     *动态表头下拉框切换
     @method DynamicTableTitleDropListChange
     @param rec 下拉框当前选中项
**/
function DynamicTableTitleDropListChange(rec) {

    var querybanding = $("#" + this.id).attr("querybanding");
    if (!querybanding) {
        alert("表格查询信息错误");
    }
    var tmp = querybanding.split(":");
    if (tmp.length<2) {
        alert("表格查询信息错误");
    }
    var tableHtmlId = tmp[0];
    var queryField = tmp[1];

    var refreshQueryParam = $("#" + tableHtmlId).attr("queryInfo");

    var dynamicTitleNew = {};
    var slectedValue = "";
    if (!rec) //当所有的表头都作废时
        slectedValue = kongbiaotou;
    else
        slectedValue = rec.Text;
    //样例： 2018-05-05(10:20) Y 1-
    slectedValue = DynamicTableTitleFormater(slectedValue);


    if (window.EmptyDynamicTitle === undefined) {
        window.EmptyDynamicTitle = {};
    }
    window.EmptyDynamicTitle[tableHtmlId] = [];

    if (IsHisUIDataTable(tableHtmlId)) {
        //表头处理规则：“先处理父表头，再处理叶子表头，并且叶子表头列从左到右依次和定义的表头对应处理”
        var dynamicTitleFields = [];
        var nurOldOpts = null;
        var nurOldPagerOpts = null;
        if ($("#div_" + tableHtmlId).data("nurOldOpts") === undefined) {
            var oldOpts = $.extend(true, {}, $("#" + tableHtmlId).datagrid('options'));
            $("#div_" + tableHtmlId).data("nurOldOpts", oldOpts);
            if (!!$("#" + tableHtmlId).data("amendDataDisplay")) {
                var oldFilelds = $.extend(true, {}, $("#" + tableHtmlId).data("filelds"));
                $("#div_" + tableHtmlId).data("filelds", oldFilelds);
            }
            else {
                var oldFilelds = $.extend(true, {}, GetTableColumnFields(tableHtmlId));
                $("#div_" + tableHtmlId).data("filelds", oldFilelds);
            }
        }
        if (!!$("#" + tableHtmlId).data("amendDataDisplay"))
            $("#" + tableHtmlId).data("filelds", $.extend(true, {}, $("#div_" + tableHtmlId).data("filelds")));
        nurOldOpts = $("#div_" + tableHtmlId).data("nurOldOpts");
        nurOldPagerOpts = $('#' + tableHtmlId).datagrid('getPager').pagination("options");
        var tempDynamicTitleFields = [];
        $.each(nurOldOpts.columns, function (i, row) {
            $.each(row, function (j, col) {
                if (!!col.dynamictitle && col.dynamictitle == true)
                    tempDynamicTitleFields.push(col["field"]);
            });
        });

        var tempFields = [];
        if (!!$("#" + tableHtmlId).data("amendDataDisplay"))
            tempFields = $("#div_" + tableHtmlId).data("filelds")[1];//0:frozenColumns;
        else
            tempFields = $("#div_" + tableHtmlId).data("filelds");
        $.each(tempFields, function (i, f) {
            if (tempDynamicTitleFields.indexOf(f) > -1)
                dynamicTitleFields.push(f);
        });

        if (!!nurOldOpts.HiddenEmptyDyTitle) {
            var mergeInfos = GetDynamicTableTitleMergeInfos(nurOldOpts);
            var newOpts = $.extend(true, {}, nurOldOpts);
            var hiddenDynamicTitleFields = [];
            var hiddenDynamicTitleFieldsFunc = function () {
                var toBeDeleted = [];
                var toBeDeletedWidth = 0;
                $.each(hiddenDynamicTitleFields, function (i, dyField) {
                    $.each(mergeInfos.keys, function (k, mergeId) {
                        var mergeSub = mergeInfos.vals[k];
                        var index = -1;
                        $.each(mergeSub, function (j, c) {
                            if (c.indexOf(dyField + "F") != -1) {
                                index = j;
                                return false;
                            }
                        });
                        if (index > -1) {
                            mergeSub.splice(index, 1);
                            var _tsplit = mergeId.split("_");
                            var strcolspan = "" + newOpts.columns[_tsplit[0]][_tsplit[1]].colspan;
                            var _tsplit2 = strcolspan.split("\"");
                            _tsplit2[0] = +_tsplit2[0] - 1;
                            newOpts.columns[_tsplit[0]][_tsplit[1]].colspan = _tsplit2.join("\"");
                        }
                    });
                });

                $.each(mergeInfos.vals, function (i, n) {
                    var mergeId = mergeInfos.keys[i];
                    var _tsplit = mergeId.split("_");
                    if (n.length == 0) {
                        toBeDeleted.push(_tsplit[0] + "_" + _tsplit[1]);
                    }
                    else if (n.length == 1)
                    {
                        var subId = n[0];
                        var _tsplit2 = subId.split("_");
                        newOpts.columns[_tsplit[0]][_tsplit[1]].width = newOpts.columns[_tsplit2[0]][_tsplit2[1]].width;
                    }
                });

                for (var i = 0; i < newOpts.columns.length; i++) {
                    var newArray = [];
                    for (var j = 0; j < newOpts.columns[i].length; j++) {
                        var n = newOpts.columns[i][j];
                        if (!!n.field && $.inArray(n.field, hiddenDynamicTitleFields) > -1){
                            toBeDeletedWidth += n.width;
                            continue;
                        }
                        else if($.inArray(i + "_" + j, toBeDeleted) > -1)
                            continue;
                        else
                            newArray.push(n);
                    }
                    newOpts.columns[i] = newArray;
                }
                if (!!$("#" + tableHtmlId).data("amendDataDisplay")) {
                    var columns = $("#" + tableHtmlId).data("filelds")[1];//0:frozenColumns
                    $("#" + tableHtmlId).data("filelds")[1] = $.grep(columns, function (n, i) {
                        return $.inArray(n, hiddenDynamicTitleFields) > -1;
                    }, true);
                }
                var adaptionWidth = nurOldOpts.width - toBeDeletedWidth;
                $("#div_" + tableHtmlId).width(adaptionWidth);
                $("#" + tableHtmlId).datagrid(newOpts);
                $('#' + tableHtmlId).datagrid('resize', { width: adaptionWidth });
                $('#' + tableHtmlId).datagrid('getPager').pagination(nurOldPagerOpts);
            }

            if (slectedValue == kongbiaotou) {
                hiddenDynamicTitleFields = dynamicTitleFields;
                hiddenDynamicTitleFieldsFunc();
            }
            else {
                var _titles = slectedValue.split(" ");
                _titles.shift();

                var dyTitleIndexs = $.map(_titles, function (n) {
                    return n.split("-")[0];
                });
                
                var toBeDeleted = [];
                $.each(newOpts.columns, function (i, row) {
                    $.each(row, function (j, col) {
                        if (!!col["colspan"]) {
                            var _bandingIndex = -1;
                            var _colspan = "" + col["colspan"];//保证是个字符串
                            if (_colspan.indexOf("dyTitle") > -1) {
                                _bandingIndex = _colspan.split("\"")[2];
                                var _findIndex = $.inArray(_bandingIndex, dyTitleIndexs);
                                if (_findIndex == -1)
                                    col["title"] = "";
                                else {
                                    toBeDeleted.push(_findIndex);
                                    col["title"] = _titles[_findIndex].split("-")[1];
                                }
                            } 
                        }
                    });
                });
                //过滤已经使用的父表头
                _titles = $.grep(_titles, function (n, i) {
                    return $.inArray(i, toBeDeleted) > -1;
                }, true);
                
                toBeDeleted = [];
                //使用剩余的表头，按顺序重置叶子表头
                $.each(_titles, function (k, t) {
                    var isFind = false;
                    $.each(newOpts.columns, function (i, row) {
                        $.each(row, function (j, col) {
                            if (!!col["field"] && col["field"] === dynamicTitleFields[k]) {
                                if (t.split("-")[1] == "") {
                                    //不做处理
                                }
                                else {
                                    col["title"] = t.split("-")[1];
                                    toBeDeleted.push(col["field"]);
                                }
                                isFind = true;
                                return false;
                            }
                        });
                        if (isFind)
                            return false;
                    });
                });
                //过滤已经设置表头的叶子表头
                dynamicTitleFields = $.grep(dynamicTitleFields, function (n, i) {
                    return $.inArray(n, toBeDeleted) > -1;
                }, true);

                hiddenDynamicTitleFields = dynamicTitleFields;
                hiddenDynamicTitleFieldsFunc();
            }
        }
        else {
            if (slectedValue == kongbiaotou) {
                $.each(dynamicTitleFields, function (i, n) {
                    dynamicTitleNew[n] = "";
                    window.EmptyDynamicTitle[tableHtmlId].push(n);
                });
                $("td[dyTitle]").each(function (i) {
                    return $(this).find("span").first().html("");
                });
            }
            else {
                var _titles = slectedValue.split(" ");
                _titles.shift();

                var dyTitleIndexs = $.map(_titles, function (n) {
                    return n.split("-")[0];
                });
                var toBeDeleted = [];
                $("td[dyTitle]").each(function (i) {
                    var _bandingIndex = $(this).attr("dyTitle");
                    var _findIndex = $.inArray(_bandingIndex, dyTitleIndexs);
                    if (_findIndex == -1)
                        return $(this).find("span").first().html("");
                    else {
                        toBeDeleted.push(_findIndex);
                        return $(this).find("span").first().html(_titles[_findIndex].split("-")[1]);
                    }
                        
                });

                //过滤已经使用的父表头
                _titles = $.grep(_titles, function (n, i) {
                    return $.inArray(i, toBeDeleted) > -1;
                }, true);

                $.each(dynamicTitleFields, function (i, n) {
                    if (!!_titles[i] && _titles[i].split("-").length > 1 && _titles[i].split("-")[1] != "") {
                        dynamicTitleNew[n] = _titles[i].split("-")[1];
                    }
                    else {
                        window.EmptyDynamicTitle[tableHtmlId].push(n);
                        dynamicTitleNew[n] = "";
                    }
                });
            }
            $("#" + tableHtmlId).datagrid('setColumnTitle', dynamicTitleNew);
        }
    }
    else {
        if (slectedValue == kongbiaotou) {
            $("td[dyTitle]").each(function (i) {
                var titleEle = $(this).find("p[id^='MutiLableElement']");
                if (titleEle.length == 0)
                    titleEle = $(this).find("div[id^='LableElement']")

                if (titleEle.length == 1)
                    $(titleEle).html("");
            });
        }
        else {
            var _titles = slectedValue.split(" ");
            _titles.shift();

            var dyTitleIndexs = $.map(_titles, function (n) {
                return n.split("-")[0];
            });

            $("td[dyTitle]").each(function (i) {
                var _bandingIndex = $(this).attr("dyTitle");
                var _findIndex = $.inArray(_bandingIndex, dyTitleIndexs);

                var titleEle = $(this).find("p[id^='MutiLableElement']");
                if (titleEle.length == 0)
                    titleEle = $(this).find("div[id^='LableElement']")

                if (titleEle.length == 1)
                {
                    if (_findIndex == -1)
                        $(titleEle).first().html("");
                    else
                        $(titleEle).first().html(_titles[_findIndex].split("-")[1]);
                }
            });
        }
    }

    DBTableLoadData(tableHtmlId);   
}

/**
     *24小时统计
     @method TwentyFourHoursStatistics 
**/
function TwentyFourHoursStatistics(gatherFun, callbackFun, templateEmrCode, windowsInfo,json) {
    var startTime = json["startTime"];//开始时间
    var endTime = json["endTime"];//结束时间
    var disTitle = json["disTitle"];//统计信息标题
    var signField = json["signField"];//签名字段
    var signDate = json["signDate"];//签名日期

    var signTime = json["signTime"];//签名时间
    var inOutType = json["inOutType"];//出入量类型

    var tempData = json["tempData"];//
    var ctLOC = json["ctLOC"];//科室
   
    var inSumTitle = json["inSumTitle"];//出量分项标题
    var inInfoTitle = json["inInfoTitle"];//入量分项标题

    var outSumTitle = json["outSumTitle"];//总出量标题
    var outInfoTitle = json["outInfoTitle"];//出量分项标题

    var startStatistics = json["startStatistics"];//开启统计
    var inDetail = json["inDetail"];//明细
    var inTitle = json["inTitle"];//标题


    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    var sender = $(arguments.callee.caller.arguments[0].target).parent().parent();//按钮本身
  
    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要回调配置进行辅助！"),"info");
        return;
    }

    var refreshQueryParam = null;
    var tableHtmlId = null;
    var queryParam = ObjectToUrlParams(window[gatherFun](),"^");
    
    var specifyFileds = window[callbackFun]();
    if (specifyFileds.length == 1) {
        tableHtmlId = specifyFileds[0];
        refreshQueryParam = $("#" + tableHtmlId).attr("queryInfo");
    }
    else {
        $.messager.alert(" ", $g("请检查回调配置，此次调用需要刷新表格"), "info");
        return;
    }

    if (($.type(window[startTime]) === "function")) {
        startTime = window[startTime]();
        if (!!startTime && !isTime(startTime,"开始时间"))
            return false;
    }

    if (($.type(window[endTime]) === "function")) {
        endTime = window[endTime]();
        if (!!endTime && !isTime(endTime,"结束时间"))
            return false;
    }

    var postAjax = function () {
        var dataPost = {};
        dataPost["templateVersionGuid"] = TemplateGUID;
        dataPost["EpisodeID"] = EpisodeID;
        dataPost["LOGON.CTLOCID"] = session['LOGON.CTLOCID'];
        dataPost["LOGON.WARDID"] = session['LOGON.WARDID'];
        dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
        dataPost["LOGON.USERID"] = session['LOGON.USERID'];
        dataPost["Type"] = "TwentyFourHoursStatistics";
        dataPost["queryInfo"] = queryParam;
        dataPost["startTime"] = startTime;
        dataPost["endTime"] = endTime;
        dataPost["disTitle"] = disTitle;
        dataPost["signField"] = signField;
        dataPost["signDate"] = signDate;
        dataPost["signTime"] = signTime;
        dataPost["inOutType"] = inOutType;
        dataPost["ctLOC"] = ctLOC;
        dataPost["inSumTitle"] = inSumTitle;
        dataPost["inInfoTitle"] = inInfoTitle;
        dataPost["outSumTitle"] = outSumTitle;
        dataPost["outInfoTitle"] = outInfoTitle;

        dataPost["startStatistics"] = startStatistics;
        dataPost["inDetail"] = inDetail;
        dataPost["inTitle"] = inTitle; 
        dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();

        if (tempData === "true") //临时统计，不入库
        {
            var msg = tkMakeServerCall("NurMp.InOutVolume.InOutRecComm", "FindInOutRec", JSON.stringify(dataPost));
            var reMsg = JSON.parse(msg);
            if (MsgIsOK(reMsg)) {
                var tempStatisticsRowData = reMsg.data;
                tempStatisticsRowData.StatisticsInfo = {};
                tempStatisticsRowData.StatisticsInfo.type = "TwentyFourHoursStatistics";
				
                $.messager.alert(" ", $g("操作成功"), "success", function () {
					var hasmergeColumns = (!!$("#" + tableHtmlId).data("StatisticsMergeDisColumns"));

					if (hasmergeColumns) {

					    var mergeColumns = $("#" + tableHtmlId).data("StatisticsMergeDisColumns");
					    var startField = mergeColumns[0];
					    var mergeCount = mergeColumns.length;
					    var text = "";
					    for (var i = 0; i < mergeCount; i++) {
					        var Field = mergeColumns[i];
					        var tmpText = tempStatisticsRowData[Field];
					        if (!!tmpText) {
					            text += tempStatisticsRowData[Field];
					        } else {
					            text += " ";
					        }
					    }
					    tempStatisticsRowData[startField] = text;
					}

					$('#' + tableHtmlId).datagrid('insertRow', {
					    index: 0,
					    row: tempStatisticsRowData
					});
					if (hasmergeColumns) {
					    var rowData = tempStatisticsRowData;
					    $('#' + tableHtmlId).datagrid('mergeCells', {
					        index: 0,
					        field: startField,
					        colspan: mergeCount
					    });

					    $('#div_' + tableHtmlId + " .datagrid-body>.datagrid-btable tr").first().css("height", '34px');
					}
                });

            } else {
                $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
            }
        }
        else {
            var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.TemplateInOutRecComm&MethodName=SaveComm";
            url = GetMWToken(url);
            $.ajax({
                type: "POST",
                url: url,
                data: { datapost: JSON.stringify(dataPost) },
                success: function (msg) {
                    var reMsg = JSON.parse(msg);
                    if (MsgIsOK(reMsg)) {
                        if (/^\d+$/.test(reMsg.data))//正常应返回流水号
                        {
                            if (window.CAVerify > 0 && !!signField && !!window.CAVarCert && !!window.CAContainerName) {
                                __NurseCASignDataByNurMPDataIDs(reMsg.data, sender);
                            }
                            $.messager.alert(" ", $g("操作成功"), "success", function () {
                                DBTableFirstLoadData(tableHtmlId,true);
                            });

                        }
                        else {
                            $.messager.alert(" ", reMsg.data, "error");
                        }

                    }
                    else {
                        $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
                    }
                }
            });
        }
    }

    if (window.CAVerify > 0 && !!signField && (!window.CAVarCert || !window.CAContainerName)) {
        __CASingLoginAsync(postAjax, signField);
    }
    else
    {
        postAjax();
    }
}

/**
     *最大值最小值统计
     @method MaxMinStatistics 
**/
function MaxMinStatistics(gatherFun, callbackFun, templateEmrCode, windowsInfo)
{
    
    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    var sender = $(arguments.callee.caller.arguments[0].target).parent().parent();//按钮本身
 
    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要采集其他数据进行辅助！"), "info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要回调配置进行辅助！"), "info");
        return;
    }

    var refreshQueryParam = null;
    var tableHtmlId = null;
    var queryParam = ObjectToUrlParams(window[gatherFun](), "^");

    var specifyFileds = window[callbackFun]();
    if (specifyFileds.length == 1) {
        tableHtmlId = specifyFileds[0];
        refreshQueryParam = $("#" + tableHtmlId).attr("queryInfo");
    }
    else {
        $.messager.alert(" ", $g("请检查回调配置，此次调用需要刷新表格"), "info");
        return;
    }

    var postAjax = function () {
        var dataPost = {};
        dataPost["templateVersionGuid"] = TemplateGUID;
        dataPost["EpisodeID"] = EpisodeID;
        dataPost["LOGON.CTLOCID"] = session['LOGON.CTLOCID'];
        dataPost["LOGON.WARDID"] = session['LOGON.WARDID'];
        dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
        dataPost["LOGON.USERID"] = session['LOGON.USERID'];
        dataPost["Type"] = "MaxMinStatistics";
        dataPost["queryInfo"] = queryParam;
       

        dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
        var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.InOutVolume.MaxMinStatistics&MethodName=SaveComm";
        url = GetMWToken(url);
        $.ajax({
            type: "POST",
            url: url,
            data: { datapost: JSON.stringify(dataPost) },
            success: function (msg) {
                var reMsg = JSON.parse(msg)
                if (MsgIsOK(reMsg)) {
                    if (/^\d+$/.test(reMsg.data))//正常应返回流水号
                    {
                        if (window.CAVerify > 0 && !!signField && !!window.CAVarCert && !!window.CAContainerName) {
                            __NurseCASignDataByNurMPDataIDs(reMsg.data, sender);
                        }
                        $.messager.alert(" ", $g("操作成功"), "success", function () {
                            DBTableFirstLoadData(tableHtmlId, true);
                        });

                    }
                    else {
                        $.messager.alert(" ", reMsg.data, "error");
                    }

                }
                else {
                    $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
                }
            }
        });
    }

    if (window.CAVerify > 0 && !!signField && (!window.CAVarCert || !window.CAContainerName)) {
        __CASingLoginAsync(postAjax, signField);
    }
    else {
        postAjax();
    }
}

/**
     *日间小结
     @method DaytimeStatistics
**/
function DaytimeStatistics(gatherFun, callbackFun, templateEmrCode, windowsInfo,json) {
    var startTime = json["startTime"];//开始时间
    var endTime = json["endTime"];//结束时间
    var disTitle = json["disTitle"];//统计信息标题
    var signField = json["signField"];//签名字段
    var signDate = json["signDate"];//签名日期

    var signTime = json["signTime"];//签名时间
    var inOutType = json["inOutType"];//出入量类型

    var tempData = json["tempData"];//
    var ctLOC = json["ctLOC"];//科室

    var inSumTitle = json["inSumTitle"];//出量分项标题
    var inInfoTitle = json["inInfoTitle"];//入量分项标题

    var outSumTitle = json["outSumTitle"];//总出量标题
    var outInfoTitle = json["outInfoTitle"];//出量分项标题

    var startStatistics = json["startStatistics"];//开启统计
    var inDetail = json["inDetail"];//明细
    var inTitle = json["inTitle"];//标题
    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    var sender = $(arguments.callee.caller.arguments[0].target).parent().parent();//按钮本身
    
    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要回调配置进行辅助！"),"info");
        return;
    }

    var refreshQueryParam = null;
    var tableHtmlId = null;
    var queryParam = ObjectToUrlParams(window[gatherFun](), "^");

    var specifyFileds = window[callbackFun]();
    if (specifyFileds.length == 1) {
        tableHtmlId = specifyFileds[0];
        refreshQueryParam = $("#" + tableHtmlId).attr("queryInfo");
    }
    else {
        $.messager.alert(" ", $g("请检查回调配置，此次调用需要刷新表格"), "info");
        return;
    }

    if (($.type(window[startTime]) === "function")) {
        startTime = window[startTime]();
        if (!!startTime && !isTime(startTime, "开始时间"))
            return false;
    }

    if (($.type(window[endTime]) === "function")) {
        endTime = window[endTime]();
        if (!!endTime && !isTime(endTime, "结束时间"))
            return false;
    }

    var postAjax = function () {
        var dataPost = {};
        dataPost["templateVersionGuid"] = TemplateGUID;
        dataPost["EpisodeID"] = EpisodeID;
        dataPost["LOGON.CTLOCID"] = session['LOGON.CTLOCID'];
        dataPost["LOGON.WARDID"] = session['LOGON.WARDID'];
        dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
        dataPost["LOGON.USERID"] = session['LOGON.USERID'];
        dataPost["Type"] = "DaytimeStatistics";
        dataPost["queryInfo"] = queryParam;
        dataPost["startTime"] = startTime;
        dataPost["endTime"] = endTime;
        dataPost["disTitle"] = disTitle;
        dataPost["signField"] = signField;
        dataPost["signDate"] = signDate;
        dataPost["signTime"] = signTime;
        dataPost["inOutType"] = inOutType;
        dataPost["ctLOC"] = ctLOC;
        dataPost["inSumTitle"] = inSumTitle;
        dataPost["inInfoTitle"] = inInfoTitle;
        dataPost["outSumTitle"] = outSumTitle;
        dataPost["outInfoTitle"] = outInfoTitle;
        dataPost["startStatistics"] = startStatistics;
        dataPost["inDetail"] = inDetail;
        dataPost["inTitle"] = inTitle;
        dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
        var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.TemplateInOutRecComm&MethodName=SaveComm";
        url = GetMWToken(url);
        $.ajax({
            type: "POST",
            url: url,
            data: { datapost: JSON.stringify(dataPost) },
            success: function (msg) {
                var reMsg = JSON.parse(msg)
                if (MsgIsOK(reMsg)) {
                    if (/^\d+$/.test(reMsg.data))//正常应返回流水号
                    {
                        if (window.CAVerify > 0 && !!signField && !!window.CAVarCert && !!window.CAContainerName) {
                            __NurseCASignDataByNurMPDataIDs(reMsg.data, sender);
                        }
                        $.messager.alert(" ", $g("操作成功"), "success", function () {
                            DBTableFirstLoadData(tableHtmlId, true);
                        });
                    }
                    else {
                        $.messager.alert(" ", reMsg.data, "error");
                    }

                }
                else {
                    $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
                }
            }
        });
    }

    if (window.CAVerify > 0 && !!signField && (!window.CAVarCert || !window.CAContainerName)) {
        __CASingLoginAsync(postAjax, signField);
    }
    else {
        postAjax();
    }
}

/**
     *单项统计
     @method SingleItemStatistics
**/
function SingleItemStatistics(gatherFun, callbackFun, templateEmrCode, windowsInfo,json) {

    var startTime = json["startTime"];//开始时间
    var endTime = json["endTime"];//结束时间
    var disTitle = json["disTitle"];//统计信息标题
    var signField = json["signField"];//签名字段
    var signDate = json["signDate"];//签名日期

    var signTime = json["signTime"];//签名时间
    var inOutType = json["inOutType"];//出入量类型

    var statisticsType = json["statisticsType"];//统计类型
    var singleItems = json["singleItems"];//单项

    var resultType = json["resultType"];//结果类型
    var ctLOC = json["ctLOC"];//科室

  
    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    var sender = $(arguments.callee.caller.arguments[0].target).parent().parent();//按钮本身
    
    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要采集其他数据进行辅助！"), "info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要回调配置进行辅助！"), "info");
        return;
    }

    var refreshQueryParam = null;
    var tableHtmlId = null;
    
    var queryParam = ObjectToUrlParams(window[gatherFun](), "^");
    var queryParamObj = UrlParamsToObject(queryParam, "^");
    if (!!queryParamObj["singleItems"])
        singleItems = queryParamObj["singleItems"];

    var specifyFileds = window[callbackFun]();
    if (specifyFileds.length == 1) {
        tableHtmlId = specifyFileds[0];
        refreshQueryParam = $("#" + tableHtmlId).attr("queryInfo");
    }
    else {
        $.messager.alert(" ", $g("请检查回调配置，此次调用需要刷新表格"), "info");
        return;
    }

    if (($.type(window[startTime]) === "function")) {
        startTime = window[startTime]();
        if (!!startTime && !isTime(startTime, "开始时间"))
            return false;
    }
    else {
        if (!!startTime && !isTime(startTime, "开始时间"))
            return false;
    }

    if (($.type(window[endTime]) === "function")) {
        endTime = window[endTime]();
        if (!!endTime && !isTime(endTime, "结束时间"))
            return false;
    }
    else {
        if (!!endTime && !isTime(endTime, "结束时间"))
            return false;
    }

    var postAjax = function () {
        var dataPost = {};
        dataPost["templateVersionGuid"] = TemplateGUID;
        dataPost["EpisodeID"] = EpisodeID;
        dataPost["LOGON.CTLOCID"] = session['LOGON.CTLOCID'];
        dataPost["LOGON.WARDID"] = session['LOGON.WARDID'];
        dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
        dataPost["LOGON.USERID"] = session['LOGON.USERID'];
        dataPost["Type"] = "SingleItemStatistics";
        dataPost["queryInfo"] = queryParam;
        dataPost["startTime"] = startTime;
        dataPost["endTime"] = endTime;
        dataPost["disTitle"] = disTitle;
        dataPost["signField"] = signField;
        dataPost["signDate"] = signDate;
        dataPost["signTime"] = signTime;
        dataPost["inOutType"] = inOutType;
        dataPost["statisticsType"] = statisticsType;
        dataPost["singleItems"] = singleItems;
        dataPost["resultType"] = resultType;
        dataPost["ctLOC"] = ctLOC;
        dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
        var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.InOutVolume.SingleItemStatistics&MethodName=SaveComm";
        url = GetMWToken(url);
        $.ajax({
            type: "POST",
            url: url,
            data: { datapost: JSON.stringify(dataPost) },
            success: function (msg) {
                var reMsg = JSON.parse(msg)
                if (MsgIsOK(reMsg)) {
                    if (/^\d+$/.test(reMsg.data))//正常应返回流水号
                    {
                        if (window.CAVerify > 0 && !!signField && !!window.CAVarCert && !!window.CAContainerName) {
                            __NurseCASignDataByNurMPDataIDs(reMsg.data, sender);
                        }
                        $.messager.alert(" ", $g("操作成功"), "success", function () {
                            DBTableFirstLoadData(tableHtmlId, true);
                        });
                    }
                    else {
                        $.messager.alert(" ", reMsg.data, "error");
                    }

                }
                else {
                    $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
                }
            }
        });
    }

    if (window.CAVerify > 0 && !!signField && (!window.CAVarCert || !window.CAContainerName)) {
        __CASingLoginAsync(postAjax, signField);
    }
    else {
        postAjax();
    }

    
}

/**
     *按时间段统计
     @method TimeQuantumStatistics
**/
function TimeQuantumStatistics(gatherFun, callbackFun, templateEmrCode, windowsInfo,json) {
    var startTime = json["startTime"];//开始时间
    var endTime = json["endTime"];//结束时间
    var disTitle = json["disTitle"];//统计信息标题
    var signField = json["signField"];//签名字段
    var signDate = json["signDate"];//签名日期

    var signTime = json["signTime"];//签名时间
    var inOutType = json["inOutType"];//出入量类型

    var tempData = json["tempData"];//
    var ctLOC = json["ctLOC"];//科室

    var inSumTitle = json["inSumTitle"];//出量分项标题
    var inInfoTitle = json["inInfoTitle"];//入量分项标题

    var outSumTitle = json["outSumTitle"];//总出量标题
    var outInfoTitle = json["outInfoTitle"];//出量分项标题

    var startStatistics = json["startStatistics"];//开启统计
    var inDetail = json["inDetail"];//明细
    var inTitle = json["inTitle"];//标题
    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    var sender = $(arguments.callee.caller.arguments[0].target).parent().parent();//按钮本身
    
    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要回调配置进行辅助！"),"info");
        return;
    }

    var refreshQueryParam = null;
    var tableHtmlId = null;
    var queryParam = ObjectToUrlParams(window[gatherFun](), "^");

    var specifyFileds = window[callbackFun]();
    if (specifyFileds.length == 1) {
        tableHtmlId = specifyFileds[0];
        refreshQueryParam = $("#" + tableHtmlId).attr("queryInfo");
    }
    else {
        $.messager.alert(" ", $g("请检查回调配置，此次调用需要刷新表格"), "info");
        return;
    }

    if (($.type(window[startTime]) === "function")) {
        startTime = window[startTime]();
        if (!!startTime && !isTime(startTime, "开始时间"))
            return false;
    }

    if (($.type(window[endTime]) === "function")) {
        endTime = window[endTime]();
        if (!!endTime && !isTime(endTime, "结束时间"))
            return false;
    }

    var postAjax = function () {
        var dataPost = {};
        dataPost["templateVersionGuid"] = TemplateGUID;
        dataPost["EpisodeID"] = EpisodeID;
        dataPost["LOGON.USERCODE"] = session['LOGON.USERCODE'];
        dataPost["LOGON.CTLOCID"] = session['LOGON.CTLOCID'];
        dataPost["LOGON.WARDID"] = session['LOGON.WARDID'];
        dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
        dataPost["LOGON.USERID"] = session['LOGON.USERID'];
        dataPost["Type"] = "TimeQuantumStatistics";
        dataPost["queryInfo"] = queryParam;
        dataPost["startTime"] = startTime;
        dataPost["endTime"] = endTime;
        dataPost["disTitle"] = disTitle;
        dataPost["signField"] = signField;
        dataPost["signDate"] = signDate;
        dataPost["signTime"] = signTime;
        dataPost["inOutType"] = inOutType;
        dataPost["ctLOC"] = ctLOC;
        dataPost["inSumTitle"] = inSumTitle;
        dataPost["inInfoTitle"] = inInfoTitle;
        dataPost["outSumTitle"] = outSumTitle;
        dataPost["outInfoTitle"] = outInfoTitle;
        dataPost["startStatistics"] = startStatistics;
        dataPost["inDetail"] = inDetail;
        dataPost["inTitle"] = inTitle;
        dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
        var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.TemplateInOutRecComm&MethodName=SaveComm";
        url = GetMWToken(url);
        $.ajax({
            type: "POST",
            url: url,
            data: { datapost: JSON.stringify(dataPost) },
            success: function (msg) {
                var reMsg = JSON.parse(msg)
                if (MsgIsOK(reMsg)) {
                    if (/^\d+$/.test(reMsg.data))//正常应返回流水号
                    {
                        if (window.CAVerify > 0 && !!signField && !!window.CAVarCert && !!window.CAContainerName) {
                            __NurseCASignDataByNurMPDataIDs(reMsg.data, sender);
                        }
                        $.messager.alert(" ", $g("操作成功"), "success", function () {
                            DBTableFirstLoadData(tableHtmlId, true);
                        });
                    }
                    else {
                        $.messager.alert(" ", reMsg.data, "error");
                    }

                }
                else {
                    $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
                }
            }
        });
    }

    if (window.CAVerify > 0 && !!signField && (!window.CAVarCert || !window.CAContainerName)) {
        __CASingLoginAsync(postAjax, signField);
    }
    else {
        postAjax();
    }
}

/**
     *记录查询
     @method RecQuery
**/
function RecQuery(gatherFun, callbackFun, templateEmrCode, windowsInfo, sortOrder) {
    if (!($.type(window[gatherFun]) === "function")){
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要回调配置进行辅助！"),"info");
        return;
    }
    var queryParam = ObjectToUrlParams(window[gatherFun](), "^");
    var specifyFileds = window[callbackFun]();

    if (!!sortOrder){
        if (!!queryParam)
            queryParam += "^sortOrder=" + sortOrder;
        else 
            queryParam += "sortOrder=" + sortOrder;
    }
        
    if (specifyFileds.length == 1){
        var tableHtmlId = specifyFileds[0];
        $("#" + tableHtmlId).attr("queryInfo", queryParam);
        GetDataFromService(null, specifyFileds, GetDBTablePageInfo(tableHtmlId,1), queryParam);
    }
    else{
        $.messager.alert(" ",$g("请检查回调配置，此次调用需要刷新表格"),"info");
    }

}

/**
     *倒序记录查询
     @method RecQuery
**/
function DescOrderRecQuery(gatherFun, callbackFun, templateEmrCode, windowsInfo) {
    RecQuery(gatherFun, callbackFun, templateEmrCode, windowsInfo,"desc");
}

/**
     *正序记录查询
     @method RecQuery
**/
function AscOrderRecQuery(gatherFun, callbackFun, templateEmrCode, windowsInfo) {
    RecQuery(gatherFun, callbackFun, templateEmrCode, windowsInfo, "asc");
}

/**
     *更新查询
     @method UpdateQuery
**/
function UpdateQuery(gatherFun, callbackFun) {
    
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要回调配置进行辅助！"),"info");
        return;
    }

    var queryParam = "";
    if ($.type(window[gatherFun]) === "function") {
        queryParam = ObjectToUrlParams(window[gatherFun](), "^");
    }
    
    var specifyFileds = window[callbackFun]();

    GetDataFromService(null, specifyFileds, null, queryParam);
}

/**
     *上一个患者
     @method PrePatient
**/
function PrePatient(gatherFun, callbackFun, templateEmrCode, windowsInfo, conditionFunc) {
    var rtn = null;
    var patientEpisodeID = null;
    if (!!conditionFunc && $.type(window[conditionFunc]) === "function") {
        rtn = window[conditionFunc]();
        if ($.type(rtn) === "boolean") {//返回false，直接退出
            if (!rtn)
                return;
        }
        else {//返回就诊号，切换患者
            patientEpisodeID = ToNumber(rtn);
        }
    }
    if (patientEpisodeID === -9999)
        $.messager.alert(" ", $g("返回错误的就诊号"), "info");
    else
        SwitchPatient(-1, patientEpisodeID);
}


/**
     *下一个患者
     @method NextPatient
**/
function NextPatient(gatherFun, callbackFun, templateEmrCode, windowsInfo, conditionFunc) {
    var rtn = null;
    var patientEpisodeID = null;
    if (!!conditionFunc && $.type(window[conditionFunc]) === "function") {
        rtn = window[conditionFunc]();
        if ($.type(rtn) === "boolean") {//返回false，直接退出
            if (!rtn)
                return;
        }
        else {//返回就诊号，切换患者
            patientEpisodeID = ToNumber(rtn);
        }
    }
    if (patientEpisodeID === -9999)
        $.messager.alert(" ", $g("返回错误的就诊号"), "info");
    else
        SwitchPatient(1, patientEpisodeID);
}

/**
     *数据手动同步
     @method DBMTSync
**/
function DBMTSync(gatherFun, callbackFun, templateEmrCode, windowsInfo, syncTempateGuid)
{
    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!templateEmrCode)
    {
        $.messager.alert(" ", $g("请检查设计器,此方法需配置录入模板"), "info");
        return;
    }

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要采集其他数据进行辅助！"), "info");
        return;
    }

    var SpecifyFiledsData = window[gatherFun]();


    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ", $g("请检查设计器,此方法需采集指定的表格"), "info");
        return;
    }
    var checkedIds = DataTableCheckRowIds(tableID);
    if (!checkedIds)
    {
        $.messager.alert(" ", $g("请选择要同步的记录"), "info");
        return;
    }

    var dataPost = {};
    dataPost["templateVersionGuid"] = TemplateGUID;
    dataPost["EpisodeID"] = EpisodeID;
    dataPost["LOGON.CTLOCID"] = session['LOGON.CTLOCID'];
    dataPost["LOGON.WARDID"] = session['LOGON.WARDID'];
    dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
    dataPost["LOGON.USERID"] = session['LOGON.USERID'];
    dataPost["dataTempateGuid"] = templateEmrCode;
    dataPost["syncTempateGuid"] = syncTempateGuid;
    dataPost["rowIds"] = checkedIds;
    dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
    var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.Sources.ManualSynch&MethodName=ManualSynchComm";
    url = GetMWToken(url);
    $.ajax({
        type: "POST",
        url: url,
        data: { datapost: JSON.stringify(dataPost) },
        success: function (msg) {
            var reMsg = JSON.parse(msg)
            if (MsgIsOK(reMsg)) {
                if (/^\d+$/.test(reMsg.data))//正常应返回流水号
                {
                    $.messager.alert(" ", $g("操作成功"), "success", function () {
                    });
                }
                else {
                    $.messager.alert(" ", reMsg.data, "error");
                }
            }
            else {
                $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
            }
        }
    });
}

/**
     *记录作废
     @method RecCancel 
**/
function RecCancel(gatherFun, callbackFun) {
    
    var _msg = IsPermission(GetTopTempletGuid(), "delete");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要回调配置进行辅助！"),"info");
        return;
    }
  
    var specifyFileds = window[callbackFun]();
    var queryParam = null;
    var tableHtmlId = null;
    if (specifyFileds.length == 1) {
        tableHtmlId = specifyFileds[0];
        queryParam = $("#" + tableHtmlId).attr("queryInfo");
    }
    else {
        $.messager.alert(" ", $g("请检查回调配置，此次调用需要刷新表格"), "info");
        return;
    }

    var SpecifyFiledsData = window[gatherFun]();
    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ",$g("请检查设计器,此方法需采集指定的表格"),"info");
        return;
    }
    var checkedIds = DataTableCheckRowIds(tableID);
    if (!checkedIds)
    {
        $.messager.alert(" ",$g("请选择要作废的记录"),"info");
        return;
    }
    $.messager.confirm($g("提示"), $g("你确定要作废记录吗?"), function (r) {
        if (r) {
          //  $.messager.popover({ msg: "点击了确定", type: 'info' });
            var dataPost = {};
            dataPost["templateVersionGuid"] = TemplateGUID;
            dataPost["EpisodeID"] = EpisodeID;
            dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
            dataPost["RecIds"] = checkedIds;
            dataPost["LOGON.USERCODE"] = session['LOGON.USERCODE'];
            dataPost["LOGON.USERID"] = session['LOGON.USERID'];
            dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
            var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.Template.MultData&MethodName=RecCancel";
            url = GetMWToken(url);
            $.ajax({
                type: "POST",
                url: url,
                data: { datapost: JSON.stringify(dataPost) },
                success: function (msg) {
                    var reMsg = JSON.parse(msg)
                    if (MsgIsOK(reMsg)) {
                        if (/^\d+$/.test(reMsg.data))//正常应返回流水号
                        {
                            $.messager.alert(" ", $g("操作成功"), "success", function () {
                                GetDataFromService(null, specifyFileds, GetDBTablePageInfo(tableHtmlId, GetDBTablePageNumber(tableHtmlId)), queryParam);
                            });
                        }
                        else {
                            $.messager.alert(" ",reMsg.data,"error");
                        }

                    }
                    else {
                        $.messager.alert($g("操作失败"),$g("错误原因：") + reMsg.msg,"error");
                    }
                }
            });
        } else {
            // $.messager.popover({ msg: "点击了取消" });
        }
    });  
}

/**
     *记录作废,并生成图片
     @method RecCancelAndGeneratePic 
**/
function RecCancelAndGeneratePic(gatherFun, callbackFun, printTemplateEmrCode, windowsInfo, conditionFunc, generatePicType) {
    if (!printTemplateEmrCode) {
        $.messager.alert(" ", $g("生成图片需要绑定打印模板"), "info");
        return;
    }

    var _msg = IsPermission(GetTopTempletGuid(), "delete");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要采集其他数据进行辅助！"), "info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要回调配置进行辅助！"), "info");
        return;
    }

    var queryParam = null;
    var SpecifyFiledsData = window[gatherFun]();
    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ", $g("请检查设计器,此方法需采集指定的表格"), "info");
        return;
    }
    var checkedIds = DataTableCheckRowIds(tableID);
    if (!checkedIds) {
        $.messager.alert(" ", $g("请选择要作废的记录"), "info");
        return;
    }
    queryParam = $("#" + tableID).attr("queryInfo");

    var innerFun = function () {
        RefreshMiddleFrameTemplateTree();
        GetDataFromService(null, [tableID], GetDBTablePageInfo(tableID, GetDBTablePageNumber(tableID)), queryParam);
    };
    if (generatePicType === undefined)
        generatePicType = 0;
    $.messager.confirm($g("提示"), $g("你确定要作废记录吗?"), function (r) {
        if (r) {
            //  $.messager.popover({ msg: "点击了确定", type: 'info' });
            var dataPost = {};
            dataPost["templateVersionGuid"] = TemplateGUID;
            dataPost["EpisodeID"] = EpisodeID;
            dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
            dataPost["RecIds"] = checkedIds;
            dataPost["LOGON.USERCODE"] = session['LOGON.USERCODE'];
            dataPost["LOGON.USERID"] = session['LOGON.USERID'];
            dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
            var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.Template.MultData&MethodName=RecCancel";
            url = GetMWToken(url);
            $.ajax({
                type: "POST",
                url: url,
                data: { datapost: JSON.stringify(dataPost) },
                success: function (msg) {
                    var reMsg = JSON.parse(msg)
                    if (MsgIsOK(reMsg)) {
                        if (/^\d+$/.test(reMsg.data))//正常应返回流水号
                        {
                            $.messager.alert(" ", $g("操作成功"), "success", function () {
                                __GeneratePic(reMsg.data, printTemplateEmrCode, true, innerFun, generatePicType);
                            });
                        }
                        else {
                            $.messager.alert(" ", reMsg.data, "error");
                        }

                    }
                    else {
                        $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
                    }
                }
            });
        } else {
            // $.messager.popover({ msg: "点击了取消" });
        }
    });
}

/**
     *单次评估单删除
     @method SingleEstimateDel 
**/
function SingleEstimateDel(gatherFun, callbackFun) {

    var _msg = IsPermission(GetTopTempletGuid(), "delete");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    $.messager.confirm($g("提示"), $g("你确定要删除记录吗?"), function (r) {
        if (r) {
            var msg = tkMakeServerCall("NurMp.Template.MultData", "delete", window.TemplateGUID, window.EpisodeID, GetLogAuxiliaryInfo());
            var reMsg = JSON.parse(msg);
            if (MsgIsOK(reMsg)) {
                if (!!reMsg.data)
                    $.messager.alert(" ", reMsg.data, "error");
                else
                    $.messager.alert(" ", $g("删除成功"), "success", function () { ClearTemplateData(gatherFun); });
            }
            else {
                $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
            }
        } else {
            // $.messager.popover({ msg: "点击了取消" });
        }
    });
}

/**
     *导出Excel
     @method ExportExcel 
**/
function ExportExcel(gatherFun, callbackFun) {

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }

    var queryParam = null;
  
    var SpecifyFiledsData = window[gatherFun]();
    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ",$g("请检查设计器,此方法需采集指定的表格"),"info");
        return;
    }
    queryParam = $("#" + tableID).attr("queryInfo");
        

    var dataPost = {};
    dataPost["templateVersionGuid"] = TemplateGUID;
    dataPost["EpisodeID"] = EpisodeID;
    dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
    dataPost["queryInfo"] = queryParam;
    dataPost["LOGON.USERCODE"] = session['LOGON.USERCODE'];
    dataPost["LOGON.USERID"] = session['LOGON.USERID'];
    dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
    var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.DHCNurRecCountReport&MethodName=GetGWCountExport";
    url = GetMWToken(url);
    $.ajax({
        type: "POST",
        url: url,
        data: { datapost: JSON.stringify(dataPost) },
        success: function (msg) {
            var reMsg = JSON.parse(msg)
            if (MsgIsOK(reMsg)) {
                var columnFields = GetTableColumnFields(tableID);
                if (!!reMsg.data && reMsg.data.rows.length > 0)
                {
                    var newRows = [];
                    $.each(reMsg.data.rows, function (i, row) {
                        var d = {};
                        $.each(columnFields, function (j, f) {
                            if (IsCA(row[f])) {
                                var SignatureFull = row[f].substring(2);//去掉前缀CA
                                d[f] = DisplayCA(SignatureFull);
                            }
                            else
                                d[f] = row[f];
                        });
                        newRows.push(d);
                    });
                    __ExportExcel(newRows);
                }
                else
                    $.messager.alert(" ", $g("没有要导出的数据"), "error");
            }
            else {
                $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
            }
        }
    });
}

/**
     *单列hisUI表格数据转移(左->右)
     @method  SCHISUIDataTableDataLToR
**/
function SCHISUIDataTableDataLToR(gatherFun, callbackFun) {

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要采集单列Hisui表格进行辅助！"), "info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要回调单列Hisui表格进行辅助！"), "info");
        return;
    }

    var leftTableID = null;
    var rightTableID = null;

    var data1 = window[gatherFun]();
    leftTableID = GetDataTabelIdFormSpecifyFiledsData(data1);

    var data2 = window[callbackFun]();
    if (data2.length == 1) {
        rightTableID = data2[0];
    }
    if (!leftTableID){
        $.messager.alert(" ", $g("请检查配置，左边单列Hisui表格ID无效！"), "info");
    }
    if (!rightTableID){
        $.messager.alert(" ", $g("请检查配置，右边单列Hisui表格ID无效！"), "info");
    }
    if (leftTableID === rightTableID){
        $.messager.alert(" ", $g("请检查配置，采集的单列Hisui表格和回调的单列Hisui表格不能是同一个！"), "info");
    }
    var leftTableField = $('#' + leftTableID).datagrid("getColumnFields")[0];
    var seledRows = $('#' + leftTableID).datagrid('getSelections');
    if (seledRows.length == 0) {
        $.messager.alert(" ", $g("请检查，没有选中要转移的数据！"), "info");
    }
    var rightOpts = $('#' + rightTableID).datagrid("options");
    if (!rightOpts.RelatedStoreDataID) {
        $.messager.alert(" ", $g("请检查，回调的单列Hisui表格没有配置关联存储元素ID！"), "info");
    }
    var relatedStoreDataStr = GetValueById(rightOpts.RelatedStoreDataID);
    var _tempArr = !!relatedStoreDataStr ? relatedStoreDataStr.split(',') : [];
    $.each(seledRows, function (i, row) {
        if ($.inArray(row[leftTableField], _tempArr) > -1)
            return true;
        else
            _tempArr.push(row[leftTableField]);
    });

    SetOneValue(rightOpts.RelatedStoreDataID, _tempArr.toString());
    SetOneValue(rightTableID,"");
}

/**
     *单列hisUI表格数据删除
     @method  SCHISUIDataTableDataDelete
**/
function SCHISUIDataTableDataDelete(gatherFun, callbackFun) {

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要采集单列Hisui表格进行辅助！"), "info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要回调单列Hisui表格进行辅助！"), "info");
        return;
    }

    var gatherTableID = null;
    var callbackTableID = null;

    var data1 = window[gatherFun]();
    gatherTableID = GetDataTabelIdFormSpecifyFiledsData(data1);

    var data2 = window[callbackFun]();
    if (data2.length == 1) {
        callbackTableID = data2[0];
    }

    if (gatherTableID !== callbackTableID) {
        $.messager.alert(" ", $g("请检查配置，采集的单列Hisui表格和回调的单列Hisui表格必须是同一个！"), "info");
    }

    var callbackTableOpts = $('#' + callbackTableID).datagrid("options");
    if (!callbackTableOpts.RelatedStoreDataID) {
        $.messager.alert(" ", $g("请检查，回调的单列Hisui表格没有配置关联存储元素ID！"), "info");
    }

    var seledRows = $('#' + callbackTableID).datagrid('getSelections');
    if (seledRows.length == 0) {
        $.messager.alert(" ", $g("请检查，没有选中要删除的数据！"), "info");
    }

    var relatedStoreDataStr = GetValueById(callbackTableOpts.RelatedStoreDataID);
    var _tempArr = !!relatedStoreDataStr ? relatedStoreDataStr.split(',') : [];
    var _deled = [];

    $.each(seledRows, function (i, row) {
        _deled.push($('#' + callbackTableID).datagrid("getRowIndex",row));
    });

    _tempArr = $.grep(_tempArr, function (n, i) {
        return $.inArray(i, _deled) > -1;
    }, true);

    SetOneValue(callbackTableOpts.RelatedStoreDataID, _tempArr.toString());
    SetOneValue(callbackTableID, "");
}

/**
     *单列hisUI表格数据上移
     @method  SCHISUIDataTableDataUpMove
**/
function SCHISUIDataTableDataUpMove(gatherFun, callbackFun) {

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要采集单列Hisui表格进行辅助！"), "info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要回调单列Hisui表格进行辅助！"), "info");
        return;
    }

    var gatherTableID = null;
    var callbackTableID = null;

    var data1 = window[gatherFun]();
    gatherTableID = GetDataTabelIdFormSpecifyFiledsData(data1);

    var data2 = window[callbackFun]();
    if (data2.length == 1) {
        callbackTableID = data2[0];
    }

    if (gatherTableID !== callbackTableID) {
        $.messager.alert(" ", $g("请检查配置，采集的单列Hisui表格和回调的单列Hisui表格必须是同一个！"), "info");
    }

    var callbackTableOpts = $('#' + callbackTableID).datagrid("options");
    if (!callbackTableOpts.RelatedStoreDataID) {
        $.messager.alert(" ", $g("请检查，回调的单列Hisui表格没有配置关联存储元素ID！"), "info");
    }

    var seledRows = $('#' + callbackTableID).datagrid('getSelections');
    if (seledRows.length == 0) {
        $.messager.alert(" ", $g("没有选中要移动的数据！"), "info");
    }

    if (seledRows.length > 1) {
        $.messager.alert(" ", $g("只能移动的一条数据！"), "info");
    }

    var relatedStoreDataStr = GetValueById(callbackTableOpts.RelatedStoreDataID);
    var _tempArr = !!relatedStoreDataStr ? relatedStoreDataStr.split(',') : [];
    var _moveIndex = $('#' + callbackTableID).datagrid("getRowIndex",seledRows[0]);
    

    if (_moveIndex == 0) {
        $.messager.alert(" ", $g("已经是第一条数据了！"), "info");
        return;
    }
    var swapIndex = _moveIndex--;
    var _temp = _tempArr[_moveIndex];
    _tempArr[_moveIndex] = _tempArr[swapIndex];
    _tempArr[swapIndex] = _temp;

    SetOneValue(callbackTableOpts.RelatedStoreDataID, _tempArr.toString());
    SetOneValue(callbackTableID, "");
    $('#' + callbackTableID).datagrid("selectRow", _moveIndex);
}

/**
     *单列hisUI表格数据下移
     @method  SCHISUIDataTableDataLDownMove
**/
function SCHISUIDataTableDataLDownMove(gatherFun, callbackFun) {

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要采集单列Hisui表格进行辅助！"), "info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要回调单列Hisui表格进行辅助！"), "info");
        return;
    }

    var gatherTableID = null;
    var callbackTableID = null;

    var data1 = window[gatherFun]();
    gatherTableID = GetDataTabelIdFormSpecifyFiledsData(data1);

    var data2 = window[callbackFun]();
    if (data2.length == 1) {
        callbackTableID = data2[0];
    }

    if (gatherTableID !== callbackTableID) {
        $.messager.alert(" ", $g("请检查配置，采集的单列Hisui表格和回调的单列Hisui表格必须是同一个！"), "info");
    }

    var callbackTableOpts = $('#' + callbackTableID).datagrid("options");
    if (!callbackTableOpts.RelatedStoreDataID) {
        $.messager.alert(" ", $g("请检查，回调的单列Hisui表格没有配置关联存储元素ID！"), "info");
    }

    var seledRows = $('#' + callbackTableID).datagrid('getSelections');
    if (seledRows.length == 0) {
        $.messager.alert(" ", $g("没有选中要移动的数据！"), "info");
    }

    if (seledRows.length > 1) {
        $.messager.alert(" ", $g("只能移动的一条数据！"), "info");
    }

    var relatedStoreDataStr = GetValueById(callbackTableOpts.RelatedStoreDataID);
    var _tempArr = !!relatedStoreDataStr ? relatedStoreDataStr.split(',') : [];
    var _moveIndex = $('#' + callbackTableID).datagrid("getRowIndex", seledRows[0]);


    if (_moveIndex == _tempArr.length - 1) {
        $.messager.alert(" ", $g("已经是最后一条数据了！"), "info");
        return;
    }
    var swapIndex = _moveIndex++;
    var _temp = _tempArr[_moveIndex];
    _tempArr[_moveIndex] = _tempArr[swapIndex];
    _tempArr[swapIndex] = _temp;

    SetOneValue(callbackTableOpts.RelatedStoreDataID, _tempArr.toString());
    SetOneValue(callbackTableID, "");
    $('#' + callbackTableID).datagrid("selectRow", _moveIndex);
}

/**
     *单列hisUI表格数据新增
     @method  SCHISUIDataTableDataAdd
**/
function SCHISUIDataTableDataAdd(gatherFun, callbackFun) {

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要采集单行文本输入框进行辅助！"), "info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要回调单列Hisui表格进行辅助！"), "info");
        return;
    }

    var gatherInputID = null;
    var callbackTableID = null;

    var data1 = window[gatherFun]();
    gatherInputID = data1.keys[0];

    var data2 = window[callbackFun]();
    if (data2.length == 1) {
        callbackTableID = data2[0];
    }

    var callbackTableOpts = $('#' + callbackTableID).datagrid("options");
    if (!callbackTableOpts.RelatedStoreDataID) {
        $.messager.alert(" ", $g("请检查，回调的单列Hisui表格没有配置关联存储元素ID！"), "info");
    }

    var addStr = GetValueById(gatherInputID);
    var _addArr = addStr.split(',');

    var relatedStoreDataStr = GetValueById(callbackTableOpts.RelatedStoreDataID);
    var _tempArr = !!relatedStoreDataStr ? relatedStoreDataStr.split(',') : [];

    _tempArr = $.merge(_tempArr, _addArr);
    SetOneValue(callbackTableOpts.RelatedStoreDataID, _tempArr.toString());
    SetOneValue(callbackTableID, "");
}

/**
     *上传图片
     @method  UploadImg
**/
function UploadImg(gatherFun, callbackFun, templateEmrCode, windowsInfo, uploader, placeHolder) {
    if (!placeHolder) {
        $.messager.alert(" ", $g("图片占位符为空，请到【上传图片功能JS】参数里配置"), "info");
        return;
    }

    var uploaderEle = $("#" + uploader);
    $(uploaderEle).on("change", function () {
        var rd = new FileReader();
        var files = uploaderEle[0].files[0];
        rd.readAsDataURL(files);
        rd.onloadend = function (e) {
            ShowOne(placeHolder, true);
            $("#" + placeHolder).attr("src", this.result);
        }
    });
    uploaderEle.click();
}

/**
     *删除上传图片
     @method  DeleteUploadImg
**/
function DeleteUploadImg(gatherFun, callbackFun, templateEmrCode, windowsInfo, placeHolder) {
    if (!placeHolder) {
        $.messager.alert(" ", "图片占位符为空，请到【删除上传图片功能JS】参数里配置", "info");
        return;
    }
    $("#" + placeHolder).attr("src", "");
    HideOne(placeHolder, true);
}

/**
     *批量签名
     @method BatchSign 
**/
function BatchSign(gatherFun, callbackFun, templateEmrCode, windowsInfo, signField, signDate, signTime, signStatistics) {

    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    var sender = $(arguments.callee.caller.arguments[0].target).parent().parent();//按钮本身
    
    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要回调配置进行辅助！"),"info");
        return;
    }

    var specifyFileds = window[callbackFun]();
    var queryParam = null;
    var tableHtmlId = null;
    if (specifyFileds.length == 1) {
        tableHtmlId = specifyFileds[0];
        queryParam = $("#" + tableHtmlId).attr("queryInfo");
    }
    else {
        $.messager.alert(" ", $g("请检查回调配置，此次调用需要刷新表格"), "info");
        return;
    }

    var SpecifyFiledsData = window[gatherFun]();
    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ",$g("请检查设计器,此方法需采集指定的表格"),"info");
        return;
    }
    var checkedIds = DataTableCheckRowIds(tableID);
    if (!checkedIds) {
        $.messager.alert(" ",$g("请选择要操作的记录"),"info");
        return;
    }
        
    var postAjax = function () {
        var dataPost = {};
        dataPost["EpisodeID"] = EpisodeID;
        dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
        dataPost["RecIds"] = checkedIds;
        dataPost["LOGON.USERCODE"] = session['LOGON.USERCODE'];
        dataPost["LOGON.USERID"] = session['LOGON.USERID'];
        dataPost["signField"] = signField;
        dataPost["signDate"] = signDate;
        dataPost["signTime"] = signTime;
        dataPost["signStatistics"] = signStatistics;
        dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
        var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.Template.EventSet&MethodName=BatchSign";
        url = GetMWToken(url);
        $.ajax({
            type: "POST",
            url: url,
            data: { datapost: JSON.stringify(dataPost) },
            success: function (msg) {
                var reMsg = JSON.parse(msg);
                if (MsgIsOK(reMsg)) {
                    if (window.CAVerify > 0 && !!signField && !!window.CAVarCert && !!window.CAContainerName) {
                        __NurseCASignDataByNurMPDataIDs(checkedIds, sender);
                    }
                    $.messager.alert(" ", $g("操作成功"), "success", function () {
                        GetDataFromService(null, specifyFileds, GetDBTablePageInfo(tableHtmlId, GetDBTablePageNumber(tableHtmlId)), queryParam);
                    });
                }
                else {
                    $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
                }
            }
        });
    }
    if (window.CAVerify > 0 && !!signField && (!window.CAVarCert || !window.CAContainerName)) {
        __CASingLoginAsync(postAjax, signField);
    }
    else {
        postAjax();
    }
}

/**
     *批量撤销签名
     @method BatchWithdrawnSign 
**/
function BatchWithdrawnSign(gatherFun, callbackFun, templateEmrCode, windowsInfo, signField, signDate, signTime, signStatistics) {

    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要回调配置进行辅助！"),"info");
        return;
    }

    var specifyFileds = window[callbackFun]();
    var queryParam = null;
    var tableHtmlId = null;
    if (specifyFileds.length == 1) {
        tableHtmlId = specifyFileds[0];
        queryParam = $("#" + tableHtmlId).attr("queryInfo");
    }
    else {
        $.messager.alert(" ", $g("请检查回调配置，此次调用需要刷新表格"), "info");
        return;
    }

    var SpecifyFiledsData = window[gatherFun]();
    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ",$g("请检查设计器,此方法需采集指定的表格"),"info");
        return;
    }
    var checkedIds = DataTableCheckRowIds(tableID);
    if (!checkedIds) {
        $.messager.alert(" ",$g("请选择要操作的记录"),"info");
        return;
    }

    var dataPost = {};
    dataPost["EpisodeID"] = EpisodeID;
    dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
    dataPost["RecIds"] = checkedIds;
    dataPost["LOGON.USERCODE"] = session['LOGON.USERCODE'];
    dataPost["LOGON.USERID"] = session['LOGON.USERID'];
    dataPost["signField"] = signField;
    dataPost["signDate"] = signDate;
    dataPost["signTime"] = signTime;
    dataPost["signStatistics"] = signStatistics;
    dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
    var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.Template.EventSet&MethodName=BatchWithdrawnSign";
    url = GetMWToken(url);
    $.ajax({
        type: "POST",
        url: url,
        data: { datapost: JSON.stringify(dataPost) },
        success: function (msg) {
            var reMsg = JSON.parse(msg)
            if (MsgIsOK(reMsg)) {
                $.messager.alert(" ", $g("操作成功"), "success", function () {
                    GetDataFromService(null, specifyFileds, GetDBTablePageInfo(tableHtmlId, GetDBTablePageNumber(tableHtmlId)), queryParam);
                });
                
            }
            else {
                $.messager.alert($g("操作失败"),$g("错误原因：") + reMsg.msg,"error");
            }
        }
    });
}

/**
     *记录恢复
     @method RecRecover
**/
function RecRecover(gatherFun, callbackFun) {

    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要回调配置进行辅助！"),"info");
        return;
    }

    var specifyFileds = window[callbackFun]();
    var queryParam = null;
    var tableHtmlId = null;
    if (specifyFileds.length == 1) {
        tableHtmlId = specifyFileds[0];
        queryParam = $("#" + tableHtmlId).attr("queryInfo");
    }
    else {
        $.messager.alert(" ", $g("请检查回调配置，此次调用需要刷新表格"), "info");
        return;
    }

    var SpecifyFiledsData = window[gatherFun]();
    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ",$g("请检查设计器,此方法需采集指定的表格"),"info");
        return;
    }
    var checkedIds = DataTableCheckRowIds(tableID);
    if (!checkedIds) {
        $.messager.alert(" ",$g("请选择要恢复的记录"),"info");
        return;
    }
    $.messager.confirm($g("提示"), $g("你确定要恢复记录吗?"), function (r) {
        if (r) {
            var dataPost = {};
            dataPost["templateVersionGuid"] = TemplateGUID;
            dataPost["EpisodeID"] = EpisodeID;
            dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
            dataPost["RecIds"] = checkedIds;
            dataPost["LOGON.USERCODE"] = session['LOGON.USERCODE'];
            dataPost["LOGON.USERID"] = session['LOGON.USERID'];
            dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
            var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.Template.MultData&MethodName=RecRecover";
            url = GetMWToken(url);
            $.ajax({
                type: "POST",
                url: url,
                data: { datapost: JSON.stringify(dataPost) },
                success: function (msg) {
                    var reMsg = JSON.parse(msg)
                    if (MsgIsOK(reMsg)) {
                        if (/^\d+$/.test(reMsg.data))//正常应返回流水号
                        {
                            $.messager.alert(" ", $g("操作成功"), "success", function () {
                                GetDataFromService(null, specifyFileds, GetDBTablePageInfo(tableHtmlId, GetDBTablePageNumber(tableHtmlId)), queryParam);
                            });
                        }
                        else {
                            $.messager.alert(" ",reMsg.data,"error");
                        }

                    }
                    else {
                        $.messager.alert($g("操作失败"),$g("错误原因：") + reMsg.msg,"error");
                    }
                }
            });
        } else {
        }
    });
}

/**
     *记录恢复并生成图片
     @method RecRecover
**/
function RecRecoverAndGeneratePic(gatherFun, callbackFun, printTemplateEmrCode, windowsInfo, conditionFunc, generatePicType) {
    if (!printTemplateEmrCode) {
        $.messager.alert(" ", $g("生成图片需要绑定打印模板"), "info");
        return;
    }
    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要采集其他数据进行辅助！"), "info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要回调配置进行辅助！"), "info");
        return;
    }
    
    var queryParam = null;
    var SpecifyFiledsData = window[gatherFun]();
    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ", $g("请检查设计器,此方法需采集指定的表格"), "info");
        return;
    }
    var checkedIds = DataTableCheckRowIds(tableID);
    if (!checkedIds) {
        $.messager.alert(" ", $g("请选择要恢复的记录"), "info");
        return;
    }
    queryParam = $("#" + tableID).attr("queryInfo");
    var innerFun = function () {
        RefreshMiddleFrameTemplateTree();
        GetDataFromService(null, [tableID], GetDBTablePageInfo(tableID, GetDBTablePageNumber(tableID)), queryParam);
    };
    if (generatePicType === undefined)
        generatePicType = 0;
    $.messager.confirm($g("提示"), $g("你确定要恢复记录吗?"), function (r) {
        if (r) {
            var dataPost = {};
            dataPost["templateVersionGuid"] = TemplateGUID;
            dataPost["EpisodeID"] = EpisodeID;
            dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
            dataPost["RecIds"] = checkedIds;
            dataPost["LOGON.USERCODE"] = session['LOGON.USERCODE'];
            dataPost["LOGON.USERID"] = session['LOGON.USERID'];
            dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
            var url = url;
            url = GetMWToken(url);
            $.ajax({
                type: "POST",
                url: url,
                data: { datapost: JSON.stringify(dataPost) },
                success: function (msg) {
                    var reMsg = JSON.parse(msg)
                    if (MsgIsOK(reMsg)) {
                        if (/^\d+$/.test(reMsg.data))//正常应返回流水号
                        {
                            $.messager.alert(" ", $g("操作成功"), "success", function () {
                                __GeneratePic(reMsg.data, printTemplateEmrCode, true, innerFun, generatePicType);
                            });
                        }
                        else {
                            $.messager.alert(" ", reMsg.data, "error");
                        }

                    }
                    else {
                        $.messager.alert($("操作失败"), $g("错误原因：") + reMsg.msg, "error");
                    }
                }
            });
        } else {
        }
    });

}

/**
     *医嘱确定
     @method DoctorAdviceEnter
**/
function DoctorAdviceEnter(gatherFun, callbackFun) {
    
    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ",$g("请检查配置，此次调用需要采集其他数据进行辅助！"),"info");
        return;
    }

    var SpecifyFiledsData = window[gatherFun]();


    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ",$g("请检查设计器,此方法需采集指定的表格"),"info");
        return;
    }

    var selectedRows = $('#' + tableID + '').datagrid('getChecked');
    if (selectedRows != null && selectedRows.length==0) {
        $.messager.alert(" ", $g("请选择要导入的信息"), "info");
        return;
    } 
    WindowBeforeCloseProxy(selectedRows, true);
}

/**
     *一键导入
     @method OnceImport
**/
function OnceImport(gatherFun, callbackFun, templateEmrCode, windowsInfo, importTable, importSources) {

    var queryParam = "";
    if (($.type(window[gatherFun]) === "function")) {
        queryParam = ObjectToUrlParams(window[gatherFun](), "^");
    }
    var dataPost = {};
    dataPost["templateVersionGuid"] = TemplateGUID;
    dataPost["EpisodeID"] = EpisodeID;
    dataPost["importTable"] = importTable;
    dataPost["importSources"] = importSources;
    dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
    dataPost["queryParam"] = queryParam;
    var msg = tkMakeServerCall("NurMp.Template.ImportBinding", "Save", JSON.stringify(dataPost));
    var reMsg = JSON.parse(msg)
    if (MsgIsOK(reMsg)) {
        var refreshQueryParam = $("#" + importTable).attr("queryInfo");
        var specifyFileds = [importTable];
        GetDataFromService(null, specifyFileds, GetDBTablePageInfo(importTable, 1), refreshQueryParam);
        RefreshMiddleFrameTemplateTree();
    }
    else {
        $.messager.alert($("导入失败"), $g("错误原因：") + reMsg.msg, "error");
    }
}

/**
     *导入医嘱
     @method ImportDoctorAdvice
**/
function ImportDoctorAdvice(gatherFun, callbackFun, templateEmrCode, windowsInfo, mutilJoinSymbol, textHidePreUnderline, numberUnitCombine, numberImportSpecialUnit, numberUnitNoImport, textFilterNumberUnit) {
    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!templateEmrCode) {
        $.messager.alert(" ",$g("请检查设计器，此方法必须绑定打开一个模板"),"info");
        return;
    }
    var callbackFunParams = {};
    callbackFunParams.mutilJoinSymbol = mutilJoinSymbol;
    callbackFunParams.textHidePreUnderline = textHidePreUnderline;
    callbackFunParams.numberUnitCombine = numberUnitCombine;
    callbackFunParams.numberImportSpecialUnit = numberImportSpecialUnit;
    callbackFunParams.numberUnitNoImport = numberUnitNoImport;
    callbackFunParams.textFilterNumberUnit = textFilterNumberUnit;
    OpenWindow(templateEmrCode, callbackFun, gatherFun, "", windowsInfo, callbackFunParams);
}

/**
     *病情变化及处理措施
     @method RefMeasure
     @param formId 表单ID
**/
function RefMeasure(formId) {
    var selector = "#" + formId;
    $(selector).data("RefConfig", ["Know","Diag","Order","Exec","Obs","Lis","Pacs","Epr","Record1","Record2","Symbol"]);
    if ($.type(buildMenu) === "function") {
		buildMenu(selector, ['Common']);
	}
}

/**
     *撤销高危上报
     @method CancelHighRiskReport 
**/
function CancelHighRiskReport(gatherFun, callbackFun, templateEmrCode) {

    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!templateEmrCode){
        $.messager.alert(" ",$g("撤销上报需要关联相应的录入模板"),"info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要回调表格进行辅助！"), "info");
        return;
    }
    var specifyFileds = window[callbackFun]();

    if ($("#cancelReportDialog").length == 0)
        $("body").append(document.getElementById('CancelHighRisKReportDialogTemplate').innerHTML);

    $("#cancelReportDialog").dialog({
        width: 300,
        height: 209,
        modal: true,
        closed: true,
        title: $g("撤销上报"),
        buttons: [{
            text: $g('确认'),
            handler: function () {
                var reason = $("#reasonBox").combobox("getValue");
				var cancelDate = $('#cancelReportDate').datebox('getValue');
				var cancelTime = $('#cancelReportTime').timespinner('getValue');
				var msg = tkMakeServerCall("NurMp.Template.EventSet", "cancelReport", window.EpisodeID, templateEmrCode, reason, cancelDate, cancelTime, GetLogAuxiliaryInfo());
                var reMsg = JSON.parse(msg);
                if (!MsgIsOK(reMsg)) {
                    $.messager.alert($g("撤销上报失败"),$g("错误原因：") + reMsg.msg,"error");
                }
                else 
                {
                    $.messager.alert(" ", $g("撤销上报成功"), "success", function () {
                        $HUI.dialog('#cancelReportDialog').close();
                        if (specifyFileds.length == 1) {
                            var tableHtmlId = specifyFileds[0];
                            var refreshQueryParam = $("#" + tableHtmlId).attr("queryInfo");
                            GetDataFromService(null, specifyFileds, GetDBTablePageInfo(tableHtmlId, 1), refreshQueryParam);
                        }
                    });
                }
            }
        }, {
            text: $g('取消'),
            handler: function () {
                $HUI.dialog('#cancelReportDialog').close();
            }
        }],
		onOpen:function(){
		    $('#cancelReportDate').datebox();
		    $('#cancelReportTime').timespinner();
		    $("#reasonBox").combobox();
		    $('#cancelReportDate').datebox('setValue', GetCurrentDate());
		    $('#cancelReportTime').timespinner('setValue', (new Date()).format("HH:mm"));
		}
		
    });

    $("#cancelReportDialog").dialog('open');

}

/**
     *知识库
     @method RefKnowledge
     @param formId  表单ID
**/
function RefKnowledge(formId) {
    var selector = "#" + formId;
    $(selector).data("RefConfig",["Know"]);
	if ($.type(buildMenu) === "function") {
		buildMenu(selector, ['Common']);
	}
}

/**
 * 清空模板中的input的值
 **/
function ClearTemplateData(gatherFun) {
    var re = {};
    var clearIds = [];//需要清空的元素集合，默认清空所有的
    if (($.type(window[gatherFun]) === "function")) {
        clearIds = window[gatherFun]();
    }

    var testReg = /^[a-zA-Z]{2,}_[0-9]{1,}$/; //命名规则是字母下划线数值三部分，//下拉单选，下拉多选会自动生成部分input，需要排除

    $.each(ElementUtility, function (key, helper) {
        if (helper.isForm()) {
            var tempInputFormNames = [];
            $("input[name^='" + key + "_']").each(function (i) {
                var name = $(this).attr("name");
                if (tempInputFormNames.indexOf(name) == -1) {
                    if (testReg.test(name)) {
                        tempInputFormNames.push(name);
                    }
                }
            });
            $("select[id^='" + key + "_']").each(function (i) {
                var name = $(this).attr("id");
                if (tempInputFormNames.indexOf(name) == -1) {
                    if (testReg.test(name)) {
                        tempInputFormNames.push(name);
                    }
                }
            });
            $("textarea[name^='" + key + "_']").each(function (i) {
                var name = $(this).attr("name");
                if (tempInputFormNames.indexOf(name) == -1) {
                    if (testReg.test(name)) {
                        tempInputFormNames.push(name);
                    }
                }

            });
            $.each(tempInputFormNames, function (index, id) {
                if (clearIds.length == 0) {
                  //  默认清空所有的
                    helper.Clear(id);
                }
                else {//采集时，之清空采集得元素
                    if (clearIds.indexOf(id)>=0) {
                        helper.Clear(id);
                    }
                }                
            });
        }
    });
}

/**
     *医惠生成病历描述
     @method GetExplanation
**/
function GetExplanation()
{
    var re = "";
    $.each(window.LoadFormElements, function (i, ele) {
        var parentId = "div_" + ele;
        if ($("#" + parentId).is(':hidden'))
            return true;
        var helper = GetElementHelper(ele);

        re += helper.getExplanation(ele);
    });

    return re;
}
/**
     *按钮按配置规则呈现
     @method ButtonPresentVisible
**/
function ButtonPresentVisible(buttonId,verifyType)
{
    var msg = tkMakeServerCall("NurMp.Sources.Comm", "IsGroup", session['LOGON.CTLOCID'], session['LOGON.WARDID'], session['LOGON.GROUPDESC'], session['LOGON.USERID'], verifyType);

    var reMsg = JSON.parse(msg);
    if (!MsgIsOK(reMsg)) {
        $.messager.alert($g("按钮呈现验证失败"), $g("错误原因：") + reMsg.msg, "error");
        return;
    }
    else {
        if (reMsg.data == "1")
            ShowOne(buttonId,true);
        else
            HideOne(buttonId,true);
    }
}

/**
     *打印换页标志
     @method PrintFormFeed
**/
function PrintFormFeed(gatherFun, callbackFun)
{
    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要采集表格进行辅助！"), "info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要回调配置进行辅助！"), "info");
        return;
    }

    var specifyFileds = window[callbackFun]();
    var queryParam = null;
    var tableHtmlId = null;
    if (specifyFileds.length == 1) {
        tableHtmlId = specifyFileds[0];
        queryParam = $("#" + tableHtmlId).attr("queryInfo");
    }
    else {
        $.messager.alert(" ", $g("请检查回调配置，此次调用需要刷新表格"), "info");
        return;
    }

    var SpecifyFiledsData = window[gatherFun]();
    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ", $g("请检查设计器,此方法需采集指定的表格"), "info");
        return;
    }
    var checkedIds = DataTableCheckRowIds(tableID);
    if (!checkedIds) {
        $.messager.alert(" ", $g("请选择要操作的记录"), "info");
        return;
    }

    if (!!checkedIds && checkedIds.split(",").length > 1) {
        $.messager.alert(" ", $g("只能操作一条记录"), "info");
        return;
    }

    var msg = tkMakeServerCall("NurMp.Template.MultData", "SetPageMarking", checkedIds, session['LOGON.USERID'], "", "Y", GetLogAuxiliaryInfo());

    var reMsg = JSON.parse(msg);
    if (!MsgIsOK(reMsg)) {
        $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
        return;
    }
    else {
        $.messager.alert(" ", $g("操作成功"), "success", function () {
            GetDataFromService(null, specifyFileds, GetDBTablePageInfo(tableHtmlId, GetDBTablePageNumber(tableHtmlId)), queryParam);
        });
    }

}

/**
     *撤销打印换页标志
     @method WithdrawnPrintFormFeed
**/
function WithdrawnPrintFormFeed(gatherFun, callbackFun)
{
    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (!($.type(window[gatherFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要采集其他数据进行辅助！"), "info");
        return;
    }
    if (!($.type(window[callbackFun]) === "function")) {
        $.messager.alert(" ", $g("请检查配置，此次调用需要回调配置进行辅助！"), "info");
        return;
    }

    var specifyFileds = window[callbackFun]();
    var queryParam = null;
    var tableHtmlId = null;
    if (specifyFileds.length == 1) {
        tableHtmlId = specifyFileds[0];
        queryParam = $("#" + tableHtmlId).attr("queryInfo");
    }
    else {
        $.messager.alert(" ", $g("请检查回调配置，此次调用需要刷新表格"), "info");
        return;
    }

    var SpecifyFiledsData = window[gatherFun]();
    var tableID = GetDataTabelIdFormSpecifyFiledsData(SpecifyFiledsData);
    if (!tableID) {
        $.messager.alert(" ", $g("请检查设计器,此方法需采集指定的表格"), "info");
        return;
    }
    var checkedIds = DataTableCheckRowIds(tableID);
    if (!checkedIds) {
        $.messager.alert(" ", $g("请选择要操作的记录"), "info");
        return;
    }

    if (!!checkedIds && checkedIds.split(",").length > 1) {
        $.messager.alert(" ", $g("只能操作一条记录"), "info");
        return;
    }

    var msg = tkMakeServerCall("NurMp.Template.MultData", "CancelPageMark", checkedIds, session['LOGON.USERID'], "", "", GetLogAuxiliaryInfo());

    var reMsg = JSON.parse(msg);
    if (!MsgIsOK(reMsg)) {
        $.messager.alert($g("操作失败"), $g("错误原因：") + reMsg.msg, "error");
        return;
    }
    else {
        $.messager.alert(" ", $g("操作成功"), "success", function () {
            GetDataFromService(null, specifyFileds, GetDBTablePageInfo(tableHtmlId, GetDBTablePageNumber(tableHtmlId)), queryParam);
        });
    }
}

/**
     *图片标注打点事件
     @method MarkerImg
**/
function MarkerImg(imgID) {
    $("#" + imgID).on("mousedown", function (e) {
        var enable = $("#" + imgID).attr("dhccEnable");
        if (!!enable && enable == "false")
            return false;
        e = e || window.event;
        if (e.button !== 2) {       //判断是否右击
            var isMarker = $("#" + imgID).attr("marker");
            if (isMarker !== undefined && isMarker === "true") {
                var x = e.offsetX || e.layerX;
                var y = e.offsetY || e.layerY;
                var markerId = -1;
                if ($(this).data("Map") == undefined || $(this).data("Map").length == 0) {
                    $(this).data("Map", []);
                    markerId = 1;
                }
                else
                    markerId = +($(this).data("Map")[$(this).data("Map").length - 1].id) + 1;

                var marker = { id: markerId, x: Math.round(x), y: Math.round(y) };

                $(this).data("Map").push(marker);
                __CreateMarker(imgID, marker);
            }
        }
    });
}

/**
     *患者签名读秒
     @method PatientCASignCountDown
**/
function PatientCASignCountDown(id) {
    var showMsg = function () {
        var remainder = $("#" + id).attr("countdown");
        var msg = "";
        +remainder--;
        if (remainder > 0) {
            $("#" + id).attr("countdown", remainder);
            msg = "剩余时间" + remainder +"秒";
        }
        else {
            clearInterval(intervalId);
            EnableOne(id, true);
        }
        $("#" + id).attr("placeholder", msg);
    }
    DisEnableOne(id, true);
    var intervalId = setInterval(showMsg, 1000);
}

/**
     *图片标注打点
     @method __CreateMarker
**/
function __CreateMarker(imgID, marker) {
    var pointSize = $("#" + imgID).attr("markerPointSize");
    var pointColor = $("#" + imgID).attr("markerPointColor");
    var div = document.createElement('div');
    div.className = 'marker';
    div.id = 'marker' + marker.id;
    var y = +(marker.y) + $("#" + imgID)[0].offsetTop - pointSize / 2;
    var x = +(marker.x) + $("#" + imgID)[0].offsetLeft - pointSize / 2;
    div.style.width = pointSize + 'px';
    div.style.height = pointSize + 'px';
    div.style.backgroundColor = pointColor;
    div.style.left = x + 'px';
    div.style.top = y + 'px';
    $(div).on("contextmenu", function (e) {//阻止冒泡行为和默认右键菜单事件，同时删除该点
        var enable = $("#" + imgID).attr("dhccEnable");
        if (!!enable && enable == "false")
            return false;
        var id = e.target.id;
        document.getElementById('div_'+imgID).removeChild(div);
        var deletedMap = $.grep($("#" + imgID).data("Map"), function (n, i) {
            return ('marker' + n.id) != id;
        });
        $("#" + imgID).data("Map", deletedMap);
        if (e && e.preventDefault) {
            //阻止默认浏览器动作(W3C)
            e.preventDefault();
        } else {
            //IE中阻止函数器默认动作的方式
            window.event.returnValue = false;
        }
        return false;
    });
    document.getElementById('div_'+imgID).appendChild(div);
}

/**
     *保存
     @method __SaveCore
**/
function __SaveCore(gatherFun, callbackFun, printTemplateEmrCode, isCloseWindow, isGeneratePic, sender, saveType, hideSaveAlert, customCallback, generatePicType) {
    
    var self = arguments.callee;
    var dataPost = null;
    if (!!gatherFun)
        dataPost = CombineSpecifyFiledsData(window[gatherFun]());
    else
        dataPost = GatherTemplateData();

    var CASignTemplateData = $.extend(true,{},dataPost);  //签名数据 

    $("img[name^='ImgElement_']").each(function (i) {//图片标记自由绘制合成图片
        var testReg = /^[a-zA-Z]{2,}_[0-9]{1,}$/;
        var name = $(this).attr("name");
        if (testReg.test(name)) {
            var markerFree = $("#" + name).attr("markerFree");
            if (markerFree !== undefined && markerFree === "true") {
                var helper = GetElementHelper(name);
                dataPost[name + "MarkFree"] = helper.getMarkFreeByName(name);
            }
        }
    });
    dataPost["templateVersionGuid"] = window.TemplateGUID;
    dataPost["EpisodeID"] = window.EpisodeID;
    dataPost["LOGON.CTLOCID"] = session['LOGON.CTLOCID'];
    dataPost["LOGON.WARDID"] = session['LOGON.WARDID'];
    dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
    dataPost["LOGON.USERID"] = session['LOGON.USERID'];
    dataPost["TemporarySave"] = saveType//0:暂存，1:保存
    dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
    var dataIsChanged = true;
    var queryObj = GetQueryObject();
    if (queryObj.NurMPDataID)//数据ID
    {
        if (!!queryObj.IsNewFlag && queryObj.IsNewFlag == "true") {
            //智护，应对整体评估带出上次结果的场景（其实是新建操作）
        }
        else
        {
            dataPost["NurMPDataID"] = queryObj.NurMPDataID;
        }
        
    }
    else if (!!window.currentNurMPDataID)
    {
        dataPost["NurMPDataID"] = window.currentNurMPDataID;
    }
    
    if (window.CAVerify > 0 && __IsRquireNurseCASign(CASignTemplateData)) {
        if (window.CAVarCert === "" || window.CAContainerName === "" || window.CAVarCert === null || window.CAContainerName === null)
        {
            $.messager.alert(" ", $g("CA验证失败，无法保存"), "error");
            return;
        }
        else if(window.CAVarCert === undefined || window.CAContainerName === undefined)
        {

            if (window.parent.TemplateGUID === undefined)//评估单
            {
                dataIsChanged = __FormDataIsChanged(window.CAOldFormData, CASignTemplateData,false);
                if (dataIsChanged)
                {
                    $.messager.alert(" ", $g("记录被修改，请重新签名"), "error");
                    return;
                }
            }
            else//记录单，弹框录入
            {
                if (!!dataPost["NurMPDataID"]) {
                    dataIsChanged = __FormDataIsChanged(window.CAOldFormData, CASignTemplateData,false);
                    if (dataIsChanged) {
                        $.messager.alert(" ", $g("记录被修改，请重新签名"), "error");
                        return;
                    }
                }
                else {
                    $.messager.alert(" ",$g( "有签名框未签名"), "error");
                    return;
                }
            }
        }
    }

	$("input[Signature='Patient']").each(function (i) {
		var PatientSignInputId = $(this).attr("id");
        if ($(this).attr("PatientSignVal") !== undefined)
			dataPost[PatientSignInputId] = $(this).attr("PatientSignVal");
    });
	var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.Template.MultData&MethodName=Save";
    url = GetMWToken(url);
    $.ajax({
        type: "POST",
        url: url,
        data: {datapost:JSON.stringify(dataPost)},
        success: function (msg) {
            var reMsg = JSON.parse(msg)
            if (MsgIsOK(reMsg)) {
                if (/^\d+$/.test(reMsg.data))//正常应返回流水号
                {                   
                    if (!dataPost["NurMPDataID"]) 
                    {
                        window.currentNurMPDataID = reMsg.data;
                    }

                    var callbackNewId = null;     //用来记录保存操作成功的流水ID
                    var callbackEles = null;
                    if (!!callbackFun)
                        callbackEles = window[callbackFun]();
                    if (!!callbackEles && callbackEles.length > 0) {
                        callbackNewId = callbackEles[0];
                        $("#" + callbackNewId).val(reMsg.data).change();
                    }
                       
                    if (window.CAVerify > 0 && !!window.CAVarCert && !!window.CAContainerName && __IsRquireNurseCASign(CASignTemplateData))
                    {
                        dataIsChanged = __FormDataIsChanged(window.CAOldFormData, CASignTemplateData, true);
                        if (dataIsChanged) {
                            __NurseCASignData(window.CAVarCert, window.CAContainerName, CASignTemplateData, reMsg.data, $(sender).attr("id"));
                            __ClearCASignedInfo();
                        }
                    }
                    var rquiredPatientCASignInput = __GetRquirePatientCASign(CASignTemplateData);
                    if (rquiredPatientCASignInput.length > 0 && window.CAPatientVerify === 1)
                    {
                        __PatientCASignData(CASignTemplateData, rquiredPatientCASignInput, reMsg.data, $(sender).attr("id"));
                        $.each(rquiredPatientCASignInput, function (i, n) {
                            $("#" + n).removeData("casign");
                        });
                    }
                    window.CAOldFormData = CASignTemplateData;
                    if (!!callbackNewId) {
                        var dataReturn = reMsg.data;
                        window.CAOldFormData[callbackNewId] = dataReturn;
                    }
                    if (!!reMsg.info)
                    {
						//--------------需求2760050 start
                        var oldOk = $.messager.defaults.ok;
						var oldCancel = $.messager.defaults.cancel;
			            $.messager.defaults.ok = $g("确定");
						$.messager.defaults.cancel = $g("取消");
						$.messager.confirm($g("提示"), reMsg.info, function (r) {
							if (r) {
								//调取【护理计划制定】界面
								var iWidth = 1300;
								var iHeight = window.screen.height - 20;
								var iTop = (window.screen.availHeight - 30 - iHeight) / 2;
								var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;
								var link = "websys.csp?a=a&IsShowPatList=N&IsShowPatInfoBannner=N&TMENU=60111&TPAGID=18794948&EpisodeID=" + window.EpisodeID;
								link = GetMWToken(link);
								window.open(link,"护理计划制定","width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft + ",scrollbars=1")
							} else {								
							}
							/*要写在回调方法内,否则在旧版下可能不能回调方法*/
							$.messager.defaults.ok = oldOk;
							$.messager.defaults.cancel = oldCancel;
							__SaveSuccessAfterCallback(printTemplateEmrCode, isGeneratePic, isCloseWindow, reMsg.data, saveType, hideSaveAlert, generatePicType);
							if (!!customCallback && $.type(window[customCallback]) === "function") {
							    window[customCallback](reMsg.data);
	                        }							
						});
						//------------------需求2760050 end
                    }
                    else {
                        __SaveSuccessAfterCallback(printTemplateEmrCode, isGeneratePic, isCloseWindow, reMsg.data, saveType, hideSaveAlert, generatePicType);
                        if (!!customCallback && $.type(window[customCallback]) === "function") {
                            window[customCallback](reMsg.data);
                        }
                    }
                }
                else {  
                    $.messager.alert(" ",reMsg.data,"error");
                }
            }
            else {
                $.messager.alert($g("提交失败"),$g("错误原因：") + reMsg.msg,"error");
            }
        }
    });
}

/**
     *表单验证
     @method __FormVerify
**/
function __FormVerify(gatherFun)
{
    var validSuccess = true;
    var requiredEle = "";
    var toVerfiyElements = window.LoadFormElements;
    if (($.type(window[gatherFun]) === "function")) {
        var getherObj = window[gatherFun]();
        toVerfiyElements = getherObj.keys;
    }
    var _VerifyFailEle = [];
    $.each(toVerfiyElements, function (i, ele) {
        var parentId = "div_" + ele;
        if ($("#" + parentId).is(':hidden') && !$("#" + ele).attr("scTableStore")) {//scTableStore 单列hisUI表格存储
            return true;
        }
        var helper = GetElementHelper(ele);
        if (!helper.isEnable)
            return true;
        if (!helper.isValid(ele)) {
            validSuccess = false;
            _VerifyFailEle.push(ele);
        }
    });
	
    if (_VerifyFailEle.length > 0 && !!window.RequiredAlter) {
        var _msgArr = [];
        for(var i = 0;i<_VerifyFailEle.length;i++){
            if (i<_VerifyFailEle.length && i<3){
                var eleLabelFor = $("#" + _VerifyFailEle[i]).attr("dhccLableFor");
                var labelFor = "";
                if (!!eleLabelFor) {
                    $.each(eleLabelFor.split("!"), function (i, n) {
                        labelFor += $("#" + n).text();
                    });
                    _msgArr.push(labelFor);
                }
            }
            else {
                _msgArr.push("...");
                break;
            }
        }
        $.messager.alert($g("必填提醒"), _msgArr.join("<br/>") + "<br/>" + "<span style='color:red;font-weight:bold'>" + $g("有必填项未填(红框显示)") + "</span>", "info");
    }
    return validSuccess;
}

/**
     *按钮护士签名验证(异步)
     @method __CASingLoginAsync
**/
function __CASingLoginAsync(callBack, inputId)
{
    var forceOpen = 0;//
    if (window.CAStrict != undefined && window.CAStrict) {
        forceOpen = 1;   
    }

    CALoginASync(session['LOGON.USERCODE'], forceOpen, callBack, inputId);
}

/**
     *CA数据批量签名,通过NurMPDataIDs
     @method __NurseCASignDataByNurMPDataIDs
**/
function __NurseCASignDataByNurMPDataIDs(ids,sender)
{
    var msg = tkMakeServerCall("NurMp.CA.DHCNurSignType", "GetTemplateData", ids);
    var reMsg = JSON.parse(msg);
    if (MsgIsOK(reMsg)) {
        var datas = reMsg.data;
        $.each(datas, function (i, rowData) {
            __NurseCASignData(window.CAVarCert, window.CAContainerName, rowData, rowData.ID, $(sender).attr("id"));
        });
        __ClearCASignedInfo();
    }
}

/**
     *生成图片
     @method __GeneratePic
     @param {generatePicType} 0:表示生成图片  1:表示生产图片痕迹，以HTML形式展示
**/
function __GeneratePic(rowIDs, printTemplateEmrCode, hideSaveAlert, callBack, generatePicType) {
    var hisURI = window.WebIp;
    var episodeID = window.EpisodeID;

    if (!printTemplateEmrCode) {
        $.messager.alert(" ", $g("生成图片需要绑定打印模板"), "info");
        return;
    }
    function MakePicCallBackFun(ret) {
        if (ret.msg == "success") {
            var msg = ret.rtn;
            var reMsg = JSON.parse(msg);
            if (MsgIsOK(reMsg)) {
                if (!!hideSaveAlert)
                    callBack();
                else {
                    $.messager.alert(" ", $g("提交并生成图片成功"), "success", function () {
                        callBack();
                    });
                }
            }
            else {
                alert($g(reMsg.msg));
            }
        }
        else {
            var text = $g("错误原因:") + $g(ret.msg) + ",状态:" + ret.status;
            $.messager.alert($g("提示"), text, "info");
        }
    }
    try {
        var sessionJson = GetLogAuxiliaryInfo();
        PrintProvider.MakePic(hisURI, printTemplateEmrCode, episodeID, rowIDs, window.CADisplayPic, sessionJson, generatePicType, MakePicCallBackFun);
    } catch (ex) {
        $.messager.alert($g("提示"), $g("打印插件MakePic无法使用") + ex.Description, "error");
    }
}

function __ExportExcel(data)
{
    var ws = XLSX.utils.json_to_sheet(data, { skipHeader: true });
    var wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "数据");
    var fileName = new Date().format("yyyy-MM-dd HH:mm:ss");
    XLSX.writeFile(wb, "报表" + fileName + ".xlsx");
}

function __SaveSuccessAfterCallback(printTemplateEmrCode, isGeneratePic, isCloseWindow, nurMPDataID, saveType, hideSaveAlert, generatePicType) {

    var innerFun = function () {
        RefreshMiddleFrameTemplateTree();
        //惠美CDSS
        if (($.type(window.getCdssInfoForInPatient) === "function")) {
            getCdssInfoForInPatient(window.EpisodeID, nurMPDataID, window.TemplateIndentity);
        }
        var resultReturnObj = GetResultReturn();
        WindowBeforeCloseProxy(resultReturnObj, isCloseWindow);
    };

    if (isGeneratePic) {
        if (!!window.CAPatientPDF)
            return false;
        __GeneratePic(nurMPDataID, printTemplateEmrCode, hideSaveAlert, innerFun, generatePicType);
    }
    else
    {
        if (!!hideSaveAlert)
            innerFun();
        else {
            var msg = saveType == 1 ? $g("提交成功") : $g("保存成功"); //0:暂存，1:保存
            $.messager.alert(" ", msg, "success", function () {
                innerFun();
            });
        }
    }
}

/**
     *护士CA签名
     @method __NurseCASign
     @param { nurMPDataID } 模板业务数据流水ID
     @param { saveID } 当一个模板有多个保存按钮时，用nurMPDataID流水ID无法区别。
**/
function __NurseCASignData(varCert, containerName, dataPostObj, nurMPDataID, saveID)
{ 
    var varCertCode = window.CAUserCertCode;
    var RecMainInfoin = JSON.stringify(dataPostObj);
    var RecMainXML = tkMakeServerCall("NurMp.CA.DHCNurSignVerify", "GetRecMainXML", RecMainInfoin);
    if (!!window.CARtn && !!window.CARtn.ca_key) {
        var RecMainXMLHash = window.CARtn.ca_key.HashData(RecMainXML);
        var SignData = window.CARtn.ca_key.SignedData(RecMainXMLHash, containerName, window.EpisodeID);
        var VarCerNo = window.CARtn.ca_key.GetCertNo(containerName);
    } else {
        var RecMainXMLHash = HashData(RecMainXML);
        var SignData = SignedData(RecMainXMLHash, containerName, window.EpisodeID);
        var VarCerNo = GetCertNo(containerName);
    }
    if ((window.EpisodeID != "") && (RecMainXMLHash != "") && (varCert != "") && (SignData != "")) {
        var tempCASignedInfos = undefined;
        var testTableReg = /^HISUIDataTableElement/;
        var testBatchReg = new RegExp("^" + saveID);
        if (testTableReg.test(saveID)){//表格可编辑时，行提交数据
            tempCASignedInfos = $.grep(window.CASignedInfos, function (n, i) {
                return n.rowIdentity == saveID;
            });
        }
        else{//只取需要提交的数据，包括各种的批量签名
            tempCASignedInfos = $.grep(window.CASignedInfos, function (n, i) {
                var isCommit = false;
                $.each(dataPostObj, function (k, v) {
                    if (k == n.inputId || (!!dataPostObj.tempSignFieldMap && dataPostObj.tempSignFieldMap[k] == n.inputId)) {
	                    if(!!dataPostObj.tempSignFieldMap && dataPostObj.tempSignFieldMap[k] == n.inputId){
		                	n.inputId=k;
		                }
                        isCommit = true;
                        return false;
                    }
                });
                return isCommit;
            });
        }
        var msg = tkMakeServerCall("NurMp.CA.DHCNurCASignVerify", "InsertNurRecBatchSign",
            window.EpisodeID, window.TemplateGUID, RecMainXMLHash, SignData, nurMPDataID, saveID, JSON.stringify(tempCASignedInfos));
        var reMsg = JSON.parse(msg);
        if (!MsgIsOK(reMsg))
        {
            alert($g("CA签名失败\n错误原因：") + reMsg.msg);
        }      
        else
        { 
            console.log(saveID + "CA签名成功");
        }
    }
    else {  
       alert($g("CA签名哈希/签名证书/签名值为空，请检查！"));
    }
}

/**
     *是否需要护士CA签名
     @method __IsRquireNurseCASign
**/
function __IsRquireNurseCASign(dataPostObj) {
    var findNurseSignInput = [];
    $("input[Signature='Common'],input[Signature='Repeat'],input[Signature='Double'],input[Signature='CommonNOReplace']").each(function (i) {
        if (dataPostObj.hasOwnProperty($(this).attr("id"))) {
            findNurseSignInput.push($(this).attr("id"));
        }
    });
    return findNurseSignInput.length > 0;
}

/**
     *得到需要患者CA签名
     @method __IsPatientCASign
**/
function __GetRquirePatientCASign(dataPostObj) {

    var findPatientSignInput = [];
    $("input[Signature='Patient']").each(function (i) {
        if (dataPostObj.hasOwnProperty($(this).attr("id")) && !!$(this).data("casign"))
        {
            findPatientSignInput.push($(this).attr("id"));
        }
    });
    
    if (findPatientSignInput.length == 0) {
        return [];
    }
        
    return findPatientSignInput;
}

/**
     *表单数据是否修改
     @method __FormDataIsChanged
**/
function __FormDataIsChanged(oldData, newData, overwrite)
{
    var changed = false;
    if (oldData === undefined)
        oldData = {};
    $.each(newData, function (key, val) {
        var helper = GetElementHelper(key);
        if (oldData[key] == undefined)
        {
            changed = true;
            if (overwrite)
                oldData[key] = newData[key];
        }
        else if (!helper.isEqual(oldData[key], newData[key])) {
            changed = true;
            if (overwrite)
                oldData[key] = newData[key];
        }
    });
    return changed;
}

/**
     *校验父子单
     @method __VerifyParentChildForm
**/
function __VerifyParentChildForm(attachTable, gatherFun) {
    if (!!attachTable && $("#" + attachTable).length > 0) {
        var opts = $('#' + attachTable).datagrid('options');
        if (!!opts.parentChildFormQueryField) {
            if (!($.type(window[gatherFun]) === "function")) {
                $.messager.alert(" ", $g("请检查配置，父子单需要采集父ID，才能新建！"), "info");
                return false;
            }
            var SpecifyFiledsData = window[gatherFun]();
            if (SpecifyFiledsData.keys.length == 0) {
                $.messager.alert(" ", "请检查配置,父子单需要采集父ID，才能新建！", "info");
                return false;
            }
            else if (SpecifyFiledsData.keys.indexOf(opts.parentChildFormQueryField) == -1) {
                $.messager.alert(" ", "请检查配置，父子单需要采集父ID，才能新建！", "info");
                return false;
            }
            else {
                var index = SpecifyFiledsData.keys.indexOf(opts.parentChildFormQueryField);
                if (!SpecifyFiledsData.vals[index]) {
                    $.messager.alert(" ", "请检查配置，采集的父ID为空，不能新建！", "info");
                    return false;
                }
            }
        }
    }
    return true;
}

/**
     *特殊符号
     @method RefSpecialChar
     @param formId  表单ID
**/
function RefSpecialChar(formId) {
	if(!formId) return;
	if ($.type(buildMenu) === "function") {
		buildMenu("#" + formId, ['Symbol']);
	}
}
/**
     *右键功能菜单参数传递
     @method RefHandler
     @param formId：表单ID, 
            refType: isKnowledge-true/false 知识库, isMeasure-true/false 病情变化及处理措施，isChars-true/false 特殊符号
**/
function RefHandler(formId, isKnowledge, isMeasure, isChars) {
	if (!formId) return;
    var selector = $.type(formId) == 'object' ? formId : '#' + formId;
	if (isKnowledge) {
		$(selector).data("RefConfig", ["Know"]);
	} 
	if (isMeasure){
		$(selector).data("RefConfig", ["Know","Diag","Order","Exec","Obs","Lis","Pacs","Epr","Record1","Record2","Symbol","Shift"]);
	}
	var refType = [];
	if ((isKnowledge || isMeasure) && !isChars) {
		refType = ['Common'];
	} else if (!isKnowledge && !isMeasure && isChars) {
		refType = ['Symbol'];
	} else if ((isKnowledge || isMeasure) && isChars) {
		refType = ['Common','Symbol'];
	} else {
		return;
	}
	if ($.type(buildMenu) === "function") {
		buildMenu(selector, refType);
	}
}
/**
     *引用特殊符号
     @method RefChars
**/
function RefChars() {
	if ($.type(showChar) === "function") {
		showChar();
	}
}

function __ClearCASignedInfo() {
    window.CAVarCert = undefined;
    window.CAContainerName = undefined;
    window.CAUserCertCode = undefined;
}

/**
 *记录单续打满页提醒
 @method ContinuPrintMaxPageAlter
**/
function ContinuPrintMaxPageAlter() {
    if (!window.PrintFullPageAlert) {
        return;
    }
    $m({
		ClassName: 'NurMp.Service.Template.Model',
		MethodName: 'IfParentPage',
		Guid: window.TemplateGUID
	},function(ifParentPage){
		if (ifParentPage == 'Y') {
			var hisURI = window.WebIp;
			 $m({
				ClassName: 'NurMp.Print.Comm',
				MethodName: 'GetPrnCode',
				EmrCode: window.TemplateGUID,
				HospitalID: session['LOGON.HOSPID']
			},function(printTemplateEmrCode){
				var episodeID = window.EpisodeID;
			    var RowIDs = "";
			    var IsXudabool = false;
			    var queryParam = "";
			    var logAuxiliaryInfo = GetLogAuxiliaryInfo();
			    var isFullMsg = function (ret) {
				    if (ret.msg == 'success') {
					    if (JSON.parse(ret.rtn).status == '0') {
					        var msg = JSON.parse(JSON.parse(ret.rtn).msg)
					        var full = msg.MaxFullPageNo
					        var all = msg.MaxPageNo
					        if (full == 1 && (all == 1)) {
					            full = 0;
					        }
					        $m({
								ClassName: 'NurMp.DHCNurRecorderPrintinfo',
								MethodName: 'PrintMsgInfo',
								Adm: window.EpisodeID,
								PrnEmrCode: printTemplateEmrCode, 
								QueryInfo: ''
							},function(msg){
								var reMsg = JSON.parse(msg);
						        if (!MsgIsOK(reMsg)) {
						            $.messager.alert(" ", $g("获取续打信息失败,无法判断是否满页") + reMsg.msg, "info");
						            return;
						        }
						        if (reMsg.data.Flag == "0") {
						            if (full >= 1) {
						                $.messager.alert(" ", $g("已有" + full + "满页未打印！请及时打印") + reMsg.msg, "info");
						                return;
						            }
						        } else if (reMsg.data.Flag == "1") {
						            var printTrace = StringObjectToObject(reMsg.data.PrintTrace[0], "^", "|");
						            var RowId = printTrace.RowId;
						            $m({
										ClassName: 'NurMp.DHCNurRecorderPrintinfo',
										MethodName: 'PrintInfo',
										Adm: window.EpisodeID, 
										RowId: RowId
									},function(lastRowInfo){
										var printStartPageNo = lastRowInfo.split("^")[2].split("|")[1];
						            	var printStartRowNo = lastRowInfo.split("^")[3].split("|")[1];
						            	if (full > printStartPageNo) {
							                $.messager.alert(" ", $g("上次打印到第" + printStartPageNo + "页，目前已写满第" + full + "页，请及时续打") + reMsg.msg, "info");
							                return;
							            }
							            if (full == printStartPageNo && printStartRowNo < 21) {
							                $.messager.alert(" ", $g("上次打印到第" + printStartPageNo + "页，第" + printStartRowNo + "行，目前已写满" + full + "页，请及时续打") + reMsg.msg, "info");
							                return;
							            }
									});
						        }
							});
					    }
				    }
			        
			    };
			    PrintProvider.GetMaxPageInfo(hisURI, printTemplateEmrCode, episodeID, window.CAVerify, RowIDs, IsXudabool, queryParam, logAuxiliaryInfo, isFullMsg)
			});		   
		}
	});
}

/**
 *单选分组互斥
 @method RadioGroupMutuallyExclusive
 @param sender  当前正在操作的单选元素 
 @param group   分组成员
**/
function RadioGroupMutuallyExclusive(sender, group) {

    $.each(group, function (i, n) {
        if (n == $(sender).attr("id"))
        {
            //不处理
        }
        else {
            var wrapValue = [];
            SetOneValue(n, wrapValue);
        }
    });
}

// 超融合
if (typeof websys_on == 'function') {
	websys_on("onRecordRefer",function(data){ 
		console.log(data);
		if (!curElement) {
			$.messager.alert("提示","请选择元素","info");
			return;
		}
		setTimeout(function(){    	
			var curPosition = getCursortPosition(curElement);
			var toPreview = data.ToPreview;
			if (JSON.parse(toPreview)) {
				SetOneValue(curElement.id, data.EditContent);   //将原有文本替换
			} else {
				var startText = curPosition == 0 ? '' : curElement.value.substring(0, curPosition);
				if (startText.trim() == '/') {
					startText = '';
				}
				var endText = curElement.value.substring(curPosition);
				SetOneValue(curElement.id, startText + data.EditContent + endText);  //在原有文本追加
			}
		},500);
	});
}

