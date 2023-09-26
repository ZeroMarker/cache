////UDHCACPatQ.AutoForPat.js

function BodyLoadHandler(){
	var obj=document.getElementById("Query");
	if (obj){
		obj.onclick=Query_OnClick;
	}
	///
	var obj=document.getElementById("Clear");
	if (obj){
		obj.onclick=Clear_OnClick;
	}
	
	var obj=document.getElementById("CardNoA");
	if (obj){
		obj.onkeydown=CardNoA_OnKeyDown;
	}
	var obj=document.getElementById("Print");
	if (obj){
		obj.onclick=Print_OnClick;
	}
	
	ReadPatAccInfo();
	
}

function Print_OnClick(){
	
}

function CardNoA_OnKeyDown(){
	var mykey=event.keyCode;
	if (mykey!=13){
		return;
	}
	var CardNo=DHCWebD_GetObjValue("CardNoA");
	if (CardNo==""){
		return;
	}
	
	var encmeth=DHCWebD_GetObjValue("ReadSecEncrypt");
	var myrtn=(cspRunServerMethod(encmeth, CardNo));
	var myary=myrtn.split("^")
	if (myary[0]!=""){
		DHCWebD_SetObjValueC("SecurityNo",myary[0]);
		
		var SecurityNo=myary[0];
		var PAPMINo=myary[1];
		var encmeth=DHCWebD_GetObjValue("ReadPAInfoEncrypt");
		var myrtn=(cspRunServerMethod(encmeth, PAPMINo, CardNo, SecurityNo))
		var myary=myrtn.split("^");
		if (myary[0]==0){
			WrtPatAccInfo(myrtn);
		}else{
			alert(t[myary[0]]);
			return;
		}

		var myAccRowID=DHCWebD_GetObjValue("AccRowID");
		var StDate=DHCWebD_GetObjValue("StDate");
		var EndDate=DHCWebD_GetObjValue("EndDate");
		PListQuery(myAccRowID, PAPMINo, CardNo, SecurityNo, StDate, EndDate);
		
	}
}

function Query_OnClick(){
	ReadHFMagCard_Click();
	
	var myAccRowID=DHCWebD_GetObjValue("AccRowID");
	var PAPMINo=DHCWebD_GetObjValue("PAPMINo");
	var CardNo=DHCWebD_GetObjValue("CardNo");
	if (CardNo==""){
		var CardNo=DHCWebD_GetObjValue("CardNoA");
	}
	var SecurityNo=DHCWebD_GetObjValue("SecurityNo");
	var StDate=DHCWebD_GetObjValue("StDate");
	var EndDate=DHCWebD_GetObjValue("EndDate");
	PListQuery(myAccRowID, PAPMINo, CardNo, SecurityNo, StDate, EndDate);
}

function Clear_OnClick()
{
	PListQuery("","","","","","");
}

function PListQuery(myAccRowID,PAPMINo,CardNo,SecurityNo,StDate, EndDate)
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCACPatQ.AutoForPat&AccRowID=" + myAccRowID;
	lnk=lnk+"&PAPMINo="+PAPMINo+"&CardNo=" +CardNo +"&SecurityNo="+SecurityNo;
	lnk+="&StDate="+StDate+"&EndDate="+EndDate+"&CardNoA="+CardNo;
	window.location.href=lnk;
}

function ReadPatAccInfo()
{
	var PAPMINo=DHCWebD_GetObjValue("PAPMINo");
	var CardNo=DHCWebD_GetObjValue("CardNo");
	if (CardNo==""){
		var CardNo=DHCWebD_GetObjValue("CardNoA");
	}
	var SecurityNo=DHCWebD_GetObjValue("SecurityNo");
	if ((CardNo=="")&&(SecurityNo==""))
	{
		return;
	}
	//CardNo="00000006";
	//SecurityNo="000000066032957746";
	var encmeth=DHCWebD_GetObjValue("ReadPAInfoEncrypt");
	var myrtn=(cspRunServerMethod(encmeth, PAPMINo, CardNo, SecurityNo))
	var myary=myrtn.split("^");
	if (myary[0]==0){
		WrtPatAccInfo(myrtn);
	}else{
		alert(t[myary[0]]);
	}
}

function ReadHFMagCard_Click()
{
	var myrtn=DHCACC_GetAccInfo();
	///alert(myrtn);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj=document.getElementById("PAPMINo");
			if (obj){
				obj.value=myary[5];
			}
			///var obj=document.getElementById("CardNo");
			///DHCWebD_SetListValueA(obj,myary[1]);
			DHCWebD_SetObjValueC("CardNo",myary[1]);
			DHCWebD_SetObjValueC("CardNoA",myary[1]);
			
			///var obj=document.getElementById("SecurityNo");
			///DHCWebD_SetListValueA(obj,myary[2]);
			DHCWebD_SetObjValueC("SecurityNo",myary[2]);
			ReadPatAccInfo();
			///Account Can Pay
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			alert(t[rtn]);
			break;
		default:
			///alert("");
	}
}

function WrtPatAccInfo(myPAInfo)
{
	///	s myPAInfo=rtn_"^"_myPAPMINO_"^"_myPatName_"^"_mySexDesc_"^"_myPatBD
	///s myPAInfo=myPAInfo_"^"_myCredDesc_"^"_myCredNo_"^"_myLeft
	///s myPAInfo=myPAInfo_"^"_myASDesc_"^"_myAccNo_"^"_myCDT_"^"_BadPrice_"^"_DepPrice
	////s myPAInfo=myPAInfo_"^"_myAccRowID
	///myPDSum_"^"_myPLSum
	
	var myary=myPAInfo.split("^");
	//var obj=document.getElementById("PAPMINo");
	DHCWebD_SetObjValueC("PAPMINo",myary[1]);
	//DHCWebD_SetListValueA(obj,myary[1]);

	//var obj=document.getElementById("PAName");
	DHCWebD_SetObjValueC("PAName",myary[2]);
	//DHCWebD_SetListValueA(obj,myary[2]);
	
	///var obj=document.getElementById("PatSex");
	///DHCWebD_SetListValueA(obj,myary[3]);
	DHCWebD_SetObjValueC("PatSex",myary[3]);
	
	///var obj=document.getElementById("PatAge");
	///DHCWebD_SetListValueA(obj,myary[4]);
	DHCWebD_SetObjValueC("PatAge",myary[4]);
	
	DHCWebD_SetObjValueC("CredType",myary[5]);
	///var obj=document.getElementById("CredType");
	////DHCWebD_SetListValueA(obj,myary[5]);
	
	DHCWebD_SetObjValueC("CredNo",myary[6]);
	///var obj=document.getElementById("CredNo");
	////DHCWebD_SetListValueA(obj,myary[6]);
	
	DHCWebD_SetObjValueC("AccStatus",myary[8]);
	////var obj=document.getElementById("AccStatus");
	////DHCWebD_SetListValueA(obj,myary[8]);
	
	DHCWebD_SetObjValueC("AccLeft",myary[7]);
	///var obj=document.getElementById("AccLeft");
	///DHCWebD_SetListValueA(obj,myary[7]);
	
	DHCWebD_SetObjValueC("AccNo",myary[9]);
	///var obj=document.getElementById("AccNo");
	///DHCWebD_SetListValueA(obj,myary[9]);
	
	DHCWebD_SetObjValueC("AccOCDate",myary[10]);
	///var obj=document.getElementById("AccOCDate");
	///DHCWebD_SetListValueA(obj,myary[10]);
	
	///var obj=document.getElementById("BadPrice");
	///DHCWebD_SetListValueA(obj,myary[11]);
	
	DHCWebD_SetObjValueC("AccDep",myary[7]);
	///var obj=document.getElementById("AccDep");
	///DHCWebD_SetListValueA(obj,myary[7]);
	
	DHCWebD_SetObjValueC("AccRowID",myary[13]);
	///var obj=document.getElementById("AccRowID");
	///DHCWebD_SetListValueA(obj,myary[13]);
	
}

document.body.onload=BodyLoadHandler;


