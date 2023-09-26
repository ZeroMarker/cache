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
	var RLCredTypeListObj;
	var bcheckpwd;
	var bcheckcred;
	var computername;
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
	//Grantobj=document.getElementById('GrantCard');
	//Exchangeobj=document.getElementById('ExchCard');
	ReportTheLossobj=document.getElementById('ReportTheLoss');
	//Cancelobj=document.getElementById('Cancel');
	Clearobj=document.getElementById('Clear');
	
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
	//readcardobj=document.getElementById('readcard');
	//if (readcardobj) readcardobj.onclick = ReadMagCard_Click
	if (Grantobj) Grantobj.onclick = Grant_Click;
	//if (Exchangeobj) Exchangeobj.onclick = Exchange_Click;
	if (ReportTheLossobj) ReportTheLossobj.onclick = ReportTheLoss_Click;
	//if (Cancelobj) Cancelobj.onclick = Cancel_Click;
	if (Clearobj) Clearobj.onclick = Clear_Click;
	//if (ExchangeCardobj) ExchangeCardobj.onclick = ExchangeCard_Click;
	if (RegNoobj) RegNoobj.onkeydown = getpatbyRegNo;
	if (CardNoobj) CardNoobj.onkeydown = getpatbyCardNo;
	if (IDCardNoobj) IDCardNoobj.onkeydown = getpatbyIDCardNo;
	RLCredTypeListObj=document.getElementById('RLCredTypeList');
	if (RLCredTypeListObj){
		RLCredTypeListObj.onkeydown = nextfocus;
		RLCredTypeListObj.size=1;
		RLCredTypeListObj.multiple=false;	
	}
	//getpath();
	//gettoday();
    CardNoobj.readOnly=true;
    ActiveFlagobj.readOnly=true;
    Flagobj.readOnly=true;
    IDCardNoobj.readOnly=true;
    //ExchangeCardNoobj.readOnly=true;
    PatNameobj.readOnly=true;
    DateFromobj.readOnly=true;
	DateToobj.readOnly=true;
	//RLCredTypeobj.readOnly=true;
    CardVerify="";
    bcheckpwd="";
    bcheckcred="";
    DHCWeb_DisBtn(ReportTheLossobj);
    //ExchCardVerify="";
    var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
	//getdefaultcredtype()
	DHCWebD_ClearAllListA("RLCredTypeList");
	var encmeth=DHCWebD_GetObjValue("ReadCredType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","RLCredTypeList");
		
	}
    websys_setfocus('RegNo');
    if (RegNoobj.value!=""){
			getpatbyregno1(RegNoobj.value);
	}
	var obj=document.getElementById("Query");
	if (obj){
		obj.onclick=Query_OnClick;
	}
}

function ReadAccInfo(){
	if (RegNoobj.value!=""){
		bcheckpwd="";
		bcheckcred="";
		websys_setfocus("RegNo");
		//DHCWeb_DisBtn(ReportTheLossobj);
		///getpatbyregno1(RegNoobj.value)
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

function Query_OnClick(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccCol.CardColQuery";
	open(lnk,"UDHCAccCol_CardColQuery","top=30,left=30, scrollbars=yes,resizable=yes")
}

function Clear_Click()
{	
	//Grant_Click()
	//Exchange_Click()
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccCardRptLoss";
}

function getpatbyRegNo()
{
    var key=websys_getKey(e);
	if (key==13) {
		if (RegNoobj.value!=""){
			bcheckpwd="";
			bcheckcred="";
			DHCWeb_DisBtn(ReportTheLossobj);
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
		//IDCardNoobj.value=val[3];
		if (val[4]!=""&&val[6]=="N"){
		CardNoobj.value=val[4];
		CardVerify=val[5];
		ActiveFlagobj.value=val[6];
		DateFromobj.value=val[7];
		DateToobj.value=val[8];
		CardIDobj.value=val[9];
		Flagobj.value=val[10];
		RLAccBalance=val[11];
		RLCredNo=val[12];
		RLCredType=val[13];
		RLCredTypeID=val[14];
		checkpwd();
		}
		else{
	    CardNoobj.value="";
		CardVerify="";
		DateFromobj.value="";
		DateToobj.value="";
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
			DHCWeb_DisBtn(ReportTheLossobj);
			websys_setfocus('RegNo');
	}
}

function checkpwd()
{
	bcheckpwd="";

	var ren=DHCACC_CheckForNOCard(CardNoobj.value,CardVerify)
	
	var myary=ren.split("^");
	if (myary[0]=='-200'){alert(t[2042]);websys_setfocus('RLName');return;}
	if (myary[0]=='-201'){alert(t[2042]);websys_setfocus('RLName');return;}
	if (myary[0]=='-202'){alert(t[2042]);websys_setfocus('RLName');return;}
	if (myary[0]=='-203'){alert(t[2053]);websys_setfocus('RLName');return;}
	if (myary[0]=='-208'){alert(t[2061]);websys_setfocus('RLName');return;}
	if (myary[0]=='-299'){alert(t[2054]);websys_setfocus('RLName');return;}
	if (myary[0]!='0'){alert(t[2055]);websys_setfocus('RLName');return;}
	if (myary[0]='0'){
		bcheckpwd="OK";
		ReportTheLossobj.disabled=false;
		ReportTheLossobj.onclick = ReportTheLoss_Click;
		websys_setfocus('ReportTheLoss');
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
		//alert(value)
		var val=value.split("^");
		
		
		if (val[4]!=""&&val[6]=="N"){
		CardNoobj.value=val[4];
		CardVerify=val[5];
		RegNoobj.value=val[0];
		RegNo=val[0];
		PatientIDobj.value=val[1];
		PatNameobj.value=val[2];
		//IDCardNoobj.value=val[3];
		ActiveFlagobj.value=val[6];
		DateFromobj.value=val[7];
		DateToobj.value=val[8];
		CardIDobj.value=val[9];
		}
		else{
			RegNoobj.value="";
		RegNo="";
		PatientIDobj.value="";
		PatNameobj.value="";
		IDCardNoobj.value="";
		DateFromobj.value="";
		DateToobj.value="";
			//CardNoobj.value="";
			CardIDobj.value="";
		    //CardVerify="";
		    ActiveFlagobj.value="";
			websys_setfocus('RegNo');
		}
		
		}
function getpatbyIDCardNo()
{
	
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
				ReportTheLossobj.disabled=false;
				ReportTheLossobj.onclick = ReportTheLoss_Click;
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
				//ReportTheLossobj.disabled=false;
				//ReportTheLossobj.onclick = ReportTheLoss_Click;
				//alert(t[2063])
				alert(t[2062])
				websys_setfocus('RLCredNo');
				return;
		}
	}
		
}

function ReportTheLoss_Click() {
	 
	 if (CardIDobj.value=="")
	 {
		alert(t[2018])
			 
			 return;
		 }
	if (ActiveFlagobj.value!="N")
	 {
		alert(t[2018])
			
			 return;
		 }
	DHCWeb_DisBtn(ReportTheLossobj);
	if (bcheckpwd!="OK" && bcheckcred!="OK" && bcheckcred!="F"){alert(t[2062]);return;}
	if (bcheckcred=="F"){
		if (RLNameobj.value==""){alert(t[2064]);websys_setfocus('RLName');return;};
		if (RLCredTypeListObj.value==""){alert(t[2065]);websys_setfocus('RLCredTypeList');return;};
		if (RLCredNoobj.value==""){alert(t[2066]);websys_setfocus('RLCredNo');return;};
		if (RLAddressobj.value==""){alert(t[2067]);websys_setfocus('RLAddress');return;};
	    if (RLPhoneNoobj.value==""){alert(t[2068]);websys_setfocus('RLPhoneNo');return;};
	    
		
	}
	//if (PatNameobj.value!=RLNameobj.value || IDCardNoobj.value!=RLCredNoobj.value)
	
	var mytmparray=RLCredTypeListObj.value.split("^");
	
	p1=CardIDobj.value+"^"+Guser+"^"+computername
	p2=RLNameobj.value+"^"+RLCredNoobj.value+"^"+RLAddressobj.value+"^"+RLPhoneNoobj.value+"^"+RLProofobj.value+"^"+RLRemarkobj.value+"^"+mytmparray[0];
	 // alert(p1)
			var getregno=document.getElementById('reportthelossclass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				
				var ren=cspRunServerMethod(encmeth,'','',p1,p2)
				//alert(ren)
				if (ren=='0'){
			       alert(t[2016])
			       Clear_Click();
				}
				else
				{
					alert(ren+"  "+t[2017])
					}
		 
	}

///document.onkeydown = DHCWeb_EStopSpaceKey;

document.body.onload = BodyLoadHandler;