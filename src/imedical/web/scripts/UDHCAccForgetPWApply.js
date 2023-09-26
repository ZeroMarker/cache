    var Guser;
	var GuserCode;
	var RegNo;
	var PatientID;
	var PatName;
	var CardNo;
	var IDCardNo;
	var AccountID;
	var RegNoobj;
	var CardNoobj;
	var PatNameobj;
	var PatientIDobj;
	var IDCardNoobj;
    var AccountNoobj;
	var AccountTypeobj;
	var AccTypeobj;
	var AccountStatusobj;
	var AccStatusobj;
	var AccountBalanceobj;
	var CredTypeobj;
	
	var DepPriceobj;
	var NewAccountobj;
	var NewAccountClassobj;
	
	var AddDepositobj;
	var AddDepositClassobj;
	var CancelAccountobj;
	var CancelAccountClassobj;
	var AccountIDobj;
	var CardIDobj;
	var CredTypeIDobj;
	var Clearobj;
	var computername
	var today;
	var CardVerify;
	var readcardobj;
	var SetDefPassWobj;
	var ChgPasswordobj;
	var RLNameobj;
	var RLCredTypeobj;
	var RLCredTypeIDobj;
	var RLCredNoobj;
	var RLAddressobj;
	var RLPhoneNoobj;
	var RLProofobj;
	var RLRemarkobj;
	var ResetPWApplyobj;
	var bcheckcred;
	var RLAccBalance;
	var RLCredNo;
	var RLCredType;
	var RLCredTypeID;
	var getPWDEditReqobj;
	var RLCredTypeListObj;
	

var m_CCMRowID="";
var m_SelectCardTypeRowID="";

function ReadCardType(){
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}
function GetCardTypeRowId(){
	var CardTypeRowId="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getActualValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
}

function GetCardEqRowId(){
	var CardEqRowId="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getActualValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardEqRowId=CardTypeArr[14];
	}
	return CardEqRowId;
}


function GetCardNoLength(){
	var CardNoLength="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getActualValue();

	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	return CardNoLength;
}

function FormatCardNo(){
	var CardNo=DHCC_GetElementData("CardNo");
	if (CardNo!='') {
		var CardNoLength=GetCardNoLength();
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo
}
function combo_CardTypeKeydownHandler(){
	//var myoptval=combo_CardType.getActualValue();
	var myoptval=combo_CardType.getSelectedValue();
	
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	m_SelectCardTypeRowID=myCardTypeDR
	
	if (myCardTypeDR=="")	{	return;	}
	m_CCMRowID=myary[14];
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj){myobj.readOnly = false;}
		DHCWeb_DisBtnA("ReadCard");
	}	else{
		//m_CCMRowID=GetCardEqRowId();
		
		var myobj=document.getElementById("CardNo");
		if (myobj){myobj.readOnly = true;}
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadHFMagCard_Click;
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCWeb_setfocus("CardNo");
	}else{
		DHCWeb_setfocus("ReadCard");
	}
	if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
}



function BodyLoadHandler() {
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	RegNoobj=document.getElementById('RegNo');
	CardNoobj=document.getElementById('CardNo');
	PatNameobj=document.getElementById('PatName');
	PatientIDobj=document.getElementById('PatientID');
	IDCardNoobj=document.getElementById('IDCardNo');
	AccountNoobj=document.getElementById('AccountNo');
	AccountTypeobj=document.getElementById('AccountType');
	AccTypeobj=document.getElementById('AccType');
    AccountStatusobj=document.getElementById('AccountStatus');
    AccStatusobj=document.getElementById('AccStatus');
    AccountBalanceobj=document.getElementById('AccountBalance');
    
    
    //SetDefPassWobj=document.getElementById('SetDefaultPassword');
    ChgPasswordobj=document.getElementById('ChgPassword');
	DepPriceobj=document.getElementById('DepPrice');
	CredTypeobj=document.getElementById('CredType');
	//NewAccountobj=document.getElementById('NewAccount');
	//NewAccountClassobj=document.getElementById('NewAccountClass');
	
	//AddDepositobj=document.getElementById('AddDeposit');
	
	//AddDepositClassobj=document.getElementById('AddDepositClass');
	//CancelAccountobj=document.getElementById('CancelAccount');
	//CancelAccountClassobj=document.getElementById('CancelAccountClass');
	AccountIDobj=document.getElementById('AccountID');
	CardIDobj=document.getElementById('CardID');
	CredTypeIDobj=document.getElementById('CredTypeID');
	Clearobj=document.getElementById('Clear');
	
	RLNameobj=document.getElementById('RLName');
	//RLCredTypeobj=document.getElementById('RLCredType');
	//RLCredTypeIDobj=document.getElementById('RLCredTypeID');
	RLCredNoobj=document.getElementById('RLCredNo');
	RLAddressobj=document.getElementById('RLAddress');
	RLPhoneNoobj=document.getElementById('RLPhoneNo');
	RLProofobj=document.getElementById('RLProof');
	RLRemarkobj=document.getElementById('RLRemark');
	ResetPWApplyobj=document.getElementById('ResetPWApply');
	RLNameobj.onkeydown = nextfocus;
	RLAddressobj.onkeydown = nextfocus;
	RLPhoneNoobj.onkeydown = nextfocus;
	RLProofobj.onkeydown = nextfocus;
	RLRemarkobj.onkeydown = nextfocus;
	getPWDEditReqobj=document.getElementById('getPWDEditReq');
	
	if (RLCredNoobj) RLCredNoobj.onkeydown = RLCredNo_Click;
	readcardobj=document.getElementById('readcard');
	if (readcardobj) readcardobj.onclick = ReadHFMagCard_Click
	//if (NewAccountobj) NewAccountobj.onclick = NewAccount_Click;
	//if (AddDepositobj) AddDepositobj.onclick = AddDeposit_Click;
	if (ResetPWApplyobj) ResetPWApplyobj.onclick = ChgPassWord_Click;
	//if (CancelAccountobj) CancelAccountobj.onclick = CancelAccount_Click;
	//if (Cancelobj) Cancelobj.onclick = Cancel_Click;
	if (Clearobj) Clearobj.onclick = Clear_Click;
	//if (ExchangeCardobj) ExchangeCardobj.onclick = ExchangeCard_Click;
	if (RegNoobj) RegNoobj.onkeydown = getpatbyRegNo;
	if (CardNoobj) CardNoobj.onkeydown = getpatbyCardNo;
	if (IDCardNoobj) IDCardNoobj.onkeydown = getpatbyIDCardNo;
	RLCredTypeListObj=document.getElementById('RLCredTypeList');
		RLCredTypeListObj.onkeydown = nextfocus;
		RLCredTypeListObj.size=1;
		RLCredTypeListObj.multiple=false;	
	//getpath();
	//gettoday();
    RegNoobj.readOnly=true;
    CardNoobj.readOnly=true;
    PatNameobj.readOnly=true;
    AccountNoobj.readOnly=true;
    AccountTypeobj.readOnly=true;
    AccTypeobj.readOnly=true;
    AccountStatusobj.readOnly=true;
    AccStatusobj.readOnly=true;
    AccountBalanceobj.readOnly=true;
    CredTypeobj.readOnly=true;
    CardNoobj.readOnly=true;
    IDCardNoobj.readOnly=true;
    DepPriceobj.readOnly=true;
    //RLCredTypeobj.readOnly=true;
    bcheckcred="";
    DHCWeb_DisBtn(ResetPWApplyobj);
    var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
	DHCWebD_ClearAllListA("RLCredTypeList");
	var encmeth=DHCWebD_GetObjValue("ReadCredType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","RLCredTypeList");
		
	}
	
	var obj=document.getElementById('CardTypeDefine');
	if (obj) {
	          ReadCardType();
	          obj.setAttribute("isDefualt","true");
	          combo_CardType=dhtmlXComboFromSelect("CardTypeDefine");
	          }
	
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	combo_CardTypeKeydownHandler();
	//getdefaultcredtype()
    //websys_setfocus('RegNo');
    //if(RegNoobj.value!=""){
	//   getpatbyregno(RegNoobj.value);
	//    }
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
function getacctype(value) {
	
	var val=value.split("^");
	
	AccountTypeobj.value=val[1];
	}
function getCredTypeid(value) {
	
	var val=value.split("^");
	
	CredTypeIDobj.value=val[1];
	}
function getRLCredTypeid(value) {
	
	var val=value.split("^");
	
	RLCredTypeIDobj.value=val[1];
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
				ResetPWApplyobj.disabled=false;
				ResetPWApplyobj.onclick = ChgPassWord_Click;
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
				//ResetPWApplyobj.disabled=false;
				//ResetPWApplyobj.onclick = ChgPassWord_Click;
				//alert(t[2063])
				alert(t[2062]);
				websys_setfocus('RLPhoneNo');
				return;
			}
		
		}
		
	}
function ChgPassWord_Click()
{
	
	
	
	if(AccountIDobj.value==""||AccountNoobj.value=="")
	{
		alert(t[2080])
		return;
		}
	DHCWeb_DisBtn(ResetPWApplyobj);
	if (bcheckcred!="OK" && bcheckcred!="F"){alert(t[2062]);return;}
	
	if (bcheckcred=="F"){
		
		if (RLNameobj.value==""){alert(t[2064]);websys_setfocus('RLName');return;};
		
		if (RLCredTypeListObj.value==""){alert(t[2065]);websys_setfocus('RLCredTypeList');return;};
		
		if (RLCredNoobj.value==""){alert(t[2066]);websys_setfocus('RLCredNo');return;};
		if (RLAddressobj.value==""){alert(t[2067]);websys_setfocus('RLAddress');return;};
	   
	    if (RLPhoneNoobj.value==""){alert(t[2068]);websys_setfocus('RLPhoneNo');return;};
	    
		
		}
	
	/*
	var rtn=getAccPassSec(AccountIDobj.value,CardIDobj.value);
	//alert(rtn)
	var myary=rtn.split("^");
	if (myary[0]!="0")
	{
	    alert(myary[0])
	    return;	
		}
	var myExpStr="3^^^^"+myary[2]
	rtn=DHCACC_ChangePWD(myary[1],myExpStr)
    myary=rtn.split("^");
    if (myary[0]!="0")
	{
	    alert(myary[0])
	    return;	
		}
	*/
	var mytmparray=RLCredTypeListObj.value.split("^");
	p1=AccountIDobj.value;
	p2=Guser;
	p3=computername;
	p4=RLNameobj.value+"^"+RLCredNoobj.value+"^"+RLAddressobj.value+"^"+RLPhoneNoobj.value+"^"+RLProofobj.value+"^"+RLRemarkobj.value+"^"+mytmparray[0];
	
	var getregno=document.getElementById('ResetPWApplyClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				var rtn=cspRunServerMethod(encmeth,p1,p2,p3,p4);
				if (rtn=="0")
				{
					alert(t[2081])
					Clear_Click();
					}
				else
				{
					alert(rtn+"  "+t[2082])
					return
					}
	}
function getAccPassSec(accid,cardid)
{
	if (accid=="") return;
			p1=accid;
			p2=cardid;
			var getregno=document.getElementById('getAccPWClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				var rtn=cspRunServerMethod(encmeth,p1,p2);
	return rtn;
	}

function Clear_Click()
{	
	
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccForgetPWApply";
	}	
function getpatbyregno(regno)
{
	        
	        if (regno=="") return;
			p1=regno
			var getregno=document.getElementById('getpatclass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpatinfo_val','',p1,"","","","")=='1'){
			
				}
			
	
	
	}
function getpatbyRegNo()
{
    var key=websys_getKey(e);
	if (key==13) {
		if (RegNoobj.value!=""){
		getpatbyregno(RegNoobj.value);
		}
		}
	}

function setpatinfo_val(value)
	{
		//str=RegNo_"^"_Papmi_"^"_name_"^"_ActiveFlag_"^"_CardNo_"^"_AccNo_"^"_Balance_"^"_DepPrice_"^"_AccType_"^"_CredType_"^"_IDCardNo
	//	alert(value)
		var val=value.split("^");
		if (val[0]==""){
			alert(t[2001])
			 websys_setfocus('RegNo');
			 return;
			}
		if (val[3]!="N")
		{
			alert(t[2080]);
			return;
			}
		RegNoobj.value=val[0];
		PatientIDobj.value=val[1];
		PatNameobj.value=val[2];
		CardNoobj.value=val[4];
		CardVerify=val[12];
	    CardIDobj.value=val[13];
		
		AccountIDobj.value=val[14];
		AccountNoobj.value=val[5];
		AccountBalanceobj.value=val[6];
		AccountStatusobj.value=val[3];
		AccStatusobj.value=val[16];
		DepPriceobj.value=val[7];
		AccountTypeobj.value=val[8];
		AccTypeobj.value=val[15];
		//CredTypeIDobj.value=val[9];
		//CredTypeobj.value=val[10];
		//IDCardNoobj.value=val[11];
		RLAccBalance=val[6];
		RLCredTypeID=val[9];
		RLCredNo=val[11];
		//if ( AccountTypeobj.value==""){ AccountTypeobj.value="P";AccTypeobj.value="P";}
		
		}
function getpatbycard()
{
	
	bcheckcred="";
    DHCWeb_DisBtn(ResetPWApplyobj);
	if (CardNoobj.value!=""){
			p1=CardNoobj.value
			p2=CardVerify
			//alert(CardVerify)
			var getregno=document.getElementById('getpatclass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpatinfo_val2','',"","",p1,p2,"")=='1'){
			
				}
			
			}
	}
function setpatinfo_val2(value)
	{
		//str=RegNo_"^"_Papmi_"^"_name_"^"_ActiveFlag_"^"_CardNo_"^"_AccNo_"^"_Balance_"^"_DepPrice_"^"_AccType_"^"_CredType_"^"_IDCardNo
		//alert(value)
		var val=value.split("^");
		if (val[0]==""){
			alert(t[2001])
			websys_setfocus('readcard');
			 return;
			}
		if (val[3]!="N")
		{
			alert(t[2080]);
			websys_setfocus('readcard');
			return;
			}
		RegNoobj.value=val[0];
		PatientIDobj.value=val[1];
		PatNameobj.value=val[2];
		//CardNoobj.value=val[4];
		//CardVerify=val[12];
	    CardIDobj.value=val[13];
		
		AccountIDobj.value=val[14];
		AccountNoobj.value=val[5];
		AccountBalanceobj.value=val[6];
		AccountStatusobj.value=val[3];
		DepPriceobj.value=val[7];
		AccountTypeobj.value=val[8];
		//CredTypeIDobj.value=val[9];
		//CredTypeobj.value=val[10];
		//IDCardNoobj.value=val[11];
		RLAccBalance=val[6];
		RLCredTypeID=val[9];
		RLCredNo=val[11];
		//if ( AccountTypeobj.value==""){ AccountTypeobj.value="P";}
		
		}
function getpatbyCardNo()
{
	var key=websys_getKey(e);
	if (key==13) {
		getpatbycard();
		}
	}	
function getpatbyIDCardNo()
{
	
	}	


/*
function AddDeposit_Click() {
	//alert(AccountIDobj.value);
	if (AccountIDobj.value!=""){
		var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit&AccountID='+AccountIDobj.value+"&CardNo="+CardNoobj.value;
		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
	}
	else
	{
		alert("no account!");
		return;
		}
	}
function CancelAccount_Click() {
	
	}
function Cancel_Click() {
	 
	}
function NewAccount_Click() {
	var Password;
	if(AccountIDobj.value!=""||AccountNoobj.value!="")
	{
		alert("account has exist")
			 websys_setfocus('RegNo');
			 return;
		}
	if (AccountStatusobj.value=="S")
	{
		alert("account has Suspend")
		websys_setfocus('RegNo');
		return;
		}
	 if (RegNoobj.value==""||PatientIDobj.value=="")
	 {
		 alert("no regno")
			 websys_setfocus('RegNo');
			 return;
		 }
	if (CardNoobj.value=="")
	 {
		alert("no card no!")
			 websys_setfocus('CardNo');
			 return;
		 }
	if (AccountTypeobj.value=="")
	 {
		alert("no Account Type!")
			 websys_setfocus('AccountType');
			 return;
		 }
	
	  if (SetDefPassWobj.checked)
	  {
		  var ren=DHCACC_GetValidatePWD(CardVerify);
		  var myary=ren.split("^");
				
				if (myary[0]=='0'){ 
				 Password=myary[1];
				}
				else
				{
					alert("set password failed");
					return;
					}
		  }
	  else
	  {
		  var ren=DHCACC_SetAccPWD();
		  var myary=ren.split("^");
				
				if (myary[0]=='0'){ 
				 Password=myary[1];
				}
				else
				{
					alert("set password failed");
					return;
					}
		  }
	//alert(Password)
	//return
	  //str=AccountNo_"^"_papmi_"^"_RegNo_"^"_CardNo_"^"_user_"^"_Password_"^"_Depprice_"^"_AccountType_"^"_CredType_"^"_IDCardNo_"^"_CardID
	  p1=AccountNoobj.value+"^"+PatientIDobj.value+"^"+RegNoobj.value+"^"+CardNoobj.value+"^"+Guser+"^"+Password+"^"+DepPriceobj.value+"^"+AccountTypeobj.value+"^"+CredTypeIDobj.value+"^"+IDCardNoobj.value+"^"+CardIDobj.value
	//  alert(p1)
	 // return
			var getregno=document.getElementById('NewAccountClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				
				var ren=cspRunServerMethod(encmeth,'setaccid','',p1)
				
				if (ren=='1'){
					alert("Account has exist!")
			        return
				}
				if (ren=='-306'){
					alert("patient has a Account!")
			        return
				}
				if (ren=='0'){
					alert("New Account ok!")
			
				}
				else
				{
					
					alert(ren+" New Account failed!")
			
			
					}
				
	}
*/
function setaccid(value)
{
	var val=value.split("^");
	AccountIDobj.value=val[0];
	AccountNoobj.value=val[1];
	AccountStatusobj.value=val[2];
	//alert(value)
	}
	
	
function ReadHFMagCard_Click()
{
	
	window.status=t[2007]
	var myoptval=combo_CardType.getSelectedValue();
	var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeRowID,myoptval);
	var myary=myrtn.split("^");
	if (myary[0]=='-5') {window.status=t[2008];return;};
	window.status="";
	
	var rtn=myary[0];
	switch (rtn){
		case "0":
			CardNoobj.value=myary[1];
			CardVerify=myary[2];
			getpatbycard();
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
		window.status=""
		//alert(myary)
		if (myary[0]=="0"){
			
			CardNoobj.value=myary[1];
			CardVerify=myary[2];
			getpatbycard();
			}
		
	//	alert(rtn);
	}
	
	
}

////document.onkeydown = DHCWeb_EStopSpaceKey;

document.body.onload = BodyLoadHandler;