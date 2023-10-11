//缓存检验打印参数
var LISSYSPrintParam = "";
//缓存Webservice地址
var LISSYSPrintWebServicAddress = "";

//LIS给HIS端提供的统一打印处理,非检验web调用*****************************zlz
//是谷歌的话先尝试HIS中间件调用，没有发布服务的话尝试LIS监听程序调用。IE用clickone调用
//Param:打印参数printFlag + "@" + WebServicAddress + "@" + labNo + "@" + userCode + "@" + printType + "@" + paramList + "@HIS.DHCReportPrintBarCodeForAll@QueryPrintData"
function HISBasePrint(Param) {
    var urlHead = window.document.location.href.split("//")[0];
    if (urlHead == "https:") {
        WEBSYSHTTPSERVERURL = "https://localhost:21996/websys/";
    }
    else {
        WEBSYSHTTPSERVERURL = "http://localhost:11996/websys/";
    }
    //url的ip
    var UrlIP = window.document.location.href.split("//")[1].split("/")[0].split(":")[0];
    LISSYSPrintParam = Param;
    //检测是否是谷歌浏览器
    var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
    //如果是谷歌浏览器尝试调用插件驱动创建用户
    if (true||isChrome) {
        var paraArr = Param.split("@");
        if (paraArr.length < 6) {
            alert("打印参数少于6位");
        }
        var rowids = paraArr[2];
        var userCode = paraArr[3];
        var printType=paraArr[4];
        var paramList = paraArr[5];
        var connectString = paraArr[1];
        var rowids = paraArr[2];
        var className = "";
        var funName = "";
        if (paramList == "") {
            paramList = "DOCTOR";
        }
        if (paraArr.length >= 8) {
            className = paraArr[6];
            funName = paraArr[7];
        }
        if (connectString != "") {
            LISSYSPrintWebServicAddress = connectString;
        }
        if (LISSYSPrintWebServicAddress == "") {
            //没传地址的查询获取
            $.ajaxRunServerMethod({ ClassName: "DHCLIS.DHCOrderList", MethodName: "GetConnectString", ID: UrlIP },
                function (rtn) {
                    if (rtn != "") {
                        var indexSP = rtn.indexOf("$LIS.SP$");
                        var onePara = rtn;
                        var towPara = "";
                        if (indexSP > 0) {
                            onePara = rtn.substring(0, indexSP);
                            //加密串
                            towPara = rtn.substring(indexSP + 8);
                        }
                        LISSYSPrintWebServicAddress = onePara;
                        if (towPara != "") {
                            LISSYSPrintWebServicAddress=towPara;
                        }
                        if (printType == "PrintPreview") {
                            LISPrint.PrintPreview(rowids, userCode, paramList, LISSYSPrintWebServicAddress, className, funName);
                        }
						else if (printType == "PrintPreviewOld")
                        {
                            LISPrint.PrintOut(rowids, userCode, paramList, LISSYSPrintWebServicAddress, className, funName, printType);
                        }
                        else if (printType.indexOf("PDF")>-1)
                        {
                            LISPrint.PrintOut(rowids, userCode, paramList, LISSYSPrintWebServicAddress, className, funName, printType);
                        }
                        else {
                            LISPrint.PrintOut(rowids, userCode, paramList, LISSYSPrintWebServicAddress, className, funName);
                        }
                    }
                });	
        }
        else {
            if (printType == "PrintPreview") {
                LISPrint.PrintPreview(rowids, userCode, paramList, LISSYSPrintWebServicAddress, className, funName);
            }
			else if (printType == "PrintPreviewOld")
            {
                LISPrint.PrintOut(rowids, userCode, paramList, LISSYSPrintWebServicAddress, className, funName, printType);
            }
            else if (printType.indexOf("PDF") > -1) {
                LISPrint.PrintOut(rowids, userCode, paramList, LISSYSPrintWebServicAddress, className, funName, printType);
            }
            else {
                LISPrint.PrintOut(rowids, userCode, paramList, LISSYSPrintWebServicAddress, className, funName);
            }
        }
        
    }
    else {
        //改为同步调用，有的IE会给异步打开页面拦截
        var result = $cm(
            {
                ClassName: "DHCLIS.DHCOrderList",
                MethodName: "GetConnectString",
                ID: UrlIP,
                dataType: "text"
            }, false);
        if (result != "") {
            var indexSP = result.indexOf("$LIS.SP$");
            var onePara = result;
            var towPara = "";
            if (indexSP > 0) {
                onePara = result.substring(0, indexSP);
                //加密串
                towPara = result.substring(indexSP + 8);
            }
            var webIP = result.split("//")[1].split("/")[0];
            var arrp = Param.split('@');
            var paramNew = "";
            for (var i = 0; i < arrp.length; i++) {
                if (i == 0) {
                    paramNew += arrp[i];
                }
                else if (i == 1) {
                    if (towPara != "") {
                        paramNew += "@" + towPara;
                    }
                    else {
                        paramNew += "@" + onePara;
                    }
                }
                else {
                    paramNew += "@" + arrp[i];
                }

            }
            Param = paramNew;
            var printUrl = result.split("//")[0] + "//" + webIP + "/imedicallis/lisprint/print2HIS/ResultPrintForHis.application?Param=" + Param;
            document.location.href = printUrl;
        }
    }
}

//dowloadUrl下载符合检验打印元素绘制协议json的url
//printFlag:打印标识 PrintPreview或PrintOut控制打印预览和直接打印或者PDF#地址  【0用户选  -1桌面  具体地址】
function JsBasePrint(downloadUrl, printFlag) {
    LISPrint.JsPrint(downloadUrl, printFlag);
}

//得到下载json数组的url
function GetDownloadUrlByJsonArr(arr) {
    var downLoadUrl = "";
    $.ajax({
        type: "post",
        dataType: "text",
        cache: false, //
        async: false, //为true时，异步，不等待后台返回值，为false时强制等待；-asir
        url: GetLisWebBasePath()+'lisprint/ashx/ashLisPrintDesigner.ashx?Method=SavePTTMPParaRlative',
        data: { printpara: JSON.stringify(arr) },
        success: function (result, status) {
            if (result != "-1") {
                downLoadUrl = GetLisWebBasePath() + result;
            }
        }
    });
    return downLoadUrl;
}

//得到检验网站根地址
var LISWebBasePath = "";
function GetLisWebBasePath() {
    if (LISWebBasePath != "") {
        return LISWebBasePath;
    }
    var result = $cm(
        {
            ClassName: "DHCLIS.DHCOrderList",
            MethodName: "GetConnectString",
            ID: UrlIP,
            dataType: "text"
        }, false);
    if (result != "") {
        LISWebBasePath = result.split("//")[0] + "//" + webIP + "/imedicallis/";
    }
    return LISWebBasePath;
}

//打印插件
var PrintWidget = {
    //初始化
    Init: function () {
        printWidget = [];
        printWidgetAllPage = [];
        printPaperHeightWidget = 1024;
        handPrintWidget = false;
    },
    //生成PDF type:PrintOut:打印  PrintPreview打印预览  PDF#地址  【0用户选  -1桌面  具体地址】
    PrintOutPDF: function (type) {
        if (type == null) {
            type = "PDF#0";
        }
        var downLoadUrl = GetDownloadUrlByJsonArr(printWidget);
        JsBasePrint(downLoadUrl, type);
    },
    //打印
    PrintOut: function () {
        var downLoadUrl = GetDownloadUrlByJsonArr(printWidget);
        JsBasePrint(downLoadUrl, "PrintOut");
    },
    //打印预览
    PrintPreview: function () {
        var downLoadUrl = GetDownloadUrlByJsonArr(printWidget);
        JsBasePrint(downLoadUrl, "PrintPreview");
    },
    //设置是否自动转换坐标
    SetIsAutoCoordinate: function (isAutoCoordinate) {
        IsAutoCoordinate = isAutoCoordinate;
    },
    //设置打印机，要在最开始设置，切记
    //IsAutoChangePage:为空默认自动，是否自动换页1:自动，自上而下的绘制，由动态库执行分页  0:主动，打印逻辑通过换页元素换页
    //PaperName:纸张名称
    //PaperWidth:宽度
    //PaperHeight:高度
    //PaperLayOut:纸张方向Landscape横向
    //Printer:打印机
    //PaperSource:送纸来源
    //PrintWidget.SetPrinter("", "", "", "Landscape", "", "");
    SetPrinter: function (IsAutoChangePage, PaperName, PaperWidth, PaperHeight, PaperLayOut, Printer, PaperSource) {
        //是设置的话就不清除数据
        if (printWidget.length > 0 && printWidget[0].PrintType == "PRINTER") {
            printWidget = [];
        }
        if (IsAutoChangePage == null) {
            IsAutoChangePage = "1";
        }
        if (PaperName == null) {
            PaperName = "";
        }
        if (PaperWidth == null || PaperWidth == "") {
            PaperWidth = "1";
        }
        if (PaperHeight == null || PaperHeight == "") {
            PaperHeight = "1";
        }
        if (PaperLayOut == null) {
            PaperLayOut = "";
        }
        if (Printer == null) {
            Printer = "";
        }
        //变化宽高
        if (PaperLayOut == "Landscape") {
            var tmpwh = printPaperHeightWidget;
            //存纸张高度
            printPaperHeightWidget = printPaperWidthWidget;
            //存纸张宽度度
            printPaperWidthWidget = tmpwh;
        }
        if (PaperSource == null || PaperSource == "") {
            PaperSource = "0";
        }
        printWidget.unshift({ PrintType: "PRINTER", PrintX: "1", PrintY: "1", PrintFont: PaperSource, PrintFontSize: "1", PrintFontStyle: "", PrintLength: "1", PrintWidth: PaperWidth, PrintHeight: PaperHeight, PrintText: "", DataField: PaperName, PrintFlag: Printer, PrintAlignment: PaperLayOut, PrintImageFile: "", PrintColor: "", Angle: "", IsVShow: IsAutoChangePage });
    },
    //仅仅设置打印机，防止干扰纸张，要在最开始设置，切记
    SetPrinterOnly: function (Printer) {
        //是设置的话就不清除数据
        if (printWidget.length > 0 && printWidget[0].PrintType == "PRINTER") {
            printWidget = [];
        }
        if (IsAutoChangePage == null) {
            IsAutoChangePage = "1";
        }
        if (PaperName == null) {
            PaperName = "";
        }
        if (PaperWidth == null || PaperWidth == "") {
            PaperWidth = "1";
        }
        if (PaperHeight == null || PaperHeight == "") {
            PaperHeight = "1";
        }
        if (PaperLayOut == null) {
            PaperLayOut = "";
        }
        if (Printer == null) {
            Printer = "";
        }
        printWidget.unshift({ PrintType: "PRINTERONLY", PrintX: "1", PrintY: "1", PrintFont: PaperSource, PrintFontSize: "1", PrintFontStyle: "", PrintLength: "1", PrintWidth: PaperWidth, PrintHeight: PaperHeight, PrintText: "", DataField: PaperName, PrintFlag: Printer, PrintAlignment: PaperLayOut, PrintImageFile: "", PrintColor: "", Angle: "", IsVShow: IsAutoChangePage });
    },
    //公共处理Y增长逻辑，超过纸张后换页
    AddY: function (curY, addHeight, paperHeight) {
        curY += addHeight;
        if (curY > paperHeight) {
            curY = curY - paperHeight;
            PrintWidget.ChangePage();
        }
        return curY;
    },
    //datas：数组数据
    //cols：绘制列数据属性名称数组
    //colRates：列比例，传空平均，传的位数比列少后面部分平均
    //colAligns：列停靠left  center right，传空left，传的位数比列少后面部分left
    //width：表格宽度
    //left：左
    //top：顶部
    //isDrawBorder：是否画边框
    //borderWidth：边框线宽度
    //rowHeight：行高，默认20
    //lineWidth：线宽，默认1
    //fontSize：字体，默认15
    //color：颜色，默认#000000
    //paperHeight:不为空，则根据传入的高度自动换页
    //colNum:列数，默认单列1，多列传列数
    //colDirection:多列的时候的列方向，默认0平均分配，否则为大于0的数，左边打满该数从左往右填
    //返回最大Y坐标
    AddGrid: function (datas, cols, colRates, colAligns, width, left, top, isDrawBorder, borderWidth, rowHeight, lineWidth, fontSize, color, paperHeight, colNum, colDirection, drawHLine) {
        var retMaxY = top;
        //有数据画表格
        if (datas != null && datas.length > 0) {
            //有列开始绘制
            if (cols != null && cols.length > 0) {
                //处理比例数据
                if (colRates == null) {
                    colRates = [];
                }
                //处理停靠
                if (colAligns == null) {
                    colAligns = [];
                }
                //默认宽度
                if (width == null) {
                    width = 800;
                }
                //默认左边
                if (left == null) {
                    left = 0;
                }
                //默认顶部
                if (top == null) {
                    top = 0;
                }
                //默认画边框
                if (isDrawBorder == null) {
                    isDrawBorder = true;
                }
                //默认宽度
                if (borderWidth == null) {
                    borderWidth = 1;
                }
                //默认行高
                if (rowHeight == null) {
                    rowHeight = 25;
                }
                else {
                    rowHeight = parseInt(rowHeight);
                }
                //线宽
                if (lineWidth == null) {
                    lineWidth = 1;
                }
                //默认字体大小
                if (fontSize == null) {
                    fontSize = 15;
                }
                if (color == null) {
                    color = "#000000";
                }
                //列数
                if (colNum == null) {
                    colNum = 1;
                }
                else {
                    colNum = parseInt(colNum);
                }
                //列方向
                if (colDirection == null) {
                    colDirection = 0;
                }
                else {
                    colDirection = parseInt(colDirection);
                }
                //处理多列数据
                if (colNum > 1) {
                    //处理左一个右一个数据
                    if (colDirection == 0) {
                        var tmpData = [];
                        for (var i = 0; i < datas.length + colNum; i += colNum) {
                            var rowData = {};
                            var hasAddData = false;
                            for (var j = 0; j < colNum; j++) {
                                if (i + j < datas.length) {
                                    for (var c in datas[i + j]) {
                                        rowData[c + "^" + j] = datas[i + j][c];
                                        hasAddData = true;
                                    }
                                }
                            }
                            if (hasAddData == true) {
                                tmpData.push(rowData);
                            }
                        }
                        datas = tmpData;
                    }
                    //处理从左向右填充数据
                    else if (colDirection > 0) {
                        var tmpData = [];
                        var curColNum = 0;
                        for (var i = 0; i < datas.length + colDirection; i += colDirection) {
                            for (var j = 0; j < colDirection; j++) {
                                //创建一行数据
                                if (tmpData[j] == null) {
                                    tmpData[j] = {};
                                }
                                if (i + j < datas.length) {
                                    for (var c in datas[i + j]) {
                                        tmpData[j][c + "^" + curColNum] = datas[i + j][c];
                                    }
                                }
                            }
                            curColNum++;
                        }
                        datas = tmpData;
                    }
                    var tmpcols = [];
                    var tmpcolRates = [];
                    var tmpcolAligns = [];
                    //处理列名等参数
                    for (var i = 0; i < colNum; i++) {
                        for (var j = 0; j < cols.length; j++) {
                            tmpcols.push(cols[j] + "^" + i);
                            tmpcolRates.push(colRates[j]);
                            tmpcolAligns.push(colAligns[j]);
                        }
                    }
                    cols = tmpcols;
                    colRates = tmpcolRates;
                    colAligns = tmpcolAligns;
                }
                var curY = top;
                //上横线
                PrintWidget.AddLine(left, top, left + width, top, lineWidth, "", "#000000");
                //存x坐标
                var xArr = [];
                //遍历绘制数据
                for (var i = 0; i < datas.length; i++) {
                    //存一行开始元素的索引
                    var startRowIndex = printWidget.length;
                    var curX = left;
                    var useRate = 0;
                    //记录最大的换行y
                    maxDataChangeY = curY;
                    //遍历画列
                    for (var j = 0; j < cols.length; j++) {
                        var align = "left";
                        if (j < colAligns.length) {
                            align = colAligns[j];
                        }
                        var rate = 1.0 / cols.length;
                        if (j >= colRates.length) {
                            rate = (1 - useRate) / (cols.length - j);
                        }
                        else {
                            rate = colRates[j] / 100;
                        }
                        var curColWidth = width * rate / colNum;
                        var printText = datas[i][cols[j]];
                        if (printText == null) {
                            printText = "";
                        }
                        printText = printText.toString();
                        var drawX = curX;
                        if (align == "left") {
                            drawX = curX;
                        }
                        else if (align == "right") {
                            drawX = curX + curColWidth;
                        }
                        else {
                            drawX = curX + curColWidth / 2;
                        }
                        //存中间串
                        var tmpValueStr = "";
                        var tmpStrWidth = 0;
                        var tmpChangeRowIndex = 0;
                        for (var k = 0; k < printText.length; k++) {
                            //得到一个字符的宽度
                            var charWidth = GetCharWidth(fontSize, printText[k]);
                            tmpStrWidth += charWidth;
                            //超出行了就画,或者^换行                               
                            if (tmpStrWidth > curColWidth || printText[k] == "^") {
                                if (printText[k] == "^") {
                                    k++;
                                }
                                PrintWidget.AddText(drawX, curY + tmpChangeRowIndex * rowHeight, tmpValueStr, align, color, "宋体", fontSize, "bold", "10", "", "", "", "");
                                if (maxDataChangeY < curY + tmpChangeRowIndex * rowHeight) {
                                    maxDataChangeY = curY + tmpChangeRowIndex * rowHeight;
                                }
                                tmpValueStr = "";
                                tmpStrWidth = charWidth;
                                tmpChangeRowIndex++;
                            }
                            tmpValueStr += printText[k];
                        }
                        if (tmpValueStr != "" && tmpValueStr != " ") {
                            //文本
                            PrintWidget.AddText(drawX, curY + tmpChangeRowIndex * rowHeight, tmpValueStr, align, color, "宋体", fontSize, "bold", "10", "", "", "", "");
                            if (maxDataChangeY < curY + tmpChangeRowIndex * rowHeight) {
                                maxDataChangeY = curY + tmpChangeRowIndex * rowHeight;
                            }
                        }
                        //第1行才存x坐标，解决四舍五入引起的竖线抖动
                        if (i == 0) {
                            xArr.push(parseInt(curX));
                        }
                        curX += curColWidth;
                        useRate += rate;
                    }
                    //第1行才存x坐标，解决四舍五入引起的竖线抖动
                    if (i == 0) {
                        xArr.push(parseInt(curX));
                    }

                    //所有列画完才知道最高行高
                    for (var j = 0; j < xArr.length; j++) {
                        if (j == xArr.length - 1) {
                            //画右竖线
                            PrintWidget.AddLine(left + width, curY, left + width, maxDataChangeY + rowHeight, lineWidth, "", "#000000");
                        }
                        else {
                            if (drawHLine != false) {
                                //画右竖线
                                PrintWidget.AddLine(xArr[j], curY, xArr[j], maxDataChangeY + rowHeight, lineWidth, "", "#000000");
                            }
                        }
                    }
                    //画左竖线
                    PrintWidget.AddLine(left, curY, left, maxDataChangeY + rowHeight, lineWidth, "", "#000000");

                    //画下横线
                    PrintWidget.AddLine(left, maxDataChangeY + rowHeight, left + width, maxDataChangeY + rowHeight, lineWidth, "", "#000000");
                    //有纸张高度，按高度换行
                    if (paperHeight != null) {
                        if (maxDataChangeY + rowHeight > paperHeight) {
                            var pageAddYY = 10;
                            //页重复标签实现
                            if (printWidgetAllPage != null && printWidgetAllPage.length > 0) {
                                pageAddYY = 40;
                            }
                            maxDataChangeY = rowHeight + pageAddYY;
                            for (var k = startRowIndex; k < printWidget.length; k++) {
                                printWidget[k].PrintY = printWidget[k].PrintY - curY + pageAddYY;
                                if (maxDataChangeY < printWidget[k].PrintY) {
                                    maxDataChangeY = printWidget[k].PrintY;
                                }
                                if (printWidget[k].PrintType == "ILineN") {
                                    printWidget[k].PrintHeight = printWidget[k].PrintHeight - curY + pageAddYY;
                                    if (maxDataChangeY < printWidget[k].PrintHeight) {
                                        maxDataChangeY = printWidget[k].PrintHeight;
                                    }
                                }
                            }
                            //页重复标签实现
                            if (printWidgetAllPage != null && printWidgetAllPage.length > 0) {
                                for (var zr = 0; zr < printWidgetAllPage.length; zr++) {
                                    printWidget.splice(startRowIndex + zr + 1, 0, printWidgetAllPage[zr]);
                                }
                            }
                            printWidget.splice(startRowIndex, 0, { PrintType: "PAGE", PrintX: 1, PrintY: 1, PrintFont: "宋体", PrintFontSize: "1", PrintFontStyle: "", PrintLength: "1", PrintWidth: "1", PrintHeight: "1", PrintText: "", DataField: "", PrintFlag: "", PrintAlignment: "left", PrintImageFile: "", PrintColor: "#00000" });
                            printWidget.splice(startRowIndex + 1, 0, { PrintType: "ILineN", PrintX: left, PrintY: pageAddYY, PrintFont: "宋体", PrintFontSize: "1", PrintFontStyle: "", PrintLength: lineWidth, PrintWidth: left + width, PrintHeight: pageAddYY, PrintText: "", DataField: "", PrintFlag: "o", PrintAlignment: "", PrintImageFile: "", PrintColor: "#000000" });
                            maxDataChangeY -= rowHeight;
                        }
                    }
                    curY = maxDataChangeY + rowHeight;
                    retMaxY = curY;
                }
            }
        }
        return retMaxY;
    },
    //添加文本
    AddText: function (PrintX, PrintY, PrintText, PrintAlignment, PrintColor, PrintFont, PrintFontSize, PrintFontStyle, PrintLength, PrintWidth, PrintHeight, Angle, IsVShow, PageRepeat) {
        if (Angle == null) {
            Angle = "";
        }
        if (IsVShow == null) {
            IsVShow = "";
        }
        if (PrintFont == null) {
            PrintFont = "宋体";
        }
        if (PrintLength == null) {
            PrintLength = "";
        }
        if (PrintHeight == null || PrintHeight == "") {
            PrintHeight = "20";
        }
        if (PrintWidth == null || PrintWidth == "") {
            PrintWidth = "1";
        }
        if (PrintFontSize != null && PrintFontSize != "") {
            //字符串类型的处理
            if (typeof (PrintFontSize) == "string") {
                PrintFontSize = PrintFontSize.replace("px", "");
            }
        }
        else {
            PrintFontSize = "9";
        }
        if (PrintAlignment == "left") {
            PrintAlignment = "Justified";
        }
        else if (PrintAlignment == "center") {
            PrintAlignment = "Center";
        }
        else if (PrintAlignment == "right") {
            PrintAlignment = "Right";
        }
        else {
            PrintAlignment = "Default";
        }
        if (PrintColor == null || PrintColor == "") {
            PrintColor = "#000000";
        }
        printWidget.push({ PrintType: "Label", PrintX: PrintX, PrintY: PrintY, PrintFont: PrintFont, PrintFontSize: PrintFontSize, PrintFontStyle: PrintFontStyle, PrintLength: PrintLength, PrintWidth: PrintWidth, PrintHeight: PrintHeight, PrintText: PrintText, DataField: "", PrintFlag: "", PrintAlignment: PrintAlignment, PrintImageFile: "", PrintColor: PrintColor, Angle: Angle, IsVShow: IsVShow });
        if (PageRepeat == true) {
            printWidgetAllPage.push({ PrintType: "Label", PrintX: PrintX, PrintY: PrintY, PrintFont: PrintFont, PrintFontSize: PrintFontSize, PrintFontStyle: PrintFontStyle, PrintLength: PrintLength, PrintWidth: PrintWidth, PrintHeight: PrintHeight, PrintText: PrintText, DataField: "", PrintFlag: "", PrintAlignment: PrintAlignment, PrintImageFile: "", PrintColor: PrintColor, Angle: Angle, IsVShow: IsVShow });
        }
    },
    //添加线
    AddLine: function (StartX, StartY, EndX, EndY, LineSize, LineType, PrintColor) {
        if (LineSize == null) {
            LineSize = 2;
        }
        if (LineType == null) {
            LineType = "o";
        }
        //线宽为0就不画线
        if (LineSize == "0") {
            return;
        }
        printWidget.push({ PrintType: "ILineN", PrintX: StartX, PrintY: StartY, PrintFont: "宋体", PrintFontSize: "1", PrintFontStyle: "", PrintLength: LineSize, PrintWidth: EndX, PrintHeight: EndY, PrintText: "", DataField: "", PrintFlag: LineType, PrintAlignment: "", PrintImageFile: "", PrintColor: PrintColor });
    },
    //添加点
    AddPoint: function (PrintX, PrintY, Size, PointType, PrintColor) {
        if (PointType == null) {
            PointType = "o";
        }
        if (Size == null) {
            Size = 1;
        }
        printWidget.push({ PrintType: "Point", PrintX: PrintX, PrintY: PrintY, PrintFont: "宋体", PrintFontSize: "1", PrintFontStyle: "", PrintLength: "1", PrintWidth: Size, PrintHeight: Size, PrintText: "", DataField: "", PrintFlag: PointType, PrintAlignment: "left", PrintImageFile: "", PrintColor: PrintColor });
    },
    //添加多边形
    AddPoly: function (PointArr, FillColor) {
        var polyPrintText = "";
        for (var i = 0; i < PointArr.length; i++) {
            if (polyPrintText == "") {
                polyPrintText += PointArr[i][0] + "@" + PointArr[i][1];
            }
            else {
                polyPrintText += "^" + PointArr[i][0] + "@" + PointArr[i][1];
            }
        }
        printWidget.push({ PrintType: "Poly", PrintX: 1, PrintY: 1, PrintFont: "宋体", PrintFontSize: "1", PrintFontStyle: "", PrintLength: "", PrintWidth: "1", PrintHeight: "1", PrintText: polyPrintText, DataField: "", PrintFlag: "", PrintAlignment: "left", PrintImageFile: "", PrintColor: FillColor });
    },
    //添加图片
    AddPic: function (PrintX, PrintY, PrintWidth, PrintHeight, Data, PrintFlag) {
        printWidget.push({ PrintType: "Graph", PrintX: PrintX, PrintY: PrintY, PrintFont: "宋体", PrintFontSize: "1", PrintFontStyle: "", PrintLength: "", PrintWidth: PrintWidth, PrintHeight: PrintHeight, PrintText: "", DataField: Data, PrintFlag: PrintFlag, PrintAlignment: "left", PrintImageFile: "", PrintColor: "" });
    },
    //换页
    ChangePage: function () {
        printWidget.push({ PrintType: "PAGE", PrintX: 1, PrintY: 1, PrintFont: "宋体", PrintFontSize: "1", PrintFontStyle: "", PrintLength: "1", PrintWidth: "1", PrintHeight: "1", PrintText: "", DataField: "", PrintFlag: "", PrintAlignment: "left", PrintImageFile: "", PrintColor: "#00000" });
    },
    //设置纸张高度，如果按数学坐标系绘制的需要用这个高度换算Y坐标
    SetPaperHeight: function (Height) {
        if (Height == null) {
            Height = 1024;
        }
        printPaperHeightWidget = Height;
    },
    //根据纸张高度处理分页
    //paperHeight:纸张高度
    DealPage: function (paperHeight) {
        for (var i = 0; i < printWidget.length; i++) {
            var aMaxY = printWidget[i].PrintY;
            if (printWidget[i].PrintType == "ILineN") {
                if (aMaxY < printWidget[i].PrintHeight) {
                    aMaxY = printWidget[i].PrintHeight;
                }
            }
            else if (printWidget[i].PrintType == "Poly") {
                var polyStr = "";
                var strArr = printWidget[i].PrintText.split("^");
                if (strArr != null && strArr.length > 0) {
                    for (var j = 0; j < strArr.length; j++) {
                        var strArr1 = strArr[j].split("@");
                        if (aMaxY < parseFloat(strArr1[1])) {
                            aMaxY = parseFloat(strArr1[1]);
                        }
                    }
                }
            }
            printWidget[i].MaxY = aMaxY;
        }
        var ztmpprintWidget = [];
        var paperIndex = 1;
        for (var i = 0; i < printWidget.length; i++) {
            if (printWidget[i].PrintType == "PRINTER") {
                ztmpprintWidget.push(printWidget[i]);
                continue;
            }
            if (printWidget[i].MaxY / (printPaperHeightWidget) > paperIndex) {
                ztmpprintWidget.push({ PrintType: "PAGE", PrintX: 1, PrintY: 1, PrintFont: "宋体", PrintFontSize: "1", PrintFontStyle: "", PrintLength: "", PrintWidth: "1", PrintHeight: "1", PrintText: "", DataField: "", PrintFlag: "", PrintAlignment: "left", PrintImageFile: "", PrintColor: "#00000" });
                paperIndex++;
            }
            printWidget[i].PrintY = printWidget[i].PrintY - (paperIndex - 1) * (printPaperHeightWidget);
            if (printWidget[i].PrintType == "ILineN") {
                printWidget[i].PrintHeight = printWidget[i].PrintHeight - (paperIndex - 1) * (printPaperHeightWidget);
            }
            if (printWidget[i].PrintType == "Poly") {
                var polyStr = "";
                var strArr = printWidget[i].PrintText.split("^");
                if (strArr != null && strArr.length > 0) {
                    for (var j = 0; j < strArr.length; j++) {
                        var strArr1 = strArr[j].split("@");
                        if (polyStr == "") {
                            polyStr += strArr1[0] + "@" + (strArr1[1] - (paperIndex - 1) * (printPaperHeightWidget));
                        }
                        else {
                            polyStr += "^" + strArr1[0] + "@" + (strArr1[1] - (paperIndex - 1) * (printPaperHeightWidget));
                        }
                    }
                }
                printWidget[i].PrintText = polyStr;
            }
            ztmpprintWidget.push(printWidget[i]);
        }
        printWidget = ztmpprintWidget;
    },
    //坐标转换
    //noTransY:是否转换y坐标
    CoordinateTrans: function (noTransY) {
        for (var i = 0; i < printWidget.length; i++) {
            if (printWidget[i].PrintType == "PRINTER") {
                continue;
            }
            if (printWidget[i].PrintFont == null) {
                printWidget[i].PrintFont = "宋体";
            }
            if (printWidget[i].PrintLength == null) {
                printWidget[i].PrintLength = "";
            }
            //处理成字符串
            printWidget[i].PrintLength += "";
            if (printWidget[i].DataField == null) {
                printWidget[i].DataField = "";
            }
            if (printWidget[i].PrintHeight == null || printWidget[i].PrintHeight == "") {
                printWidget[i].PrintHeight = "20";
            }
            //处理成数字
            printWidget[i].PrintHeight = parseFloat(printWidget[i].PrintHeight);
            if (printWidget[i].PrintWidth == null || printWidget[i].PrintWidth == "") {
                printWidget[i].PrintWidth = "1";
            }
            //处理成数字
            printWidget[i].PrintWidth = parseFloat(printWidget[i].PrintWidth);
            //处理成字符串
            printWidget[i].PrintFlag += "";
            if (printWidget[i].PrintFontSize != null && printWidget[i].PrintFontSize != "") {
                //字符串类型的处理
                if (typeof (printWidget[i].PrintFontSize) == "string") {
                    printWidget[i].PrintFontSize = printWidget[i].PrintFontSize.replace("px", "");
                }
            }
            else {
                printWidget[i].PrintFontSize = "9";
            }
            if (printWidget[i].PrintAlignment.toLowerCase() == "left" || printWidget[i].PrintAlignment == "Justified") {
                printWidget[i].PrintAlignment = "Justified";
            }
            else if (printWidget[i].PrintAlignment.toLowerCase() == "center" || printWidget[i].PrintAlignment == "Center") {
                printWidget[i].PrintAlignment = "Center";
            }
            else if (printWidget[i].PrintAlignment.toLowerCase() == "right" || printWidget[i].PrintAlignment == "Right") {
                printWidget[i].PrintAlignment = "Right";
            }
            else {
                printWidget[i].PrintAlignment = "Default";
            }
            if (noTransY != true) {
                //坐标换算
                printWidget[i].PrintY = (printPaperHeightWidget - printWidget[i].PrintY) * 0.95;
                if (printWidget[i].PrintType == "ILineN") {
                    printWidget[i].PrintHeight = (printPaperHeightWidget - printWidget[i].PrintHeight) * 0.95;
                }
                if (printWidget[i].PrintType == "Poly") {
                    var polyStr = "";
                    var strArr = printWidget[i].PrintText.split("^");
                    if (strArr != null && strArr.length > 0) {
                        for (var j = 0; j < strArr.length; j++) {
                            var strArr1 = strArr[j].split("@");
                            if (polyStr == "") {
                                polyStr += strArr1[0] + "@" + (printPaperHeightWidget - strArr1[1]) * 0.95;
                            }
                            else {
                                polyStr += "^" + strArr1[0] + "@" + (printPaperHeightWidget - strArr1[1]) * 0.95;
                            }
                        }
                    }
                    printWidget[i].PrintText = polyStr;
                }
            }
        }
    }
}

//根据字体大小得到一个字符的宽度
function GetCharWidth(fontSize, char) {
    var modulus = 1.48;
    //除数
    var num = 2;
    if (/^[\u4e00-\u9fa5]+$/.test(char)) {
        num = 1;
    }
    if (fontSize == null && fontSize == "") {
        return 15 / num * modulus;
    }
    //字符串类型的处理
    if (typeof (fontSize) == "string") {
        fontSize = fontSize.replace("px", "");
    }
    if (fontSize == 16) {
        modulus = 1.475;
    }
    else if (fontSize == 14) {
        modulus = 1.461;
    }
    else if (fontSize == 13) {
        modulus = 1.46;
    }
    else if (fontSize == 12) {
        modulus = 1.444;
    }
    else if (fontSize == 11) {
        modulus = 1.43;
    }
    else if (fontSize == 10) {
        modulus = 1.429;
    }
    else if (fontSize == 9) {
        modulus = 1.42;
    }
    return fontSize / num * modulus;
}

//http请求根地址
var WEBSYSHTTPSERVERURL = "http://localhost:11996/websys/";
var myXmlHttp = null, debuggerflag = false, isUseGetMethod = false, isMozilla = false;
//ajax
function websysAjax(bizUrl, data, async) {
    var url = WEBSYSHTTPSERVERURL + bizUrl;
    var cspXMLHttp = null;
    data.push({ "notReturn": "1" });
    if (window.XMLHttpRequest) {
        isMozilla = true;
        cspXMLHttp = new XMLHttpRequest();
    }
    else if (window.ActiveXObject) {
        isMozilla = false;
        try
        {
            cspXMLHttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch (e)
        {
            try
            {
                cspXMLHttp = new ActiveXObject("Msxml2.XMLHTTP");
            }
            catch (E) {
                //失败后尝试监听
                LISBasePrint(LISSYSPrintParam);
                cspXMLHttp = null;
            }
        }
    }
    var req = cspXMLHttp;
    req.onreadystatechange = invkProcessReq;
    var dataArr = [],
        dataStr = data;
    if ("object" == typeof data) {
        if (data.slice) {
            for (var i = 0; i < data.length; i++) {
                for (var j in data[i]) {
                    dataArr.push(j + "=" + encodeURIComponent(data[i][j]));
                }
            }
        }
        else
        {
            for (var k in data) {
                dataArr.push(k + "=" + encodeURIComponent(data[k]));
            }
        }
        dataStr = dataArr.join("&");
    }
    if (isUseGetMethod)
    {
        req.open("GET", url + "?" + dataStr, async);
        if (isMozilla)
        {
            req.send(null);
        }
        else
        {
            req.send();
        }
    }
    else
    {
        req.open("POST", url, async);
        req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        try
        {
            req.send(dataStr);
        }
        catch (e)
        {
            //失败后尝试监听
            LISBasePrint(LISSYSPrintParam);
            return invkProcessResponse(e);
        }
    }
    return invkProcessResponse(req);
}
function invkProcessResponse(req) {
    if (debuggerflag) {
        debugger;
    }
    if ("undefined" == typeof req.status) {
        var err = req.name + '(' + req.message + ')'; /*alert(err);*/
        return {
            "msg": err, "status": 404, "rtn": null
        };
    }
    if (req.status != 200) {
        var err = req.statusText + ' (' + req.status + ')';
        return { "msg": err, "status": req.status, "rtn": null };
    }
    var result = req.responseText;
    return result;
}
function invkProcessReq(req) { }
function invokeDll(mode, ass, cls, q, callback)
{
    return websysAjax(ass + '/' + cls, q, false);
};

function ICls()
{
    this.data = [];
    this.mode = 0;
    this.ass = "";
    this.cls = "";
}
ICls.prototype.constructor = ICls;
ICls.prototype.invk = function (c)
{
    var rtn = invokeDll(this.mode, this.ass, this.cls, this.data, c);
    return rtn;
};
ICls.prototype.clear = function ()
{
    this.data.length = 2;
    return this;
};
ICls.prototype.prop = function (k, v) {
    var o = {};
    o[k] = v;
    this.data.push(o);
    return this;
};
ICls.prototype.getMthParam = function (arg)
{
    if (!arg.length) {
        return "";
    } 
    var param = "";
    if (arg.length > 0)
    {
        param = "P_COUNT=" + arg.length;
        for (var i = 0; i < arg.length; i++)
        {
            param += "&P_" + i + "=" + encodeURIComponent(arg[i]);
        }
    }
    return param;
};
ICls.AssDirList = [];
/*检验打印*/
ICls.LISPrint = function () {
    var curPageUrl = window.document.location.href;
    var thisfun = this;
    if (LISSYSPrintWebServicAddress == "") {
        //没传地址的查询获取
        $.ajaxRunServerMethod({ ClassName: "DHCLIS.DHCOrderList", MethodName: "GetConnectString", ID: "1", async: false },
            function (rtn) {
                if (rtn != "") {
                    LISSYSPrintWebServicAddress = rtn;
                    curPageUrl = LISSYSPrintWebServicAddress;
                    var indexSP = rtn.indexOf("$LIS.SP$");
                    var onePara = rtn;
                    var towPara = "";
                    if (indexSP > 0) {
                        onePara = rtn.substring(0, indexSP);
                        //加密串
                        towPara = rtn.substring(indexSP + 8);
                    }
                    if (towPara != "") {
                        LISSYSPrintWebServicAddress = towPara;
                    }
                    var rootPath = curPageUrl.split("//")[0] + "//" + curPageUrl.split("//")[1].split("/")[0];
                    if (curPageUrl.toLowerCase().indexOf("/imedicallis") > -1) {
                        rootPath = rootPath + "/" + curPageUrl.split("//")[1].split("/")[1];
                    }
                    else if (curPageUrl.toLowerCase().indexOf("/imedical") > -1) {
                        rootPath = rootPath + "/" + curPageUrl.split("//")[1].split("/")[1]+"lis";
                    }
                    var defaultDllDir = rootPath + "/lisprint/addins/plugin";
                    thisfun.ass = "DHCLabtrakReportPrint.dll"; thisfun.cls = "DHCLabtrakReportPrint.DHCLabtrakReportPrint"; thisfun.data.push({ "_dllDir": defaultDllDir + "/DHCLabtrakReportPrint.dll,lisprint.zip" }); thisfun.data.push({ "_version": "LISPrint13" }); 
                    thisfun.PrintOut = function () { thisfun.clear(); thisfun.data.push({ "M_PrintOut": thisfun.getMthParam(arguments) }); return thisfun.invk(); }
                    thisfun.PrintPreview = function () { thisfun.clear(); thisfun.data.push({ "M_PrintPreview": thisfun.getMthParam(arguments) }); return thisfun.invk(); }
                    thisfun.JsPrint = function () { thisfun.clear(); thisfun.data.push({ "M_JsPrint": thisfun.getMthParam(arguments) }); return thisfun.invk(); }
                }
            });
    }
    else {
        var rootPath = curPageUrl.split("//")[0] + "//" + curPageUrl.split("//")[1].split("/")[0];
        if (curPageUrl.toLowerCase().indexOf("/imedicallis") > -1) {
            rootPath = rootPath + "/" + curPageUrl.split("//")[1].split("/")[1];
        }
        else if (curPageUrl.toLowerCase().indexOf("/imedical") > -1) {
            rootPath = rootPath + "/" + curPageUrl.split("//")[1].split("/")[1] + "lis";
        }
        var defaultDllDir = rootPath + "/lisprint/addins/plugin";
        thisfun.ass = "DHCLabtrakReportPrint.dll"; thisfun.cls = "DHCLabtrakReportPrint.DHCLabtrakReportPrint"; thisfun.data.push({ "_dllDir": defaultDllDir + "/DHCLabtrakReportPrint.dll,lisprint.zip" }); thisfun.data.push({ "_version": "LISPrint13" }); 
        thisfun.PrintOut = function () { thisfun.clear(); thisfun.data.push({ "M_PrintOut": thisfun.getMthParam(arguments) }); return thisfun.invk(); }
        thisfun.PrintPreview = function () { thisfun.clear(); thisfun.data.push({ "M_PrintPreview": thisfun.getMthParam(arguments) }); return thisfun.invk(); }
        thisfun.JsPrint = function () { thisfun.clear(); thisfun.data.push({ "M_JsPrint": thisfun.getMthParam(arguments) }); return thisfun.invk(); }
    }
}
ICls.LISPrint.prototype = new ICls();
ICls.LISPrint.prototype.constructor = ICls.LISPrint;
var LISPrint = new ICls.LISPrint();


//检验基础打印,调插件的统一入口
function LISBasePrint(para) {
    var paraArr = para.split("@");
    var paratmp = "";
    for (var i = 0; i < paraArr.length; i++) {
        if (i == 0) {
            paratmp = paraArr[i];
        }
        else {
            if (i == 1 && paraArr[1]=="") {
                paratmp = paratmp + "@" + LISSYSPrintWebServicAddress;
            }
            else {
                paratmp = paratmp + "@" + paraArr[i];
            }
            
        }
    }
    para = paratmp;
    if (para.length > 500 || (para.indexOf('"') > -1)) {
        //往后台提交数据
        $.ajax({
            type: "post",
            dataType: "text",
            cache: false, //
            async: false, //为true时，异步，不等待后台返回值，为false时强制等待；-asir
            url: '../../lisprint/ashx/ashLisPrintDesigner.ashx?Method=SavePTTMPPara',
            data: para,
            success: function (result, status) {
                if (result != "-1") {
                    LisBaseMsg.Subscribe("print#iMedicalLIS://DOWNLOADDATA@" + result, null, function () {
                        try {
                            localStorage["iMedicalLISPrintExtend"] = "";
                            var evt = document.createEvent("CustomEvent");
                            evt.initCustomEvent('myCustomEvent', true, false, para);
                            // fire the event
                            document.dispatchEvent(evt);
                            if (localStorage["iMedicalLISPrintExtend"] == undefined || localStorage["iMedicalLISPrintExtend"] == null || localStorage["iMedicalLISPrintExtend"] == "") {
                                throw new Error("未能驱动插件LIS谷歌打印插件！");
                            }
                        }
                        catch (e) {
                            if (localStorage["iMedicalLISPrintExtendFlag"] == "2") {
                                var iframeName = "zPrintIframe" + zPrintIframeIndex;
                                zPrintIframeIndex++;
                                //添加一个弹窗依托的div，作为弹出消息框
                                $(document.body).append('<iframe id="' + iframeName + '" src="' + "iMedicalLIS://DOWNLOADDATA@" + result + '" style="display:none;"><iframe>');
                                setTimeout(function () {
                                    $("#" + iframeName).remove();
                                }, 1500);
                            }
                            else {
                                var win = window.open("iMedicalLIS://DOWNLOADDATA@" + result, "打印等待", "height=750,width=650,top=10,left=10,titlebar =no,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no, status=no,alwaysLowered=no");
                                if (localStorage["iMedicalLISPrintExtendFlag"] == "" || isNaN(localStorage["iMedicalLISPrintExtendFlag"])) {
                                    //调用标识
                                    localStorage["iMedicalLISPrintExtendFlag"] = "1";
                                }
                                else {
                                    //调用标识
                                    localStorage["iMedicalLISPrintExtendFlag"] = parseInt(localStorage["iMedicalLISPrintExtendFlag"]) + 1;
                                }
                            }
                        }
                    }, true,true);
                }
            }
        });
    }
    else {
        LisBaseMsg.Subscribe("print#iMedicalLIS://" + para, null, function () {
            try {
                localStorage["iMedicalLISPrintExtend"] = ""
                var evt = document.createEvent("CustomEvent");
                evt.initCustomEvent('myCustomEvent', true, false, para);
                // fire the event
                document.dispatchEvent(evt);
                if (localStorage["iMedicalLISPrintExtend"] == undefined || localStorage["iMedicalLISPrintExtend"] == null || localStorage["iMedicalLISPrintExtend"] == "") {
                    throw new Error("未能驱动插件LIS谷歌打印插件！");
                }
            }
            catch (e) {
                if (localStorage["iMedicalLISPrintExtendFlag"] == "3") {
                    var iframeName = "zPrintIframe" + zPrintIframeIndex;
                    zPrintIframeIndex++;
                    //添加一个弹窗依托的div，作为弹出消息框
                    $(document.body).append('<iframe id="' + iframeName + '" src="' + "iMedicalLIS://" + para + '" style="display:none;"><iframe>');
                    setTimeout(function () {
                        $("#" + iframeName).remove();
                    }, 1500);
                }
                else {
                    var win = window.open("iMedicalLIS://" + para, "打印等待", "height=750,width=650,top=10,left=10,titlebar =no,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no, status=no,alwaysLowered=no");
                    if (localStorage["iMedicalLISPrintExtendFlag"] == "" || isNaN(localStorage["iMedicalLISPrintExtendFlag"])) {
                        //调用标识
                        localStorage["iMedicalLISPrintExtendFlag"] = "1";
                    }
                    else {
                        //调用标识
                        localStorage["iMedicalLISPrintExtendFlag"] = parseInt(localStorage["iMedicalLISPrintExtendFlag"]) + 1;
                    }
                }
            }
        }, true, true);
    }
}


var LisBaseMsg = {
    wsImpl: window.WebSocket || window.MozWebSocket,
    //标志用户是否登陆
    isuserlogined: false,
    //暂存回调和消息类型的对象
    callBackMsgTypeObj: {},
    //记录回复
    reply: null,
    ws: null,
    //消息是否能使用
    CanUse: false,
    //连接失败回调
    noConnCallBack: null,
    //调用失败回调后是否清除回调
    clearnoConnCallBack: false,
    //端口
    port: localStorage["CanUserMsgPort"],
    portIndex: 0,
    portList: ["8082", "10210", "19910", "19902"],
    tryNum: 0,
    state: false,
    //订阅一个消息
    //msg:订阅后要发送的消息
    //callBack:回调方法，有一个消息参数
    //noConnCallBack:没连接成功回调
    //clearnoConnCallBack:调用失败回调后是否清除回调
    //isSend:是否主要发送数据，为true就不重复连接了，只连接一次
    Subscribe: function (msg, callBack, noConnCallBack, clearnoConnCallBack, isSend) {
        if (isSend == true && LisBaseMsg.ws != null && LisBaseMsg.state != false) {
            if (LisBaseMsg.state == false) {
                if (noConnCallBack != null) {
                    noConnCallBack();
                }
                return;
            }
            LisBaseMsg.Send(msg);
            return;
        }
        else if (isSend == true) {
            LisBaseMsg.port == ""
            LisBaseMsg.ws = null;
        }
        //默认8082端口
        if (LisBaseMsg.port == null || LisBaseMsg.port == "") {
            LisBaseMsg.port = "8082";
        }
        LisBaseMsg.noConnCallBack = noConnCallBack;
        LisBaseMsg.clearnoConnCallBack = clearnoConnCallBack;
        //有消息就不创建了
        if (LisBaseMsg.ws != null) {
            if (LisBaseMsg.state == false) {
                if (noConnCallBack != null) {
                    noConnCallBack();
                }
                return;
            }
            //有消息就发
            if (msg != null) {
                LisBaseMsg.Send(msg);
                if (LisBaseMsg.ws.readyState == "1") {
                    LisBaseMsg.state = true;
                    msg = null;
                    LisBaseMsg.noConnCallBack = null;
                    return;
                }
            }
        }
        LisBaseMsg.ws = new LisBaseMsg.wsImpl("ws://127.0.0.1:" + LisBaseMsg.port);
        // 收到消息
        LisBaseMsg.ws.onmessage = function (evt) {
            if (callBack != null) {
                //调用回调方法
                callBack(evt.data);
            }
            LisBaseMsg.CanUse = true;
        };
        // 连接上
        LisBaseMsg.ws.onopen = function () {
            LisBaseMsg.CanUse = true;
            localStorage["CanUserMsgPort"] = LisBaseMsg.port;
            //有消息就发
            if (msg != null) {
                LisBaseMsg.Send(msg);
                msg = null;
                if (LisBaseMsg.ws.readyState == "1") {
                    LisBaseMsg.state = true;
                    LisBaseMsg.noConnCallBack = null;
                }
            }
        };
        // 断开连接
        LisBaseMsg.ws.onclose = function (notconn) {
            LisBaseMsg.state = false;
            LisBaseMsg.ws = null;
            console.info("消息已断开连接，即将为您重连");
            if (LisBaseMsg.tryNum < 4 && LisBaseMsg.CanUse == false) {
                LisBaseMsg.portIndex++;
                LisBaseMsg.portIndex = LisBaseMsg.portIndex % 4;
                LisBaseMsg.port = LisBaseMsg.portList[LisBaseMsg.portIndex];
                LisBaseMsg.ws = null;
                LisBaseMsg.tryNum++;
                setTimeout(function () {
                    LisBaseMsg.Subscribe(msg, callBack, LisBaseMsg.noConnCallBack, LisBaseMsg.clearnoConnCallBack);
                }, 400);
                return;
            }
            msg = null;
            if (LisBaseMsg.noConnCallBack != null) {
                LisBaseMsg.noConnCallBack();
                if (LisBaseMsg.clearnoConnCallBack == true) {
                    LisBaseMsg.noConnCallBack = null;
                }
            }
            LisBaseMsg.CanUse = false;
            if (notconn != true) {
                setTimeout(function () {
                    LisBaseMsg.Subscribe(msg, callBack, LisBaseMsg.noConnCallBack, LisBaseMsg.clearnoConnCallBack);
                }, 10000);
            }
        }
        //发生了错误事件
        LisBaseMsg.ws.onerror = function () {
            console.info("发生了错误");
        }
        //连接服务失败
        if (LisBaseMsg.ws.readyState == "3") {
            if (LisBaseMsg.ws != null) {
                LisBaseMsg.ws.onclose(true);
            }
            LisBaseMsg.ws = null;
        }
    },
    //发送消息
    //msg:消息
    Send: function (msg) {
        if (LisBaseMsg.ws == null) {
            LisBaseMsg.ws = new LisBaseMsg.wsImpl("ws://127.0.0.1:8082");
            console.info("警告：没有订阅消息就发送消息");
        }
        if (LisBaseMsg.state == true) {
            LisBaseMsg.ws.send(msg);
        }
        else {
            LisBaseMsg.MsgQuen.push(msg);
            if (LisBaseMsg.QuenTime == null) {
                LisBaseMsg.QuenTime = window.setInterval(LisBaseMsg.QuenSend, 1000);
            }
        }

    },
    QuenTime: null,
    MsgQuen: [],
    QuenSend: function () {
        if (LisBaseMsg.state == true) {
            for (var mi = 0; mi < LisBaseMsg.MsgQuen.length; mi++) {
                if (LisBaseMsg.MsgQuen.length > 0) {
                    var msg = LisBaseMsg.MsgQuen.splice(0, 1);
                    LisBaseMsg.ws.send(msg);
                }
            }
            if (LisBaseMsg.MsgQuen.length == 0) {
                clearInterval(LisBaseMsg.QuenTime);
                LisBaseMsg.QuenTime = null;
            }
        }
    }

}