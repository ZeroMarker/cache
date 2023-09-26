//库存转移单打印

/*
 * description:打印单个库存转移单（润乾）
 * params: init:库存转移主表id
 * return:
 * */
 var BCInIsTrfOutParamObj = GetAppPropValue('DHCSTBCM');
function PrintInIsTrf(init){
	
	if(init==null || init==''){
		return;
	}
	
	var mainData=GetMainData(init);
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var InitNo=mainArr[8];
	var InitFrLocDesc=mainArr[26];
	var InitToLocDesc=mainArr[27];
	var InitReqNo=mainArr[28];
	var InitDate=mainArr[29];
	var InitUser=mainArr[31];
	var HospDesc=App_LogonHospDesc;
	var OperateTypeDesc=mainArr[32];
	
	fileName="{DHCSTM_InIsTrf_Common.raq(init="+init+";HospDesc="+HospDesc+";InitFrLocDesc="+InitFrLocDesc+";InitToLocDesc="+InitToLocDesc+";InitNo="+InitNo+";InitReqNo="+InitReqNo+";InitDate="+InitDate+";InitUser="+InitUser+";OperateTypeDesc="+OperateTypeDesc+")}";
	if(BCInIsTrfOutParamObj.IndirPrint!="N")
	{
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
}

function GetMainData(init){
	var mainData="";
	if(init==null || init==''){
		return;
	}
	
	var url="dhcstm.dhcinistrfaction.csp?actiontype=Select&Rowid="+init;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
}
