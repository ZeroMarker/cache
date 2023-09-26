//物资发放单打印

/*
 * description:打印单个物资发放单（润乾）
 * params: indisp:科室内物资发放主表id
 * return:
 * */
function PrintInDisp(indisp){
	
	if(indisp==null || indisp==''){
		return;
	}
	
	var mainData=GetMainData(indisp);
	if(mainData==""){
		return;
	}
	
	var fileName = "{DHCSTM_InDisp_Common.raq(indisp="+indisp+")}";
	if(InDispParamObj.IndirPrint!="N")
	{
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
}

function GetMainData(indisp){
	var mainData="";
	if(indisp==null || indisp==''){
		return;
	}
	
	var url="dhcstm.indispaction.csp?actiontype=select&disp="+indisp;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.results>0) {
		data=jsonData.rows  ;
		if (!data) return;
		var InDispLoc=data[0]['locDesc'];
		var InDispSCG=data[0]['scgDesc'];
		var InDispNo=data[0]['INDS_No'];
		var InDispMode=data[0]['INDS_DispMode'];
		var InDispRecUser=data[0]['DispRecUser'];	//领用人
		var InDispGrp=data[0]['LUG_GroupDesc'];
		
		var InDispDate=data[0]['INDS_Date'];
		var InDispTime=data[0]['INDS_Time'];
		var InDispUser=data[0]['userName'];
		var InDispRqNo=data[0]['dsrqNo'];
		var InDispRemarks=data[0]['INDS_Remarks'];
		mainData=InDispLoc+"^"+InDispSCG+"^"+InDispNo+"^"+InDispMode+"^"+InDispRecUser
				+"^"+InDispGrp+"^"+InDispDate+"^"+InDispTime+"^"+InDispUser+"^"+InDispRqNo
				+"^"+InDispRemarks;
	}
	return mainData;
}
