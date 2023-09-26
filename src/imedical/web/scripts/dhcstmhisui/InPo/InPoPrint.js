function PrintInPo(PoId, AutoFlag) {
	if(isEmpty(PoId)){
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	fileName="{DHCSTM_HUI_INPO_Common.raq(Parref="+PoId+")}";
	if(InPoParamObj.IndirPrint!="N"){
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
	Common_PrintLog('PO', PoId, AutoFlag);
}
