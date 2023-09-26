function PrintStkMon(growid,activeTabtmp){
	if(growid==null || growid==""){
		return;
		}
	var mainData=GetMainData(growid);	
	if(mainData==null || mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var month=mainArr[0]
	var LocDesc=mainArr[1]
	var fromdate=mainArr[2]
	var todate=mainArr[3]
	var createdate=mainArr[4]
	var createUser=mainArr[5]
	var fromTime=mainArr[6]
	var toTime=mainArr[7]
	var createTime=mainArr[8]
	var stkgrpid=Ext.getCmp("StkGrpType").getValue();
	var stkcatid=Ext.getCmp("IncStkCat").getValue();
	var incdesc=Ext.getCmp("IncDesc").getValue();
	var RQDTFormat=App_StkRQDateFormat; //+" "+App_StkRQTimeFormat;
			if(activeTabtmp.id=="ReportDetailSp"){
				//fileName="{DHCST_ReportDetailSp_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate+";createdate="+createdate+";createUser="+createUser+";fromTime="+fromTime+";toTime="+toTime+";createTime="+createTime+";stkgrpid="+stkgrpid+";stkcatid="+stkcatid+";incdesc="+incdesc+";RQDTFormat="+RQDTFormat+";HospDesc="+App_LogonHospDesc+")}";
				fileName="{DHCST_ReportDetailSp_Common.raq(growid="+growid+";stkgrpid="+stkgrpid+";stkcatid="+stkcatid+";RQDTFormat="+RQDTFormat+")}";
			}else if(activeTabtmp.id=="ReportDetailRp"){
				//fileName="{DHCST_ReportDetailRp_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate+";createdate="+createdate+";createUser="+createUser+";fromTime="+fromTime+";toTime="+toTime+";createTime="+createTime+";stkgrpid="+stkgrpid+";stkcatid="+stkcatid+";incdesc="+incdesc+";RQDTFormat="+RQDTFormat+";HospDesc="+App_LogonHospDesc+")}";
				fileName="{DHCST_ReportDetailRp_Common.raq(growid="+growid+";stkgrpid="+stkgrpid+";stkcatid="+stkcatid+";RQDTFormat="+RQDTFormat+")}";
			}else if(activeTabtmp.id=="ReportDetailLbSp" || activeTabtmp.id=="ReportDetailLbRp"){
				//fileName="{DHCST_ReportDetailLb_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate+";createdate="+createdate+";createUser="+createUser+";fromTime="+fromTime+";toTime="+toTime+";createTime="+createTime+";stkgrpid="+stkgrpid+";stkcatid="+stkcatid+";incdesc="+incdesc+";RQDTFormat="+RQDTFormat+";HospDesc="+App_LogonHospDesc+")}";
				fileName="{DHCST_ReportDetailLb_Common.raq(growid="+growid+";stkgrpid="+stkgrpid+";stkcatid="+stkcatid+";RQDTFormat="+RQDTFormat+")}";
			}else if(activeTabtmp.id=="ReportDetailSCGRp"){
				//fileName="{DHCST_ReportDetailSCGRp_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate+";createdate="+createdate+";createUser="+createUser+";fromTime="+fromTime+";toTime="+toTime+";createTime="+createTime+";Type="+0+";RQDTFormat="+RQDTFormat+";HospDesc="+App_LogonHospDesc+")}";
				fileName="{DHCST_ReportDetailSCGRp_Common.raq(growid="+growid+";Type="+0+";RQDTFormat="+RQDTFormat+")}";
			}else if(activeTabtmp.id=="ReportDetailSCG"){
				//fileName="{DHCST_ReportDetailSCGRp_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate+";createdate="+createdate+";createUser="+createUser+";fromTime="+fromTime+";toTime="+toTime+";createTime="+createTime+";Type="+1+";RQDTFormat="+RQDTFormat+";HospDesc="+App_LogonHospDesc+")}";
				fileName="{DHCST_ReportDetailSCGRp_Common.raq(growid="+growid+";Type="+1+";RQDTFormat="+RQDTFormat+")}";
			}else if(activeTabtmp.id=="ReportDetailCat"){
				//fileName="{DHCST_ReportDetailCat_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate+";createdate="+createdate+";createUser="+createUser+";fromTime="+fromTime+";toTime="+toTime+";createTime="+createTime+";Type="+1+";RQDTFormat="+RQDTFormat+";HospDesc="+App_LogonHospDesc+")}";
				fileName="{DHCST_ReportDetailCat_Common.raq(growid="+growid+";Type="+1+";RQDTFormat="+RQDTFormat+")}";
			}else if(activeTabtmp.id=="ReportDetailCatRp"){
				//fileName="{DHCST_ReportDetailCat_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate+";createdate="+createdate+";createUser="+createUser+";fromTime="+fromTime+";toTime="+toTime+";createTime="+createTime+";Type="+0+";RQDTFormat="+RQDTFormat+";HospDesc="+App_LogonHospDesc+")}";
				fileName="{DHCST_ReportDetailCat_Common.raq(growid="+growid+";Type="+0+";RQDTFormat="+RQDTFormat+")}";
			}else{
				//fileName="{DHCST_ReportDetailSp_Common.raq(growid="+growid+";LocDesc="+LocDesc+";fromdate="+fromdate+";todate="+todate+";createdate="+createdate+";createUser="+createUser+";fromTime="+fromTime+";toTime="+toTime+";createTime="+createTime+";stkgrpid="+stkgrpid+";stkcatid="+stkcatid+";incdesc="+incdesc+";RQDTFormat="+RQDTFormat+";HospDesc="+App_LogonHospDesc+")}";
				fileName="{DHCST_ReportDetailSp_Common.raq(growid="+growid+";stkgrpid="+stkgrpid+";stkcatid="+stkcatid+";RQDTFormat="+RQDTFormat+")}";
			}
	DHCCPM_RQDirectPrint(fileName);
		}
	

	
function GetMainData(growid){
	var mainData="";
	if(growid==null || growid==''){
		return;
	}
	var url='dhcst.stkmonaction.csp?actiontype=getMain&rowid='+growid ;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
	
	}	