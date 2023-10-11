// ָ������ӡ����js
// DHCPEPrintDJDCommon.js
// document.write("<script language='javascript' src='../SCRIPTS/DHCPEPrintDJDCommon.js'></script>")
// PEPrintDJD("V",iTAdmId,"");
// var PrinterName="Zan ͼ���ӡ��(��ɫ)";


if (isIE()){
	document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js?needCLodop=1'></script>")
}else{
	document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js'></script>")
}

/*
 * lodop ��ӡָ����cspͨ�÷���
 * Input: Id, Type(VIPLevel,PAADM), PrintType(V P E), PrinterName(��ӡ������), ExStrs(��չ�ֶ�:ȫ����ӡ+"^"+�Ƿ��ӡ���), PrtFormat ��ӡ��ʽ
 */
function PrintDJDByType(Id, Type, PrintType, PrinterName, ExStrs, PrtFormat) {
	
	if (Id == "" || Id == "undefined" || Id == undefined) {
		$.messager.alert("��ʾ", "û�д�����Ҫ��ӡ����Ա", "info");
		return false;
	}
	if (Type == "" || Type == "undefined" || Type == undefined) {
		$.messager.alert("��ʾ", "û�д�����ԱID����", "info");
		return false;
	}
	
	var HospID = session["LOGON.HOSPID"];
	var LocID = session["LOGON.CTLOCID"];
	var UserID = session["LOGON.USERID"];
	
	var djdURL = tkMakeServerCall("web.DHCPE.GetLodopPrintPath", "GetDJDData", Id, Type, UserID, LocID, HospID, ExStrs);

	if (djdURL == "") {
		$.messager.alert("��ʾ", "δ��ȡ����Чָ������ַ", "info");
		return false;
	}
	var PAADM = "";  // PAADM=Temporary
	if (Type != "LocVIPLevel") {
		var tmp = djdURL.match(/PAADM=(\d+)&/);  // ��ȡurl�еľ����
		if (tmp) PAADM = tmp[1];
		if (PAADM == "") {
			$.messager.alert("��ʾ", "δ��ȡ����Ч����¼", "info");
			return false;
		}
	} else {
		PAADM = "Temporary";
	}
	
	if (PrtFormat == "" || PrtFormat == "undefined" || PrtFormat == undefined) PrtFormat = "";
	PrtDJDHtmlPage(djdURL, PrintType, PrinterName, PrtFormat, PAADM);
}

/*
 * lodop ��ȡ��ӡ��ʽ�� htmlԴ�벢���ô�ӡ
 */
function PrtDJDHtmlPage(PrintURL, PrtType, PrinterName, PrtFormat, PAADM) {
	var xmlHttp = createXmlHttp();
	xmlHttp.onreadystatechange = function(a,b) {
	    if (xmlHttp.readyState == 4) {
		    var HTMLCode = xmlHttp.responseText;
		    
		    // ��ǰ��ӡ���� ���ص� body �� �����޷���ȡ��ҳ���Ӧ���ֵĸ߶�
		    var DivPage = "";
		    if (PAADM == "Temporary") DivPage = ".page-a4";
		    else DivPage = "body";
		    
		    if ($(DivPage).find("#DJDDiv-" + PAADM).length > 0) {
			    $("#DJDDiv-" + PAADM).remove();
		    }
		    $(DivPage).append($.parseHTML(HTMLCode,true));
			
		    var LODOP = getLodop();
			/// �����·����е�����ӡ��ʽ
			switch (PrtFormat) {
				case "Test":  // ����
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

// Ĭ��ָ���������ʽ
function CreateDJDPrintPage(LODOP, PAADM, PrinterName) {
	var HDiv = $("#DJDDiv-" + PAADM + " #H-Div-" + PAADM).html();
	var BDiv = $("#DJDDiv-" + PAADM + " #B-Div-" + PAADM).html();
	var FDiv = $("#DJDDiv-" + PAADM + " #F-Div-" + PAADM).html();
	var HHeight = Number($("#DJDDiv-" + PAADM + " #H-Div-Height-" + PAADM).val());
	var BHeight = Number($("#DJDDiv-" + PAADM + " #B-Div-Height-" + PAADM).val());
	var FHeight = Number($("#DJDDiv-" + PAADM + " #F-Div-Height-" + PAADM).val());
	console.log("HHeight=" + HHeight + "mm, BHeight=" + BHeight + "mm, FHeight=" + FHeight + "mm");
	
	LODOP.PRINT_INIT(PAADM + "�ĵ��쵥");  //��ӡ���������
	//LODOP.PRINT_INITA(0,"0mm","RightMargin:0mm","BottomMargin:0mm",PAADM); 
	if (PrinterName != "") {  //ָ����ӡ������
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	
	LODOP.ADD_PRINT_HTM("0mm","0mm","RightMargin:0mm",(HHeight+5)+"mm",HDiv);  //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	//���Ӷ�ά��
	//LODOP.ADD_PRINT_BARCODE("2mm","5mm",250,100, "QRCode", "http://baidu.com")
	//LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",7);
	//LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	//����һά���루�����ӡ���벻��������ʹ�ã�  128Auto
	//var RegNo=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetRegNoByPAADM",PAADM)
	//LODOP.ADD_PRINT_BARCODE(17,527,187,65,"128A",RegNo);
	//LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	//����ҳ�룬�ӵ�һҳ��ʼ��
	LODOP.ADD_PRINT_HTM((297-FHeight)+"mm","0mm","RightMargin:0mm",FHeight+"mm",FDiv);  //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",1);
	
	//���Ӵ�ӡ��Ŀ��Ϣ
	LODOP.ADD_PRINT_HTM((HHeight+4)+"mm","0","RightMargin:0","BottomMargin:"+(FHeight+2)+"mm",BDiv);  //Top,Left,Width,Height,strURL
	
	return LODOP;
}

/*
 * ʵ�ʴ�ӡ����
 * PAADM �����   PrtType ��ӡ����   PrinterName �����ӡ��
 */
function DJDRealPrint(LODOP, PAADM, PrtType, PrinterName) {
	if (PrtType == "V"){  //Ԥ��
		LODOP.PREVIEW();
	}else if (PrtType == "P"){  //��ӡ
	    
		LODOP.PRINT();
		var PFlag = tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","PatItemPrintFlag",PAADM);
	}else{  //����
		if (PrinterName != "") {  //��������˴�ӡ�����ƣ�ͨ�����õ������ӡ�����ɶ�Ӧ���ļ�
			LODOP.PRINT();
		} else {  //û�����ô�ӡ�����ƣ�����ͼƬ�ļ�
			LODOP.SET_SAVE_MODE("FILE_PROMPT",0);
			LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME",".jpg");
			var ret = LODOP.SAVE_TO_FILE("D:\\DHCPE\\" + Id + ".jpg");
			if (ret) {
				//�ɹ����浼��״̬��
				alert(ret);
			}else{
				alert(ret);
				//ʧ�ܱ���ʧ��
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
    //����window.XMLHttpRequest�����Ƿ����ʹ�ò�ͬ�Ĵ�����ʽ
    if (window.XMLHttpRequest) {
       xmlHttp = new XMLHttpRequest();                  //FireFox��Opera�������֧�ֵĴ�����ʽ
    } else {
       xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");//IE�����֧�ֵĴ�����ʽ
    }
    return xmlHttp;
}