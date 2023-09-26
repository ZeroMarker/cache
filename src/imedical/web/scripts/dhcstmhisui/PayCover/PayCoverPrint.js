function PrintPayCoverByIncsc(CoverId){
	if(CoverId==null||CoverId==''){
		return;
	}
	var RaqName = "DHCSTM_HUI_PayCover_Common.raq";
	var DirectPrintStr = '{' + RaqName + '(CoverId=' + CoverId + ')}';
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	if (PayCoverParamObj.IndirPrint != "N") {
		DHCSTM_DHCCPM_RQPrint(RQPrintStr);
	} else {
		DHCCPM_RQDirectPrint(DirectPrintStr);
	}
}
function PrintPayCoverByVendor(CoverId){
	if(CoverId==null||CoverId==''){
		return;
	}
	var RaqName = "DHCSTM_HUI_PayCoverVendor.raq";
	var DirectPrintStr = '{' + RaqName + '(CoverId=' + CoverId + ')}';
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	if (PayCoverParamObj.IndirPrint != "N") {
		DHCSTM_DHCCPM_RQPrint(RQPrintStr);
	} else {
		DHCCPM_RQDirectPrint(DirectPrintStr);
	}
}