function PrintInPur(Parref,zbFlag)
{
	if(Parref==null||Parref==''){
		return;
		}
		//alert(Parref)
		
	var mainData=GetMainData(Parref);	
	if(mainData==null || mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var InPurPlanLoc=mainArr[3]
	var InpoNo=mainArr[1]
	var user=mainArr[6]
	var InpoDate=mainArr[4]
	//alert(ZBFlag)
	if (zbFlag==1){PzbFlag=""}
	else if (zbFlag==2){PzbFlag="招标"}
	else {PzbFlag="非招标"}
	
	//fileName="{DHCST_INPurPlan_Common.raq(Parref="+Parref+";InPurPlanLoc="+InPurPlanLoc+";InpoNo="+InpoNo+";user="+user+";InpoDate="+InpoDate+";PzbFlag="+PzbFlag+";HospDesc="+App_LogonHospDesc+")}";
	fileName="{DHCST_INPurPlan_Common.raq(Parref="+Parref+";InpoNo="+InpoNo+";InpoDate="+InpoDate+";zbFlagIO="+zbFlag+")}";
	//alert(fileName)
	DHCCPM_RQDirectPrint(fileName);
			
	}
	
function GetMainData(Parref)
{
	var mainData="";
	if(Parref==null || Parref==''){
		return;
	}
	var url='dhcst.inpurplanaction.csp?actiontype=SelectMain&Parref='+Parref;
	
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	//alert(mainData)
	return mainData;
	}	