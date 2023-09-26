
function PrintINScrap(Inscrap, AutoFlag){
	if(Inscrap==null || Inscrap==''){
		return;
	}
	
	var INScrapObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINScrap',
		MethodName: 'Select',
		Inscrap: Inscrap
	},false);
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	
	fileName="{DHCSTM_HUI_INScrap_Common.raq(Parref="+Inscrap+")}";
	if(InScrapParamObj.IndirPrint!="N")
	{
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
		Common_PrintLog('D', Inscrap, AutoFlag);
}



/*function PrintMBPL(inscrap,HospID,user){
     if(inscrap==null || inscrap==''){
        return;
    }
    var url='dhcstm.inscrapaction.csp?actiontype=PrintMBPL&inscrapRowid='+inscrap+'&HospId='+gHospId+'&user='+gUserId;
    var responseText=ExecuteDBSynAccess(url);
    var jsonData=Ext.util.JSON.decode(responseText);
    if(jsonData.success=='true'){
        mainData=jsonData.info;
        if(mainData!=0){
            Msg.info('error','≤Â»Î ˝æ› ß∞‹');
        }
    }
}*/