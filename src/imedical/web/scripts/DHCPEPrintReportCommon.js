//document.write("<script language='javascript' src='../SCRIPTS/DHCPEPrintReportCommon.js'></script>")
//PEPrintReport("V",iTAdmId,"");
//		return false;

document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js'></script>")
var LODOP; //����Ϊȫ�ֱ���
function PECreatePrintPage(PrintURL,Header,Footer,PrinterName,PAADM) {
	//alert(Footer)
	LODOP=getLodop(); 
	LODOP.PRINT_INIT(PAADM+"��챨��");  //��ӡ���������
	//LODOP.PRINT_INITA(0,"0mm","RightMargin:0mm","BottomMargin:0mm",PAADM); 
	if (PrinterName!=""){  //ָ����ӡ������
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	
	if (PrintURL.toUpperCase().split(".PDF").length>1){
		LODOP.ADD_PRINT_PDF(0,0,"100%","100%",PrintURL);
		//LODOP.PRINT();
		return true;
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
	
	LODOP.ADD_PRINT_URL(60,"15mm","RightMargin:15mm","BottomMargin:20mm",PrintURL);  //Top,Left,Width,Height,strURL
	LODOP.NEWPAGEA ();
	LODOP.ADD_PRINT_IMAGE(60,"15mm","RightMargin:15mm","BottomMargin:20mm","http://127.0.0.1/iMedical/web/p1.pdf")
	
}


function PEHistoryCreatePrintPage(PrintURL,Header,Footer,PrinterName,PAADM) {
	//alert(Footer)
	LODOP=getLodop(); 
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
	
	LODOP.ADD_PRINT_HTM(60,"15mm","RightMargin:15mm","BottomMargin:20mm","URL:"+PrintURL);
	LODOP.SET_PRINT_STYLEA(0,"HtmWaitMilSecs",3000);
	LODOP.NEWPAGEA ();
	
	
}

function PECreateOneFormatPrintPage(ReportName,PrintURL,Header,Footer,PrinterName,PAADM) {
	LODOP=getLodop(); 
	LODOP.PRINT_INIT(PAADM+ReportName);  //��ӡ���������
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
	
	LODOP.ADD_PRINT_URL(60,"15mm","RightMargin:15mm","BottomMargin:20mm",PrintURL);  //Top,Left,Width,Height,strURL
	LODOP.NEWPAGEA ();
}
function isIE() {
    if(!!window.ActiveXObject || "ActiveXObject" in window){
      return true;
    }else{
      return false;
���� }
}
function PEPrintReport(Type,PAADM,PrinterName)
{
	var ReportInfo=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetReportPrintInfo",PAADM);
	var ReportArr=ReportInfo.split("^");
	var PrintURL=ReportArr[0];
	var Header=ReportArr[1];
	var Footer=ReportArr[2];
	
    if (isIE()&&(PrintURL.toUpperCase().split(".PDF").length>1))
    {
	    //var lnk="http://127.0.0.1/imedical/web/csp/dhcpeireport.changepdf.new.csp?URLPath=ftp://dhcgw:abc%40123GW@10.1.5.79:21/report/J3739864.PDF&DoType=P";
	    var lnk="dhcpeireport.changepdf.new.csp?URLPath="+PrintURL+"&DoType="+Type;
		var ret=window.showModalDialog(lnk, "", "dialogwidth:800px;dialogheight:600px;center:1"); 
			
	    if (Type=="P") var ret=tkMakeServerCall("web.DHCPE.Report","SetReportStatusByPAADM",PAADM,"P",session["LOGON.USERID"]);
	    return false;
    }
	PECreatePrintPage(PrintURL,Header,Footer,PrinterName,PAADM)
	if (Type=="V"){
		LODOP.PREVIEW();
	}else if (Type=="P"){///���±����ӡ״̬ȱ����SetReportStatusByPAADM
		var ret=tkMakeServerCall("web.DHCPE.Report","SetReportStatusByPAADM",PAADM,"P",session["LOGON.USERID"]);
		LODOP.PRINT();
	}else{
		if (PrinterName!=""){
			LODOP.PRINT();
		}else{
			LODOP.SET_SAVE_MODE("FILE_PROMPT",0);
			LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME",".jpg");
			var ret=LODOP.SAVE_TO_FILE("D:\\DHCPE\\"+PAADM+".jpg");
			if (ret){
				//�ɹ����浼��״̬
				$.messager.alert("��ʾ","��������ɹ�",'success');

			}else{
				//ʧ�ܱ���ʧ��
				$.messager.alert("��ʾ","��������ʧ��",'error');
			}
		}
	}
}


function PEPrintHistoryReport(Type,PAADM,PrinterName)
{
	var ReportInfo=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetHistoryReportPrintInfo",PAADM);
	var ReportArr=ReportInfo.split("$");
	var PrintURL=ReportArr[0];
	var Header=ReportArr[1];
	var Footer=ReportArr[2];
    
	PEHistoryCreatePrintPage(PrintURL,Header,Footer,PrinterName,PAADM)
	if (Type=="V"){
		LODOP.PREVIEW();
	}else if (Type=="P"){
		LODOP.PRINT();
	}else{
		if (PrinterName!=""){
			LODOP.PRINT();
		}else{
			LODOP.SET_SAVE_MODE("FILE_PROMPT",0);
			LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME",".jpg");
			var ret=LODOP.SAVE_TO_FILE("D:\\DHCPE\\"+PAADM+".jpg");
			if (ret){
				//�ɹ����浼��״̬
				$.messager.alert("��ʾ","��������ɹ�",'success');

			}else{
				//ʧ�ܱ���ʧ��
				$.messager.alert("��ʾ","��������ʧ��",'error');
			}
		}
	}
}

function PEPrintOneFormatReport(Type,PAADM,PrinterName,PrintType) {
	var ReportInfo=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetOneFormatReportPrintInfo",PAADM,PrintType);
	var ReportArr=ReportInfo.split("^");
	var PrintURL=ReportArr[0];
	var Header=ReportArr[1];
	var Footer=ReportArr[2];
	var RPName=ReportArr[3];
    
	PECreateOneFormatPrintPage(RPName,PrintURL,Header,Footer,PrinterName,PAADM);
	if (Type=="V"){
		LODOP.PREVIEW();
	}else if (Type=="P"){
		LODOP.PRINT();
	}else{
		if (PrinterName!=""){
			LODOP.PRINT();
		}else{
			LODOP.SET_SAVE_MODE("FILE_PROMPT",0);
			LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME",".jpg");
			var ret=LODOP.SAVE_TO_FILE("D:\\DHCPE\\"+PAADM+".jpg");
			if (ret){
				//�ɹ����浼��״̬
				$.messager.alert("��ʾ","��������ɹ�",'success');

			}else{
				//ʧ�ܱ���ʧ��
				$.messager.alert("��ʾ","��������ʧ��",'error');
			}
		}
	}
}