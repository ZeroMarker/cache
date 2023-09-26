var gHospId=session['LOGON.HOSPID'];
 var gUserId = session['LOGON.USERID'];
function PrintINScrap(inscrap, AutoFlag){
	if(inscrap==null || inscrap==''){
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
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
	var INScrapRemark=mainArr[6];
	
	fileName="{DHCSTM_INScrap_Common.raq(Parref="+inscrap+")}";
	if(InScrapParamObj.IndirPrint!="N")
	{
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
	Common_PrintLog('D', inscrap, AutoFlag);
}

function GetMainData(inscrap){
	var mainData="";
	if(inscrap==null || inscrap==''){
		return;
	}
	
	var url='dhcstm.inscrapaction.csp?actiontype=Select'+'&InscpId='+inscrap;
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
function PrintMBPL(inscrap,HospID,user){
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
}