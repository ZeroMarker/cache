// 条码打印js

/**
 * 条码打印公用方法
 * @param {高值条码} barcode
 * @param {打印次数} Times
 */
function PrintBarcode(barcode, Times){
	if(Times == undefined){
		Times = 1;
	}
	var DHCITInfo = tkMakeServerCall('web.DHCSTM.DHCItmTrack', 'Select', barcode);
	if(Ext.isEmpty(DHCITInfo)){
		Msg.info('error', '获取打印信息失败!');
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
		//调用具体打印方法
		DHCP_PrintFun(MyPara, "");
		//PrintBarcodePDF(BarcodeStr);
	}
	var PrintFlag = "Y";
	SavePrintFlag(PrintFlag, barcode);
}

//PDF417打印
//需注册DHCSTMBarcode.dll
function PrintBarcodePDF(BarcodeStr){
	var Bar=new ActiveXObject("DHCSTMBarcode.GZBarcode");
	Bar.Device = "GZTiaoMa"
	Bar.PageWidth = 7
	Bar.PageHeight = 5
	Bar.HeadFontSize = 12
	Bar.FontSize = 8
	Bar.Title = "高值条码"
	Bar.HeadType = ""
	Bar.IfPrintBar = true
	Bar.BarTop = 37
	Bar.BarLeftMarg = 12
	Bar.BarFontSize = 20
	Bar.PageSpaceItm = 2
	Bar.ItmFontSize = 8
	Bar.ItmCharNums = 33			//每行显示的字符数
	Bar.ItmOmit = false				//名称是否取舍只打印一行
	Bar.PageMainStr = BarcodeStr	//打印标签主信息
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