function PrintStkMon(growid,activeTabtmp){
	if(growid==null || growid==""){
		return;
	}
		
	var mainData=GetMainData(growid);
	if(mainData==null || mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var LocId=mainArr[2];
	var month=mainArr[10];
	var LocDesc=mainArr[11];
	var fromdate=mainArr[12];
	var todate=mainArr[13];
	var createdate=mainArr[14];
	var createUser=mainArr[15];
	var fromTime=mainArr[16];
	var toTime=mainArr[17];
	var createTime=mainArr[18];
	var stkgrpid=Ext.getCmp("StkGrpType").getValue();
	var stkcatid=Ext.getCmp("IncStkCat").getValue();
	var incdesc=Ext.getCmp("IncDesc").getValue();
	var startDate=toDate(fromdate).format(ARG_DATEFORMAT);
	var endDate=toDate(todate).format(ARG_DATEFORMAT);
	var fileName="";
	if(activeTabtmp.id=="ReportDetailSp"){
		fileName="{DHCSTM_ReportDetailSp_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate
		+";createdate="+createdate+";createUser="+createUser+";fromTime="+fromTime+";toTime="+toTime+";createTime="+createTime
		+";stkgrpid="+stkgrpid+";stkcatid="+stkcatid+";incdesc="+incdesc+";HospDesc="+App_LogonHospDesc+";Month="+month+")}";
	}else if(activeTabtmp.id=="ReportDetailRp"){
		fileName="{DHCSTM_ReportDetailRp_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate
		+";createdate="+createdate+";createUser="+createUser+";fromTime="+fromTime+";toTime="+toTime+";createTime="+createTime
		+";stkgrpid="+stkgrpid+";stkcatid="+stkcatid+";incdesc="+incdesc+";HospDesc="+App_LogonHospDesc+";Month="+month+")}";
	}else if(activeTabtmp.id=="ReportDetailLbSp"){
		fileName="{DHCSTM_ReportDetailLb_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate
		+";createdate="+createdate+";createUser="+createUser+";fromTime="+fromTime+";toTime="+toTime+";createTime="+createTime
		+";stkgrpid="+stkgrpid+";stkcatid="+stkcatid+";incdesc="+incdesc+";HospDesc="+App_LogonHospDesc+";Month="+month+")}";
	}else if( activeTabtmp.id=="ReportDetailLbRp"){
		fileName="{DHCSTM_ReportDetailLbRp_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate
		+";createdate="+createdate+";createUser="+createUser+";fromTime="+fromTime+";toTime="+toTime+";createTime="+createTime
		+";stkgrpid="+stkgrpid+";stkcatid="+stkcatid+";incdesc="+incdesc+";HospDesc="+App_LogonHospDesc+";Month="+month+")}";
	}else{
		fileName="";
		Msg.info("warning","请使用报表上面的打印功能!");
	}
	if(fileName!=""){
		DHCCPM_RQDirectPrint(fileName);
	}
}

function GetMainData(growid){
	var mainData="";
	if(growid==null || growid==''){
		return;
	}
	var url='dhcstm.stkmonaction.csp?actiontype=getMain&rowid='+growid ;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
}