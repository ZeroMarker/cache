////UDHCAccCardExchange.js

var m_RegNo=""
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
	var RLCredNo;
	var RLCredTypeID;
	
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
	ExchangeCardNoobj=document.getElementById('ExchangeCardNo');
	//CredTypeobj=document.getElementById('CredType');
	ExchangeCardobj=document.getElementById('ExchangeCard');
	getpatclassobj==document.getElementById('getpatclass');
	//Grantobj=document.getElementById('GrantCard');
	Exchangeobj=document.getElementById('ExchCard');
	Clearobj=document.getElementById('Clear');
	readcardobj=document.getElementById('readcard');
	if (readcardobj) readcardobj.onclick = ReadMagCard_Click
	//if (Grantobj) Grantobj.onclick = Grant_Click;
	if (Exchangeobj) Exchangeobj.onclick = Exchange_Click;
	DHCWeb_DisBtnA("ExchCard");
	//if (ReportTheLossobj) ReportTheLossobj.onclick = ReportTheLoss_Click;
	//if (Cancelobj) Cancelobj.onclick = Cancel_Click;
	if (Clearobj) Clearobj.onclick = Clear_Click;
	if (ExchangeCardobj) ExchangeCardobj.onclick = ExchangeCard_Click;
	if (RegNoobj) RegNoobj.onkeydown = getpatbyRegNo;
	if (CardNoobj) CardNoobj.onkeydown = getpatbyCardNo;
	if (IDCardNoobj) IDCardNoobj.onkeydown = getpatbyIDCardNo;
	
	//getpath();
	//gettoday();
    CardNoobj.readOnly=true;
    ActiveFlagobj.readOnly=true;
    Flagobj.readOnly=true;
    //ExchangeCardNoobj.readOnly=true;
    PatNameobj.readOnly=true;
    IDCardNoobj.readOnly=true;
    DateFromobj.readOnly=true;
	DateToobj.readOnly=true;
	ExchangeCardNoobj.readOnly=true;
    ExchangeCardobj.checked=true;
    CardVerify="";
    ExchCardVerify="";
    var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
    websys_setfocus('RegNo');
    if (RegNoobj.value!=""){
		getpatbyregno1(RegNoobj.value);
	}
	var obj=document.getElementById('RLCredTypeList');
	if (obj){
		obj.onkeydown = nextfocus;
		obj.size=1;
		obj.multiple=false;	
	}
	
	var obj=document.getElementById("RLName");
	if (obj){
		obj.onkeydown=nextfocus;				///DHCWeb_NextfocusA;
	}
	var obj=document.getElementById("RLCredNo");
	if (obj){
		obj.onkeydown=RLCredNo_OnKeyDown;				///DHCWeb_NextfocusA;
	}
	var obj=document.getElementById("RLAddress");
	if (obj){
		obj.onkeydown=nextfocus;				///DHCWeb_NextfocusA;
	}
	var obj=document.getElementById("RLPhoneNo");
	if (obj){
		obj.onkeydown=nextfocus;				///DHCWeb_NextfocusA;
	}
	var obj=document.getElementById("RLProof");
	if (obj){
		obj.onkeydown=nextfocus;				///DHCWeb_NextfocusA;
	}
	var obj=document.getElementById("RLCredTypeList");
	if (obj){
		obj.onkeydown=nextfocus;				///DHCWeb_NextfocusA;
	}
	var obj=document.getElementById("RLRemark");
	if (obj){
		obj.onkeydown=nextfocus;				///DHCWeb_NextfocusA;
	}
	
	document.onkeydown = DHCWeb_EStopSpaceKey;	
	
	DHCWebD_ClearAllListA("RLCredTypeList");
	var encmeth=DHCWebD_GetObjValue("ReadCredType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","RLCredTypeList");
		
	}
	
}

function RLCredNo_OnKeyDown()
{
	bcheckcred=""
	var key=websys_getKey(e);
	if (key==13) {
		var myVersion=DHCWebD_GetObjValue("DHCVersion");
		switch(myVersion){
			case "0":
				bcheckcred="OK";
				var obj=document.getElementById("ExchCard");
				if (obj){
					obj.disabled=false;
					obj.onclick=Exchange_Click;
				}
				nextfocus();
				return;
				break;
			default:
				break;
		}
		
		if (RLCredNo!=""){
			var myobj=document.getElementById("RLCredTypeList");
			var mytmparray=myobj.value.split("^");
			var myRCredNo=DHCWebD_GetObjValue("RLCredNo");
			if (RLCredNo==myRCredNo && RLCredTypeID==mytmparray[0])
			{
				bcheckcred="OK";
				var obj=document.getElementById("ExchCard");
				if (obj){
					obj.disabled=false;
					obj.onclick=Exchange_Click;
				}
				nextfocus();
				////websys_setfocus('RLPhoneNo');
			}else{
				alert(t[2062]);return;
				DHCWeb_DisBtnA("ExchCard");
			}
		}else{
				bcheckcred="F";
				DHCWeb_DisBtnA("ExchCard");
				alert(t[2062])
				websys_setfocus('RLCredNo');
				return;
		}
		
	}
	
}


function Clear_Click()
{	
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccCardExchange";
}
	
function getpatbyRegNo()
{
    var key=websys_getKey(e);
	if (key==13) {
		if (RegNoobj.value!=""){
			getpatbyregno1(RegNoobj.value)
		}
	}
}
function getpatbyregno1(regno)
{
	if (regno=="") return;
	p1=regno;
	
	var getregno=document.getElementById('getpatclass');
	
	if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'setpatinfo_val','',p1,"","","","")=='1'){
	}
	
}

function setpatinfo_val(value)
{
	//RegNo_"^"_papmi_"^"_name_"^"_IDCardNo_"^"_CardNo_"^"_SecurityNO_"^"_ActiveFlag_"^"_DateFrom_"^"_DateTo
	///alert(value)
	var val=value.split("^");
	
	if (val[0]==""){
		alert(t[2001])
		websys_setfocus('RegNo');
		return;
	}
	RegNoobj.value=val[0];
	m_RegNo=val[0];
	RegNo=val[0];
	PatientIDobj.value=val[1];
	PatNameobj.value=val[2];
	if (val[4]!=""){
		CardNoobj.value=val[4];
		CardVerify=val[5];
		ActiveFlagobj.value=val[6];
		DateFromobj.value=val[7];
		DateToobj.value=val[8];
		CardIDobj.value=val[9];
		Flagobj.value=val[10];
		
		RLCredNo=val[12];
		RLCredTypeID=val[14];
		var myVersion=DHCWebD_GetObjValue("DHCVersion");
		switch(myVersion){
			case "0":
				ExchangeCardNoobj.value="";
				var obj=document.getElementById("ExchCard");
				if (obj){
					obj.disabled=false;
					obj.onclick=Exchange_Click;
				}
				nextfocus();
				break;
			default:
				ExchangeCardNoobj.value=val[4];
		}
		nextfocus();
		///websys_setfocus('ExchCard');
	}else{
		CardIDobj.value="";
		ActiveFlagobj.value="";
		Flagobj.value="";
		ExchangeCardNoobj.value="";
		websys_setfocus('RegNo');
	}
		
}

function getpatbycard()
{
	if (CardNoobj.value!=""){
		p1=CardNoobj.value
		p2=CardVerify
		var getregno=document.getElementById('getpatclass');
		if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
		if (cspRunServerMethod(encmeth,'setpatinfo_val2','',"","",p1,p2,"")=='1'){}
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
	//alert(value)
	var val=value.split("^");
	
	if (val[4]!=""){
		RegNoobj.value=val[0];
		m_RegNo=val[0];
		RegNo=val[0];
		PatientIDobj.value=val[1];
		PatNameobj.value=val[2];
		//IDCardNoobj.value=val[3];
		ActiveFlagobj.value=val[6];
		DateFromobj.value=val[7];
		DateToobj.value=val[8];
		CardIDobj.value=val[9];
		Flagobj.value=val[10];
		ExchangeCardNoobj.value=val[4];
		websys_setfocus('ExchCard');
	}else{
		//CardNoobj.value="";
		CardIDobj.value="";
		//CardVerify="";
		ActiveFlagobj.value="";
		Flagobj.value=val[6];
		ExchangeCardNoobj.value="";
		websys_setfocus('RegNo');
	}
}
		
function getpatbyIDCardNo()
{
	
}

function ExchangeCard_Click() {
	if (ExchangeCardobj.checked){
		ExchangeCardNoobj.readOnly=false; 
	}
	else{
		ExchangeCardNoobj.value="";
		ExchCardVerify="";
	    ExchangeCardNoobj.readOnly=true;
	}
}

function Exchange_Click()
{
	if (CardIDobj.value==""){
		alert(t[2005]);
		return;
	}
	if (ExchangeCardNoobj.value==""){
		alert(t[2004]);
		websys_setfocus('ExchangeCardNo');
		return;
	}
	
    if (ActiveFlagobj.value=="S"){
		alert(t[2051]);
		return;
	}
	
	if (ActiveFlagobj.value!="N"){
		alert(t[2006]);
		return;
	}
	
	var ren=DHCACC_CheckForNOCard(CardNoobj.value,CardVerify)
	
	var myary=ren.split("^");
	if (myary[0]=='-200'){alert(t[2042]);return;}
	if (myary[0]=='-201'){alert(t[2042]);return;}
	if (myary[0]=='-202'){alert(t[2042]);return;}
	if (myary[0]=='-203'){alert(t[2053]);return;}
	if (myary[0]=='-299'){alert(t[2054]);return;}
	if (myary[0]!='0' && myary[0]!='-208'){alert(myary[0]+"  "+t[2055]);return;}
	
	var myrtn=WrtCard();
	var myary=myrtn.split("^");
	if (myary[0]!="0"){
		return;
	}
	var mySecrityNo=myary[1];
	
	ExchCardVerify=""
	//str=CardID_"^"_CardNo_"^"_SecurityNO_"^"_user_"^"_IP
	var myCardInfo=CardIDobj.value+"^"+ExchangeCardNoobj.value+"^"+ExchCardVerify+"^"+Guser+"^"+computername+"^R"+"^"+mySecrityNo;
	
	///Relationship
	var myRLinfo=BuildRLStr();
	///var myobj=document.getElementById("RLCredTypeList");
	////var mytmparray=myobj.value.split("^");
	
	///alert(myCardInfo);
	///alert(myRLinfo);
	///return;
	
	var getregno=document.getElementById('exchangeclass');
	if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
	
	var ren=cspRunServerMethod(encmeth,'','',myCardInfo,myRLinfo)
	var myary=ren.split("^");
	if (myary[0]=='0'){
		CardIDobj.value=myary[2]
		CardNoobj.value=myary[3]
		alert(t[2013]);
		Clear_Click();
	}
	else{
		alert(myary[0]+"  "+t[2015]);
	}
}

function BuildRLStr(){
	var myary=new Array();
	
	///var myRLInfo=RLNameobj.value+"^"+RLCredNoobj.value+"^"+RLAddressobj.value+"^"+RLPhoneNoobj.value+"^"+RLProofobj.value+"^"+RLRemarkobj.value+"^"+mytmparray[0];
	///var myRLInfo=+"^"++"^"++"^"++"^"++"^"++"^"+
	myary[0]=DHCWebD_GetObjValue("RLName");
	myary[1]=DHCWebD_GetObjValue("RLCredNo")	///RLCredNoobj.value;
	myary[2]=DHCWebD_GetObjValue("RLAddress")	///RLAddressobj.value;
	myary[3]=DHCWebD_GetObjValue("RLPhoneNo")	///RLPhoneNoobj.value;
	myary[4]=DHCWebD_GetObjValue("RLProof")	///RLProofobj.value;
	myary[5]=DHCWebD_GetObjValue("RLRemark")	///RLRemarkobj.value;
	
	var myobj=document.getElementById("RLCredTypeList");
	var mytmparray=myobj.value.split("^");
	myary[6]=mytmparray[0];
	
	var mystr=myary.join("^");
	return mystr;
}

function WrtCard(){
	////Read Secrity
	///ReadSecEnvrypt
	var mySecrityNo="";
	window.status=t[2011];
	var myencmeth=DHCWebD_GetObjValue("ReadSecEnvrypt");
	if (myencmeth!=""){
		var myPAPMINo=DHCWebD_GetObjValue("ID");
		var myPAPMINo=m_RegNo;
		mySecrityNo=cspRunServerMethod(myencmeth,myPAPMINo);
	}else
	{
		alert("Read Err!");
		return "-1^";
	}
	///Write Card First
	if (mySecrityNo!=""){
		var rtn=DHCACC_WrtMagCard("23",ExchangeCardNoobj.value,mySecrityNo)
		window.status="";
		if (rtn!="0"){
			alert(t[2014]);
			return "-1^"
		}
	}else{
		return "-1^";
	}
	
	return "0^"+mySecrityNo
}


function ReadMagCard_Click(){
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		window.status=t[2007]
		var rtn=obj.ReadMagCard("23");
		//obj.DHCACC_ReadMagCard("2");
		//obj.DHCACC_ReadMagCard("3");
		//obj.DHCACC_WrtMagCard("");
		//alert(rtn)
		var myary=rtn.split("^");
		if (myary[0]=='-5') {window.status=t[2008];return;}
		window.status="";
		if (myary[0]=="0"){
			//Add Check Card No DHCACC_GetPAPMINo
			var myVersion=DHCWebD_GetObjValue("DHCVersion");
			if (myVersion=="0"){
				var myCardStat=DHCACC_GetAccInfoFNoCard(myary[1],myary[2]);
				var myStatAry=myCardStat.split("^");
				if (myStatAry[0]=="0"){
					alert(t["EntCardtip"]);
					return;
				}
			}
			if (ExchangeCardobj.checked==true){
			    ExchangeCardNoobj.value=myary[1];
			    ExchCardVerify=myary[2];
			}
			else{
			//CardNo=myary[1];
			CardNoobj.value=myary[1];
			CardVerify=myary[2];
			getpatbycard();}
		}
	}
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	//alert(eSrc.tabIndex);
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}


////document.onkeydown = DHCWeb_EStopSpaceKey;

document.body.onload = BodyLoadHandler;