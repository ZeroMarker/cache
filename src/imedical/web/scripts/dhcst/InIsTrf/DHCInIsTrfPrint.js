//���ת�Ƶ���ӡ

/*
 * description:��ӡ�������ת�Ƶ�����Ǭ��
 * params: init:���ת������id
 * return:
 * */
function PrintInIsTrf(init,printtype){
	if(init==null || init==''){
		return;
	}
	var mainData=GetMainData(init);
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var InitNo=mainArr[8];
	var InitFrLocDescIO=mainArr[6];
	var InitFrLocDesc=mainArr[26];
	var InitToLocDescIO=mainArr[12];
	var InitToLocDesc=mainArr[27];
	var InitReqNo=mainArr[28];
	var InitDate=mainArr[29];
	var InitUserIO=mainArr[10];
	var InitUser=mainArr[31];
	var HospDescIO=session['LOGON.HOSPID'];
	//var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
	if (printtype==1) {
		//ֱ�Ӵ�ӡ
		fileName="{DHCST_InIsTrf_Common.raq(init="+init+";HospDescIO="+HospDescIO+";InitFrLocDescIO="+InitFrLocDescIO+";InitToLocDescIO="+InitToLocDescIO+";InitNo="+InitNo+";InitReqNo="+InitReqNo+";InitDate="+InitDate+";InitUserIO="+InitUserIO+")}";
		DHCCPM_RQDirectPrint(fileName);
		
	}
	else {
		//Ԥ����ӡ
		fileName="DHCST_InIsTrf_Common.raq&init="+init+"&HospDescIO="+HospDescIO+"&InitFrLocDescIO="+InitFrLocDescIO+"&InitToLocDescIO="+InitToLocDescIO+"&InitNo="+InitNo+"&InitReqNo="+InitReqNo+"&InitDate="+InitDate+"&InitUserIO="+InitUserIO
		DHCCPM_RQPrint(fileName);
		
	}
	
}

function GetMainData(init){
	var mainData="";
	if(init==null || init==''){
		return;
	}
	
	var url="dhcst.dhcinistrfaction.csp?actiontype=Select&Rowid="+init;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
}
