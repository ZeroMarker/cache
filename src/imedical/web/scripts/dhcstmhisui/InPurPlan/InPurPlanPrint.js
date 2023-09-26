function PrintInPurPlan(PurId, AutoFlag){
	if(isEmpty(PurId)){
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	fileName="{DHCSTM_HUI_INPurPlan_Common.raq(Parref="+PurId+")}";
	if(InPurPlanParamObj.IndirPrint!="N"){
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
	Common_PrintLog('INPP', PurId, AutoFlag);
}