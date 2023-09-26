/**
/      Interface for medical record request
/before call function WMR_NewRequest,add 2 items in you component
/  1:MethodGetMrMain    TextBox   Hidden
/    ValueGet:s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMainQry.GetMainByPapmi"))
/  2:MethodInvalidRequest    TextBox  Hidden
/    ValueGet:s val=##Class(%CSP.Page).Encrypt($lb("web.DHCWMRRequest.InvalidReqByADM"))
/then, include  'DHC.WMR.Request.js' in you component
/last, add paraments in you menu
/   "&OMrType=&IMrType=&sWorkItem=&sReqType"
/
/by wuqk 2008-06
*/

function WMR_NewRequest(PatientID,EpisodeID,OMrType,IMrType,sWorkItem,sReqType)
{
	var strUrl="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.NewRequest"
		           
		          
	//var sWorkItem="10";
	//var sReqType="54";
	//var PatientID=22029;
	
	//var WorkItemDisable="N";
	//var obj=document.getElementById("MethodCheckWMR");
	//if (obj){var encmeth=obj.value} else {var encmeth=''}
	//var HaveWMR=cspRunServerMethod(encmeth,PatientID,OMrType);
	//1234201	5497914
  
  /*
	var HaveWMR=1234201;
	var PatientID=22029;
	var EpisodeID=5497914;
	*/
	
	if (OMrType!=="") {
		var OMrMain=GetDHCWMRMainByPapmi("MethodGetMrMain",OMrType,PatientID)
		if (OMrMain!==null){
			var HaveWMR=OMrMain.RowID;
			var strUrl = strUrl+ "&MrMain=" + HaveWMR 
			           + "&PatientID=" + PatientID 
			           + "&EpisodeID=" + EpisodeID 
			           + "&sWorkItem=" + sWorkItem 
			           + "&sReqType=" + sReqType;
			var objReturn = window.showModalDialog(
				strUrl,
				"",
				"dialogHeight: 550px; dialogWidth: 600px");
			return objReturn;
		}
	}
	
	if (IMrType!=="") {
		var IMrMain=GetDHCWMRMainByPapmi("MethodGetMrMain",IMrType,PatientID)
		if (IMrMain!==null){
			var HaveWMR=IMrMain.RowID;
			var strUrl = strUrl+ "&MrMain=" + HaveWMR 
			           + "&PatientID=" + PatientID 
			           + "&EpisodeID=" + EpisodeID 
			           + "&sWorkItem=" + sWorkItem 
			           + "&sReqType=" + sReqType;
			var objReturn = window.showModalDialog(
				strUrl,
				"",
				"dialogHeight: 550px; dialogWidth: 600px");
			return objReturn;
		}
	}
	//return objReturn;
}

/*
//Add Hidden Item
//MethodGetMrMain    TextBox
//ValueGet:s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMainQry.GetMainByPapmi"))
*/
function GetDHCWMRMainByPapmi(methodControl, MrType, PatientID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MrType, PatientID);
	return BuildDHCWMRMain(ret);
}

//******************************************
//build main information
//******************************************
function BuildDHCWMRMain(str)
{
	
	if((str == "") || (str == null))
	{
		return null;
	}
	var obj = new Object();
	var arry = str.split("^");
	obj.RowID = arry[0];				//	DHC_WMR_MainRowID
	obj.MrType = arry[1];			//		
	obj.MRNO =arry[2];				//		
	obj.Papmi_Dr = arry[3];			//		
	obj.History_DR = arry[4];		//		
	obj.IsDead = (arry[5] == "Y");			//		
	obj.IsActive = (arry[6] == "Y");			//		
	obj.IsStayIn = (arry[7] == "Y");			//		
	obj.BuildDate = arry[8];			//		
	obj.ResumeText = arry[9];		//		
	return obj;
}

//window.alert("DHC.WMR.Request Loaded");


//add by zf 2008-05-08
//Invalid Request
//
//Add Hidden Item
//MethodInvalidRequest    TextBox
//ValueGet:s val=##Class(%CSP.Page).Encrypt($lb("web.DHCWMRRequest.InvalidReqByADM"))
//
//Add "DHC.WMR.Request.js" to component
function InvalidRequest(Paadm)
{
	if ((Paadm=="")||(!Paadm)) {
		alert("Paadm Error!");
		return false;
	}
	var obj=document.getElementById('MethodInvalidRequest');
	if (obj) {var encmeth=obj.value} else {var encmeth=''}
	var ret=-100;
	ret=cspRunServerMethod(encmeth,Paadm);
	if ((ret<0)||(!ret)){
		alert("Invalid Request Error!");
		return false;
	}else{
		return true;
	}
}