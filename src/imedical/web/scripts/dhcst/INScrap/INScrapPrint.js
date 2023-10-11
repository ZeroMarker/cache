function PrintINScrap(inscrap){
	
	if(inscrap==null || inscrap==''){
		return;
	}
	
	var mainData=GetMainData(inscrap);
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var INScrapNo=mainArr[0];
	var INScrapReason=mainArr[1];
	var INScrapDate=mainArr[2];
	var INScrapLoc=mainArr[3];
	var INScrapScg=mainArr[4];
	var INScrapUser=mainArr[5];
	var INScrapRemark=mainArr[6];  // £»
	var RQDTFormat=App_StkRQDateFormat; //+" "+App_StkRQTimeFormat;
	//fileName="{DHCST_INScrap_Common.raq(Parref="+inscrap+";INScrapNo="+INScrapNo+";INScrapReason="+INScrapReason+";INScrapDate="+INScrapDate+";INScrapLoc="+INScrapLoc+";INScrapScg="+INScrapScg+";INScrapUser="+INScrapUser+";HospDesc="+App_LogonHospDesc+";INScrapRemark="+INScrapRemark+";RQDTFormat="+RQDTFormat+")}";
	fileName="{DHCST_INScrap_Common.raq(Parref="+inscrap+";INScrapNo="+INScrapNo+";INScrapDate="+INScrapDate+";RQDTFormat="+RQDTFormat+")}";

	DHCCPM_RQDirectPrint(fileName);
}

function GetMainData(inscrap){
	var mainData="";
	if(inscrap==null || inscrap==''){
		return;
	}
	
	var url='dhcst.inscrapaction.csp?actiontype=Select'+'&InscpId='+inscrap;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responseText);
	if (jsonData.results>0) {
		data=jsonData.rows;
		if (!data) return;
		
		var INScrapNo=data[0]['INSCP_NO'];
		var INScrapReason=data[0]['reason'];
		var INScrapDate=data[0]['INSCP_Date'];
		var INScrapLoc=data[0]['locDesc'];
		var INScrapScg=data[0]['scgDesc'];
		var INScrapUser=data[0]['userName'];
		var INScrapRemark=data[0]['INSCP_Remarks'];
		
		mainData=INScrapNo+"^"+INScrapReason+"^"+INScrapDate+"^"+INScrapLoc+"^"+INScrapScg+"^"+INScrapUser+"^"+INScrapRemark;
	}
	return mainData;
}
