document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js'></script>")
//document.write("<script language='javascript' src='../SCRIPTS/DHCPEPrintDJDCommon.js'></script>")
//PEPrintDJD("V",iTAdmId,"");
//		return false;
var LODOP; //声明为全局变量
//var PrinterName="Zan 图像打印机(彩色)"; 
function PEPrintDJD(Type,PAADM,PrinterName)
{
	if (PAADM==""){
		alert("没有传入需要打印的人员");
		return false;
	}
	//alert(PrintURL)
	DJDCreatePrintPage(PrinterName,PAADM)
	if (Type=="V"){  //预览
		LODOP.PREVIEW();
	}else if (Type=="P"){  //打印
		LODOP.PRINT();
		var PFlag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","PatItemPrintFlag",PAADM);
		
	}else{  //导出
		if (PrinterName!=""){  //如果设置了打印机名称，通过设置的虚拟打印机生成对应的文件
			LODOP.PRINT();
		}else{  //没有设置打印机名称，生成图片文件
			LODOP.SET_SAVE_MODE("FILE_PROMPT",0);
			LODOP.SET_SAVE_MODE("SAVEAS_IMGFILE_EXENAME",".jpg");
			var ret=LODOP.SAVE_TO_FILE("D:\\DHCPE\\"+PAADM+".jpg");
			if (ret){
				//成功保存导出状态、
				alert(ret)
			}else{
				alert(ret)
				//失败保存失败
			}
		}
	}
}
function DJDCreatePrintPage(PrinterName,PAADM)
{
	
	var HospID=session['LOGON.HOSPID']
	var UserID=session['LOGON.USERID']	
	LODOP=getLodop(); 
	
	LODOP.PRINT_INIT(PAADM+"的导检单");  //打印任务的名称
	if (PrinterName!=""){  //指定打印机名称
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	var PrintURL=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetDJDPrintInfo",PAADM,"Header",HospID,UserID);
	//增加打印基本信息，做为页眉打印，每页都有
	LODOP.ADD_PRINT_URL("12mm","12mm","RightMargin:6mm","80mm",PrintURL);  //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Page");
	//增加二维码
	//LODOP.ADD_PRINT_BARCODE("2mm","5mm",250,100, "QRCode", "http://baidu.com")
	//LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",7);
	//LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	//增加一维条码（字体打印条码不清晰可以使用）  128Auto
	var RegNo=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetRegNoByPAADM",PAADM)
	//LODOP.ADD_PRINT_BARCODE(17,527,187,65,"128A",RegNo);
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	//同上面二维码，就是QType不同
	//增加页码，从第一页开始算
	LODOP.ADD_PRINT_TEXT("143mm",582,165,22,"第#页/共&页"); //Top,Left,Width,Height,strContent
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Horient",1);
	LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",1);
	//var Info=LODOP.PRINT_DESIGN();
	//alert(Info)
	//return false;
	//LODOP.NEWPAGEA ();
	
	//增加打印项目信息
	var PrintURL=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetDJDPrintInfo",PAADM,"Body",HospID,UserID);
	LODOP.ADD_PRINT_URL("75mm","12mm","RightMargin:6mm","BottomMargin:20mm",PrintURL);  //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);
	
	//LODOP.PRINT_DESIGN()
}