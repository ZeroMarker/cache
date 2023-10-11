document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js'></script>")
//		return false;
var LODOP; //����Ϊȫ�ֱ���
//var PrinterName="Zan ͼ���ӡ��(��ɫ)"; 

function PrintHealthGuide(PAADM,PatientID,CotentType,Type,PrinterName)
{
	
	HGCreatePrintPage(PrinterName,PAADM,PatientID,CotentType)
	
	//���Ӵ�ӡ��Ŀ��Ϣ
	var PrintURL=tkMakeServerCall("web.DHCPE.HealthGuide","GetPrintInfo",PAADM,PatientID,CotentType,"Body");
	//LODOP.ADD_PRINT_URL("5mm","12mm","RightMargin:6mm","BottomMargin:25mm",PrintURL);  //Top,Left,Width,Height,strURL
	//LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);
	var xmlHttp=createXmlHttp();
	xmlHttp.onreadystatechange = function (a,b){
	    if (xmlHttp.readyState == 4) {
		    LODOP.ADD_PRINT_HTM(55,20,"100%","100%",xmlHttp.responseText);
		    LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);
			if (Type=="V"){
				LODOP.PREVIEW();
			}else if (Type=="P"){
				LODOP.PRINT();
			}else{
				LODOP.SET_SAVE_MODE("FILE_PROMPT",0);
				LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME",".jpg");
				var ret=LODOP.SAVE_TO_FILE("D:\\DHCPE\\"+PAADM+".jpg");
				if (ret){
					//�ɹ����浼��״̬��
					alert(ret)
				}else{
					alert(ret)
					//ʧ�ܱ���ʧ��
				}
			}	
		} 
	}
	xmlHttp.open("GET", PrintURL, true);
    xmlHttp.send(null);
	
}

function HGCreatePrintPage(PrinterName,PAADM,PatientID,CotentType)
{
	LODOP=getLodop(); 
	
	LODOP.PRINT_INIT(PAADM+"�Ľ�������ָ��");  //��ӡ���������
	if (PrinterName!=""){  //ָ����ӡ������
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	/*
	var PrintURL=tkMakeServerCall("web.DHCPE.HealthGuide","GetPrintInfo",PAADM,PatientID,CotentType,"Header");
	//���Ӵ�ӡ������Ϣ����Ϊҳü��ӡ��ÿҳ����
	LODOP.ADD_PRINT_URL("12mm","12mm","RightMargin:6mm","80mm",PrintURL);  //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Page");
	*/
	//���Ӷ�ά��
	//LODOP.ADD_PRINT_BARCODE("2mm","5mm",250,100, "QRCode", "http://baidu.com")
	//LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",7);
	//LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	//����һά���루�����ӡ���벻��������ʹ�ã�  128Auto
	var RegNo=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetRegNoByPAADM",PAADM)
	//LODOP.ADD_PRINT_BARCODE(17,527,187,65,"128A",RegNo); //SVN
	//LODOP.ADD_PRINT_BARCODE(17,60,187,65,"128A",RegNo); //����
	//LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	//ͬ�����ά�룬����QType��ͬ
	//����ҳ�룬�ӵ�һҳ��ʼ��
	LODOP.ADD_PRINT_TEXT("143mm",582,165,22,"��#ҳ/��&ҳ"); //Top,Left,Width,Height,strContent
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Horient",1);
	LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",1);
	
	
	
	//LODOP.PRINT_DESIGN()
}
function DeletePatImg()
{
	
}


function PEPrintHG()
{
	//dhcpe.healthguide.print
	var iPAADM=$("#PAADM").val();
	var iType=$("#Type").val();
	var iPatientID=$("#PatientID").val();
	var PrintURL='dhcpe.healthguide.print.csp'+'?PAADM='+iPAADM+'&Type='+iType+'&PatientID='+iPatientID;
	PEPrintReport('V',iPAADM,iPatientID,PrintURL)
	
}
function PEPrintReport(Type,PAADM,PatientID,CSPName)
{
	var ReportInfo=tkMakeServerCall("web.DHCPE.HealthGuide","GetPrintInfo",PAADM,PatientID,CSPName);
	var ReportArr=ReportInfo.split("^");
	var PrintURL=ReportArr[0];
	var Header=ReportArr[1];
	var Footer=ReportArr[2];
	PECreatePrintPage(PrintURL,Header,Footer)
	//LODOP.ADD_PRINT_URL(55,20,"100%","100%",PrintURL);
	var xmlHttp=createXmlHttp();
	xmlHttp.onreadystatechange = function (a,b){
	    if (xmlHttp.readyState == 4) {
		    LODOP.ADD_PRINT_HTM(55,20,"100%","100%",xmlHttp.responseText);
			if (Type=="V"){
				LODOP.PREVIEW();
			}else if (Type=="P"){
				LODOP.PRINT();
			}else{
				LODOP.SET_SAVE_MODE("FILE_PROMPT",0);
				LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME",".jpg");
				var ret=LODOP.SAVE_TO_FILE("D:\\DHCPE\\"+PAADM+".jpg");
				if (ret){
					//�ɹ����浼��״̬��
					alert(ret)
				}else{
					alert(ret)
					//ʧ�ܱ���ʧ��
				}
			}	
		} 
	}
	xmlHttp.open("GET", PrintURL, true);
    xmlHttp.send(null);
	
}
function PECreatePrintPage(PrintURL,Header,Footer) {
	//alert(Footer)
	LODOP=getLodop(); 
	LODOP.PRINT_INITA("5mm","5mm","100%","100%","����ҽΪ��챨���ӡ");  //�߾�  Top,Left,Width,Heigh
	
	LODOP.SET_PRINT_PAGESIZE(1, 0, 0,"A4");  //ֽ��
	if (PrinterName!=""){  //ָ����ӡ������
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	
	LODOP.ADD_PRINT_LINE("92%","3%","92%","97%",0,1);  //����
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"Horient",3);  
	LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex",1);  //����ĳһҳ����ӡ
	
	//LODOP.SET_PRINT_STYLEA(0,"PageIndex","3,Last-1");
	if (Header!=""){
		//LODOP.SET_PRINT_STYLEA(0,"PageIndex",2);  //�ڶ�ҳ��ʼ��ҳüҳ��
		
		LODOP.ADD_PRINT_LINE(53,"3%",53,"97%",0,1);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Horient",3);  //����
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex",1);
		
		LODOP.ADD_PRINT_TEXT(21,"3%","100%","94%",Header+"\n");
		LODOP.SET_PRINT_STYLEA(0,"FontSize",12);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);  //ҳüҳ��
	
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex",1);
		LODOP.SET_PRINT_STYLEA(0,"Horient",0);  //����
	}
	
	if (Footer!=""){
		LODOP.ADD_PRINT_TEXT("93%","3%",344,22,Footer);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex",1);
	}
	LODOP.ADD_PRINT_TEXT("93%",542,165,22,"��#ҳ/��&ҳ");
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Horient",1);
	LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex",1);
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",2);  //�ӵڶ�ҳ��ʼ����ҳ��
	
	
	
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