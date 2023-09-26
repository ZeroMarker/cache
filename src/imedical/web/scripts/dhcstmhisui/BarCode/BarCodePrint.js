// 条码打印js

/**
 * 条码打印公用方法
 * @param {高值条码} barcode
 * @param {打印次数} Times
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
		//调用具体打印方法
		DHC_PrintByLodop(getLodop(),inpara,"",[],"高值条码打印",{printListByText:true});
	}
 }
 function LodopPrintBarcodeOld(barcode, Times){
	if(Times == undefined){
		Times = 1;
	}
	//高值信息
	var DHCITInfo = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'Select', barcode);
	if(isEmpty(DHCITInfo)){
		Msg.info('error', '获取打印信息失败!');
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
	//处理打印标志
	var PrintFlag = "Y";
	SavePrintFlag(PrintFlag, barcode);

	/*判断Lodop控件*/
	var LODOP=getLodop();
	/*初始化*/
	LODOP.PRINT_INIT("高值条码打印");
	var intOrient=1; //打印方向
	var PageWidth=794; //不加单位,默认0.1mm
	var PageHeight=317; //不加单位,默认0.1mm
	var strPageName="A4"; //当width和height不起作用时，才有用
	LODOP.SET_PRINT_PAGESIZE(intOrient, PageWidth,PageHeight,strPageName)
	LODOP.SET_PRINT_STYLE("FontSize", 11); //单位是pt
	
	/*模板内容-标题*/
	var type="2";  //1一维码打印 2二维码打印
	//一维码
	if(type==1){
		LODOP.ADD_PRINT_BARCODE(5,55,200,60,"128B",barcode);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",18);
		LODOP.ADD_PRINT_TEXT(70,15,100,20,"名称:"+IncDesc);
		LODOP.ADD_PRINT_TEXT(70,150,100,20,"规格:"+Spec);
		LODOP.ADD_PRINT_TEXT(95,15,100,20,"批号:"+BatNo);
		LODOP.ADD_PRINT_TEXT(95,150,100,20,"效期:"+ExpDate);
	}
	//二维码
	if(type==2){
		LODOP.ADD_PRINT_BARCODE(5,25,130,130,"QRCode",barcode);
		LODOP.SET_PRINT_STYLEA(0,"GroundColor","#0080FF");
		LODOP.ADD_PRINT_TEXT(5,150,100,20,"条码:"+barcode);
		LODOP.ADD_PRINT_TEXT(25,150,100,20,"名称:"+IncDesc);
		LODOP.ADD_PRINT_TEXT(45,150,100,20,"规格:"+Spec);
		LODOP.ADD_PRINT_TEXT(65,150,100,20,"批号:"+BatNo);
		LODOP.ADD_PRINT_TEXT(85,150,100,20,"效期:"+ExpDate);
	}
	LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Width");  //按整宽
	LODOP.SET_PRINT_COPIES(Times)  //设置打印次数
	
	LODOP.PREVIEW();  //预览打印
}

function XMLPrintBarcode(barcode, Times){
	DHCP_GetXMLConfig("DHCSTM_Barcode");
	if(Times == undefined){
		Times = 1;
	}
	var DHCITInfo = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'Select', barcode);
	if(isEmpty(DHCITInfo)){
		Msg.info('error', '获取打印信息失败!');
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
	tkMakeServerCall("web.DHCSTMHUI.DHCItmTrack", "SavePrintFlag", PrintFlag, Barecode);
}