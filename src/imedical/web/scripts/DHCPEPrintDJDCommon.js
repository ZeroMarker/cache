document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js'></script>")
//document.write("<script language='javascript' src='../SCRIPTS/DHCPEPrintDJDCommon.js'></script>")
//PEPrintDJD("V",iTAdmId,"");
//		return false;
var LODOP; //����Ϊȫ�ֱ���
//var PrinterName="Zan ͼ���ӡ��(��ɫ)"; 
function PEPrintDJD(Type,PAADM,PrinterName)
{
	if (PAADM==""){
		alert("û�д�����Ҫ��ӡ����Ա");
		return false;
	}
	//alert(PrintURL)
	DJDCreatePrintPage(PrinterName,PAADM)
	if (Type=="V"){  //Ԥ��
		LODOP.PREVIEW();
	}else if (Type=="P"){  //��ӡ
		LODOP.PRINT();
		var PFlag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","PatItemPrintFlag",PAADM);
		
	}else{  //����
		if (PrinterName!=""){  //��������˴�ӡ�����ƣ�ͨ�����õ������ӡ�����ɶ�Ӧ���ļ�
			LODOP.PRINT();
		}else{  //û�����ô�ӡ�����ƣ�����ͼƬ�ļ�
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
function DJDCreatePrintPage(PrinterName,PAADM)
{
	
	var HospID=session['LOGON.HOSPID']
	var UserID=session['LOGON.USERID']	
	LODOP=getLodop(); 
	
	LODOP.PRINT_INIT(PAADM+"�ĵ��쵥");  //��ӡ���������
	if (PrinterName!=""){  //ָ����ӡ������
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	var PrintURL=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetDJDPrintInfo",PAADM,"Header",HospID,UserID);
	//���Ӵ�ӡ������Ϣ����Ϊҳü��ӡ��ÿҳ����
	LODOP.ADD_PRINT_URL("12mm","12mm","RightMargin:6mm","80mm",PrintURL);  //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Page");
	//���Ӷ�ά��
	//LODOP.ADD_PRINT_BARCODE("2mm","5mm",250,100, "QRCode", "http://baidu.com")
	//LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",7);
	//LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	//����һά���루�����ӡ���벻��������ʹ�ã�  128Auto
	var RegNo=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetRegNoByPAADM",PAADM)
	//LODOP.ADD_PRINT_BARCODE(17,527,187,65,"128A",RegNo);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	//ͬ�����ά�룬����QType��ͬ
	//����ҳ�룬�ӵ�һҳ��ʼ��
	LODOP.ADD_PRINT_TEXT("143mm",582,165,22,"��#ҳ/��&ҳ"); //Top,Left,Width,Height,strContent
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Horient",1);
	LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",1);
	//var Info=LODOP.PRINT_DESIGN();
	//alert(Info)
	//return false;
	//LODOP.NEWPAGEA ();
	
	//���Ӵ�ӡ��Ŀ��Ϣ
	var PrintURL=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetDJDPrintInfo",PAADM,"Body",HospID,UserID);
	LODOP.ADD_PRINT_URL("75mm","12mm","RightMargin:6mm","BottomMargin:20mm",PrintURL);  //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);
	
	//LODOP.PRINT_DESIGN()
}