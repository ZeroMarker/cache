//物资请领单打印

/*
 * description:打印单个物资请领单（润乾）
 * params: parref:科室内物资请领主表id
 * return:
 * */
function PrintINDispReq(parref){
	
	if(parref==null || parref==''){
		return;
	}
	
	var mainData=GetMainData(parref);
	if(mainData==""){
		return;
	}
	
	var mainArr=mainData.split("^");
	var DispReqNo=mainArr[1],DispReqLoc=mainArr[3],DispReqSCG=mainArr[5];
	var DispReqDate=mainArr[6],DispReqTime=mainArr[7],DispReqUser=mainArr[9];
	var DispReqMode=mainArr[10],DispReqGrp=mainArr[16];
	
	var Act="";		//sort^dir
	fileName="{DHCSTM_InDispReq_Common.raq(DSRQ="+parref+";Act="+Act+";HospDesc="+App_LogonHospDesc
		+";DispReqNo="+DispReqNo+";DispReqLoc="+DispReqLoc+";DispReqSCG="+DispReqSCG
		+";DispReqDate="+DispReqDate+";DispReqTime="+DispReqTime+";DispReqUser="+DispReqUser
		+";DispReqMode="+DispReqMode+";DispReqGrp="+DispReqGrp
		+")}";
	if(InDispReqParamObj.IndirPrint!="N")
	{
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
}

function GetMainData(parref){
	var mainData="";
	if(parref==null || parref==''){
		return;
	}
	
	var url="dhcstm.indispreqaction.csp?actiontype=SelectDsReq&dsrq="+parref;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
}
