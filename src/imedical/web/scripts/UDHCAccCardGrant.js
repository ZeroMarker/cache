    var Guser;
	var GuserCode;
	var RegNo;
	var PatientID;
	var PatName;
	var CardNo;
	var CardVerify;
	var ExchCardVerify;
	var IDCardNo;
	var RegNoobj;
	var CardNoobj;
	var CardIDobj;
	var PatNameobj;
	var PatientIDobj;
	var IDCardNoobj;
	var ActiveFlagobj;
	var Flagobj;
	var DateFromobj;
	var DateToobj;
	var ExchangeCardNoobj;
	var CredTypeobj;
	var ExchangeCardobj;
	var getpatclassobj;
	var Grantobj;
	var Exchangeobj;
	var ReportTheLossobj;
	var Cancelobj;
	var Clearobj;
	var readcardobj;
	var computername
	var today;
function BodyLoadHandler() {
	
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	RegNoobj=document.getElementById('RegNo');
	CardNoobj=document.getElementById('CardNo');
	CardIDobj=document.getElementById('CardID');
	PatNameobj=document.getElementById('PatName');
	PatientIDobj=document.getElementById('PatientID');
	IDCardNoobj=document.getElementById('IDCardNo');
	ActiveFlagobj=document.getElementById('ActiveFlag');
	Flagobj=document.getElementById('Flag');
	DateFromobj=document.getElementById('DateFrom');
	DateToobj=document.getElementById('DateTo');
	//ExchangeCardNoobj=document.getElementById('ExchangeCardNo');
	//CredTypeobj=document.getElementById('CredType');
	//ExchangeCardobj=document.getElementById('ExchangeCard');
	getpatclassobj==document.getElementById('getpatclass');
	Grantobj=document.getElementById('GrantCard');
	//Exchangeobj=document.getElementById('ExchCard');
	//ReportTheLossobj=document.getElementById('ReportTheLoss');
	//Cancelobj=document.getElementById('Cancel');
	Clearobj=document.getElementById('Clear');
	readcardobj=document.getElementById('readcard');
	if (readcardobj) readcardobj.onclick = ReadMagCard_Click
	if (Grantobj) Grantobj.onclick = Grant_Click;
	//if (Exchangeobj) Exchangeobj.onclick = Exchange_Click;
	//if (ReportTheLossobj) ReportTheLossobj.onclick = ReportTheLoss_Click;
	//if (Cancelobj) Cancelobj.onclick = Cancel_Click;
	if (Clearobj) Clearobj.onclick = Clear_Click;
	//if (ExchangeCardobj) ExchangeCardobj.onclick = ExchangeCard_Click;
	if (RegNoobj) RegNoobj.onkeydown = getpatbyRegNo;
	if (CardNoobj) CardNoobj.onkeydown = getpatbyCardNo;
	//if (CardNoobj) CardNoobj.onFocus = OK;
	if (IDCardNoobj) IDCardNoobj.onkeydown = getpatbyIDCardNo;
	
	//getpath();
	//gettoday();
    CardNoobj.readOnly=true;
    ActiveFlagobj.readOnly=true;
    Flagobj.readOnly=true;
    //ExchangeCardNoobj.readOnly=true;
    PatNameobj.readOnly=true;
    CardVerify="";
    //ExchCardVerify="";
    var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
    websys_setfocus('RegNo');
    if (RegNoobj.value!=""){
		getpatbyregno1(RegNoobj.value);
	}
}

function OK()
{
	alert("ok")
}
function Clear_Click()
{	
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccCardGrant";
}
	
function getpatbyRegNo()
{
    var key=websys_getKey(e);
	if (key==13) {
		if (RegNoobj.value!=""){
			getpatbyregno1(RegNoobj.value)
		}
	}


function getpatbyregno1(regno)
{
	if (regno=="") return;
	p1=regno
	
			var getregno=document.getElementById('getpatclass');
		
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpatinfo_val','',p1,"","","","")=='1'){
			
				}
			
			}
	}
function setpatinfo_val(value)
{
		//RegNo_"^"_papmi_"^"_name_"^"_IDCardNo_"^"_CardNo_"^"_SecurityNO_"^"_ActiveFlag_"^"_DateFrom_"^"_DateTo
		
		var val=value.split("^");
		
		if (val[0]==""){
			alert(t[2001])
			 websys_setfocus('RegNo');
			 return;
			}
		
		RegNoobj.value=val[0];
	
		RegNo=val[0];
		PatientIDobj.value=val[1];
		PatNameobj.value=val[2];
		IDCardNoobj.value=val[3];
		if (val[4]!=""){
		CardNoobj.value=val[4];
		CardVerify=val[5];
		ActiveFlagobj.value=val[6];
		DateFromobj.value=val[7];
		DateToobj.value=val[8];
		CardIDobj.value=val[9];
		Flagobj.value=val[10];
		}
		else{
			//CardNoobj.value="";
			CardIDobj.value="";
		    //CardVerify="";
		    ActiveFlagobj.value="";
		    Flagobj.value="";
			websys_setfocus('CardNo');
		}
		
}
function getpatbycard()
{
	if (CardNoobj.value!=""){
			p1=CardNoobj.value
			p2=CardVerify
			
			var getregno=document.getElementById('getpatclass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpatinfo_val2','',"","",p1,p2,"")=='1'){
			
				}
			
			}
}
function getpatbyCardNo()
{
	
	var key=websys_getKey(e);
	if (key==13) {
		getpatbycard();
		}
	}	
function setpatinfo_val2(value)
	{
		//RegNo_"^"_papmi_"^"_name_"^"_IDCardNo_"^"_CardNo_"^"_SecurityNO_"^"_ActiveFlag_"^"_DateFrom_"^"_DateTo
		///alert(value)
		var val=value.split("^");
		
		
		if (val[4]!=""){
		//CardNoobj.value=val[4];
		//CardVerify=val[5];
		RegNoobj.value=val[0];
		RegNo=val[0];
		PatientIDobj.value=val[1];
		PatNameobj.value=val[2];
		IDCardNoobj.value=val[3];
		ActiveFlagobj.value=val[6];
		DateFromobj.value=val[7];
		DateToobj.value=val[8];
		CardIDobj.value=val[9];
		Flagobj.value=val[10];
		}
		else{
			//CardNoobj.value="";
			CardIDobj.value="";
		    //CardVerify="";
		    ActiveFlagobj.value="";
		    Flagobj.value="";
			websys_setfocus('RegNo');
		}
		
		}
function getpatbyIDCardNo()
{
	
	}	


function Grant_Click() {
	if (RegNoobj.value==""||PatientIDobj.value=="")
	{
		alert(t[2019])
		websys_setfocus('RegNo');
		return;
	}
	
	if (CardNoobj.value=="")
	{
		alert(t[2002])
			 //websys_setfocus('CardNo');
		return;
	}
	
	if (CardIDobj.value!="")
	 {
		alert(t[2024])
		return;
	 }
	var myrtn=WrtCard();
	///alert(myrtn);
	var myary=myrtn.split("^");
	if (myary[0]!="0"){
		return;
	}
	
	var mySecrityNo=myary[1];
	
	//RegNo_"^"_papmi_"^"_IDCardNo_"^"_CardNo_"^"_SecurityNO_"^"_DateFrom_"^"_DateTo
	///PAPMINo^PAPMIDR^IDCardNo^CardNo^SecrityNo^DateFrom^DateTo^UserDR^ComputerName^SecrityNo
	p1=RegNoobj.value+"^"+PatientIDobj.value+"^"+IDCardNoobj.value+"^"+CardNoobj.value
	p1+="^"+CardVerify+"^"+DateFromobj.value+"^"+DateToobj.value+"^"+Guser+"^"+computername
	p1+="^"+mySecrityNo;
	
	var getregno=document.getElementById('grantclass');
	if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
	
	var ren=cspRunServerMethod(encmeth,'','',p1)
	var myary=ren.split("^");
	if (myary[0]=='0'){
		window.status=t[2011]
		///ren=DHCACC_WrtMagCard("3","",myary[1])
		ren=myary[0];
		window.status=""
		if (ren=='-5') {alert(t[2060]);return;}
		if (ren=='0'){
			alert(t[2013]);
			Clear_Click();
		}else{
			alert(t[2014])}
	}else if (myary[0]=='-302'){
		alert(t[2025]);
	}
	else if (myary[0]=='-303'){
		alert(t[2002]);
	}
	else if (myary[0]=='-304'){
		alert(t[2024]);
	}
	else{
		alert(myary[0]+"  "+t[2015]);
	}
}

function WrtCard(){
	////Read Secrity
	///ReadSecEnvrypt
	window.status=t[2011]
	var mySecrityNo="";
	var myencmeth=DHCWebD_GetObjValue("ReadSecEnvrypt");
	if (myencmeth!=""){
		var myPAPMINo=DHCWebD_GetObjValue("RegNo");
		mySecrityNo=cspRunServerMethod(myencmeth,myPAPMINo);
	}else
	{
		alert("Read Err!");
		return "-1^";
	}
	var myCardNo=DHCWebD_GetObjValue("CardNo");
	window.status=""
	///Write Card First
	if (mySecrityNo!=""){
		///alert(myCardNo+"^"+mySecrityNo);
		var rtn=DHCACC_WrtMagCard("3",myCardNo,mySecrityNo)
		if (rtn!="0"){
			return "-1^"
		}
	}else{
		return "-1^";
	}
	
	return "0^"+mySecrityNo
}


function rtncard_val(value)
{
	
}
function ReadMagCard_Click(){
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		window.status=t[2007]
		var rtn=obj.ReadMagCard("23");
		//obj.DHCACC_ReadMagCard("2");
		//obj.DHCACC_ReadMagCard("3");
		//obj.DHCACC_WrtMagCard("");
		
		var myary=rtn.split("^");
		if (myary[0]=='-5') {window.status=t[2008];return;}
		window.status=""
		if (myary[0]=="0"){
			CardNoobj.value=myary[1];
			CardVerify=myary[2];
			//websys_setfocus('CardNo');
			getpatbycard();
		}
	}
	
}

///document.onkeydown = DHCWeb_EStopSpaceKey;

document.body.onload = BodyLoadHandler;