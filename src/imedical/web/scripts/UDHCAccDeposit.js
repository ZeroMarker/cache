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
	var AccountStatusobj;
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
    AccountStatusobj=document.getElementById('AccountStatus');
    AccountBalanceobj=document.getElementById('AccountBalance');
    
    
    //SetDefPassWobj=document.getElementById('SetDefaultPassword');
    //ChgPasswordobj=document.getElementById('ChgPassword');
	DepPriceobj=document.getElementById('DepPrice');
	CredTypeobj=document.getElementById('CredType');
	//NewAccountobj=document.getElementById('NewAccount');
	//NewAccountClassobj=document.getElementById('NewAccountClass');
	
	AddDepositobj=document.getElementById('AddDeposit');
	
	AddDepositClassobj=document.getElementById('AddDepositClass');
	//CancelAccountobj=document.getElementById('CancelAccount');
	//CancelAccountClassobj=document.getElementById('CancelAccountClass');
	AccountIDobj=document.getElementById('AccountID');
	CardIDobj=document.getElementById('CardID');
	CredTypeIDobj=document.getElementById('CredTypeID');
	Clearobj=document.getElementById('Clear');
	readcardobj=document.getElementById('readcard');
	if (readcardobj) readcardobj.onclick = ReadMagCard_Click
	//if (NewAccountobj) NewAccountobj.onclick = NewAccount_Click;
	if (AddDepositobj) AddDepositobj.onclick = AddDeposit_Click;
	//if (ChgPasswordobj) ChgPasswordobj.onclick = ChgPassWord_Click;
	//if (CancelAccountobj) CancelAccountobj.onclick = CancelAccount_Click;
	//if (Cancelobj) Cancelobj.onclick = Cancel_Click;
	if (Clearobj) Clearobj.onclick = Clear_Click;
	//if (ExchangeCardobj) ExchangeCardobj.onclick = ExchangeCard_Click;
	if (RegNoobj) RegNoobj.onkeydown = getpatbyRegNo;
	if (CardNoobj) CardNoobj.onkeydown = getpatbyCardNo;
	if (IDCardNoobj) IDCardNoobj.onkeydown = getpatbyIDCardNo;
	
	//getpath();
	//gettoday();
    CardNoobj.readOnly=true;
    PatNameobj.readOnly=true;
    AccountNoobj.readOnly=true;
    AccountTypeobj.readOnly=true;
    AccountStatusobj.readOnly=true;
    AccountBalanceobj.readOnly=true;
    CredTypeobj.readOnly=true;
    IDCardNoobj.readOnly=true;
    DepPriceobj.readOnly=true;
    
    var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
    websys_setfocus('RegNo');
    if(RegNoobj.value!=""){
	    getpatbyregno(RegNoobj.value);
	    }
}

function getCredTypeid(value) {
	
	var val=value.split("^");
	
	CredTypeIDobj.value=val[1];
	}

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

function Clear_Click()
{	
	
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccDeposit";
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
			alert("no regno!")
			 websys_setfocus('RegNo');
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
		DepPriceobj.value=val[7];
		AccountTypeobj.value=val[8];
		CredTypeIDobj.value=val[9];
		CredTypeobj.value=val[10];
		IDCardNoobj.value=val[11];
		if ( AccountTypeobj.value==""){ AccountTypeobj.value="P";}
		
		}
function getpatbycard()
{
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
			alert("no regno!")
			 websys_setfocus('RegNo');
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
		CredTypeIDobj.value=val[9];
		CredTypeobj.value=val[10];
		IDCardNoobj.value=val[11];
		if ( AccountTypeobj.value==""){ AccountTypeobj.value="P";}
		
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

function setaccid(value)
{
	var val=value.split("^");
	AccountIDobj.value=val[0];
	AccountNoobj.value=val[1];
	AccountStatusobj.value=val[2];
	//alert(value)
	}
function ReadMagCard_Click(){
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		window.status="Read Card ..."
		var rtn=obj.ReadMagCard("23");
		//obj.DHCACC_ReadMagCard("2");
		//obj.DHCACC_ReadMagCard("3");
		//obj.DHCACC_WrtMagCard("");
		alert(rtn)
		var myary=rtn.split("^");
		//alert(myary)
		if (myary[0]=="0"){
			
			CardNoobj.value=myary[1];
			CardVerify=myary[2];
			getpatbycard();
			}
		else
		{
		   
		   //window.status="Cancel Read Card "	
			}
		
		//alert(rtn);
		if (myary[0]=="-5"){
			window.status="Cancel Read Card "	
		}
			
	}
	
	
}


/*
function ChgPassWord_Click()
{
	
	//getAccPWClass
	if(AccountIDobj.value==""||AccountNoobj.value=="")
	{
		alert("no account ")
		return;
		}
	
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
	ChgAccPWD(AccountIDobj.value,myary[1],Guser,computername);
	}
function ChgAccPWD(p1,p2,p3,p4)
{
	var getregno=document.getElementById('ChgPasswordClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				var rtn=cspRunServerMethod(encmeth,p1,p2,p3,p4);
				if (rtn=="0")
				{
					alert("change account password ok")
					}
				else
				{
					alert(rtn+"   change account password failed")
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

function CancelAccount_Click() {
	
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
document.body.onload = BodyLoadHandler;