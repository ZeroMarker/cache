function PrintIngDret(ingrt){
	
	if(ingrt==null || ingrt==''){
		return;
	}
	
	var mainData=GetMainData(ingrt);
	if(mainData==null || mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var vendorIO=mainArr[1];
	var vendor=mainArr[27];
	var ingrtNo=mainArr[6];
	var ingrtLocIO=mainArr[7];
	var ingrtLoc=mainArr[28];
	var ingrtDate=mainArr[29];
	var ingrtUserIO=mainArr[8];
	var ingrtUser=mainArr[30];
	var PrintNegative=gParam[2]; 
	var qPar="" //"ingrti^desc";	//sort^dir
	var HospDescIO=session['LOGON.HOSPID'];
	var RQDTFormat=App_StkRQDateFormat  //+" "+App_StkRQTimeFormat;
	fileName="{DHCST_IngDret_Common.raq(qPar="+qPar+";INGRT="+ingrt+";vendorIO="+vendorIO+";IngrtNo="+ingrtNo+";IngrtDate="+ingrtDate+";ingrtLocIO="+ingrtLocIO+";ingrtUserIO="+ingrtUserIO+";HospDescIO="+HospDescIO+";PrintNegative="+PrintNegative+";RQDTFormat="+RQDTFormat+")}";
	DHCCPM_RQDirectPrint(fileName);
}

function GetMainData(ingrt){
	var mainData="";
	if(ingrt==null || ingrt==''){
		return;
	}
	
	var url='dhcst.ingdretaction.csp?actiontype=getOrder&rowid='+ingrt;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
}