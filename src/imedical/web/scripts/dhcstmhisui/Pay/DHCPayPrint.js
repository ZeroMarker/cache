//¸¶¿îµ¥´òÓ¡
function PrintPay(Pay) {
	if (Pay == null || Pay == '') {
		return;
	}
	var RaqName = "DHCSTM_HUI_Pay_Common.raq";
	var DirectPrintStr = '{' + RaqName + '(Pay=' + Pay + ')}';
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	if (PayParamObj.IndirPrint != 'N') {
		DHCSTM_DHCCPM_RQPrint(RQPrintStr);
	} else {
		DHCCPM_RQDirectPrint(DirectPrintStr);
	}
}