/**
 * creator:		yunhaibao
 * createdate:	2017-12-06
 * description: 静配打印公共
 * DHCST.PIVA.PRINT.js
 */
var PIVASPRINT = ({
    Init: function() {
        document.write("<OBJECT ID='PIVALabel' width='0' height='0' CLASSID='B9D18A6E-5B73-4235-B1D8-457D6DFD45C8' CODEBASE='dthealth/web/addins/client/DHCSTPrint.CAB#version=1,0,0,27'></object>");
    },
    // 定义多少个签发送一次任务
    PrintNum: 50,
    // 记录全局打签json
    LabelsJson: [],
    // 回调
    CallBack: "",
    // 当前打印病区液体的组数总数
    WardPogNum: "",
    // 配液打签直接打印,按打印单号汇总,一次打印一个单号
    LabelsByPogsNo: function(_options) {
        // _options.pogsNo:  单号
        // _options.sortWay: 排序方式DHCST.PIVA.COMMON.js
        var pogsNo = _options.pogsNo;
        var sortWay = _options.sortWay;
        if (pogsNo == undefined) {
            return "";
        }
        var retVal = tkMakeServerCall("web.DHCSTPIVAS.PrintCom", "LabelsByPogsNo", pogsNo, sortWay);
        var retValArr = retVal.split("^");
        var pid = retValArr[0];
        var count = retValArr[1];
        if ((pid == "") || (count == 0)) {
            return;
        }
        var pageI = 0;
        for (var i = 1; i <= count; i++) {
            var pogId = tkMakeServerCall("web.DHCSTPIVAS.PrintCom", "ListPrintData", pid, i);
            if (pogId == "") {
                break;
            }
            var printTask = "0";
            if (i % (this.PrintNum) == 0) {
                printTask = "1";
            }
            if (i == count) {
                printTask = "1";
            }
            pageI = pageI + 1;
            this.Label({
                pogId: pogId,
                printTask: printTask,
                pageNo: pageI, // 页码
                pageNumbers: count, // 页数
                rePrint: ""
            });
        }
        // 清除所有global
        tkMakeServerCall("web.DHCSTPIVAS.PrintCom", "KillPrintData", pid);
    },
    // 根据单号打印所有标签,Json输出
    LabelsJsonByPogsNo: function(_options) {
        var pogsNo = _options.pogsNo;
        var sortWay = _options.sortWay;
        if (pogsNo == undefined) {
            return "";
        }
        $.messager.progress({
            title: "请耐心等待...",
            text: '<b>{value}%</b>  打  印  数  据  中  ',
            interval: 1000000
        })
        $.cm({
            ClassName: "web.DHCSTPIVAS.PrintCom",
            MethodName: "LabelsJsonByPogsNo",
            pogsNo: pogsNo,
            prtWayStr: sortWay
        }, function(retJson) {
            PIVASPRINT.LabelsJson = retJson;
            var retLen = retJson.length;
            if (retLen > 0) {
                PIVASPRINT.LabelsJsonPrint(retLen, 0)
            } else {
                $.messager.progress("close");
            }
        })
    },
    // 递归打印
    // @labelCnt:  标签总个数
    // @labelPageI:第几个标签
    LabelsJsonPrint: function(labelCnt, labelPageI) {
        var PrintNum = PIVASPRINT.PrintNum;
        var PrintLabelI = labelPageI + 1;
        if (labelPageI >= labelCnt) {
            $.messager.progress('close');
            if (PIVASPRINT.CallBack != "") {
                PIVASPRINT.CallBack();
            }
            return;
        }
        var labelJson = PIVASPRINT.LabelsJson[labelPageI];
        var pogId = labelJson.pogId
        if (pogId == "") {
            labelPageI++;
            PIVASPRINT.LabelsJsonPrint(labelCnt, labelPageI);
            return;
        }
        var printTask = "0";
        if (labelPageI % PrintNum == 0) {
            printTask = "1";
        }
        if ((labelPageI + 1) == labelCnt) {
            printTask = "1";
        }
        PIVASPRINT.Label({
            pogId: pogId,
            printTask: printTask,
            pageNo: PrintLabelI, // 页码
            pageNumbers: labelCnt, // 总页数
            rePrint: "",
            pogLabelData: labelJson.LabelData
        });
        if (labelPageI % (PIVASPRINT.PrintNum) == 0) {
            // 延时处理progress
            $("body>div.messager-window").find("div.messager-p-msg").text(PrintLabelI + " / " + labelCnt)
            $.messager.progress('bar').progressbar('setValue', parseInt((PrintLabelI / labelCnt) * 100));
            setTimeout(function() {
                labelPageI++;
                PIVASPRINT.LabelsJsonPrint(labelCnt, labelPageI);
            }, 10)
        } else {
            labelPageI++;
            PIVASPRINT.LabelsJsonPrint(labelCnt, labelPageI);
        }
    },
    // 打印单个标签
    // _options.printTask:   是否发送打印任务
    // _options.pogId:	  	 配液主表Id
    // _options.pogLabelData:标签内容
    Label: function(_options) {
        var printTask = _options.printTask;
        var pogId = _options.pogId;
        var pogLabelData = _options.pogLabelData;
        if (pogLabelData == undefined) {
            pogLabelData = "";
        }
        if (pogId == undefined) {
            pogId = "";
        }
        if ((pogLabelData == "") && (pogId == "")) {
            return;
        }
        if (pogLabelData == "") {
            pogLabelData = tkMakeServerCall("web.DHCSTPIVAS.PrintCom", "GetPrintLabel", pogId);
        }
        if (pogLabelData == "") {
            alert("打印标签错误,PogId:" + pogId);
            return;
        }
        var pageNumbers = _options.pageNumbers;
        var pageNo = _options.pageNo;
        var rePrint = _options.rePrint;
        if (pageNumbers == undefined) {
            pageNumbers = 1;
        }
        if (pageNo == undefined) {
            pageNo = 1;
        }
        if (rePrint == undefined) {
            rePrint = "";
        }
        var pogLabelArr = pogLabelData.split("|@|");
        var pogMainData = pogLabelArr[0];
        var pogDetailData = pogLabelArr[1];
        var Bar = new ActiveXObject("DHCSTPrint.PIVALabel")
        Bar.Device = "PIVAS"
        Bar.PageWidth = 70
        Bar.PageHeight = 90
        Bar.HeadFontSize = 9
        Bar.FontSize = 10
        Bar.Title = pogMainData.split("^")[36] + "输液签" + rePrint;
        Bar.HeadType = ""
        Bar.IfPrintBar = "True" // 是否打印码
        Bar.BarTop = 66
        Bar.BarLeftMarg = 2
        Bar.BarFontSize = 20
        Bar.PageSpaceItm = 1
        Bar.ItmFontSize = 9
        Bar.PageMainStr = pogMainData
        Bar.PageItmStr = pogDetailData
        Bar.PageSpace = 1
        Bar.PageLeftMargine = 1
        Bar.PageTopMargine = 0
        Bar.BarWidth = 24
        Bar.BarHeight = 8
        Bar.PageNumbers = pageNumbers
        Bar.PageNumber = pageNo
        Bar.ItmOmit = true; // 药品名称是否换行
        Bar.ItmCharNums = 30; // 药品名称每行字符数
        Bar.PrintDPage(printTask.toString());
    },
    // 所有汇总签
    HeadTotalLabel: function(_options) {

    },
    // 病区汇总签
    HeadWardLabel: function(_options) {
        /// _options.headLabelStr
        try {
            var headLabelStr = _options.headLabelStr
            if (headLabelStr == "") {
                return;
            }
            var headLabelArr = headLabelStr.split("|@|");
            var headMainStr = headLabelArr[0];
            var headDetailStr = headLabelArr[1];
            var headMainArr = headMainStr.split("^");
            var headDetailArr = headDetailStr.split("!!");
            var MyList = "";
            var MyPara = "";
            MyPara += "title" + String.fromCharCode(2) + headMainArr[0];
            MyPara += "^printDateTime" + String.fromCharCode(2) + headMainArr[1];
            MyPara += "^printUser" + String.fromCharCode(2) + session['LOGON.USERNAME'];
            MyPara += "^wardDesc" + String.fromCharCode(2) + headMainArr[2];
            MyPara += "^count" + String.fromCharCode(2) + headMainArr[3];
            for (var headI = 0; headI < headDetailArr.length; headI++) {
                var detailStr = headDetailArr[headI];
                var detailArr = detailStr.split("^");
                var listIData = detailArr[0] + "^" + detailArr[1];
                if (MyList == "") MyList = listIData
                else MyList = MyList + String.fromCharCode(2) + listIData
            }
            DHCSTGetXMLConfig("PIVASHeadWardLabel");
            DHCSTPrintFun(MyPara, MyList);
            this.WardPogNum = headMainArr[3].split("组")[0];
        } catch (e) {}
    },
    // TPN标签
    TPNLabel: function(_options) {},
    // 打印路径
    Path: function(_options) {},
    // 验证该机器是否已注册动态库
    // xName:DHCSTPrint.PIVALabel(打标签)
    CheckActiveX: function(xName) {
        try {
            var activeObj = new ActiveXObject(xName);
        } catch (e) {
            alert("不能打印标签,请先注册动态库 " + xName);
            return false;
        }
    },
    /// 修改为润乾raq路径,注意同时引入润乾文件
    /// _option.raqName:   润乾文件名
    /// _options.raqParams:参数信息
    /// _options.isPreview:是否预览(1:是)
    /// _options.isPath:   是否仅获取路径(1:是)
    RaqPrint: function(_options) {
        var raqName = _options.raqName;
        var raqParams = _options.raqParams;
        var isPreview = _options.isPreview;
        var isPath = _options.isPath;
        var raqSplit = (isPreview == 1 ? "&" : ";");
        var fileName = "";
        var params = "";
        var paramsI = 0;
        for (var param in raqParams) {
            var iParam = raqParams[param];
            var iParamStr = param + "=" + iParam;
            if (paramsI == 0) {
                params = iParamStr;
            } else {
                params = params + raqSplit + iParamStr;
            }
            paramsI++;
        }
        var rqDTFormat = this.RQDTFormat();
        if (isPreview == 1) {
            fileName = raqName + "&RQDTFormat=" + rqDTFormat + "&" + params;
            if (isPath == 1) {
                return "dhccpmrunqianreport.csp?reportName=" + fileName;
            } else {
                DHCCPM_RQPrint(fileName, window.screen.availWidth * 0.5, window.screen.availHeight);
            }
        } else {
            fileName = "{" + raqName + "(" + params + ";RQDTFormat=" + rqDTFormat + ")}";
            alert(fileName)
            DHCCPM_RQDirectPrint(fileName);
        }
    },
    // 一些界面打印的默认条件,如扫描时打印交接单,返回数组
    DefaultParams: {
        // 排药单
        Arrange: function() {
            var paramsArr = new Array(29);
            paramsArr[8] = "1"; // 执行记录状态
            paramsArr[21] = "N"; // 执行记录状态
            return paramsArr;
        },
        // 病区交接单
        WardBat: function() {
            var paramsArr = new Array(28);
            paramsArr[8] = "1"; // 执行记录状态
            paramsArr[21] = "N"; // 执行记录状态
            return paramsArr;
        }
    },
    // 系统日期格式,润乾打印用
    RQDTFormat: function() {
        var dateFmt = "yyyy-MM-dd"
        var fmtDate = $.fn.datebox.defaults.formatter(new Date());
        if (fmtDate.indexOf("/") >= 0) {
            dateFmt = "dd/MM/yyyy"
        }
        return dateFmt + " " + "HH:mm:ss";
    }
});