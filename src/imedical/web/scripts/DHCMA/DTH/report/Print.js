//��ӡ�������˵��
//MethodGetServer s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMedBaseCtl.GetServerInfo"))
//MethodGetData   s val=##Class(%CSP.Page).Encrypt($LB("�෽��"))
//DHC.WMR.CommonFunction.js,DHC.WMR.ExcelPrint.JS,
//btnPrint  ��ӡ  websys/print_compile.gif
//btnExport ��ӡ  websys/print_compile.gif
var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var RepString ="";  //����������ݱ�������

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

//��������ӡ
function ExportDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments) {
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ){  //δ����ʹ���м�� �� ����Ŀ��Ȼ�����ϵķ�ʽ����	
		var ServerInfo = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"GetServerInfo"
		},false);
		var TemplatePath=GetWebConfig(ServerInfo).Path;
		
		var FileName=TemplatePath+"\\\\"+"DHCMedDMReportThree.xls";
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ���á�\n\n�����ǰΪChrome������������м���Ƿ����á����У�",'info');
			return false;
		}
		
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMReportThreePrint","fillxlSheet",strArguments);

		//��ӡԤ��
		xls.visible=true;
		xlSheet.PrintPreview();
		
		//ֱ�Ӵ�ӡ
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
	   //�м������
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMedDMReportThree.xls"
		FileName=FileName.replace(/\\/g,"/");
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMReportThreePrint","fillxlSheetStr",strArguments);
		var Str ="(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
		"var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"+  //�����ź���Ҫ��ֵ����''����������ʹ��
		"var xlSheet = xlBook.Worksheets.Item(1);"+
	    RepString +	  //����һ��������;
	    "xlSheet.PrintOut();"+
	    "xlApp.Visible = false;"+
	    "xlApp.UserControl = false;"+
	    "xlBook.Close(savechanges=false);"+
	    "xlApp.Quit();"+
	    "xlSheet=null;"+
	    "xlBook=null;"+
	    "xlApp=null;"+
	    "return 1;}());";
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
	
		CmdShell.notReturn =1;   //�����޽�����ã�����������
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
	}

	return true;
}
//��������ӡ
function ExportDataToExcelNew(strMethodGetServer,strMethodGetData,strTemplateName,strArguments,strSwitchPrint,strFlagIdS){
	var SignImg = GetUserImg(ReportID);   //ȡǩ��ͼƬ
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb || (BrowserVer=="isIE11")){  //δ����ʹ���м�� �� ����Ŀ��Ȼ�����ϵķ�ʽ����	
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.ReportThreeNew.xls"
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ���á�\n\n�����ǰΪChrome������������м���Ƿ����á����У�",'info');
			return false;
		}
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);	
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMReportThreePrintNew","fillxlSheet",strArguments,strSwitchPrint,strFlagIdS);
		if (SignImg) {
		   	xlSheet.Shapes.AddPicture(SignImg,'1','1','250','150','50','17'); //����ͼƬ����(�ļ��������ӡ�saveWithDocument����ࡢ��������ȡ��߶�)
		   	xlSheet.Shapes.AddPicture(SignImg,'1','1','250','390','50','17');
		   	xlSheet.Shapes.AddPicture(SignImg,'1','1','250','640','50','17');
	   	}
	   	
		//��ӡԤ��
		xls.visible=true;
		xlSheet.PrintPreview();
		
		//ֱ�Ӵ�ӡ
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
		    Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //�����ź���Ҫ��ֵ����''����������ʹ��
		    Str += "var xlSheet = xlBook.Worksheets.Item(1);"
	        Str += RepString 	  //����һ��������;
	        Str +=((SignImg)?("xlSheet.Shapes.AddPicture('" +SignImg+ "','1','1','250','150','50','17');"):"")            //����ͼƬ����(�ļ��������ӡ�saveWithDocument����ࡢ��������ȡ��߶�)
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

		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���	
		CmdShell.notReturn =1;   //�����޽�����ã�����������
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 

	}
	return true;
}

//�¶�����ӡ
function ExportTwoDataToExcelNew(strMethodGetServer,strMethodGetData,strTemplateName,strArguments,strFlagIdS) {
	var SignImg = GetUserImg(ReportID);   //ȡǩ��ͼƬ
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb || (BrowserVer=="isIE11") ){  //δ����ʹ���м�� �� ����Ŀ��Ȼ�����ϵķ�ʽ����	
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
		var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.ReportNew.xls";
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ���á�\n\n�����ǰΪChrome������������м���Ƿ����á����У�",'info');
			return false;
		}
		
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMTwoReportPrintNew","fillxlSheet",strArguments,strFlagIdS);
		if (SignImg) {
		   	xlSheet.Shapes.AddPicture(SignImg,'1','1','78','390','50','17'); //����ͼƬ����(�ļ��������ӡ�saveWithDocument����ࡢ��������ȡ��߶�)
	   	}
	   	
		//��ӡԤ��
		xls.visible=true;
		xlSheet.PrintPreview();
		
		//ֱ�Ӵ�ӡ
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
	   //�м������
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMed.DTH.ReportNew.xls"
		FileName=FileName.replace(/\\/g,"/");
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMTwoReportPrintNew","fillxlSheetStr",strArguments,strFlagIdS);
		
		var Str ="(function test(x){"
		    Str += "var xlApp = new ActiveXObject('Excel.Application');"
		    Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //�����ź���Ҫ��ֵ����''����������ʹ��
		    Str += "var xlSheet = xlBook.Worksheets.Item(1);"
	        Str += RepString 	  //����һ��������;
	        Str +=((SignImg)?("xlSheet.Shapes.AddPicture('" +SignImg+ "','1','1','78','390','50','17');"):"")            //����ͼƬ����(�ļ��������ӡ�saveWithDocument����ࡢ��������ȡ��߶�)
	        Str += "xlSheet.PrintOut();"
	        Str += "xlApp.Visible = false;"
	        Str += "xlApp.UserControl = false;"
	        Str += "xlBook.Close(savechanges=false);"
	        Str += "xlApp.Quit();"
	        Str += "xlSheet=null;"
	        Str += "xlBook=null;"
	        Str += "xlApp=null;"
	        Str += "return 1;}());";
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
		CmdShell.notReturn =1;   //�����޽�����ã�����������
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
	}

	return true;
}

//�ɶ�����ӡ
function ExportTwoDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments) {   //strArgumes����ID
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ){  //δ����ʹ���м�� �� ����Ŀ��Ȼ�����ϵķ�ʽ����	

		var ServerInfo = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"GetServerInfo"
		},false);
		var TemplatePath=GetWebConfig(ServerInfo).Path;
		var FileName=TemplatePath+"\\\\"+"DHCMedDMReport.xls";
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ���á�\n\n�����ǰΪChrome������������м���Ƿ����á����У�",'info');
			return false;
		}
		
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);

		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMTwoReportPrint","fillxlSheet",strArguments);
		
		//��ӡԤ��
		xls.visible=true;
		xlSheet.PrintPreview();
		
		//ֱ�Ӵ�ӡ
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
	   //�м������
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMedDMReport.xls"
		FileName=FileName.replace(/\\/g,"/");
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMTwoReportPrint","fillxlSheetStr",strArguments);
		
		var Str ="(function test(x){"
		    Str += "var xlApp = new ActiveXObject('Excel.Application');"
		    Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //�����ź���Ҫ��ֵ����''����������ʹ��
		    Str += "var xlSheet = xlBook.Worksheets.Item(1);"
	        Str += RepString 	  //����һ��������;
	        Str += "xlSheet.PrintOut();"
	        Str += "xlApp.Visible = false;"
	        Str += "xlApp.UserControl = false;"
	        Str += "xlBook.Close(savechanges=false);"
	        Str += "xlApp.Quit();"
	        Str += "xlSheet=null;"
	        Str += "xlBook=null;"
	        Str += "xlApp=null;"
	        Str += "return 1;}());";
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���	
		CmdShell.notReturn =1;   //�����޽�����ã�����������
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
	}

	return true;
}
//��ӡ������Ϣ
function ExportBaseDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments) {
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ){  //δ����ʹ���м�� �� ����Ŀ��Ȼ�����ϵķ�ʽ����	
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.ReportBaseInfo.xls"
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ���á�\n\n�����ǰΪChrome������������м���Ƿ����á����У�",'info');
			return false;
		}
		
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMBaseReportPrint","fillxlSheet",strArguments);

		//��ӡԤ��
		xls.visible=true;
		xlSheet.PrintPreview();
		
		//ֱ�Ӵ�ӡ
		//xls.visible=false;
		//xlSheet.printout();
		
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	}else{ //�м������
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMed.DTH.ReportBaseInfo.xls"
		FileName=FileName.replace(/\\/g,"/");
    	var  flg =tkMakeServerCall("DHCMed.DTHService.ReportSrv","DMBaseReportPrint","fillxlSheetStr",strArguments);

		var Str ="(function test(x){"
		    Str += "var xlApp = new ActiveXObject('Excel.Application');"
		    Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //�����ź���Ҫ��ֵ����''����������ʹ��
		    Str += "var xlSheet = xlBook.Worksheets.Item(1);"
	        Str += RepString 	  //����һ��������;
	        Str += "xlSheet.PrintOut();"
	        Str += "xlApp.Visible = false;"
	        Str += "xlApp.UserControl = false;"
	        Str += "xlBook.Close(savechanges=false);"
	        Str += "xlApp.Quit();"
	        Str += "xlSheet=null;"
	        Str += "xlBook=null;"
	        Str += "xlApp=null;"
	        Str += "return 1;}());";
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���	
		CmdShell.notReturn =1;   //�����޽�����ã�����������
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
	}

	return true;
}

//5�����¶�ͯ���������ӡ
function ExportChildDataToExcel(aReportID) {
	
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ){  //δ����ʹ���м�� �� ����Ŀ��Ȼ�����ϵķ�ʽ����	
		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
		
		var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.ChildReport.xlt"
		var xls = null;
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ���á�\n\n�����ǰΪChrome������������м���Ƿ����á����У�",'info');
			return;
		}
		//xls.visible=true;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var aChRepID=tkMakeServerCall("DHCMed.DTH.ChildReport","GetRepIDByDthID",aReportID);
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportChildSrv","PrintDTHChildReport","fillxlSheet,MergCells,DeleteRows",aChRepID);
		if ((flg*1)<1) {
			$.messager.alert("��ʾ","Excel��ӡʧ��!",'info');
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
	   //�м������
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
			Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //�����ź���Ҫ��ֵ����''����������ʹ��
			Str += "var xlSheet = xlBook.Worksheets.Item(1);"
			Str += RepString 	  //����һ��������;
			Str += "xlSheet.PrintOut();"
			Str += "xlApp.Visible = false;"
			Str += "xlApp.UserControl = false;"
			Str += "xlBook.Close(savechanges=false);"
			Str += "xlApp.Quit();"
			Str += "xlSheet=null;"
			Str += "xlBook=null;"
			Str += "xlApp=null;"
			Str += "return 1;}());";
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
		CmdShell.notReturn =1;   //�����޽�����ã�����������
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
	}

	return true;
}

//�в�������������ӡ
function ExportMaDataToExcel(aReportID) {
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ){  //δ����ʹ���м�� �� ����Ŀ��Ȼ�����ϵķ�ʽ����	

		var TemplatePath = $m({                  
			ClassName:"DHCMed.Service",
			MethodName:"GetTemplatePath"
		},false);
		
		var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.MaterReport.xlt"
		var xls = null;
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ���á�\n\n�����ǰΪChrome������������м���Ƿ����á����У�",'info');
			return;
		}
		//xls.visible=true;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var aMthRepID=tkMakeServerCall("DHCMed.DTH.MaternalReport","GetRepIDByDthID",aReportID);
		
		var flg = tkMakeServerCall("DHCMed.DTHService.ReportMaternalSrv","PrintDTHMaterReport","fillxlSheet,MergCells,DeleteRows",aMthRepID);
		if ((flg*1)<1) {
			$.messager.alert("��ʾ","Excel��ӡʧ��!",'info');
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
	
	}else{ //�м������
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
			Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //�����ź���Ҫ��ֵ����''����������ʹ��
			Str += "var xlSheet = xlBook.Worksheets.Item(1);"
			Str += RepString 	  //����һ��������;
			Str += "xlSheet.PrintOut();"
			Str += "xlApp.Visible = false;"
			Str += "xlApp.UserControl = false;"
			Str += "xlBook.Close(savechanges=false);"
			Str += "xlApp.Quit();"
			Str += "xlSheet=null;"
			Str += "xlBook=null;"
			Str += "xlApp=null;"
			Str += "return 1;}());";
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���

		CmdShell.notReturn =1;   //�����޽�����ã�����������
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 	
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

//����Ԫ��
function AddCells(objSheet,fRow,fCol,tRow,tCol,xTop,xLeft)
{
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(2).LineStyle=1;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

//��Ԫ��ϲ�
function MergCells(objSheet,fRow,fCol,tRow,tCol)
{
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).MergeCells =1;
}

//��Ԫ�����
//-4130 �����
//-4131 �Ҷ���
//-4108 ���ж���
function HorizontCells(objSheet,fRow,fCol,tRow,tCol,HorizontNum)
{
   objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).HorizontalAlignment=HorizontNum;
}

//�м����ӡ��ʽƴ���ַ���
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
			RepString=RepString+ "xlSheet.Cells("+ (cRow+i) +","+ (cCol+j) +").Value='"+arryDataY[j]+"';"  //�����ź���Ҫ��һ����������
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

	if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
		var BaseImg= new ActiveXObject("Base64IMGSave.ClsSaveBase64IMG");
		var sReigstNo = aUserID;
		var sFiletype= "gif"
	    var rtn=BaseImg.WriteFile(sReigstNo,ImgBase64,sFiletype);   //C��λ�����ܹ����ʣ�����ͼƬ����Ŀ¼����C://Ŀ¼
	    if(!rtn){
	          //alert("ǩ��ͼƬת������");
	          return false;
	     }  
		return true;
	}else{	
		if (EnableLocalWeb==1) {  //��IE��������������м��
			var sReigstNo = aUserID;
			var sFiletype= "gif"
			var Str ="(function test(x){"
	    	Str +="var BaseImg= new ActiveXObject('Base64IMGSave.ClsSaveBase64IMG');"
	    	Str +="var rtn=BaseImg.WriteFile('"+sReigstNo+"','"+ImgBase64+"','"+sFiletype+"');"
		    Str += "return 1;}());";
			CmdShell.notReturn =0;   
			var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ����
			if (rtn.status=="200") {
				return true;
			}else {
				return false;
			}
		}
	}
}
