//~{4rS!84S!5G<GLuBk~}
function PrintBarCode(RecordID)
{
	try{
		var IsCopyPrintBarcode = ExtTool.RunServerMethod("DHCWMR.SSService.ConfigSrv","GetValueByKeyHosp",'IsCopyPrintBarcode'); //~{JG7qFtSC4rS!~}
		if (IsCopyPrintBarcode==0) return;
		var strPrinterName = ExtTool.RunServerMethod("DHCWMR.SSService.ConfigSrv","GetValueByKeyHosp",'BarCodePrinterName');  //~{H!LuBk4rS!;zC{3F~}
		if (strPrinterName=='') strPrinterName='Zebra';
		var strPrintInfo = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","GetPrintInfo",RecordID);
		if (strPrintInfo == '') return;
		var arrPrintInfo = strPrintInfo.split("^");
		/*var Bar;
		Bar = new ActiveXObject("DHCMedBarCode.PrintBarMRCopy");
		Bar.PrinterName = strPrinterName;  //~{4rS!;zC{3F~}
		Bar.PrinterPort = "";              //~{4rS!;z6K?Z:E~}
		Bar.SetPrinter();                  //~{IhVC4rS!;z~}
		Bar.vMrType      = arrPrintInfo[0];
		Bar.vMrNo        = arrPrintInfo[1];
		Bar.vPatientName = arrPrintInfo[2];
		Bar.vBarCode	 = arrPrintInfo[3];
		Bar.vRegditDate  = arrPrintInfo[4];
		Bar.vNumber		 = arrPrintInfo[5];
		Bar.PrintCopyBarCode();*/
		
		var printParam="";
		// ~{4rS!2NJ}~}
		printParam=printParam+"^MrType"+String.fromCharCode(2)+arrPrintInfo[0];
		printParam=printParam+"^MrNo"+String.fromCharCode(2)+arrPrintInfo[1];
		printParam=printParam+"^PatientName"+String.fromCharCode(2)+arrPrintInfo[2];
		printParam=printParam+"^BarCode"+String.fromCharCode(2)+arrPrintInfo[3];
		printParam=printParam+"^RegditDate"+String.fromCharCode(2)+arrPrintInfo[4];
		printParam=printParam+"^Number"+String.fromCharCode(2)+arrPrintInfo[5];
		// ~{;qH!~}XML~{D#0eEdVC~}
		DHCP_GetXMLConfig("InvPrintEncrypt","WMRCopyBar");
		var printObj = document.getElementById("ClsBillPrint");
		var c2 = String.fromCharCode(2);
		DHC_PrintByLodop(getLodop(),printParam,'',{},"");
	}catch(e){
		alert('~{4rS!LuBk4mNs#:~}' + e.message);
	}
	
}
//~{4rS!84S!5G<GHHCtLu~}
function PrintSerialNumber(RecordID)
{
	try{
		var IsCopyPrintSerialNumber = ExtTool.RunServerMethod("DHCWMR.SSService.ConfigSrv","GetValueByKeyHosp",'IsCopyPrintSerialNumber'); //~{JG7qFtSC4rS!~}
		if (IsCopyPrintSerialNumber==0) return;
		var strPrinterName = ExtTool.RunServerMethod("DHCWMR.SSService.ConfigSrv","GetValueByKeyHosp",'BarCodePrinterName');  //~{H!4rS!HHCtLuC{3F~}
		if (strPrinterName=='') strPrinterName='Epson';
		var strPrintInfo = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","GetPrintInfo",RecordID);
		if (strPrintInfo == '') return;
		var arrPrintInfo = strPrintInfo.split("^");
		/*var Bar;
		Bar = new ActiveXObject("DHCMedBarCode.PrintBarMRCopy");
		Bar.PrinterName = strPrinterName;  //~{4rS!;zC{3F~}
		Bar.PrinterPort = "";              //~{4rS!;z6K?Z:E~}
		Bar.SetPrinter();                  //~{IhVC4rS!;z~}
		Bar.vMrType      = arrPrintInfo[0];
		Bar.vMrNo        = arrPrintInfo[1];
		Bar.vPatientName = arrPrintInfo[2];
		Bar.vBarCode	 = arrPrintInfo[3];
		Bar.vRegditDate  = arrPrintInfo[4];
		Bar.vNumber		 = arrPrintInfo[5];
		Bar.PrintCopySerialNumber();*/
		
		var printParam="";
		// ~{4rS!2NJ}~}
		printParam=printParam+"^MrType"+String.fromCharCode(2)+arrPrintInfo[0];
		printParam=printParam+"^MrNo"+String.fromCharCode(2)+arrPrintInfo[1];
		printParam=printParam+"^PatientName"+String.fromCharCode(2)+arrPrintInfo[2];
		printParam=printParam+"^BarCode"+String.fromCharCode(2)+arrPrintInfo[3];
		printParam=printParam+"^RegditDate"+String.fromCharCode(2)+arrPrintInfo[4];
		printParam=printParam+"^Number"+String.fromCharCode(2)+arrPrintInfo[5];
		// ~{;qH!~}XML~{D#0eEdVC~}
		DHCP_GetXMLConfig("InvPrintEncrypt","WMRCopyBar");
		var printObj = document.getElementById("ClsBillPrint");
		var c2 = String.fromCharCode(2);
		DHC_PrintByLodop(getLodop(),printParam,'',{},"");
	}catch(e){
		alert('~{4rS!HHCtPr:E4mNs#:~}'+e.message);
	}
}

function PrintBill(InvRowID,User,PayModeID)
{
	
	try{
		DHCP_GetXMLConfig("InvPrintEncrypt","INVPrtFlag2007");
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		var UserID=session['LOGON.USERID'];
		var Printinfo=ExtTool.RunServerMethod("web.UDHCOPINVPrtMedical","GetOPPrtData","InvPrint",InvRowID,UserID,PayModeID,"INVPrtFlag2007");
		
	}catch(e)
	{
		alert('~{4rS!7"F14mNs#:~}'+e.message);
	}
}
function InvPrint(TxtInfo,ListInfo)
{
	var objClsBill=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(objClsBill,TxtInfo,ListInfo);	
}

