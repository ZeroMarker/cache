//物资发放单打印

/*
 * description:打印单个物资发放单（润乾）
 * params: indsr:科室内物资发放主表id
 * return:
 * */
function PrintDsr(indsr){
	
	if(indsr==null || indsr==''){
		return;
	}
	var mainData=GetMainData(indsr);
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var indsrLoc=mainArr[0];
	var indsrNo=mainArr[1];
	var indsrSCG=mainArr[2];
	var indsrUser=mainArr[3];
	var indsrDate=mainArr[4];
	var indsrTime=mainArr[5];
	var indsrRemark=mainArr[6];
	
	fileName="{DHCSTM_InDispRet_Common.raq(indsr="+indsr+")}";
	if(InDispReqRetParamObj.IndirPrint!="N")
	{
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
}

function GetMainData(indsr){
	var mainData="";
	if(indsr==null || indsr==''){
		return;
	}
	
	var url="dhcstm.indispretaction.csp?actiontype=select&dsr="+indsr;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.results>0) {
		data=jsonData.rows  ;
		if (!data) return;
		var indsrLoc=data[0]['locDesc'];
		var indsrNo=data[0]['DSR_No'];
		var indsrSCG=data[0]['scgDesc'];
		var indsrUser=data[0]['userName'];
		var indsrDate=data[0]['DSR_Date'];
		var indsrTime=data[0]['DSR_Time'];
		var indsrRemark=data[0]['DSR_Remark'];

		mainData=indsrLoc+"^"+indsrNo+"^"+indsrSCG+"^"+indsrUser+"^"+indsrDate
				+"^"+indsrTime+"^"+indsrRemark;
	}
	
	return mainData;
}
