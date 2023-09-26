//document.write("<script language='javascript' src='../SCRIPTS/DHCPEPrintReportCommon.js'></script>")
//PEPrintReport("V",iTAdmId,"");
//		return false;

document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js'></script>")
var LODOP; //声明为全局变量
function PECreatePrintPage(PrintURL,Header,Footer,PrinterName,PAADM) {
	//alert(Footer)
	LODOP=getLodop(); 
	LODOP.PRINT_INIT(PAADM+"体检报告");  //打印任务的名称
	//LODOP.PRINT_INITA(0,"0mm","RightMargin:0mm","BottomMargin:0mm",PAADM); 
	if (PrinterName!=""){  //指定打印机名称
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	
	if (PrintURL.toUpperCase().split(".PDF").length>1){
		LODOP.ADD_PRINT_PDF(0,0,"100%","100%",PrintURL);
		//LODOP.PRINT();
		return true;
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
	
	LODOP.ADD_PRINT_URL(60,"15mm","RightMargin:15mm","BottomMargin:20mm",PrintURL);  //Top,Left,Width,Height,strURL
	LODOP.NEWPAGEA ();
	LODOP.ADD_PRINT_IMAGE(60,"15mm","RightMargin:15mm","BottomMargin:20mm","http://127.0.0.1/iMedical/web/p1.pdf")
	
}


function PEHistoryCreatePrintPage(PrintURL,Header,Footer,PrinterName,PAADM) {
	//alert(Footer)
	LODOP=getLodop(); 
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
	
	LODOP.ADD_PRINT_HTM(60,"15mm","RightMargin:15mm","BottomMargin:20mm","URL:"+PrintURL);
	LODOP.SET_PRINT_STYLEA(0,"HtmWaitMilSecs",3000);
	LODOP.NEWPAGEA ();
	
	
}

function PECreateOneFormatPrintPage(ReportName,PrintURL,Header,Footer,PrinterName,PAADM) {
	LODOP=getLodop(); 
	LODOP.PRINT_INIT(PAADM+ReportName);  //打印任务的名称
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
	
	LODOP.ADD_PRINT_URL(60,"15mm","RightMargin:15mm","BottomMargin:20mm",PrintURL);  //Top,Left,Width,Height,strURL
	LODOP.NEWPAGEA ();
}
function isIE() {
    if(!!window.ActiveXObject || "ActiveXObject" in window){
      return true;
    }else{
      return false;
　　 }
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
	}else if (Type=="P"){///更新报告打印状态缺方法SetReportStatusByPAADM
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
				//成功保存导出状态
				$.messager.alert("提示","导出报告成功",'success');

			}else{
				//失败保存失败
				$.messager.alert("提示","导出报告失败",'error');
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
				//成功保存导出状态
				$.messager.alert("提示","导出报告成功",'success');

			}else{
				//失败保存失败
				$.messager.alert("提示","导出报告失败",'error');
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
				//成功保存导出状态
				$.messager.alert("提示","导出报告成功",'success');

			}else{
				//失败保存失败
				$.messager.alert("提示","导出报告失败",'error');
			}
		}
	}
}