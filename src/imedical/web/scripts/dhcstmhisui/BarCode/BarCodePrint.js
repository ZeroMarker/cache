// 条码打印js

/**
 * 条码打印公用方法
 * @param {高值条码} barcode
 * @param {打印次数} Times
 */
function PrintBarcode(barcode, Times) {
	LodopPrintBarcode(barcode, Times);
}
function LodopPrintBarcode(barcode, Times) {
	if (Times == undefined) {
		Times = 1;
	}
	DHCP_GetXMLConfig('InvPrintEncrypt', 'DHCSTM_Barcode');
	var inpara = '';
	inpara = $.cm({ ClassName: 'web.DHCSTMHUI.DHCItmTrack', MethodName: 'GetPrintBarcodeInfo', Barcode: barcode, dataType: 'text' }, false);
	for (var i = 1; i <= Times; i++) {
		// 调用具体打印方法
		DHC_PrintByLodop(getLodop(), inpara, '', [], '高值条码打印', { printListByText: true });
	}
	SavePrintFlag('Y', barcode);
}
 
function SavePrintFlag(PrintFlag, Barecode) {
	tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'SavePrintFlag', PrintFlag, Barecode);
}