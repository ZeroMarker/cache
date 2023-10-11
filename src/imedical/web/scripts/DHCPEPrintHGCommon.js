document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js'></script>")
//		return false;
var LODOP; //声明为全局变量
//var PrinterName="Zan 图像打印机(彩色)"; 

function PrintHealthGuide(PAADM,PatientID,CotentType,Type,PrinterName)
{
	
	HGCreatePrintPage(PrinterName,PAADM,PatientID,CotentType)
	
	//增加打印项目信息
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
					//成功保存导出状态、
					alert(ret)
				}else{
					alert(ret)
					//失败保存失败
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
	
	LODOP.PRINT_INIT(PAADM+"的健康分析指导");  //打印任务的名称
	if (PrinterName!=""){  //指定打印机名称
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	/*
	var PrintURL=tkMakeServerCall("web.DHCPE.HealthGuide","GetPrintInfo",PAADM,PatientID,CotentType,"Header");
	//增加打印基本信息，做为页眉打印，每页都有
	LODOP.ADD_PRINT_URL("12mm","12mm","RightMargin:6mm","80mm",PrintURL);  //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Page");
	*/
	//增加二维码
	//LODOP.ADD_PRINT_BARCODE("2mm","5mm",250,100, "QRCode", "http://baidu.com")
	//LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",7);
	//LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	//增加一维条码（字体打印条码不清晰可以使用）  128Auto
	var RegNo=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetRegNoByPAADM",PAADM)
	//LODOP.ADD_PRINT_BARCODE(17,527,187,65,"128A",RegNo); //SVN
	//LODOP.ADD_PRINT_BARCODE(17,60,187,65,"128A",RegNo); //蚌埠
	//LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	
	//同上面二维码，就是QType不同
	//增加页码，从第一页开始算
	LODOP.ADD_PRINT_TEXT("143mm",582,165,22,"第#页/共&页"); //Top,Left,Width,Height,strContent
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
					//成功保存导出状态、
					alert(ret)
				}else{
					alert(ret)
					//失败保存失败
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
	LODOP.PRINT_INITA("5mm","5mm","100%","100%","东华医为体检报告打印");  //边距  Top,Left,Width,Heigh
	
	LODOP.SET_PRINT_PAGESIZE(1, 0, 0,"A4");  //纸张
	if (PrinterName!=""){  //指定打印机名称
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	
	LODOP.ADD_PRINT_LINE("92%","3%","92%","97%",0,1);  //画线
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_STYLEA(0,"Horient",3);  
	LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex",1);  //控制某一页不打印
	
	//LODOP.SET_PRINT_STYLEA(0,"PageIndex","3,Last-1");
	if (Header!=""){
		//LODOP.SET_PRINT_STYLEA(0,"PageIndex",2);  //第二页开始有页眉页脚
		
		LODOP.ADD_PRINT_LINE(53,"3%",53,"97%",0,1);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Horient",3);  //居中
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex",1);
		
		LODOP.ADD_PRINT_TEXT(21,"3%","100%","94%",Header+"\n");
		LODOP.SET_PRINT_STYLEA(0,"FontSize",12);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);  //页眉页脚
	
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex",1);
		LODOP.SET_PRINT_STYLEA(0,"Horient",0);  //居左
	}
	
	if (Footer!=""){
		LODOP.ADD_PRINT_TEXT("93%","3%",344,22,Footer);
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
		LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
		LODOP.SET_PRINT_STYLEA(0,"PageUnIndex",1);
	}
	LODOP.ADD_PRINT_TEXT("93%",542,165,22,"第#页/共&页");
	LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
	LODOP.SET_PRINT_STYLEA(0,"Horient",1);
	LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
	LODOP.SET_PRINT_STYLEA(0,"PageUnIndex",1);
	LODOP.SET_PRINT_STYLEA(0,"NumberStartPage",2);  //从第二页开始计算页码
	
	
	
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