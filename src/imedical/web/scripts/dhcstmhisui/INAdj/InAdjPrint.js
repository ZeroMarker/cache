//库存调整单打印
function PrintInAdj(InAdj, AutoFlag) {
	if (InAdj == null || InAdj == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	//var Params = JSON.stringify({InAdj:InAdj});
	var Params = ""; 
	var RQStr=InAdj
	fileName="{DHCSTM_HUI_InAdj_Common.raq(Params="+Params+";adj="+InAdj+";RQStr=" + RQStr + ")}";
	if(InAdjParamObj.IndirPrint!="N"){
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
	Common_PrintLog('A', InAdj, AutoFlag);
}