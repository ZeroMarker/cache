
var PrintProvider = {
    PrintALL: function (hisURI, printTemplateEmrCode, episodeID, RowIDs, CAVerify, CallBackFun, queryParam, IsPrintAll, logAuxiliaryInfo, isShowPreViewstr, printerName) {
        var mode = GetPrintMode("PrintALL");
        if (typeof (CAVerify) == "undefined") {          
            $.messager.alert($g("提示"), $g("CAVerify undefined"), "info");
            CAVerify = 0;
        }
        if (typeof (isShowPreViewstr) == "undefined") {
          //  $.messager.alert($g("提示"), $g("CAVerify undefined"), "info");
            isShowPreViewstr = "";//如果是0，不弹出打印预览，否则根据打印模板的配置走
        }
        if (typeof (printerName) == "undefined") {
          //  $.messager.alert($g("提示"), $g("CAVerify undefined"), "info");
            printerName = "";//默认打印机
        }      
        if (mode == 1) {
            NurEmrPrint.timeout = 999999;
            NurEmrPrint.notReturn = 1;//异步是1，同步是0，必须设置，是全局变量
            NurEmrPrint.PrintALL(hisURI, printTemplateEmrCode, episodeID, RowIDs, CAVerify, queryParam, IsPrintAll,logAuxiliaryInfo,isShowPreViewstr,printerName, CallBackFun);
        } else if (mode == 2) {
            var obj = document.PrintActiveX;
            if (typeof (obj) == "undefined") {
                $.messager.alert($g("提示"), $g("PrintActiveX undefined"), "info");
            }
            var ret = {};
            ret.msg = "success";
            var msg = obj.PrintALL(hisURI, printTemplateEmrCode, episodeID, RowIDs, CAVerify, queryParam, IsPrintAll, logAuxiliaryInfo,isShowPreViewstr,printerName);
            ret.rtn = msg;
            CallBackFun(ret);
        } else if (mode == 3) {
            var jsObject = { "status": "-99", "msg": $g("请到Demo中的插件管理配置对应的方法"), "data": null };

            CallBackFun(jsObject);
        } else if (mode == 4) {
            var jsObject = { "status": "-98", "msg": $g("当前环境没有合适的打印方式"), "data": null };
            CallBackFun(jsObject);
        }
        return msg;
    },
    GetMaxPageInfo: function (hisURI, printTemplateEmrCode, episodeID, CAVerify, RowIDs, IsXudabool, queryParam, logAuxiliaryInfo, CallBackFun) {
        var mode = GetPrintMode("GetMaxPageInfo");
        var IsXuda = "0";
        if (IsXudabool) {
            IsXuda = "1";
        }
        if (typeof (CAVerify) == "undefined") {
            $.messager.alert($g("提示"), $g("CAVerify undefined"), "info");
            CAVerify = 0;
        }      
       
        if (mode == 1) {
            NurEmrPrint.timeout = 999999;
            NurEmrPrint.notReturn = 0;//异步是1，同步是0，必须设置，是全局变量
            NurEmrPrint.GetMaxPageInfo(hisURI, printTemplateEmrCode, episodeID, CAVerify, IsXuda, RowIDs, queryParam, logAuxiliaryInfo, CallBackFun);
        } else if (mode == 2) {
            var obj = document.PrintActiveX;
            if (typeof (obj) == "undefined") {
                $.messager.alert($g("提示"), $g("PrintActiveX undefined"), "info");
            }
            var ret = {};
            ret.msg = "success";
            var msg = obj.GetMaxPageInfo(hisURI, printTemplateEmrCode, episodeID, CAVerify, IsXuda, RowIDs, queryParam, logAuxiliaryInfo);
            ret.rtn = msg;
            CallBackFun(ret);
        } else if (mode == 3) {
            var jsObject = { "status": "-99", "msg": $g("请到Demo中的插件管理配置对应的方法"), "data": null };

            CallBackFun(jsObject);
        } else if (mode == 4) {
            var jsObject = { "status": "-98", "msg": $g("当前环境没有合适的打印方式"), "data": null };
            CallBackFun(jsObject);
        }
        return msg;
    },
    Print: function (hisURI, printTemplateEmrCode, episodeID, IsXudabool, printRowId, intStartPageNo, intStartIndex, flag, CAVerify, CallBackFun, queryParam, logAuxiliaryInfo) {
        var mode = GetPrintMode("Print");
        var IsXuda = "0";
        if (IsXudabool)
        {
            IsXuda = "1";
        }
        if (mode == 1) {
            NurEmrPrint.timeout = 999999;
            NurEmrPrint.notReturn = 1;//异步是1，同步是0，必须设置，是全局变量
             NurEmrPrint.Print(hisURI, printTemplateEmrCode, episodeID, IsXuda, printRowId, intStartPageNo, intStartIndex, flag, CAVerify, queryParam,logAuxiliaryInfo,CallBackFun);
           
        } else if (mode == 2) {
            var obj = document.PrintActiveX;
            if (typeof (obj) == "undefined") {
                $.messager.alert($g("提示"), $g("PrintActiveX undefined"), "info");
            }
            var ret = {};
            ret.msg = "success";
            var msg = obj.Print(hisURI, printTemplateEmrCode, episodeID, IsXuda, printRowId, intStartPageNo, intStartIndex, flag, CAVerify, queryParam, logAuxiliaryInfo);
          
            ret.rtn = msg;
            CallBackFun(ret);
        } else if (mode == 3) {
            var jsObject = { "status": "-99", "msg": $g("请到Demo中的插件管理配置对应的方法"), "data": null }
            CallBackFun(jsObject);
        } else if (mode == 4) {
            var jsObject = { "status": "-98", "msg": $g("当前环境没有合适的打印方式"), "data": null }
            CallBackFun(jsObject);
        }
        return msg
    },
    MakePicAll: function (hisURI, printTemplateEmrCode, episodeID, CAVerify, queryParam, logAuxiliaryInfo,isimg, CallBackFun) {
        var mode = GetPrintMode("MakePicAll");
       // var isimg = "0";//1是HTML，否为图片
        if (mode == 1) {
            NurEmrPrint.timeout = 999999;
            NurEmrPrint.notReturn = 1;//异步是1，同步是0，必须设置，是全局变量
            NurEmrPrint.MakePicAll(hisURI, printTemplateEmrCode, episodeID, CAVerify, queryParam, logAuxiliaryInfo,isimg,CallBackFun);
          
        } else if (mode == 2) {
            var obj = document.PrintActiveX;
            if (typeof (obj) == "undefined") {
                $.messager.alert($g("提示"), $g("PrintActiveX undefined"), "info");
            }
            var msg = obj.MakePicAll(hisURI, printTemplateEmrCode, episodeID, CAVerify, queryParam, logAuxiliaryInfo,isimg);
            var ret = {};
            ret.msg = "success";   
            ret.rtn = msg;
            CallBackFun(ret);
        } else if (mode == 3) {
            var jsObject = { "status": "-99", "msg": $g("请到Demo中的插件管理配置对应的方法"), "data": null }
            var msg = JSON.stringify(jsObject);
            CallBackFun(jsObject);
        } else if (mode == 4) {
            var jsObject = { "status": "-98", "msg": $g("当前环境没有合适的打印方式"), "data": null }
            var msg = JSON.stringify(jsObject);
            CallBackFun(jsObject);
        }
        return msg
    },
    MakePic: function (hisURI, printTemplateEmrCode, episodeID, rowIDs, CAVerify, logAuxiliaryInfo,  isimg, CallBackFun) {
        var mode = GetPrintMode("MakePic");
        // var isimg = "0";//1是HTML，否为图片
        var queryParam = "";
        if (mode == 1) {
            NurEmrPrint.timeout = 999999;
            NurEmrPrint.notReturn = 1;//异步是1，同步是0，必须设置，是全局变量
            NurEmrPrint.MakePic(hisURI, printTemplateEmrCode, episodeID, rowIDs, CAVerify, queryParam, logAuxiliaryInfo, isimg, CallBackFun);
          
        } else if (mode == 2) {
            var obj = document.PrintActiveX;
            if (typeof (obj) == "undefined") {              
                $.messager.alert($g("提示"), $g("PrintActiveX undefined"), "info");
            }

            var msg = obj.MakePic(hisURI, printTemplateEmrCode, episodeID, rowIDs, CAVerify, queryParam, logAuxiliaryInfo, isimg);
            var ret = {};
            ret.msg = "success";
            ret.rtn = msg;
            CallBackFun(ret);
        } else if (mode == 3) {
            var jsObject = { "status": "-99", "msg": $g("请到Demo中的插件管理配置对应的方法"), "data": null }
            var msg = JSON.stringify(jsObject);
            CallBackFun(jsObject);
        } else if (mode == 4) {
            var jsObject = { "status": "-98", "msg": $g("当前环境没有合适的打印方式"), "data": null }
            var msg = JSON.stringify(jsObject);
            CallBackFun(jsObject);
        }
        return msg
    },
    MakeHTML: function (hisURI, printTemplateEmrCode, episodeID, rowIDs,pageNO, CAVerify, logAuxiliaryInfo, CallBackFun) {
        var mode = GetPrintMode("MakeHTML");
        var queryParam = "";
        // var isimg = "0";//1是HTML，否为图片
        if (mode == 1) {
            NurEmrPrint.timeout = 999999;
            NurEmrPrint.notReturn = 1;//异步是1，同步是0，必须设置，是全局变量
            NurEmrPrint.MakeHTML(hisURI, printTemplateEmrCode, episodeID, rowIDs, pageNO, CAVerify, queryParam, logAuxiliaryInfo, CallBackFun);

        } else if (mode == 2) {
            var obj = document.PrintActiveX;
            if (typeof (obj) == "undefined") {
                $.messager.alert($g("提示"), $g("PrintActiveX undefined"), "info");
            }
            var msg = obj.MakeHTML(hisURI, printTemplateEmrCode, episodeID, rowIDs, pageNO, CAVerify, queryParam, logAuxiliaryInfo);
            var ret = {};
            ret.msg = "success";
            ret.rtn = msg;
            CallBackFun(ret);
        } else if (mode == 3) {
            var jsObject = { "status": "-99", "msg": $g("请到Demo中的插件管理配置对应的方法"), "data": null }
            var msg = JSON.stringify(jsObject);
            CallBackFun(jsObject);
        } else if (mode == 4) {
            var jsObject = { "status": "-98", "msg": $g("当前环境没有合适的打印方式"), "data": null }
            var msg = JSON.stringify(jsObject);
            CallBackFun(jsObject);
        }
        return msg
    }
};


//Input:方法名字Print，PrintALL，MakePicAll，MakePic
//Return:1-使用中间件打印，2-使用原来方式打印，3-满足中间件不满足原来方式但方法没有配置，4.两种方式都不满足
//如果插件管理程序未启动没法判断
function GetPrintMode(methodName) {
    var isIE = (!!window.ActiveXObject || "ActiveXObject" in window);
    var ret = "2"; //默认原来的方式
    if ("undefined" == typeof EnableLocalWeb || 0 == EnableLocalWeb || "undefined" == typeof NurEmrPrint) //不满足中间件打印
    {
        if (isIE) { //是IE调用原来的方式打印
            ret = 2;
        } else { //不是IE也不满足中间件，提示不能打印
            ret = 4;
        }
    } else { //满足中间件环境
        ret = 1;
        if (methodName == "Print") {
            if ("undefined" == typeof NurEmrPrint.Print || (NurEmrPrint.Print.toString().indexOf("invk()") < 0)) {
                ret = 3;
            }
        } else if (methodName == "PrintALL") {
            if ("undefined" == typeof NurEmrPrint.PrintALL || (NurEmrPrint.PrintALL.toString().indexOf("invk()") < 0)) {
                ret = 3;
            }
        } else if (methodName == "MakePicAll") {
            if ("undefined" == typeof NurEmrPrint.MakePicAll || (NurEmrPrint.MakePicAll.toString().indexOf("invk()") < 0)) {
                ret = 3;
            }
        } else if (methodName == "MakePic") {
            if ("undefined" == typeof NurEmrPrint.MakePic || (NurEmrPrint.MakePic.toString().indexOf("invk()") < 0)) {
                ret = 3;
            }
        } else if (methodName == "MakeHTML") {
            if ("undefined" == typeof NurEmrPrint.MakeHTML || (NurEmrPrint.MakeHTML.toString().indexOf("invk()") < 0)) {
                ret = 3;
            }
        } else if (methodName == "GetMaxPageInfo") {
            if ("undefined" == typeof NurEmrPrint.GetMaxPageInfo || (NurEmrPrint.GetMaxPageInfo.toString().indexOf("invk()") < 0)) {
                ret = 3;
            }
        } else {
            ret = 3;
        }
        if (ret == 3 && isIE) {
            ret = 2; //方法没有配置或不存在并且是IE 调用原来方式
        }
        //如果方法没有配置或凭证不存在且不是IE，提示配置正确的方法
    }
    return ret;
}