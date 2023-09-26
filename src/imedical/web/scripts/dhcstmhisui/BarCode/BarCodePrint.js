// �����ӡjs

/**
 * �����ӡ���÷���
 * @param {��ֵ����} barcode
 * @param {��ӡ����} Times
 */
 function PrintBarcode(barcode, Times){
	if(HVBarcodePrintMethod==0){
		LodopPrintBarcode(barcode, Times);
	}else{
		XMLPrintBarcode(barcode, Times)
	}
}
 function LodopPrintBarcode(barcode, Times){
	if(Times == undefined){
		Times = 1;
	}
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCSTM_Barcode")
	var inpara = "";
	inpara = $.cm({ClassName:"web.DHCSTMHUI.DHCItmTrack",MethodName:"GetPrintBarcodeInfo",Barcode:barcode,dataType:"text"},false);
	for(var i = 1; i <= Times; i++){
		//���þ����ӡ����
		DHC_PrintByLodop(getLodop(),inpara,"",[],"��ֵ�����ӡ",{printListByText:true});
	}
 }
 function LodopPrintBarcodeOld(barcode, Times){
	if(Times == undefined){
		Times = 1;
	}
	//��ֵ��Ϣ
	var DHCITInfo = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'Select', barcode);
	if(isEmpty(DHCITInfo)){
		Msg.info('error', '��ȡ��ӡ��Ϣʧ��!');
		return false;
	}
	DHCITInfo=$.parseJSON(DHCITInfo);
	var IncDesc = DHCITInfo.incidesc;
	var BatNo = DHCITInfo.batno;
	var ExpDate = DHCITInfo.expdate;
	var	Spec = DHCITInfo.spec;
	var Sp = DHCITInfo.sp;
	var Rp = DHCITInfo.rp;
	var Brand = DHCITInfo.Brand;
	var OriginalCode = DHCITInfo.OriginalCode;
	var OldOriginalCode = DHCITInfo.OldOriginalCode;
	//�����ӡ��־
	var PrintFlag = "Y";
	SavePrintFlag(PrintFlag, barcode);

	/*�ж�Lodop�ؼ�*/
	var LODOP=getLodop();
	/*��ʼ��*/
	LODOP.PRINT_INIT("��ֵ�����ӡ");
	var intOrient=1; //��ӡ����
	var PageWidth=794; //���ӵ�λ,Ĭ��0.1mm
	var PageHeight=317; //���ӵ�λ,Ĭ��0.1mm
	var strPageName="A4"; //��width��height��������ʱ��������
	LODOP.SET_PRINT_PAGESIZE(intOrient, PageWidth,PageHeight,strPageName)
	LODOP.SET_PRINT_STYLE("FontSize", 11); //��λ��pt
	
	/*ģ������-����*/
	var type="2";  //1һά���ӡ 2��ά���ӡ
	//һά��
	if(type==1){
		LODOP.ADD_PRINT_BARCODE(5,55,200,60,"128B",barcode);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",18);
		LODOP.ADD_PRINT_TEXT(70,15,100,20,"����:"+IncDesc);
		LODOP.ADD_PRINT_TEXT(70,150,100,20,"���:"+Spec);
		LODOP.ADD_PRINT_TEXT(95,15,100,20,"����:"+BatNo);
		LODOP.ADD_PRINT_TEXT(95,150,100,20,"Ч��:"+ExpDate);
	}
	//��ά��
	if(type==2){
		LODOP.ADD_PRINT_BARCODE(5,25,130,130,"QRCode",barcode);
		LODOP.SET_PRINT_STYLEA(0,"GroundColor","#0080FF");
		LODOP.ADD_PRINT_TEXT(5,150,100,20,"����:"+barcode);
		LODOP.ADD_PRINT_TEXT(25,150,100,20,"����:"+IncDesc);
		LODOP.ADD_PRINT_TEXT(45,150,100,20,"���:"+Spec);
		LODOP.ADD_PRINT_TEXT(65,150,100,20,"����:"+BatNo);
		LODOP.ADD_PRINT_TEXT(85,150,100,20,"Ч��:"+ExpDate);
	}
	LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Width");  //������
	LODOP.SET_PRINT_COPIES(Times)  //���ô�ӡ����
	
	LODOP.PREVIEW();  //Ԥ����ӡ
}

function XMLPrintBarcode(barcode, Times){
	DHCP_GetXMLConfig("DHCSTM_Barcode");
	if(Times == undefined){
		Times = 1;
	}
	var DHCITInfo = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'Select', barcode);
	if(isEmpty(DHCITInfo)){
		Msg.info('error', '��ȡ��ӡ��Ϣʧ��!');
		return false;
	}
	DHCITInfo=$.parseJSON(DHCITInfo);
	var IncDesc = DHCITInfo.incidesc, BatNo = DHCITInfo.batno
		ExpDate = DHCITInfo.expdate, Spec = DHCITInfo.spec, 
		Sp = DHCITInfo.sp, Rp = DHCITInfo.rp, 
		Brand = DHCITInfo.Brand, OriginalCode = DHCITInfo.OriginalCode,
		OldOriginalCode = DHCITInfo.OldOriginalCode;
	
	var MyPara = 'BarCode' + String.fromCharCode(2) + "*" + barcode + "*"
		+ '^IncDesc' + String.fromCharCode(2) + IncDesc
		+ '^Brand' + String.fromCharCode(2) + Brand
		+ '^Spec' + String.fromCharCode(2) + Spec
		+ '^Rp' + String.fromCharCode(2) + Rp
		+ '^Sp' + String.fromCharCode(2) + Sp
		+ '^BatNo' + String.fromCharCode(2) + BatNo
		+ '^ExpDate' + String.fromCharCode(2) + ExpDate;
	
	var BarcodeStr = barcode+"^"+OriginalCode+"^"+IncDesc;
	for(var i = 1; i <= Times; i++){
		//���þ����ӡ����
		DHCP_PrintFun(MyPara, "");
		//PrintBarcodePDF(BarcodeStr);
	}
	var PrintFlag = "Y";
	SavePrintFlag(PrintFlag, barcode);
}

//PDF417��ӡ
//��ע��DHCSTMBarcode.dll
function PrintBarcodePDF(BarcodeStr){
	var Bar=new ActiveXObject("DHCSTMBarcode.GZBarcode");
	Bar.Device = "GZTiaoMa"
	Bar.PageWidth = 7
	Bar.PageHeight = 5
	Bar.HeadFontSize = 12
	Bar.FontSize = 8
	Bar.Title = "��ֵ����"
	Bar.HeadType = ""
	Bar.IfPrintBar = true
	Bar.BarTop = 37
	Bar.BarLeftMarg = 12
	Bar.BarFontSize = 20
	Bar.PageSpaceItm = 2
	Bar.ItmFontSize = 8
	Bar.ItmCharNums = 33			//ÿ����ʾ���ַ���
	Bar.ItmOmit = false				//�����Ƿ�ȡ��ֻ��ӡһ��
	Bar.PageMainStr = BarcodeStr	//��ӡ��ǩ����Ϣ
	Bar.PageLeftMargine = 3
	Bar.PageItmStr = ""
	Bar.PageSpace = 1
	Bar.BarWidth = 27
	Bar.BarHeight = 9
	Bar.PrintDPage();
}

function SavePrintFlag(PrintFlag, Barecode) {
	tkMakeServerCall("web.DHCSTMHUI.DHCItmTrack", "SavePrintFlag", PrintFlag, Barecode);
}