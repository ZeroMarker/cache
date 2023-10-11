//库存调整单打印

/*
 * description:打印单个库存调整单（润乾）
 * params: inadj:库存调整主表id
 * return:
 * */
function PrintInAdj(inadj){
	
	if(inadj==null || inadj==''){
		return;
	}
	
	var mainData=GetMainData(inadj);
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var InadjLoc=mainArr[0];
	var InadjNo=mainArr[1];
	var InadjDate=mainArr[2];
	var InadjUser=mainArr[3];;
	var InadjUserIO=mainArr[4];
	var InadjLocIO=mainArr[5];
	
	var RQDTFormat=App_StkRQDateFormat  //+" "+App_StkRQTimeFormat;
	fileName="{DHCST_InAdj_Common.raq(adj="+inadj+";InadjLocIO="+InadjLocIO+";InadjNo="+InadjNo+";InadjDate="+InadjDate+";InadjUserIO="+InadjUserIO+";HospDescIO="+session['LOGON.HOSPID']+";RQDTFormat="+RQDTFormat+")}";
	DHCCPM_RQDirectPrint(fileName);
}

function GetMainData(inadj){
	var mainData="";
	if(inadj==null || inadj==''){
		return;
	}
	
	var url="dhcst.inadjaction.csp?actiontype=select&adj="+inadj;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.results>0) {
		data=jsonData.rows  ;
		if (!data) return;
		var InadjLoc=data[0]['locDesc'];
		var InadjNo=data[0]['INAD_No'];
		var InadjDate=data[0]['INAD_Date'];
		var InadjUser=data[0]['userName'];
		var InadjUserID=data[0]['userNameId'];
		var InadjLocID=data[0]['locDescId'];
		
		mainData=InadjLoc+"^"+InadjNo+"^"+InadjDate+"^"+InadjUser+"^"+InadjUserID+"^"+InadjLocID
	}
	return mainData;
}
