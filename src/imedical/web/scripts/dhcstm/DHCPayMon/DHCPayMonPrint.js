function PrintPayMon(growid,activeTabtmp){
	if(growid==null || growid==""){
		return;
		}
		
	var mainData=GetPayMonMain(growid);	
	if(mainData==null || mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var LocId=mainArr[3];
	var month=mainArr[2]
	var LocDesc=mainArr[4]
	var fromdate=mainArr[5]
	var todate=mainArr[6]
	var createdate=mainArr[7]
	var createUser=mainArr[8]
	var createTime=mainArr[9]
	if(activeTabtmp.id=="ReportPayMDetailRp"){
		fileName="{DHCSTM_PayMonDetailRp_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate
		+";createdate="+createdate+";createUser="+createUser+";createTime="+createTime+";HospDesc="+App_LogonHospDesc+")}";
	}
	DHCCPM_RQDirectPrint(fileName);
		}
	

	
function GetPayMonMain(growid){
	var mainData="";
	if(growid==null || growid==''){
		return;
	}
	var url='dhcstm.paymonaction.csp?actiontype=getPayMonMain&rowid='+growid ;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
	
	}	