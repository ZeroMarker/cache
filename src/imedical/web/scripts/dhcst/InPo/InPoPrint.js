function PrintInPo(Parref)
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
	var inpono=mainArr[1]
	var date=mainArr[34]
	var user=mainArr[30]
	var PoLocDesc=mainArr[26]  //£»
	var VenDesc=mainArr[29]
	var RQDTFormat=App_StkRQDateFormat;  //+" "+App_StkRQTimeFormat;
	//alert(inpono+" "+date+" "+user+" "+PoLocDesc+" "+VenDesc) 
	//fileName="{DHCST_INPO_Common.raq(Parref="+Parref+";inpono="+inpono+";date="+date+";user="+user+";PoLocDesc="+PoLocDesc+";VenDesc="+VenDesc+";HospDesc="+App_LogonHospDesc+";RQDTFormat="+RQDTFormat+")}";
	fileName="{DHCST_INPO_Common.raq(Parref="+Parref+";inpono="+inpono+";date="+date+";RQDTFormat="+RQDTFormat+")}";
	DHCCPM_RQDirectPrint(fileName);
	//fileName="DHCST_INPO_Common.raq&Parref="+Parref+"&inpono="+inpono+"&date="+date+"&user="+user+"&PoLocDesc="+PoLocDesc+"&VenDesc="+VenDesc+"&HospDesc="+App_LogonHospDesc+"&RQDTFormat="+RQDTFormat;
	//DHCCPM_RQPrint(fileName);
	}
	
	
function GetMainData(Parref)
 {
	var mainData="";
	if(Parref==null || Parref==''){
		return;
	}
	var url='dhcst.inpoaction.csp?actiontype=SelectMain&Parref='+Parref;
 
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
	}	