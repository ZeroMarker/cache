// /名称: 付款封面打印
// /描述: 付款封面打印
// /编写者：zhangxiao
// /编写日期: 2017.10.20

function PrintPayCover(CoverId){
	if(CoverId==null||CoverId==''){
		return;
	}
	
	var mainData=GetMainData(CoverId);	
	if(mainData==null || mainData==""){
		return;
	}	
	var mainArr=mainData.split("^");
	var cvrno=mainArr[1]
	var locdesc=mainArr[2]
	var date=mainArr[3]
	var time=mainArr[4]
	var user=mainArr[5]
	var month=mainArr[6]
	var vouchercount=mainArr[7]
	var rpamt=mainArr[8]
	//rpamt=parseFloat(rpamt)
	var spamt=mainArr[9]
	fileName="{DHCSTM_PayCover_Common.raq(Parref="+CoverId+";cvrno="+cvrno+";locdesc="+locdesc+";date="+date+";time="+time+";user="+user+";month="+month+";vouchercount="+vouchercount+";rpamt="+rpamt+";HospDesc="+App_LogonHospDesc+")}";
	DHCCPM_RQDirectPrint(fileName);
	}
function PrintPayCover2(CoverId){
	if(CoverId==null||CoverId==''){
		return;
	}
	
	var mainData=GetMainData(CoverId);	
	if(mainData==null || mainData==""){
		return;
	}	
	var mainArr=mainData.split("^");
	var cvrno=mainArr[1]
	var locdesc=mainArr[2]
	var date=mainArr[3]
	var time=mainArr[4]
	var user=mainArr[5]
	var month=mainArr[6]
	var vouchercount=mainArr[7]
	var rpamt=mainArr[8]
	//rpamt=parseFloat(rpamt)
	var spamt=mainArr[9]
	fileName="{DHCSTM_PayCoverVendor.raq(Parref="+CoverId+";cvrno="+cvrno+";locdesc="+locdesc+";date="+date+";time="+time+";user="+user+";month="+month+";vouchercount="+vouchercount+";rpamt="+rpamt+";HospDesc="+App_LogonHospDesc+")}";
	DHCCPM_RQDirectPrint(fileName);
}			
///取主表信息	
function GetMainData(CoverId){
	var mainData="";
	if(CoverId==null || CoverId==''){
		return;
	}
	var url='dhcstm.paycoveraction.csp?actiontype=Select&CoverId='+CoverId;	
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	return mainData;
}	