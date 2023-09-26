function printConsent(cstID){
	var printData="";
	/// 获取打印分诊数据
	runClassMethod("web.DHCMDTConsultQuery","GetMdtConsPrintCon",{"CstID":cstID},function(jsonString){
		printData=jsonString;
	},'json',false)
	
	if (printData=="") return;
	var myPara="";
	myPara="PatName"+String.fromCharCode(2)+printData.PatName
	myPara = myPara+"^"+"PatSex"+String.fromCharCode(2)+printData.PatSex;
	myPara = myPara+"^"+"PatAge"+String.fromCharCode(2)+printData.PatAge;
	myPara = myPara+"^"+"PatWard"+String.fromCharCode(2)+printData.PatWard;
	myPara = myPara+"^"+"PatSeatNo"+String.fromCharCode(2)+printData.PatBed;
	myPara = myPara+"^"+"CstNDate"+String.fromCharCode(2)+printData.PreDate;
	myPara = myPara+"^"+"CstNPlace"+String.fromCharCode(2)+printData.CstNPlace;
	myPara = myPara+"^"+"PatDiagDesc"+String.fromCharCode(2)+printData.PatDiag;
	myPara = myPara+"^"+"DirectLoc"+String.fromCharCode(2)+printData.CstRLoc;
	myPara = myPara+"^"+"CstRLocID"+String.fromCharCode(2)+printData.CstRLoc;   
	
	LODOP.PRINT_INIT("CST PRINT");
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCMDT_ZQTYS");
	DHC_CreateByXML(LODOP,myPara,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
	LODOP.PRINT()
	InsCsMasPrintFlag(cstID,"Z");
	return;
}


 /// 修改会诊打印标志
function InsCsMasPrintFlag(mdtID,printFlag){
	runClassMethod("web.DHCMDTConsult","InsCsMasPrintFlag",{"CstID":mdtID,"PrintFlag":printFlag},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("提示:","更新会诊打印状态失败，失败原因:"+jsonString);
		}
	},'',false)
}
