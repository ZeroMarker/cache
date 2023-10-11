//打印程序添加说明
//MethodGetServer s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMedBaseCtl.GetServerInfo"))
//MethodGetData   s val=##Class(%CSP.Page).Encrypt($LB("类方法"))
//DHC.WMR.CommonFunction.js,DHC.WMR.ExcelPrint.JS,
//btnPrint  打印  websys/print_compile.gif
//btnExport 打印  websys/print_compile.gif
var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var RepString ="";  //用于输出整份报告数据

function GetWebConfig(encmeth){
	var objWebConfig=new Object();
	if (encmeth!=""){
		if (encmeth!=""){
			var TempFileds=encmeth.split(String.fromCharCode(1));
			objWebConfig.CurrentNS=TempFileds[0];
			objWebConfig.MEDDATA=TempFileds[1];
			objWebConfig.LABDATA=TempFileds[2];
			objWebConfig.Server="cn_iptcp:"+TempFileds[3]+"[1972]";
			objWebConfig.Path=TempFileds[4];
			objWebConfig.LayOutManager=TempFileds[5];
		}
	}else{
		objWebConfig=null;
	}
	return objWebConfig;
}

//旧三联打印
function ExportDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments) {
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ){  //未开启使用中间件 或 老项目，然仍用老的方式运行	
		var ServerInfo = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"GetServerInfo"
		},false);
		var TemplatePath=GetWebConfig(ServerInfo).Path;
		
		var FileName=TemplatePath+"\\\\"+"DHCMedDMReportThree.xls";
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用。\n\n如果当前为Chrome浏览器，请检查中间件是否启用、运行！",'info');
			return false;
		}
		
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMReportThreePrint","fillxlSheet",strArguments);

		//打印预览
		xls.visible=true;
		xlSheet.PrintPreview();
		
		//直接打印
		//xls.visible=false;
		//xlSheet.printout();
		
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	}else{
	   //中间件运行
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMedDMReportThree.xls"
		FileName=FileName.replace(/\\/g,"/");
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMReportThreePrint","fillxlSheetStr",strArguments);
		var Str ="(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
		"var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"+  //标点符号很重要，值都是''引起来才能使用
		"var xlSheet = xlBook.Worksheets.Item(1);"+
	    RepString +	  //后面一定不能有;
	    "xlSheet.PrintOut();"+
	    "xlApp.Visible = false;"+
	    "xlApp.UserControl = false;"+
	    "xlBook.Close(savechanges=false);"+
	    "xlApp.Quit();"+
	    "xlSheet=null;"+
	    "xlBook=null;"+
	    "xlApp=null;"+
	    "return 1;}());";
		//以上为拼接Excel打印代码为字符串
	
		CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 
	}

	return true;
}
//新三联打印
function ExportDataToExcelNew(strMethodGetServer,strMethodGetData,strTemplateName,strArguments,strSwitchPrint,strFlagIdS){
	var SignImg = GetUserImg(ReportID);   //取签名图片
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb || (BrowserVer=="isIE11")){  //未开启使用中间件 或 老项目，然仍用老的方式运行	
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.ReportThreeNew.xls"
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用。\n\n如果当前为Chrome浏览器，请检查中间件是否启用、运行！",'info');
			return false;
		}
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);	
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMReportThreePrintNew","fillxlSheet",strArguments,strSwitchPrint,strFlagIdS);
		if (SignImg) {
		   	xlSheet.Shapes.AddPicture(SignImg,'1','1','250','150','50','17'); //插入图片方法(文件名、链接、saveWithDocument、左侧、顶部、宽度、高度)
		   	xlSheet.Shapes.AddPicture(SignImg,'1','1','250','390','50','17');
		   	xlSheet.Shapes.AddPicture(SignImg,'1','1','250','640','50','17');
	   	}
	   	
		//打印预览
		xls.visible=true;
		xlSheet.PrintPreview();
		
		//直接打印
		//xls.visible=false;
		//xlSheet.printout();
		
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	}else{
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMed.DTH.ReportThreeNew.xls"
		FileName=FileName.replace(/\\/g,"/");
    	var  flg =tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMReportThreePrintNew","fillxlSheetStr",strArguments,strSwitchPrint,strFlagIdS);

		var Str ="(function test(x){"
		    Str += "var xlApp = new ActiveXObject('Excel.Application');"
		    Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //标点符号很重要，值都是''引起来才能使用
		    Str += "var xlSheet = xlBook.Worksheets.Item(1);"
	        Str += RepString 	  //后面一定不能有;
	        Str +=((SignImg)?("xlSheet.Shapes.AddPicture('" +SignImg+ "','1','1','250','150','50','17');"):"")            //插入图片方法(文件名、链接、saveWithDocument、左侧、顶部、宽度、高度)
	        Str +=((SignImg)?("xlSheet.Shapes.AddPicture('" +SignImg+ "','1','1','250','390','50','17');"):"")
	        Str +=((SignImg)?("xlSheet.Shapes.AddPicture('" +SignImg+ "','1','1','250','640','50','17');"):"")
	        Str += "xlSheet.PrintOut();"
	        Str += "xlApp.Visible = false;"
	        Str += "xlApp.UserControl = false;"
	        Str += "xlBook.Close(savechanges=false);"
	        Str += "xlApp.Quit();"
	        Str += "xlSheet=null;"
	        Str += "xlBook=null;"
	        Str += "xlApp=null;"
	        Str += "return 1;}());";

		//以上为拼接Excel打印代码为字符串	
		CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 

	}
	return true;
}

//新二联打印
function ExportTwoDataToExcelNew(strMethodGetServer,strMethodGetData,strTemplateName,strArguments,strFlagIdS) {
	var SignImg = GetUserImg(ReportID);   //取签名图片
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb || (BrowserVer=="isIE11") ){  //未开启使用中间件 或 老项目，然仍用老的方式运行	
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
		var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.ReportNew.xls";
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用。\n\n如果当前为Chrome浏览器，请检查中间件是否启用、运行！",'info');
			return false;
		}
		
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMTwoReportPrintNew","fillxlSheet",strArguments,strFlagIdS);
		if (SignImg) {
		   	xlSheet.Shapes.AddPicture(SignImg,'1','1','78','390','50','17'); //插入图片方法(文件名、链接、saveWithDocument、左侧、顶部、宽度、高度)
	   	}
	   	
		//打印预览
		xls.visible=true;
		xlSheet.PrintPreview();
		
		//直接打印
		//xls.visible=false;
		//xlSheet.printout();
		
		xlSheet=null;
		xlBook.Close(savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	}else{
	   //中间件运行
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMed.DTH.ReportNew.xls"
		FileName=FileName.replace(/\\/g,"/");
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMTwoReportPrintNew","fillxlSheetStr",strArguments,strFlagIdS);
		
		var Str ="(function test(x){"
		    Str += "var xlApp = new ActiveXObject('Excel.Application');"
		    Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //标点符号很重要，值都是''引起来才能使用
		    Str += "var xlSheet = xlBook.Worksheets.Item(1);"
	        Str += RepString 	  //后面一定不能有;
	        Str +=((SignImg)?("xlSheet.Shapes.AddPicture('" +SignImg+ "','1','1','78','390','50','17');"):"")            //插入图片方法(文件名、链接、saveWithDocument、左侧、顶部、宽度、高度)
	        Str += "xlSheet.PrintOut();"
	        Str += "xlApp.Visible = false;"
	        Str += "xlApp.UserControl = false;"
	        Str += "xlBook.Close(savechanges=false);"
	        Str += "xlApp.Quit();"
	        Str += "xlSheet=null;"
	        Str += "xlBook=null;"
	        Str += "xlApp=null;"
	        Str += "return 1;}());";
		//以上为拼接Excel打印代码为字符串
		CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 
	}

	return true;
}

//旧二联打印
function ExportTwoDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments) {   //strArgumes报告ID
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ){  //未开启使用中间件 或 老项目，然仍用老的方式运行	

		var ServerInfo = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"GetServerInfo"
		},false);
		var TemplatePath=GetWebConfig(ServerInfo).Path;
		var FileName=TemplatePath+"\\\\"+"DHCMedDMReport.xls";
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用。\n\n如果当前为Chrome浏览器，请检查中间件是否启用、运行！",'info');
			return false;
		}
		
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);

		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMTwoReportPrint","fillxlSheet",strArguments);
		
		//打印预览
		xls.visible=true;
		xlSheet.PrintPreview();
		
		//直接打印
		//xls.visible=false;
		//xlSheet.printout();
		
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	}else{
	   //中间件运行
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMedDMReport.xls"
		FileName=FileName.replace(/\\/g,"/");
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMTwoReportPrint","fillxlSheetStr",strArguments);
		
		var Str ="(function test(x){"
		    Str += "var xlApp = new ActiveXObject('Excel.Application');"
		    Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //标点符号很重要，值都是''引起来才能使用
		    Str += "var xlSheet = xlBook.Worksheets.Item(1);"
	        Str += RepString 	  //后面一定不能有;
	        Str += "xlSheet.PrintOut();"
	        Str += "xlApp.Visible = false;"
	        Str += "xlApp.UserControl = false;"
	        Str += "xlBook.Close(savechanges=false);"
	        Str += "xlApp.Quit();"
	        Str += "xlSheet=null;"
	        Str += "xlBook=null;"
	        Str += "xlApp=null;"
	        Str += "return 1;}());";
		//以上为拼接Excel打印代码为字符串	
		CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 
	}

	return true;
}
//打印基本信息
function ExportBaseDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments) {
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ){  //未开启使用中间件 或 老项目，然仍用老的方式运行	
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.ReportBaseInfo.xls"
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用。\n\n如果当前为Chrome浏览器，请检查中间件是否启用、运行！",'info');
			return false;
		}
		
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMBaseReportPrint","fillxlSheet",strArguments);

		//打印预览
		xls.visible=true;
		xlSheet.PrintPreview();
		
		//直接打印
		//xls.visible=false;
		//xlSheet.printout();
		
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	}else{ //中间件运行
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMed.DTH.ReportBaseInfo.xls"
		FileName=FileName.replace(/\\/g,"/");
    	var  flg =tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMBaseReportPrint","fillxlSheetStr",strArguments);

		var Str ="(function test(x){"
		    Str += "var xlApp = new ActiveXObject('Excel.Application');"
		    Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //标点符号很重要，值都是''引起来才能使用
		    Str += "var xlSheet = xlBook.Worksheets.Item(1);"
	        Str += RepString 	  //后面一定不能有;
	        Str += "xlSheet.PrintOut();"
	        Str += "xlApp.Visible = false;"
	        Str += "xlApp.UserControl = false;"
	        Str += "xlBook.Close(savechanges=false);"
	        Str += "xlApp.Quit();"
	        Str += "xlSheet=null;"
	        Str += "xlBook=null;"
	        Str += "xlApp=null;"
	        Str += "return 1;}());";
		//以上为拼接Excel打印代码为字符串	
		CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 
	}

	return true;
}

//5岁以下儿童死亡报告打印
function ExportChildDataToExcel(aReportID) {
	
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ){  //未开启使用中间件 或 老项目，然仍用老的方式运行	
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
		
		var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.ChildReport.xlt"
		var xls = null;
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用。\n\n如果当前为Chrome浏览器，请检查中间件是否启用、运行！",'info');
			return;
		}
		//xls.visible=true;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var aChRepID=tkMakeServerCall("DHCMed.DTH.ChildReport","GetRepIDByDthID",aReportID);
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportChildSrv","PrintDTHChildReport","fillxlSheet,MergCells,DeleteRows",aChRepID);
		if ((flg*1)<1) {
			$.messager.alert("提示","Excel打印失败!",'info');
		} else {
			xlSheet.printout();
		}
		
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	}else{
	   //中间件运行
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMed.DTH.ChildReport.xlt"
		FileName=FileName.replace(/\\/g,"/");

    	var aChRepID=tkMakeServerCall("DHCMed.DTH.ChildReport","GetRepIDByDthID",aReportID);
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportChildSrv","PrintDTHChildReport","fillxlSheetStr",aChRepID);

		var Str ="(function test(x){"
			Str += "var xlApp = new ActiveXObject('Excel.Application');"
			Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //标点符号很重要，值都是''引起来才能使用
			Str += "var xlSheet = xlBook.Worksheets.Item(1);"
			Str += RepString 	  //后面一定不能有;
			Str += "xlSheet.PrintOut();"
			Str += "xlApp.Visible = false;"
			Str += "xlApp.UserControl = false;"
			Str += "xlBook.Close(savechanges=false);"
			Str += "xlApp.Quit();"
			Str += "xlSheet=null;"
			Str += "xlBook=null;"
			Str += "xlApp=null;"
			Str += "return 1;}());";
		//以上为拼接Excel打印代码为字符串
		CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 
	}

	return true;
}

//孕产妇死亡副卡打印
function ExportMaDataToExcel(aReportID) {
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ){  //未开启使用中间件 或 老项目，然仍用老的方式运行	

		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
		
		var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.MaterReport.xlt"
		var xls = null;
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用。\n\n如果当前为Chrome浏览器，请检查中间件是否启用、运行！",'info');
			return;
		}
		//xls.visible=true;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var aMthRepID=tkMakeServerCall("DHCMed.DTH.MaternalReport","GetRepIDByDthID",aReportID);
		
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportMaternalSrv","PrintDTHMaterReport","fillxlSheet,MergCells,DeleteRows",aMthRepID);
		if ((flg*1)<1) {
			$.messager.alert("提示","Excel打印失败!",'info');
		} else {
			xlSheet.printout();
		}
		
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	
	}else{ //中间件运行
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMed.DTH.MaterReport.xlt"
		FileName=FileName.replace(/\\/g,"/");
    	
    	var aMthRepID=tkMakeServerCall("DHCMed.DTH.MaternalReport","GetRepIDByDthID",aReportID);		
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportMaternalSrv","PrintDTHMaterReport","fillxlSheetStr",aMthRepID);

		var Str ="(function test(x){"
			Str += "var xlApp = new ActiveXObject('Excel.Application');"
			Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //标点符号很重要，值都是''引起来才能使用
			Str += "var xlSheet = xlBook.Worksheets.Item(1);"
			Str += RepString 	  //后面一定不能有;
			Str += "xlSheet.PrintOut();"
			Str += "xlApp.Visible = false;"
			Str += "xlApp.UserControl = false;"
			Str += "xlBook.Close(savechanges=false);"
			Str += "xlApp.Quit();"
			Str += "xlSheet=null;"
			Str += "xlBook=null;"
			Str += "xlApp=null;"
			Str += "return 1;}());";
		//以上为拼接Excel打印代码为字符串

		CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 	
	}
	return true;
}

function fillxlSheet(xlSheet,cData,cRow,cCol)
{
	var cells = xlSheet.Cells;
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			cells(cRow+i,cCol+j).Value = arryDataY[j];
			//cells(cRow+i,cCol+j).Borders.Weight = 1;
		}
	}
	return cells;
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}

//画单元格
function AddCells(objSheet,fRow,fCol,tRow,tCol,xTop,xLeft)
{
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(2).LineStyle=1;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

//单元格合并
function MergCells(objSheet,fRow,fCol,tRow,tCol)
{
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).MergeCells =1;
}

//单元格对其
//-4130 左对齐
//-4131 右对齐
//-4108 居中对齐
function HorizontCells(objSheet,fRow,fCol,tRow,tCol,HorizontNum)
{
   objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).HorizontalAlignment=HorizontNum;
}

//中间件打印方式拼接字符串
function fillxlSheetStr(cxlSheet,cData,cRow,cCol)
{
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			RepString=RepString+ "xlSheet.Cells("+ (cRow+i) +","+ (cCol+j) +").Value='"+arryDataY[j]+"';"  //标点符号很重要，一个都不能少
		}
	}
	 
	return RepString; 
}


function GetUserImg(ReportID) {
	var SignImg="";
	var SignID = tkMakeServerCall("DHCMed.CA.SignVerify","GetRepSignID","DTH","DTH",ReportID,"S");
	if (SignID != "") {
		SignImg = $m({
			ClassName:"DHCMed.CA.SignVerify",
			MethodName:"SaveSignImg",
			aSignID: SignID
		},false);
		if (SignImg!='') {
			var ImgUrl = window.location.href;
			ImgUrl = ImgUrl.substring(0,ImgUrl.lastIndexOf('/'));
			ImgUrl = ImgUrl.substring(0,ImgUrl.lastIndexOf('/'));
			SignImg = ImgUrl + SignImg + SignID + '.gif';
		}
	}
	return SignImg;
}

function GetUserSignImg(aUserID) {	
	var ImgBase64 = tkMakeServerCall("CA.BICAService","GetImageByUserID",aUserID);

	if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
		var BaseImg= new ActiveXObject("Base64IMGSave.ClsSaveBase64IMG");
		var sReigstNo = aUserID;
		var sFiletype= "gif"
	    var rtn=BaseImg.WriteFile(sReigstNo,ImgBase64,sFiletype);   //C盘位置需能够访问，否则图片存在目录不在C://目录
	    if(!rtn){
	          //alert("签名图片转换错误");
	          return false;
	     }  
		return true;
	}else{	
		if (EnableLocalWeb==1) {  //非IE浏览器，且启用中间件
			var sReigstNo = aUserID;
			var sFiletype= "gif"
			var Str ="(function test(x){"
	    	Str +="var BaseImg= new ActiveXObject('Base64IMGSave.ClsSaveBase64IMG');"
	    	Str +="var rtn=BaseImg.WriteFile('"+sReigstNo+"','"+ImgBase64+"','"+sFiletype+"');"
		    Str += "return 1;}());";
			CmdShell.notReturn =0;   
			var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序
			if (rtn.status=="200") {
				return true;
			}else {
				return false;
			}
		}
	}
}
