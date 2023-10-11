// lodop 报告打印公共js
// DHCPEPrintReportCommon.js

if (isIE()){
	document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js?needCLodop=1'></script>")
}else{
	document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js'></script>")
}

/*
 * lodop 打印通用方法
 * PrtType 打印类型   PrinterName 指定打印机   PrtFormat 打印格式
 */
function PEPrintReport(PrtType, PAADM, PrinterName, PrtFormat) {
	var LODOP = getLodop();
	
	var HadFormat = false;  // 是否有打印格式
	var NeedOthReport = false;  // 是否需要打印其他报告 pdf jpg 等
	var UpdRptStatus = true;  // 是否需要更新报告状态
	
	var ReportInfo = tkMakeServerCall("web.DHCPE.GetLodopPrintPath", "GetReportPrintInfo", PAADM, "PAADM", PrtFormat, "");
	var ReportArr = ReportInfo.split("^");
	var PrintURL = ReportArr[0];
	var Header = ReportArr[1];
	var Footer = ReportArr[2];
	var PrtName = ReportArr[3];
	var PrtFormat = ReportArr[4];
	if (PrtFormat == "" || PrtFormat == "undefined" || PrtFormat == undefined) PrtFormat = ReportArr[4];
	
	/// 在以下方法中调整打印样式
	switch (PrtFormat) {
		case "JKTJ":  // 健康体检
			LODOP = CreateJKTJPrintPage(LODOP, PAADM, PrinterName, Header, Footer);
			HadFormat = true;
			NeedOthReport = true;
			break;
			
		case "ZYJK":  // 职业健康
			LODOP = CreateZYJKPrintPage(LODOP, PAADM, PrinterName, Header, Footer);
			HadFormat = true;
			NeedOthReport = true;
			break;
			
		case "YGBG":  // 乙肝报告
			LODOP = CreateYGBGPrintPage(LODOP, PAADM, PrinterName, Header, Footer);
			HadFormat = true;
			break;
			
		case "TJDB":  // 对比报告
			LODOP = CreateTJDBPrintPage(LODOP, PAADM, PrinterName, Header, Footer);
			HadFormat = true;
			break;
			
		case "FCBG":  // 复查报告
			LODOP = CreateFCBGPrintPage(LODOP, PAADM, PrinterName, Header, Footer);
			HadFormat = true;
			break;
			
		case "PDF":  // PDF报告
			LODOP = CreatePDFPrintPage(LODOP, PAADM, PrinterName, Header, Footer, PrintURL);
			PrintURL = "";
			HadFormat = true;
			break;
			
		default:
    		break;
	}
	if (!HadFormat) {  // 未定义的报告格式
		$.messager.alert("提示", "未定义的报告格式", "info");
		return HadFormat;
	}
	PrtHtmlPage(LODOP, PrintURL, PAADM, PrtType, NeedOthReport, UpdRptStatus, PrinterName);
}

/*
 * lodop 获取打印格式的 html源码并调用打印    UpdRptStatus 是否更新报告状态
 */
function PrtHtmlPage(LODOP, PrintURL, PAADM, PrtType, NeedOthReport, UpdRptStatus, PrinterName) {
	var xmlHttp = createXmlHttp();
	xmlHttp.onreadystatechange = function(a,b) {
	    if (xmlHttp.readyState == 4) {
		    var HTMLCode = xmlHttp.responseText;
		    var OthReport = tkMakeServerCall("web.DHCPE.ReportShowOther","GetRptImgByPaadm",PAADM);
		    RealPrint(LODOP, HTMLCode, PrtType, OthReport, PrinterName,PAADM);
			if (UpdRptStatus) {
		    	if (PrtType == "P") {
					var ret = tkMakeServerCall("web.DHCPE.Report", "SetReportStatusByPAADM", PAADM, "P", session["LOGON.USERID"]);
				} else if (PrinterName != "") {
					var ret = tkMakeServerCall("web.DHCPE.Report", "SetReportStatusByPAADM", PAADM, "P", session["LOGON.USERID"]);
				}
			}
		}
	}
	xmlHttp.open("get", PEURLAddToken(PrintURL), true);
    xmlHttp.send(null);
}

/*
 * 实际打印方法
 * HTMLCode 页面源码   PrtType 打印类型   OthReport 其他报告   PrinterName 虚拟打印机
 */
function RealPrint(LODOP, HTMLCode, PrtType, OthReport, PrinterName,PAADM) {
	if (HTMLCode != "") {
		LODOP.ADD_PRINT_HTM("16mm", "0mm", "RightMargin:0mm", "BottomMargin:20mm", HTMLCode);
	}
	
	var rptUrlArr = eval('(' + OthReport + ')');
	if (rptUrlArr.length > 0) {
		LODOP.NEWPAGEA();
		for (i = 0; i < rptUrlArr.length; i++) {
			var rptUrlType = rptUrlArr[i].t;
			var rptUrl = rptUrlArr[i].v;
			if (rptUrlType == "IMG") {
				LODOP.ADD_PRINT_IMAGE("11mm", "10mm", "RightMargin:10mm","BottomMargin:15mm", rptUrl);
				LODOP.SET_PRINT_STYLEA(0,"Stretch",1);
			} else if (rptUrlType == "PDF") {
				LODOP.ADD_PRINT_PDF("12mm", "5mm", "90%", "100%", rptUrl);
				LODOP.SET_PRINT_STYLEA(0,"ScalX",0.9);
				LODOP.SET_PRINT_STYLEA(0,"ScalY",0.92);
				LODOP.SET_PRINT_STYLEA(0,"PDFScalMode",1);
				// LODOP.SET_PRINT_STYLEA(0,"Angle",90);  // 旋转90°
			} else if (rptUrlType == "HTML") {
				LODOP.ADD_PRINT_URL("11mm", "0mm", "RightMargin:0mm", "BottomMargin:15mm", rptUrl);
			}
			if (i < (rptUrlArr.length-1)) LODOP.NEWPAGEA ();
		}
	}
	
	if (PrtType == "V") {
		LODOP.PREVIEW();  // PRINT_DESIGN()
	} else if (PrtType == "P") {
		LODOP.PRINT();
	} else {
		if (PrinterName != "") {
			LODOP.PRINT();
		} else {
			LODOP.SET_SAVE_MODE("FILE_PROMPT",0);
			LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME", ".jpg");
			var ret = LODOP.SAVE_TO_FILE("D:\\DHCPE\\" + PAADM + ".jpg");
			if (ret) { //成功保存导出状态
				$.messager.alert("提示", "导出报告成功", "success");
			} else { //失败保存失败
				$.messager.alert("提示", "导出报告失败", "error");
			}
		}
	}
}

// 健康体检报告格式
function CreateJKTJPrintPage(LODOP, PAADM, PrinterName, Header, Footer) {
	LODOP.PRINT_INIT(PAADM + "体检报告");  //打印任务的名称
	//LODOP.PRINT_INITA(0,"0mm","RightMargin:0mm","BottomMargin:0mm",PAADM); 
	if (PrinterName != "") {  //指定打印机名称
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	
	//页脚的线
	LODOP.ADD_PRINT_LINE("283mm","10mm","283mm","RightMargin:10mm",0,1);  //画线  Top1,Left1, Top2, Left2,intLineStyle, intLineWidt
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"Horient",3);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");  //控制某一页不打印
	
	//LODOP.SET_PRINT_STYLEA(0,"PageIndex","3,Last-1");
	if (Header!=""){
		//LODOP.SET_PRINT_STYLEA(0,"PageIndex",2);  //第二页开始有页眉页脚
		
		LODOP.ADD_PRINT_HTML("4mm","11mm","RightMargin:11mm","10mm",Header);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);  //页眉页脚
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
		
		LODOP.ADD_PRINT_LINE("12.5mm","10mm","12.5mm","RightMargin:10mm",0,1);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Horient",3);  //居中
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	
	if (Footer!=""){
		LODOP.ADD_PRINT_HTM("284.5mm","11mm","RightMargin:11mm",22,Footer);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	LODOP.ADD_PRINT_TEXT("284.5mm","11mm","RightMargin:11mm",22,"第#页/共&页"); //Top,Left,Width,Height,strContent
	LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Alignment",3);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",3);  //从第3页开始计算页码
	
	return LODOP;
}

// 职业健康体检报告格式
function CreateZYJKPrintPage(LODOP, PAADM, PrinterName, Header, Footer) {
	LODOP.PRINT_INIT(PAADM + "职业健康体检报告");  //打印任务的名称
	//LODOP.PRINT_INITA(0,"0mm","RightMargin:0mm","BottomMargin:0mm",PAADM); 
	if (PrinterName != "") {  //指定打印机名称
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	
	//页脚的线
	LODOP.ADD_PRINT_LINE("283mm","10mm","283mm","RightMargin:10mm",0,1);  //画线  Top1,Left1, Top2, Left2,intLineStyle, intLineWidt
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"Horient",3);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");  //控制某一页不打印
	
	//LODOP.SET_PRINT_STYLEA(0,"PageIndex","3,Last-1");
	if (Header!=""){
		//LODOP.SET_PRINT_STYLEA(0,"PageIndex",2);  //第二页开始有页眉页脚
		
		LODOP.ADD_PRINT_HTML("4mm","11mm","RightMargin:11mm","10mm",Header);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);  //页眉页脚
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
		
		LODOP.ADD_PRINT_LINE("12.5mm","10mm","12.5mm","RightMargin:10mm",0,1);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Horient",3);  //居中
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	
	if (Footer!=""){
		LODOP.ADD_PRINT_HTM("284.5mm","11mm","RightMargin:11mm",22,Footer);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	LODOP.ADD_PRINT_TEXT("284.5mm","11mm","RightMargin:11mm",22,"第#页/共&页"); //Top,Left,Width,Height,strContent
	LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Alignment",3);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",3);  //从第3页开始计算页码
	
	return LODOP;
}

// 对比报告格式
function CreateTJDBPrintPage(LODOP, PAADM, PrinterName, Header, Footer) {
	LODOP.PRINT_INIT(PAADM+"对比报告");  //打印任务的名称
	//LODOP.PRINT_INITA(0,"0mm","RightMargin:0mm","BottomMargin:0mm",PAADM); 
	if (PrinterName!=""){  //指定打印机名称
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	//页脚的线
	LODOP.ADD_PRINT_LINE("436mm","15mm","436mm","RightMargin:15mm",2,2);  //画线  Top1,Left1, Top2, Left2,intLineStyle, intLineWidt
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"Horient",3);  
	LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");  //控制某一页不打印
	
	//LODOP.SET_PRINT_STYLEA(0,"PageIndex","3,Last-1");
	if (Header!=""){
		//LODOP.SET_PRINT_STYLEA(0,"PageIndex",2);  //第二页开始有页眉页脚
		
		LODOP.ADD_PRINT_LINE(53,"15mm",53,"RightMargin:15mm",2,2);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Horient",3);  //居中
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
		
		LODOP.ADD_PRINT_TEXT(21,"15mm","100%","RightMargin:15mm",Header+"\n");  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"FontSize",12);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);  //页眉页脚
	
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
		LODOP.SET_PRINT_STYLEA(0,"Horient",0);  //居左
	}
	
	if (Footer!=""){
		LODOP.ADD_PRINT_TEXT("438mm","15mm",344,22,Footer);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	LODOP.ADD_PRINT_TEXT("438mm",582,165,22,"第#页/共&页"); //Top,Left,Width,Height,strContent
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Horient",1);
	LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",3);  //从第二页开始计算页码
	return LODOP;
}

// 乙肝报告
function CreateYGBGPrintPage(LODOP, PAADM, PrinterName, Header, Footer){
	LODOP.PRINT_INIT(PAADM+"乙肝报告");  //打印任务的名称
	//LODOP.PRINT_INITA(0,"0mm","RightMargin:0mm","BottomMargin:0mm",PAADM); 
	if (PrinterName!=""){  //指定打印机名称
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	
	//页脚的线
	LODOP.ADD_PRINT_LINE("283mm","10mm","283mm","RightMargin:10mm",0,1);  //画线  Top1,Left1, Top2, Left2,intLineStyle, intLineWidt
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"Horient",3);
	//LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");  //控制某一页不打印
	
	//LODOP.SET_PRINT_STYLEA(0,"PageIndex","3,Last-1");
	if (Header!=""){
		//LODOP.SET_PRINT_STYLEA(0,"PageIndex",2);  //第二页开始有页眉页脚
		
		LODOP.ADD_PRINT_HTML("4mm","11mm","RightMargin:11mm","10mm",Header);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);  //页眉页脚
		//LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
		
		LODOP.ADD_PRINT_LINE("12.5mm","10mm","12.5mm","RightMargin:10mm",0,1);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Horient",3);  //居中
		//LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	
	/*
	if (Footer!=""){
		LODOP.ADD_PRINT_HTM("284.5mm","11mm","RightMargin:11mm",22,Footer);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		//LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	*/
	
	LODOP.ADD_PRINT_TEXT("284.5mm","11mm","RightMargin:11mm",22,"第#页/共&页"); //Top,Left,Width,Height,strContent
	LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Alignment",3);
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",1);  //从第3页开始计算页码
	
	return LODOP;
}

// 职业病复查报告
function CreateFCBGPrintPage(LODOP, PAADM, PrinterName, Header, Footer) {
	LODOP.PRINT_INIT(PAADM+"职业复查报告");  //打印任务的名称
	if (PrinterName!=""){  //指定打印机名称
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	return LODOP;
}

// PDF报告
function CreatePDFPrintPage(LODOP, PAADM, PrinterName, Header, Footer, PrintURL) {
	LODOP.PRINT_INIT(PAADM+"体检报告");  //打印任务的名称
	if (PrinterName!=""){  //指定打印机名称
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	LODOP.ADD_PRINT_PDF(0,0,"100%","100%",PrintURL);
}

function isIE() {
	if(!!window.ActiveXObject || "ActiveXObject" in window){
		return true;
	}else{
		return false;
	}
}

function createXmlHttp() {
    //根据window.XMLHttpRequest对象是否存在使用不同的创建方式
    if (window.XMLHttpRequest) {
       xmlHttp = new XMLHttpRequest();                  //FireFox、Opera等浏览器支持的创建方式
    } else {
       xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");//IE浏览器支持的创建方式
    }
    return xmlHttp;
}