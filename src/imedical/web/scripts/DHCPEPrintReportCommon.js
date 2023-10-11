// lodop �����ӡ����js
// DHCPEPrintReportCommon.js

if (isIE()){
	document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js?needCLodop=1'></script>")
}else{
	document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js'></script>")
}

/*
 * lodop ��ӡͨ�÷���
 * PrtType ��ӡ����   PrinterName ָ����ӡ��   PrtFormat ��ӡ��ʽ
 */
function PEPrintReport(PrtType, PAADM, PrinterName, PrtFormat) {
	var LODOP = getLodop();
	
	var HadFormat = false;  // �Ƿ��д�ӡ��ʽ
	var NeedOthReport = false;  // �Ƿ���Ҫ��ӡ�������� pdf jpg ��
	var UpdRptStatus = true;  // �Ƿ���Ҫ���±���״̬
	
	var ReportInfo = tkMakeServerCall("web.DHCPE.GetLodopPrintPath", "GetReportPrintInfo", PAADM, "PAADM", PrtFormat, "");
	var ReportArr = ReportInfo.split("^");
	var PrintURL = ReportArr[0];
	var Header = ReportArr[1];
	var Footer = ReportArr[2];
	var PrtName = ReportArr[3];
	var PrtFormat = ReportArr[4];
	if (PrtFormat == "" || PrtFormat == "undefined" || PrtFormat == undefined) PrtFormat = ReportArr[4];
	
	/// �����·����е�����ӡ��ʽ
	switch (PrtFormat) {
		case "JKTJ":  // �������
			LODOP = CreateJKTJPrintPage(LODOP, PAADM, PrinterName, Header, Footer);
			HadFormat = true;
			NeedOthReport = true;
			break;
			
		case "ZYJK":  // ְҵ����
			LODOP = CreateZYJKPrintPage(LODOP, PAADM, PrinterName, Header, Footer);
			HadFormat = true;
			NeedOthReport = true;
			break;
			
		case "YGBG":  // �Ҹα���
			LODOP = CreateYGBGPrintPage(LODOP, PAADM, PrinterName, Header, Footer);
			HadFormat = true;
			break;
			
		case "TJDB":  // �Աȱ���
			LODOP = CreateTJDBPrintPage(LODOP, PAADM, PrinterName, Header, Footer);
			HadFormat = true;
			break;
			
		case "FCBG":  // ���鱨��
			LODOP = CreateFCBGPrintPage(LODOP, PAADM, PrinterName, Header, Footer);
			HadFormat = true;
			break;
			
		case "PDF":  // PDF����
			LODOP = CreatePDFPrintPage(LODOP, PAADM, PrinterName, Header, Footer, PrintURL);
			PrintURL = "";
			HadFormat = true;
			break;
			
		default:
    		break;
	}
	if (!HadFormat) {  // δ����ı����ʽ
		$.messager.alert("��ʾ", "δ����ı����ʽ", "info");
		return HadFormat;
	}
	PrtHtmlPage(LODOP, PrintURL, PAADM, PrtType, NeedOthReport, UpdRptStatus, PrinterName);
}

/*
 * lodop ��ȡ��ӡ��ʽ�� htmlԴ�벢���ô�ӡ    UpdRptStatus �Ƿ���±���״̬
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
 * ʵ�ʴ�ӡ����
 * HTMLCode ҳ��Դ��   PrtType ��ӡ����   OthReport ��������   PrinterName �����ӡ��
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
				// LODOP.SET_PRINT_STYLEA(0,"Angle",90);  // ��ת90��
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
			if (ret) { //�ɹ����浼��״̬
				$.messager.alert("��ʾ", "��������ɹ�", "success");
			} else { //ʧ�ܱ���ʧ��
				$.messager.alert("��ʾ", "��������ʧ��", "error");
			}
		}
	}
}

// ������챨���ʽ
function CreateJKTJPrintPage(LODOP, PAADM, PrinterName, Header, Footer) {
	LODOP.PRINT_INIT(PAADM + "��챨��");  //��ӡ���������
	//LODOP.PRINT_INITA(0,"0mm","RightMargin:0mm","BottomMargin:0mm",PAADM); 
	if (PrinterName != "") {  //ָ����ӡ������
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	
	//ҳ�ŵ���
	LODOP.ADD_PRINT_LINE("283mm","10mm","283mm","RightMargin:10mm",0,1);  //����  Top1,Left1, Top2, Left2,intLineStyle, intLineWidt
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"Horient",3);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");  //����ĳһҳ����ӡ
	
	//LODOP.SET_PRINT_STYLEA(0,"PageIndex","3,Last-1");
	if (Header!=""){
		//LODOP.SET_PRINT_STYLEA(0,"PageIndex",2);  //�ڶ�ҳ��ʼ��ҳüҳ��
		
		LODOP.ADD_PRINT_HTML("4mm","11mm","RightMargin:11mm","10mm",Header);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);  //ҳüҳ��
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
		
		LODOP.ADD_PRINT_LINE("12.5mm","10mm","12.5mm","RightMargin:10mm",0,1);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Horient",3);  //����
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	
	if (Footer!=""){
		LODOP.ADD_PRINT_HTM("284.5mm","11mm","RightMargin:11mm",22,Footer);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	LODOP.ADD_PRINT_TEXT("284.5mm","11mm","RightMargin:11mm",22,"��#ҳ/��&ҳ"); //Top,Left,Width,Height,strContent
	LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Alignment",3);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",3);  //�ӵ�3ҳ��ʼ����ҳ��
	
	return LODOP;
}

// ְҵ������챨���ʽ
function CreateZYJKPrintPage(LODOP, PAADM, PrinterName, Header, Footer) {
	LODOP.PRINT_INIT(PAADM + "ְҵ������챨��");  //��ӡ���������
	//LODOP.PRINT_INITA(0,"0mm","RightMargin:0mm","BottomMargin:0mm",PAADM); 
	if (PrinterName != "") {  //ָ����ӡ������
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	
	//ҳ�ŵ���
	LODOP.ADD_PRINT_LINE("283mm","10mm","283mm","RightMargin:10mm",0,1);  //����  Top1,Left1, Top2, Left2,intLineStyle, intLineWidt
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"Horient",3);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");  //����ĳһҳ����ӡ
	
	//LODOP.SET_PRINT_STYLEA(0,"PageIndex","3,Last-1");
	if (Header!=""){
		//LODOP.SET_PRINT_STYLEA(0,"PageIndex",2);  //�ڶ�ҳ��ʼ��ҳüҳ��
		
		LODOP.ADD_PRINT_HTML("4mm","11mm","RightMargin:11mm","10mm",Header);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);  //ҳüҳ��
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
		
		LODOP.ADD_PRINT_LINE("12.5mm","10mm","12.5mm","RightMargin:10mm",0,1);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Horient",3);  //����
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	
	if (Footer!=""){
		LODOP.ADD_PRINT_HTM("284.5mm","11mm","RightMargin:11mm",22,Footer);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	LODOP.ADD_PRINT_TEXT("284.5mm","11mm","RightMargin:11mm",22,"��#ҳ/��&ҳ"); //Top,Left,Width,Height,strContent
	LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Alignment",3);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",3);  //�ӵ�3ҳ��ʼ����ҳ��
	
	return LODOP;
}

// �Աȱ����ʽ
function CreateTJDBPrintPage(LODOP, PAADM, PrinterName, Header, Footer) {
	LODOP.PRINT_INIT(PAADM+"�Աȱ���");  //��ӡ���������
	//LODOP.PRINT_INITA(0,"0mm","RightMargin:0mm","BottomMargin:0mm",PAADM); 
	if (PrinterName!=""){  //ָ����ӡ������
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	//ҳ�ŵ���
	LODOP.ADD_PRINT_LINE("436mm","15mm","436mm","RightMargin:15mm",2,2);  //����  Top1,Left1, Top2, Left2,intLineStyle, intLineWidt
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"Horient",3);  
	LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");  //����ĳһҳ����ӡ
	
	//LODOP.SET_PRINT_STYLEA(0,"PageIndex","3,Last-1");
	if (Header!=""){
		//LODOP.SET_PRINT_STYLEA(0,"PageIndex",2);  //�ڶ�ҳ��ʼ��ҳüҳ��
		
		LODOP.ADD_PRINT_LINE(53,"15mm",53,"RightMargin:15mm",2,2);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Horient",3);  //����
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
		
		LODOP.ADD_PRINT_TEXT(21,"15mm","100%","RightMargin:15mm",Header+"\n");  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"FontSize",12);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);  //ҳüҳ��
	
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
		LODOP.SET_PRINT_STYLEA(0,"Horient",0);  //����
	}
	
	if (Footer!=""){
		LODOP.ADD_PRINT_TEXT("438mm","15mm",344,22,Footer);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	LODOP.ADD_PRINT_TEXT("438mm",582,165,22,"��#ҳ/��&ҳ"); //Top,Left,Width,Height,strContent
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Horient",1);
	LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",3);  //�ӵڶ�ҳ��ʼ����ҳ��
	return LODOP;
}

// �Ҹα���
function CreateYGBGPrintPage(LODOP, PAADM, PrinterName, Header, Footer){
	LODOP.PRINT_INIT(PAADM+"�Ҹα���");  //��ӡ���������
	//LODOP.PRINT_INITA(0,"0mm","RightMargin:0mm","BottomMargin:0mm",PAADM); 
	if (PrinterName!=""){  //ָ����ӡ������
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	
	//ҳ�ŵ���
	LODOP.ADD_PRINT_LINE("283mm","10mm","283mm","RightMargin:10mm",0,1);  //����  Top1,Left1, Top2, Left2,intLineStyle, intLineWidt
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"Horient",3);
	//LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");  //����ĳһҳ����ӡ
	
	//LODOP.SET_PRINT_STYLEA(0,"PageIndex","3,Last-1");
	if (Header!=""){
		//LODOP.SET_PRINT_STYLEA(0,"PageIndex",2);  //�ڶ�ҳ��ʼ��ҳüҳ��
		
		LODOP.ADD_PRINT_HTML("4mm","11mm","RightMargin:11mm","10mm",Header);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);  //ҳüҳ��
		//LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
		
		LODOP.ADD_PRINT_LINE("12.5mm","10mm","12.5mm","RightMargin:10mm",0,1);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Horient",3);  //����
		//LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	
	/*
	if (Footer!=""){
		LODOP.ADD_PRINT_HTM("284.5mm","11mm","RightMargin:11mm",22,Footer);  //Top,Left,Width,Height,strContent
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		//LODOP.SET_PRINT_STYLEA(0,"PageUnIndex","1,2");
	}
	*/
	
	LODOP.ADD_PRINT_TEXT("284.5mm","11mm","RightMargin:11mm",22,"��#ҳ/��&ҳ"); //Top,Left,Width,Height,strContent
	LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Alignment",3);
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",1);  //�ӵ�3ҳ��ʼ����ҳ��
	
	return LODOP;
}

// ְҵ�����鱨��
function CreateFCBGPrintPage(LODOP, PAADM, PrinterName, Header, Footer) {
	LODOP.PRINT_INIT(PAADM+"ְҵ���鱨��");  //��ӡ���������
	if (PrinterName!=""){  //ָ����ӡ������
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	return LODOP;
}

// PDF����
function CreatePDFPrintPage(LODOP, PAADM, PrinterName, Header, Footer, PrintURL) {
	LODOP.PRINT_INIT(PAADM+"��챨��");  //��ӡ���������
	if (PrinterName!=""){  //ָ����ӡ������
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
    //����window.XMLHttpRequest�����Ƿ����ʹ�ò�ͬ�Ĵ�����ʽ
    if (window.XMLHttpRequest) {
       xmlHttp = new XMLHttpRequest();                  //FireFox��Opera�������֧�ֵĴ�����ʽ
    } else {
       xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");//IE�����֧�ֵĴ�����ʽ
    }
    return xmlHttp;
}