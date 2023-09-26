//发票组合单打印
function PrintInv(Inv) {
	if (Inv == null || Inv == '') {
		return;
	}
	var RaqName = "DHCSTM_HUI_Inv_Common.raq";
	var DirectPrintStr = '{' + RaqName + '(Inv=' + Inv + ')}';
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	if (InvParamObj.IndirPrint != "N") {
		DHCSTM_DHCCPM_RQPrint(RQPrintStr);
	} else {
		DHCCPM_RQDirectPrint(DirectPrintStr);
	}
}