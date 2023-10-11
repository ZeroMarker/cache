// 指引单打印公共js
// DHCPEPrintDJDCommon.js
// document.write("<script language='javascript' src='../SCRIPTS/DHCPEPrintDJDCommon.js'></script>")
// PEPrintDJD("V",iTAdmId,"");
// var PrinterName="Zan 图像打印机(彩色)";


if (isIE()){
	document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js?needCLodop=1'></script>")
}else{
	document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js'></script>")
}

/*
 * lodop 打印指引单csp通用方法
 * Input: Id, Type(VIPLevel,PAADM), PrintType(V P E), PrinterName(打印机名称), ExStrs(扩展字段:全部打印+"^"+是否打印金额), PrtFormat 打印格式
 */
function PrintDJDByType(Id, Type, PrintType, PrinterName, ExStrs, PrtFormat) {
	
	if (Id == "" || Id == "undefined" || Id == undefined) {
		$.messager.alert("提示", "没有传入需要打印的人员", "info");
		return false;
	}
	if (Type == "" || Type == "undefined" || Type == undefined) {
		$.messager.alert("提示", "没有传入人员ID类型", "info");
		return false;
	}
	
	var HospID = session["LOGON.HOSPID"];
	var LocID = session["LOGON.CTLOCID"];
	var UserID = session["LOGON.USERID"];
	
	var djdURL = tkMakeServerCall("web.DHCPE.GetLodopPrintPath", "GetDJDData", Id, Type, UserID, LocID, HospID, ExStrs);

	if (djdURL == "") {
		$.messager.alert("提示", "未获取到有效指引单地址", "info");
		return false;
	}
	var PAADM = "";  // PAADM=Temporary
	if (Type != "LocVIPLevel") {
		var tmp = djdURL.match(/PAADM=(\d+)&/);  // 获取url中的就诊号
		if (tmp) PAADM = tmp[1];
		if (PAADM == "") {
			$.messager.alert("提示", "未获取到有效体检记录", "info");
			return false;
		}
	} else {
		PAADM = "Temporary";
	}
	
	if (PrtFormat == "" || PrtFormat == "undefined" || PrtFormat == undefined) PrtFormat = "";
	PrtDJDHtmlPage(djdURL, PrintType, PrinterName, PrtFormat, PAADM);
}

/*
 * lodop 获取打印格式的 html源码并调用打印
 */
function PrtDJDHtmlPage(PrintURL, PrtType, PrinterName, PrtFormat, PAADM) {
	var xmlHttp = createXmlHttp();
	xmlHttp.onreadystatechange = function(a,b) {
	    if (xmlHttp.readyState == 4) {
		    var HTMLCode = xmlHttp.responseText;
		    
		    // 当前打印界面 加载到 body 中 否则无法获取该页面对应部分的高度
		    var DivPage = "";
		    if (PAADM == "Temporary") DivPage = ".page-a4";
		    else DivPage = "body";
		    
		    if ($(DivPage).find("#DJDDiv-" + PAADM).length > 0) {
			    $("#DJDDiv-" + PAADM).remove();
		    }
		    $(DivPage).append($.parseHTML(HTMLCode,true));
			
		    var LODOP = getLodop();
			/// 在以下方法中调整打印样式
			switch (PrtFormat) {
				case "Test":  // 测试
					LODOP = CreateDJDPrintPage(LODOP, PAADM, PrinterName);
					break;
					
				default:
					LODOP = CreateDJDPrintPage(LODOP, PAADM, PrinterName);
		    		break;
			}
		    
		    DJDRealPrint(LODOP, PAADM, PrtType, PrinterName);
		}
	}
	xmlHttp.open("get", PEURLAddToken(PrintURL), true);
    xmlHttp.send(null);
}

// 默认指引单报告格式
function CreateDJDPrintPage(LODOP, PAADM, PrinterName) {
	var HDiv = $("#DJDDiv-" + PAADM + " #H-Div-" + PAADM).html();
	var BDiv = $("#DJDDiv-" + PAADM + " #B-Div-" + PAADM).html();
	var FDiv = $("#DJDDiv-" + PAADM + " #F-Div-" + PAADM).html();
	var HHeight = Number($("#DJDDiv-" + PAADM + " #H-Div-Height-" + PAADM).val());
	var BHeight = Number($("#DJDDiv-" + PAADM + " #B-Div-Height-" + PAADM).val());
	var FHeight = Number($("#DJDDiv-" + PAADM + " #F-Div-Height-" + PAADM).val());
	console.log("HHeight=" + HHeight + "mm, BHeight=" + BHeight + "mm, FHeight=" + FHeight + "mm");
	
	LODOP.PRINT_INIT(PAADM + "的导检单");  //打印任务的名称
	//LODOP.PRINT_INITA(0,"0mm","RightMargin:0mm","BottomMargin:0mm",PAADM); 
	if (PrinterName != "") {  //指定打印机名称
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	
	LODOP.ADD_PRINT_HTM("0mm","0mm","RightMargin:0mm",(HHeight+5)+"mm",HDiv);  //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	//增加二维码
	//LODOP.ADD_PRINT_BARCODE("2mm","5mm",250,100, "QRCode", "http://baidu.com")
	//LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",7);
	//LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	//增加一维条码（字体打印条码不清晰可以使用）  128Auto
	//var RegNo=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetRegNoByPAADM",PAADM)
	//LODOP.ADD_PRINT_BARCODE(17,527,187,65,"128A",RegNo);
	//LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	//增加页码，从第一页开始算
	LODOP.ADD_PRINT_HTM((297-FHeight)+"mm","0mm","RightMargin:0mm",FHeight+"mm",FDiv);  //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",1);
	
	//增加打印项目信息
	LODOP.ADD_PRINT_HTM((HHeight+4)+"mm","0","RightMargin:0","BottomMargin:"+(FHeight+2)+"mm",BDiv);  //Top,Left,Width,Height,strURL
	
	return LODOP;
}

/*
 * 实际打印方法
 * PAADM 就诊号   PrtType 打印类型   PrinterName 虚拟打印机
 */
function DJDRealPrint(LODOP, PAADM, PrtType, PrinterName) {
	if (PrtType == "V"){  //预览
		LODOP.PREVIEW();
	}else if (PrtType == "P"){  //打印
	    
		LODOP.PRINT();
		var PFlag = tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","PatItemPrintFlag",PAADM);
	}else{  //导出
		if (PrinterName != "") {  //如果设置了打印机名称，通过设置的虚拟打印机生成对应的文件
			LODOP.PRINT();
		} else {  //没有设置打印机名称，生成图片文件
			LODOP.SET_SAVE_MODE("FILE_PROMPT",0);
			LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME",".jpg");
			var ret = LODOP.SAVE_TO_FILE("D:\\DHCPE\\" + Id + ".jpg");
			if (ret) {
				//成功保存导出状态、
				alert(ret);
			}else{
				alert(ret);
				//失败保存失败
			}
		}
	}
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