var gHospId=session['LOGON.HOSPID'];
var gUserId = session['LOGON.USERID'];
function PrintINRequest(inreq, AutoFlag){
	if(inreq==null || inreq==''){
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var showTransfered=1;	//是否显示已转移数据
	fileName="{DHCSTM_INRequest_Common.raq(ShowTransfered="+showTransfered+";Parref="+inreq+")}";

	if(InRequestParamObj.IndirPrint!="N")
	{
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
	Common_PrintLog('RQ', inreq, AutoFlag);
}

function GetMainData(inreq){
	var mainData="";
	if(inreq==null || inreq==''){
		return;
	}
	
	var url='dhcstm.inrequestaction.csp?actiontype=select&ReqId='+inreq;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
	
}
function PrintMBPL(inreq,gHospId,gUserId){
	
     if(inreq==null || inreq==''){
        return;
    }
    var url='dhcstm.inrequestaction.csp?actiontype=PrintMBPL&ReqId='+inreq+'&HospId='+gHospId+'&user='+gUserId;
    var responseText=ExecuteDBSynAccess(url);
    var jsonData=Ext.util.JSON.decode(responseText);
    if(jsonData.success=='true'){
        mainData=jsonData.info;
        if(mainData!=0){
            Msg.info('error','插入数据失败');
        }
    }
    }