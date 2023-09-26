


function XMLPrintLabel(Label, Times){
	DHCP_GetXMLConfig("CSSD_PackegeLabel");
	if(Times == undefined){
		Times = 1;
	}
	var PrintInfo = tkMakeServerCall('web.CSSDHUI.Pack.Package', 'GetPrintPackageLableInfo', Label);
	if(isEmpty(PrintInfo)){
		Msg.info('error', '��ȡ��ӡ��Ϣʧ��!');
		return false;
	}
	PrintInfo=$.parseJSON(PrintInfo);
	var Label=PrintInfo.label;
	var LocName=PrintInfo.LocName;
	var MyPara = 'Label' + String.fromCharCode(2) + "*" + Label + "*"
		+ '^LocName' + String.fromCharCode(2) + LocName;
	for(var i = 1; i <= Times; i++){
		//���þ����ӡ����
		DHCP_PrintFun(MyPara, "");
	}
	var PrintFlag = "Y";
	//SavePrintFlag(PrintFlag, barcode);
}

function PrintBarcode(label){
	var url="isLodop=1&label="+label
	websys_printout("CSSD_PackageLabel",url)
}
//��ӡ����ϸ��������
function printout(label,ToLoc,PotNoValue,HeatNo,PotNoSterType,packNum,PrintDetailNum){
	DHCP_GetXMLConfig("InvPrintEncrypt","CSSD_PackageLabel")
	//var LODOP = getLodop();
	//LODOP.PRINT_INIT(""); //����ϴδ�ӡԪ��
	var inpara = "";
	var inlist = "";
	inpara = $.cm({ClassName:"web.CSSDHUI.Pack.Package",MethodName:"GetPrintPackageLableInfo",label:label,ToLoc:ToLoc,PotNoValue:PotNoValue,HeatNo:HeatNo,PotNoSterType:PotNoSterType,packNum:packNum,dataType:"text"},false);
	inlist = $.cm({ClassName:"web.CSSDHUI.Pack.Package",MethodName:"GetItms",label:label,detailLine:PrintDetailNum,dataType:"text",rows:9999999},false);
	//DHC_CreateByXML(LODOP,inpara,inlist,[],"�����ӡ"),HeatNo,PotNoSterType
	//LODOP.NEWPAGE();
	//LODOP.PRINT();
	DHC_PrintByLodop(getLodop(),inpara,inlist,[],"�����ӡ",{printListByText:true});
}
//��ӡ����������е
function printExt(label,ToLoc,PotNoValue,HeatNo,PotNoSterType,PrintDetailNum){
	DHCP_GetXMLConfig("InvPrintEncrypt","CSSD_PackageLabelExt")
	//var LODOP = getLodop();
	//LODOP.PRINT_INIT(""); //����ϴδ�ӡԪ��
	var inpara = "";
	var inlist = "";
	inpara = $.cm({ClassName:"web.CSSDHUI.Pack.Package",MethodName:"GetPrintExtPackageLableInfo",label:label,ToLoc:ToLoc,PotNoValue:PotNoValue,HeatNo:HeatNo,PotNoSterType:PotNoSterType,dataType:"text"},false);
	inlist = $.cm({ClassName:"web.CSSDHUI.Pack.Package",MethodName:"GetItms",label:label,dataType:"text",rows:9999999},false);
	//DHC_CreateByXML(LODOP,inpara,inlist,[],"�����ӡ"),HeatNo,PotNoSterType
	//LODOP.NEWPAGE();
	//LODOP.PRINT();
	DHC_PrintByLodop(getLodop(),inpara,inlist,[],"������е�����ӡ",{printListByText:true});
}
//��ӡ���ŵ���������
function printlower(label,ToLoc,PotNoValue,HeatNo,PotNoSterType,packNum,PrintDetailNum){
	DHCP_GetXMLConfig("InvPrintEncrypt","CSSD_PackageLabelLower")
	//var LODOP = getLodop();
	//LODOP.PRINT_INIT(""); //����ϴδ�ӡԪ��
	var inpara = "";
	var inlist = "";
	inpara = $.cm({ClassName:"web.CSSDHUI.Pack.Package",MethodName:"GetPrintPackageLableInfo",label:label,ToLoc:ToLoc,PotNoValue:PotNoValue,HeatNo:HeatNo,PotNoSterType:PotNoSterType,packNum:packNum,dataType:"text"},false);
	inlist = $.cm({ClassName:"web.CSSDHUI.Pack.Package",MethodName:"GetItms",label:label,detailLine:PrintDetailNum,dataType:"text",rows:9999999},false);
	//DHC_CreateByXML(LODOP,inpara,inlist,[],"�����ӡ"),HeatNo,PotNoSterType
	//LODOP.NEWPAGE();
	//LODOP.PRINT();
	DHC_PrintByLodop(getLodop(),inpara,inlist,[],"���������ӡ",{printListByText:true});
}
//��ӡ������е��ϸ
function printoutnotitm(label,ToLoc,PotNoValue,HeatNo,PotNoSterType,packNum,PackAndCheck,AckUser){
	DHCP_GetXMLConfig("InvPrintEncrypt","CSSD_PackageLabelNotDetail")
	//var LODOP = getLodop();
	//LODOP.PRINT_INIT(""); //����ϴδ�ӡԪ��
	var inpara = "";
	//var inlist = "";
	inpara = $.cm({ClassName:"web.CSSDHUI.Pack.Package",MethodName:"GetPrintPackageLableInfo",label:label,ToLoc:ToLoc,PotNoValue:PotNoValue,HeatNo:HeatNo,PotNoSterType:PotNoSterType,packNum:packNum,PackAndCheck:PackAndCheck,AckUser:AckUser,dataType:"text"},false);
	//inlist = $.cm({ClassName:"web.CSSDHUI.Pack.Package",MethodName:"GetItms",label:label,dataType:"text",rows:9999999},false);
	//DHC_CreateByXML(LODOP,inpara,inlist,[],"�����ӡ")
	//LODOP.NEWPAGE();
	//LODOP.PRINT();
	DHC_PrintByLodop(getLodop(),inpara,"",[],"�����ӡ",{printListByText:true});
}
function printCodeDict(label,name,stertype){
	DHCP_GetXMLConfig("InvPrintEncrypt","CSSD_CodeLabel")
	var LODOP = getLodop();
	LODOP.PRINT_INIT(""); //����ϴδ�ӡԪ��
	var inpara = "";
	var inlist = "";
	var inpara = 'label' + String.fromCharCode(2) + label +
		'^name' + String.fromCharCode(2) + name +
		'^stertype' + String.fromCharCode(2) + stertype;
	DHC_CreateByXML(LODOP,inpara,inlist,[],"��ӡ����")
	LODOP.NEWPAGE();
	LODOP.PRINT();
}
//��ӡ��е��ϸͨ���̶���ǩ
function printitmByCodeDict(label,CodeDictName){
	DHCP_GetXMLConfig("InvPrintEncrypt","CSSD_CodeDictItem")
	//var LODOP = getLodop();
	//LODOP.PRINT_INIT(""); //����ϴδ�ӡԪ��
	var inpara = "";
	var inlist = "";
	var inpara = 'CodeDictName' + String.fromCharCode(2) + CodeDictName;
	inlist = $.cm({ClassName:"web.CSSDHUI.Pack.Package",MethodName:"GetItmsByCode",label:label,detailLine:2,dataType:"text",rows:9999999},false);
	DHC_PrintByLodop(getLodop(),inpara,inlist,[],"�����ӡ",{printListByText:true});
}