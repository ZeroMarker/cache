function PrintINRequest(inreq){
	
	if(inreq==null || inreq==''){
		return;
	}
	
	var mainData=GetMainData(inreq);	
	if(mainData==null || mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var INReqNo=mainArr[1];
	var INReqDate=mainArr[6];
	var INRecLoc=mainArr[12];
	var INReqLoc=mainArr[13];
	var INReqScg=mainArr[16];
	var INReqUser=mainArr[14];
	var INReqRemark=mainArr[10];
	var INReqType=mainArr[17];
	var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
	var showTransfered=1;	//是否显示已转移数据
	//fileName="{DHCST_INRequest_Common.raq(ShowTransfered="+showTransfered+";Parref="+inreq+";INReqNo="+INReqNo+";INReqDate="+INReqDate+";INRecLoc="+INRecLoc+";INReqLoc="+INReqLoc+";INReqScg="+INReqScg+";INReqUser="+INReqUser+";INReqRemark="+INReqRemark+";INReqType="+INReqType+";HospDesc="+App_LogonHospDesc+";RQDTFormat="+RQDTFormat+")}";
	fileName="{DHCST_INRequest_Common.raq(ShowTransfered="+showTransfered+";Parref="+inreq+";INReqNo="+INReqNo+";INReqDate="+INReqDate+";RQDTFormat="+RQDTFormat+")}";
	DHCCPM_RQDirectPrint(fileName);
	//fileName="DHCST_INRequest_Common.raq&ShowTransfered="+showTransfered+"&Parref="+inreq+"&INReqNo="+INReqNo+"&INReqDate="+INReqDate+"&INRecLoc="+INRecLoc+"&INReqLoc="+INReqLoc+"&INReqScg="+INReqScg+"&INReqUser="+INReqUser+"&INReqRemark="+INReqRemark+"&INReqType="+INReqType+"&HospDesc="+App_LogonHospDesc+"&RQDTFormat="+RQDTFormat;
	//DHCCPM_RQPrint(fileName);

}

function GetMainData(inreq){
	var mainData="";
	if(inreq==null || inreq==''){
		return;
	}
	
	var url='dhcst.inrequestaction.csp?actiontype=select&ReqId='+inreq;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
}