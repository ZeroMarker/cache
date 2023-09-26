
/*
 * description:打印单个凭证单（润乾）
 * params: svcrowid:凭证单id
 * return:
 * */
function PrintPayVoucher(svcrowid){
	if(svcrowid==null || svcrowid==''){
		return;
	}
	
	var mainData=GetSVCMainData(svcrowid);
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var svcTypeDesc="";
	var svcType=mainArr[2];
    if(svcType=="G")
	{
		svcTypeDesc="入库";
    }
	else
	{
		svcTypeDesc="退货";
	}
	var vendor=mainArr[15];
	var svcNo=mainArr[7];
	var svcLocDesc=mainArr[8];
	var svcmon=mainArr[10];
	var svcDate=mainArr[5];
	var svcUser=mainArr[3];
	var svcStrDate=mainArr[11];
	var svcEndDate=mainArr[12];
	var HospDesc=App_LogonHospDesc;
	var fileName="{DHCSTM_PayVoucher_Common.raq(Parref="+svcrowid+";svcrowid="+svcrowid+";HospDesc="+HospDesc+";"+
	"svcNo="+svcNo+";svcLocDesc="+svcLocDesc+";svcmon="+svcmon+";svcDate="+svcDate+";"+
	"svcUser="+svcUser+";svcStrDate="+svcStrDate+";svcEndDate="+svcEndDate+";HospDesc="+HospDesc+")}";
	if(PayParamObj.IndirPrint!="N")
	{
		transfileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(transfileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
}

function GetSVCMainData(svcrowid){
	var mainData="";
	if(svcrowid==null || svcrowid==''){
		return;
	}
	var url="dhcstm.payvoucheraction.csp?actiontype=Select&Rowid="+svcrowid;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
}

