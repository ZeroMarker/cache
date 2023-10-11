// �����ӡjs

/**
 * �����ӡ���÷���
 * @param {��ֵ����} barcode
 * @param {��ӡ����} Times
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
		// ���þ����ӡ����
		DHC_PrintByLodop(getLodop(), inpara, '', [], '��ֵ�����ӡ', { printListByText: true });
	}
	SavePrintFlag('Y', barcode);
}
 
function SavePrintFlag(PrintFlag, Barecode) {
	tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'SavePrintFlag', PrintFlag, Barecode);
}