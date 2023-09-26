////UDHCAccCardReissue.js
/////zhaocz Update 
/////

var m_RegNo="";
    var Guser;
	var GuserCode;
	var RegNo;		////->PAPMINo
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
	var getCardReqSuspendobj;
	var computername
	var today;
	var RLNameobj;
	var RLCredTypeobj;
	var RLCredTypeIDobj;
	var RLCredNoobj;
	var RLAddressobj;
	var RLPhoneNoobj;
	var RLProofobj;
	var RLRemarkobj;
	var RLAccBalance;
	var RLCredNo;
	var RLCredType;
	var RLCredTypeID;
	var bcheckpwd;
	var bcheckcred;
	var RLCredTypeListObj;
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
	var Exchangeobj2=document.getElementById('ExchCard2');
	if(Exchangeobj2){
		Exchangeobj2.disabled=true;
		///Exchangeobj2.onclick = Exchange2_Click;
	}
	//ReportTheLossobj=document.getElementById('ReportTheLoss');
	//Cancelobj=document.getElementById('Cancel');
	Clearobj=document.getElementById('Clear');
	getCardReqSuspendobj=document.getElementById('getCardReqSuspend');
	
	RLNameobj=document.getElementById('RLName');
	//RLCredTypeobj=document.getElementById('RLCredType');
	//RLCredTypeIDobj=document.getElementById('RLCredTypeID');
	RLCredNoobj=document.getElementById('RLCredNo');
	RLAddressobj=document.getElementById('RLAddress');
	RLPhoneNoobj=document.getElementById('RLPhoneNo');
	RLProofobj=document.getElementById('RLProof');
	RLRemarkobj=document.getElementById('RLRemark');
	if (RLCredNoobj) RLCredNoobj.onkeydown = RLCredNo_Click;
	RLNameobj.onkeydown = nextfocus;
	RLAddressobj.onkeydown = nextfocus;
	RLPhoneNoobj.onkeydown = nextfocus;
	RLProofobj.onkeydown = nextfocus;
	RLRemarkobj.onkeydown = nextfocus;
	readcardobj=document.getElementById('readcard');
	if (readcardobj) readcardobj.onclick = ReadMagCard_Click
	
	if (Exchangeobj) Exchangeobj.onclick = Exchange_Click;
	
	if (Clearobj) Clearobj.onclick = Clear_Click;
	if (ExchangeCardobj) ExchangeCardobj.onclick = ExchangeCard_Click;
	if (RegNoobj) RegNoobj.onkeydown = getpatbyRegNo;
	if (CardNoobj) CardNoobj.onkeydown = getpatbyCardNo;
	if (IDCardNoobj) IDCardNoobj.onkeydown = getpatbyIDCardNo;
	RLCredTypeListObj=document.getElementById('RLCredTypeList');
		RLCredTypeListObj.onkeydown = nextfocus;
		RLCredTypeListObj.size=1;
		RLCredTypeListObj.multiple=false;	
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
    //RLCredTypeobj.readOnly=true;
    ExchangeCardNoobj.readOnly=true;
    ExchangeCardobj.checked=true;
    
    CardVerify="";
    ExchCardVerify="";
    bcheckpwd="";
    bcheckcred="";
    DHCWeb_DisBtn(Exchangeobj);
    var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
	DHCWebD_ClearAllListA("RLCredTypeList");
	var encmeth=DHCWebD_GetObjValue("ReadCredType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","RLCredTypeList");
		
	}
	//getdefaultcredtype()
    websys_setfocus('RegNo');
    if (RegNoobj.value!=""){
		getpatbyregno1(RegNoobj.value);
	}
}

function getdefaultcredtype()
{
	var getregno=document.getElementById('getcredtypeClass');
	if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
	var rtn=cspRunServerMethod(encmeth);
	var myarray=rtn.split("^");
	if (myarray[0]=='0')
	{
		RLCredTypeobj.value=myarray[1];
		RLCredTypeIDobj.value=myarray[2];
	}
}

function getRLCredTypeid(value) {
	
	var val=value.split("^");
	RLCredTypeIDobj.value=val[1];
}

function Clear_Click()
{	
	//Grant_Click()
	//Exchange_Click()
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccCardReissue";
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
	bcheckpwd="";
    bcheckcred="";
    DHCWeb_DisBtn(Exchangeobj);
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
		
		var val=value.split("^");
		
		if (val[0]==""){
			alert(t[2001])
			 websys_setfocus('RegNo');
			 return;
			}
		if (getCardReqSuspendobj.value=="0")
    {
	    if (val[6]!="S")
	    {
		     alert(t[2056])
			 return;
	    }
	    }
	if (getCardReqSuspendobj.value=="1")
	 {
		if ( val[6]!="N" && val[6]!="S"){
			 alert(t[2057])
			 return;
		}
		 }
		RegNoobj.value=val[0];
		RegNo=val[0];
		m_RegNo=val[0];
		PatientIDobj.value=val[1];
		PatNameobj.value=val[2];
		//IDCardNoobj.value=val[3];
		if (val[4]!=""){
		CardNoobj.value=val[4];
		CardVerify=val[5];
		ActiveFlagobj.value=val[6];
		DateFromobj.value=val[7];
		DateToobj.value=val[8];
		CardIDobj.value=val[9];
		Flagobj.value=val[10];
		ExchangeCardNoobj.value=val[4];
		RLAccBalance=val[11];
		RLCredNo=val[12];
		RLCredType=val[13];
		RLCredTypeID=val[14];
		if (ActiveFlagobj.value=="N")
		{checkpwd();}
		if (ActiveFlagobj.value=="S")
		{
			Exchangeobj.disabled=false;
			Exchangeobj.onclick = Exchange_Click;
			var Exchangeobj2=document.getElementById('ExchCard2');
			if(Exchangeobj2){
				Exchangeobj2.disabled=false;
				Exchangeobj2.onclick = Exchange2_Click;
			}
			}
		}
		else{
			//CardNoobj.value="";
			CardIDobj.value="";
		    //CardVerify="";
		    ActiveFlagobj.value="";
		    Flagobj.value="";
		     RLAccBalance="";
			RLCredNo="";
			RLCredType="";
			RLCredTypeID="";
			bcheckpwd="";
			bcheckcred="";
			ExchangeCardNoobj.value="";
			websys_setfocus('CardNo');
	}
}

function checkpwd()
{
	bcheckpwd="";
	var ren=DHCACC_CheckForNOCard(CardNoobj.value,CardVerify)
	//alert(ren)
	var myary=ren.split("^");
	if (myary[0]=='-202'){alert(t[2042]);websys_setfocus('RLName');return;}
	if (myary[0]=='-203'){alert(t[2053]);websys_setfocus('RLName');return;}
	if (myary[0]=='-208'){alert(t[2061]);websys_setfocus('RLName');return;}
	if (myary[0]=='-299'){alert(t[2054]);websys_setfocus('RLName');return;}
	if (myary[0]!='0'){alert(t[2055]);websys_setfocus('RLName');return;}
	if (myary[0]='0'){
		bcheckpwd="OK";
		Exchangeobj.disabled=false;
		Exchangeobj.onclick = Exchange_Click;
		var Exchangeobj2=document.getElementById('ExchCard2');
		if(Exchangeobj2){
			Exchangeobj2.disabled=false;
			Exchangeobj2.onclick = Exchange2_Click;
		}
		websys_setfocus('ExchCard');
	}
	
}
function RLCredNo_Click()
{
	bcheckcred=""
	var key=websys_getKey(e);
	if (key==13) {
		if (RLCredNo!=""){
			var mytmparray=RLCredTypeListObj.value.split("^");
			if (RLCredNo==RLCredNoobj.value && RLCredTypeID==mytmparray[0])
			{
				bcheckcred="OK";
				Exchangeobj.disabled=false;
				Exchangeobj.onclick = Exchange_Click;
				var Exchangeobj2=document.getElementById('ExchCard2');
				if(Exchangeobj2){
					Exchangeobj2.disabled=false;
					Exchangeobj2.onclick = Exchange2_Click;
				}
				
				websys_setfocus('RLPhoneNo');
			}
			else
			{
				alert(t[2062]);return;
				}
		}
		else
		{
				bcheckcred="F";
				//Exchangeobj.disabled=false;
				//Exchangeobj.onclick = Exchange_Click;
				//alert(t[2063])
				alert(t[2062])
				websys_setfocus('RLPhoneNo');
				return;
		}
	}
}
		
function getpatbycard()
{
	bcheckpwd="";
    bcheckcred="";
    DHCWeb_DisBtn(Exchangeobj);
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
	alert(value)
	var val=value.split("^");
	
	if (val[4]!=""){
		//CardNoobj.value=val[4];
		//CardVerify=val[5];
		RegNoobj.value=val[0];
		RegNo=val[0];
		m_RegNo=val[0];
		PatientIDobj.value=val[1];
		PatNameobj.value=val[2];
		//IDCardNoobj.value=val[3];
		ActiveFlagobj.value=val[6];
		DateFromobj.value=val[7];
		DateToobj.value=val[8];
		CardIDobj.value=val[9];
		Flagobj.value=val[10];
		ExchangeCardNoobj.value=val[4];
	}else{
		CardIDobj.value="";
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

function Exchange_Click() {
    var myrtn=CheckExChange();
    if (!myrtn){
	    return;
    }
	
	DHCWeb_DisBtn(Exchangeobj);
	
	var myRLInfo="";			////Relation Constant
	if (ActiveFlagobj.value=="N"){
		if (bcheckpwd!="OK" && bcheckcred!="OK" && bcheckcred!="F"){alert(t[2062]);return;}
		if (bcheckcred=="F"){
			if (RLNameobj.value==""){alert(t[2064]);websys_setfocus('RLName');return;};
			if (RLCredTypeListObj.value==""){alert(t[2065]);websys_setfocus('RLCredTypeList');return;};
			if (RLCredNoobj.value==""){alert(t[2066]);websys_setfocus('RLCredNo');return;};
			if (RLAddressobj.value==""){alert(t[2067]);websys_setfocus('RLAddress');return;};
	    	if (RLPhoneNoobj.value==""){alert(t2068);websys_setfocus('RLPhoneNo');return;};
		}
		var mytmparray=RLCredTypeListObj.value.split("^");
		myRLInfo=RLNameobj.value+"^"+RLCredNoobj.value+"^"+RLAddressobj.value+"^"+RLPhoneNoobj.value+"^"+RLProofobj.value+"^"+RLRemarkobj.value+"^"+mytmparray[0];
	}
	var myrtn=WrtCard();
	var myary=myrtn.split("^");
	if (myary[0]!="0"){
		return;
	}
	var mySecrityNo=myary[1];
	
	ExchCardVerify=""
	//str=CardID_"^"_CardNo_"^"_SecurityNO_"^"_user_"^"_IP
	var myCardInfo=CardIDobj.value+"^"+ExchangeCardNoobj.value+"^"+ExchCardVerify+"^"+Guser+"^"+computername+"^D"+"^"+mySecrityNo;
	//alert(myCardInfo)
	var getregno=document.getElementById('exchangeclass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				var ren=cspRunServerMethod(encmeth, '', '', myCardInfo, myRLInfo)
				//alert(ren)
				var myary=ren.split("^");
				if (myary[0]=='100'){alert(t[2071]);return;}
				if (myary[0]=='-310'){alert(t[2069]);return;}
				if (myary[0]=='-311'){
					alert(t[2058]+myary[1]+t[2059]);
					return;}
				if (myary[0]=='0'){
					CardIDobj.value=myary[2]
					CardNoobj.value=myary[3]
					alert(t[2013]);
					Clear_Click();
					////window.status=t[2011];
					////ren=DHCACC_WrtMagCard("23",ExchangeCardNoobj.value,myary[1])
					////}
					if (ren=='0'){
					}
					else
					{
						///alert(t[2014])
					}
				}
				else
				{alert(myary[0]+"  "+t[2015]);}
}

function Exchange2_Click() {
    var myrtn=CheckExChange();
    if (!myrtn){
	    return;
    }

	DHCWeb_DisBtn(Exchangeobj);
	
	var myRLInfo="";			////Relation Constant
	if (ActiveFlagobj.value=="N"){
		if (bcheckpwd!="OK" && bcheckcred!="OK" && bcheckcred!="F"){alert(t[2062]);return;}
		if (bcheckcred=="F"){
			if (RLNameobj.value==""){alert(t[2064]);websys_setfocus('RLName');return;};
			if (RLCredTypeListObj.value==""){alert(t[2065]);websys_setfocus('RLCredTypeList');return;};
			if (RLCredNoobj.value==""){alert(t[2066]);websys_setfocus('RLCredNo');return;};
			if (RLAddressobj.value==""){alert(t[2067]);websys_setfocus('RLAddress');return;};
	    	if (RLPhoneNoobj.value==""){alert(t2068);websys_setfocus('RLPhoneNo');return;};
		}
		var mytmparray=RLCredTypeListObj.value.split("^");
		myRLInfo=RLNameobj.value+"^"+RLCredNoobj.value+"^"+RLAddressobj.value+"^"+RLPhoneNoobj.value+"^"+RLProofobj.value+"^"+RLRemarkobj.value+"^"+mytmparray[0];
	}
	var myrtn=WrtCard2();
	var myary=myrtn.split("^");
	if (myary[0]!="0"){
		return;
	}
	var mySecrityNo=myary[1];
	
	ExchCardVerify=""
	//str=CardID_"^"_CardNo_"^"_SecurityNO_"^"_user_"^"_IP
	var myCardInfo=CardIDobj.value+"^"+ExchangeCardNoobj.value+"^"+ExchCardVerify+"^"+Guser+"^"+computername+"^D"+"^"+mySecrityNo;
	//alert(myCardInfo)
	var getregno=document.getElementById('exchangeclass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				var ren=cspRunServerMethod(encmeth, '', '', myCardInfo, myRLInfo)
				//alert(ren)
				var myary=ren.split("^");
				if (myary[0]=='100'){alert(t[2071]);return;}
				if (myary[0]=='-310'){alert(t[2069]);return;}
				if (myary[0]=='-311'){
					alert(t[2058]+myary[1]+t[2059]);
					return;}
				if (myary[0]=='0'){
					CardIDobj.value=myary[2]
					CardNoobj.value=myary[3]
					alert(t[2013]);
					Clear_Click();
					////window.status=t[2011];
					////ren=DHCACC_WrtMagCard("23",ExchangeCardNoobj.value,myary[1])
					////}
					if (ren=='0'){
					}
					else
					{
						///alert(t[2014])
					}
				}
				else
				{alert(myary[0]+"  "+t[2015]);}
}

function CheckExChange(){
	
	if (CardIDobj.value=="")
	{
		alert(t[2071]);
		return false;
	}
	if (ExchangeCardNoobj.value=="")
	{
		alert(t[2052])
		websys_setfocus('ExchangeCardNo');
		return false;
	}
    if (getCardReqSuspendobj.value=="0")
    {
	    if (ActiveFlagobj.value!="S")
	    {
		     alert(t[2056])
			 return false;
	    }
	    }
	if (getCardReqSuspendobj.value=="1")
	{
		if ( ActiveFlagobj.value!="N" && ActiveFlagobj.value!="S"){
			 alert(t[2057])
			 return false;
		}
	}
	
	return true;	
}

function WrtCard(){
	////Read Secrity
	///ReadSecEnvrypt
	var mySecrityNo="";
	window.status=t[2011];
	var myencmeth=DHCWebD_GetObjValue("ReadSecEnvrypt");
	if (myencmeth!=""){
		var myPAPMINo=RegNo;			////Require PAPMINo  ,not CardNo
		var myPAPMINo=m_RegNo;
		mySecrityNo=cspRunServerMethod(myencmeth,myPAPMINo);
	}else
	{
		alert("Read Err!");
		return "-1^";
	}
	///Write Card First
	if (mySecrityNo!=""){
		///var rtn=DHCACC_WrtMagCard("23",ExchangeCardNoobj.value,mySecrityNo)
		var rtn=DHCACC_WrtMagCard("23",ExchangeCardNoobj.value,mySecrityNo);
		////RegNo
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

function WrtCard2(){
	////Read Secrity
	///ReadSecEnvrypt
	var mySecrityNo="";
	window.status=t[2011];
	var myencmeth=DHCWebD_GetObjValue("ReadSecEnvrypt");
	if (myencmeth!=""){
		var myPAPMINo=RegNo;			////Require PAPMINo  ,not CardNo
		var myPAPMINo=m_RegNo;
		mySecrityNo=cspRunServerMethod(myencmeth,myPAPMINo);
	}else
	{
		alert("Read Err!");
		return "-1^";
	}
	///Write Card First
	if (mySecrityNo!=""){
		///var rtn=DHCACC_WrtMagCard("23",ExchangeCardNoobj.value,mySecrityNo)
		var rtn=DHCACC_WrtMagCard2(7,ExchangeCardNoobj.value,mySecrityNo);
		////RegNo
		window.status="";
		if (rtn!=0){
			alert(t[2014]);
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
		var myary=rtn.split("^");
		if (myary[0]=='-5') {window.status=t[2008];return;}
		window.status=""
		if (myary[0]=="0"){
			//Add Check Card No DHCACC_GetPAPMINo
			var myVersion=DHCWebD_GetObjValue("DHCVersion");
			if (myVersion=="0"){
				var myCardStat=DHCACC_GetAccInfoFNoCard(myary[1],myary[2]);
				var myStatAry=myCardStat.split("^");
				if (myStatAry[0]=="0"){
					alert(t["EntCardtip"]);
					DHCWeb_DisBtnA("ExchCard");
					return;
				}else{
					if (Exchangeobj){
						Exchangeobj.disabled=false;
						Exchangeobj.onclick = Exchange_Click;
					}
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

////document.onkeydown = DHCWeb_EStopSpaceKey;

document.body.onload = BodyLoadHandler;