// �����ӡjs

/**
 * �����ӡ���÷���
 * @param {��ֵ����} barcode
 * @param {��ӡ����} Times
 */
function PrintBarcode(barcode, Times){
	if(Times == undefined){
		Times = 1;
	}
	var DHCITInfo = tkMakeServerCall('web.DHCSTM.DHCItmTrack', 'Select', barcode);
	if(Ext.isEmpty(DHCITInfo)){
		Msg.info('error', '��ȡ��ӡ��Ϣʧ��!');
		return false;
	}
	var DHCITInfoArr = DHCITInfo.split('^');
	var IncDesc = DHCITInfoArr[0], BatNo = DHCITInfoArr[5],
		ExpDate = DHCITInfoArr[6], Spec = DHCITInfoArr[7], Sp = DHCITInfoArr[8], Rp = DHCITInfoArr[9], 
		Brand = DHCITInfoArr[14], OriginalCode = DHCITInfoArr[15],
		OldOriginalCode = DHCITInfoArr[16];
	
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
	tkMakeServerCall("web.DHCSTM.DHCItmTrack", "SavePrintFlag", PrintFlag, Barecode);
}