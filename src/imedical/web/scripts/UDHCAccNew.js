    var Guser;
	var GuserCode;
	var GroupID;
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
	
	var BankObj;
	var BankCardTypeObj;
	var PayModeObj;
	var amtObj;
	var ReceiptsNoObj;
	var PayCompanyObj;
	var CardChequeNoObj;
	var ChequeDateObj;
	var PayAccNoObj;
	var RemarkObj;
	var AccountTypeListobj;
	var CredTypeListobj;

var m_CCMRowID="";
var m_SelectCardTypeRowID="";
var m_ReceiptsType ="";

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
	GroupID=session['LOGON.GROUPID'];
	RegNoobj=document.getElementById('RegNo');
	CardNoobj=document.getElementById('CardNo');
	PatNameobj=document.getElementById('PatName');
	PatientIDobj=document.getElementById('PatientID');
	IDCardNoobj=document.getElementById('IDCardNo');
	
	AccountNoobj=document.getElementById('AccountNo');
	//AccountTypeobj=document.getElementById('AccountType');
    AccountStatusobj=document.getElementById('AccountStatus');
    //AccTypeobj=document.getElementById('AccType');
    AccStatusobj=document.getElementById('AccStatus');
    AccountBalanceobj=document.getElementById('AccountBalance');
    
    
    SetDefPassWobj=document.getElementById('SetDefaultPassword');
    //ChgPasswordobj=document.getElementById('ChgPassword');
	DepPriceobj=document.getElementById('DepPrice');
	//CredTypeobj=document.getElementById('CredType');
	NewAccountobj=document.getElementById('NewAccount');
	NewAccountClassobj=document.getElementById('NewAccountClass');
	
	//AddDepositobj=document.getElementById('AddDeposit');
	BankObj=document.getElementById('Bank');
		BankObj.onkeydown = nextfocus;
		BankObj.size=1;
		BankObj.multiple=false;
	BankCardTypeObj=document.getElementById('BankCardType');
		BankCardTypeObj.onkeydown = nextfocus;
		BankCardTypeObj.size=1;
		BankCardTypeObj.multiple=false;
	AccountTypeListobj=document.getElementById('AccountTypeList');
		AccountTypeListobj.onkeydown = nextfocus;
		AccountTypeListobj.size=1;
		AccountTypeListobj.multiple=false;
	CredTypeListobj=document.getElementById('CredTypeList');
		CredTypeListobj.onkeydown = nextfocus;
		CredTypeListobj.size=1;
		CredTypeListobj.multiple=false;	
	PayModeObj=document.getElementById('PayMode');
		PayModeObj.onchange=PayModeObj_OnChange;
		PayModeObj.onkeydown = nextfocus;
		PayModeObj.size=1;
		PayModeObj.multiple=false;	
	amtObj=document.getElementById('amt');
	amtObj.onkeydown = nextfocus;
	ReceiptsNoObj=document.getElementById('ReceiptsNo');
	ReceiptsNoObj.readOnly=true
	PayCompanyObj=document.getElementById("PayCompany");
	PayCompanyObj.onkeydown = nextfocus;
	BankObj=document.getElementById("Bank");
	BankObj.onkeydown = nextfocus;
	BankCardTypeObj=document.getElementById("BankCardType");
	BankCardTypeObj.onkeydown = nextfocus;
	CardChequeNoObj=document.getElementById("CardChequeNo");
	CardChequeNoObj.onkeydown = nextfocus;
	ChequeDateObj=document.getElementById("ChequeDate");
	ChequeDateObj.onkeydown = nextfocus;
	PayAccNoObj=document.getElementById("PayAccNo");
	PayAccNoObj.onkeydown = nextfocus;
	RemarkObj=document.getElementById("Remark");
	RemarkObj.onkeydown = nextfocus;
	//AddDepositClassobj=document.getElementById('AddDepositClass');
	//CancelAccountobj=document.getElementById('CancelAccount');
	//CancelAccountClassobj=document.getElementById('CancelAccountClass');
	AccountIDobj=document.getElementById('AccountID');
	CardIDobj=document.getElementById('CardID');
	CredTypeIDobj=document.getElementById('CredTypeID');
	Clearobj=document.getElementById('Clear');
	readcardobj=document.getElementById('readcard');
	if (readcardobj) readcardobj.onclick = ReadHFMagCard_Click
	if (NewAccountobj) NewAccountobj.onclick = NewAccount_Click;
	//if (AddDepositobj) AddDepositobj.onclick = AddDeposit_Click;
	//if (ChgPasswordobj) ChgPasswordobj.onclick = ChgPassWord_Click;
	//if (CancelAccountobj) CancelAccountobj.onclick = CancelAccount_Click;
	//if (Cancelobj) Cancelobj.onclick = Cancel_Click;
	if (Clearobj) Clearobj.onclick = Clear_Click;
	//if (ExchangeCardobj) ExchangeCardobj.onclick = ExchangeCard_Click;
	if (RegNoobj) RegNoobj.onkeydown = getpatbyRegNo;
	if (CardNoobj) CardNoobj.onkeydown = getpatbyCardNo;
	if (IDCardNoobj) IDCardNoobj.onkeydown = nextfocus;
	
	//getpath();
	//gettoday();
	RegNoobj.readOnly=true;
    CardNoobj.readOnly=true;
    PatNameobj.readOnly=true;
    AccountNoobj.readOnly=true;
    //AccountTypeobj.readOnly=true;
    AccountStatusobj.readOnly=true;
    //AccTypeobj.readOnly=true;
    AccStatusobj.readOnly=true;
    AccountBalanceobj.readOnly=true;
    //CredTypeobj.readOnly=true;
    DepPriceobj.readOnly=true;
    
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
	GetCurrentRecNo()
  IntDoc()
	//SetPayInfoStatus(true)
	PayModeObj_OnChange()
	DHCP_GetXMLConfig("DepositPrintEncrypt","UDHCAccDeposit");
    var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
    //websys_setfocus('RegNo');
    if(RegNoobj.value!=""){
	    getpatbyregno(RegNoobj.value);
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
function IntDoc(){
	
	DHCWebD_ClearAllListA("Bank");
	var encmeth=DHCWebD_GetObjValue("ReadBankEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","Bank");
		
	}
	DHCWebD_ClearAllListA("AccountTypeList");
	var encmeth=DHCWebD_GetObjValue("ReadAccountType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","AccountTypeList");
		
	}
	DHCWebD_ClearAllListA("BankCardType");
	var encmeth=DHCWebD_GetObjValue("ReadBankCardType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","BankCardType");
		
	}
	
	DHCWebD_ClearAllListA("PayMode");
	var encmeth=DHCWebD_GetObjValue("ReadPayMode");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PayMode",GroupID);
		
	}
	
	DHCWebD_ClearAllListA("CredTypeList");
	var encmeth=DHCWebD_GetObjValue("ReadCredType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CredTypeList");

	}
	var encmeth=DHCWebD_GetObjValue("ReadAccParaEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth);
		var myary=rtn.split("^");
		if (isNaN(myary[0])){
			var myVal=0;
		}else{
			var myVal=parseInt(myary[0]);
		}
		if (myVal=1){
			
		}
		DHCWebD_SetObjValueA("SetDefaultPassword",myVal);
	}
	combo_CardTypeKeydownHandler();
}
function PayModeObj_OnChange()
{
	
		if (PayModeObj.options.length==0){
			SetPayInfoStatus(true);
			return;
		}
		var myIdx=PayModeObj.options.selectedIndex;
		if (myIdx==-1){
			SetPayInfoStatus(true);
			return;}
		var myary=PayModeObj.options[myIdx].value.split("^");
		
		if (myary[2]=="Y"){
			SetPayInfoStatus(false);
		}else{
			SetPayInfoStatus(true);
		}
	
	}
function IsNumber(string,sign) 
{ 
var number; 
if (string==null) return false; 
if ((sign!=null)&&(sign!='-')&&(sign!='+')) 
{ 
	return false; 
}

number = new Number(string);

if (isNaN(number)) 
{ 
	return false; 
} 
else if ((sign==null)||(sign=='-'&&number<0)||(sign=='+'&&number>0)) 
{ 
	return true; 
} 
else 
	return false; 
}
function GetCurrentRecNo()
{
	        
			var p1=Guser;
			var p2="D";
			var getregno=document.getElementById('GetCurrentRecNoClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
			var ren=cspRunServerMethod(encmeth,p1,p2);
			 var myary=ren.split("^");
				
				if (myary.length>5) m_ReceiptsType=myary[5];
				if (myary[0]=='0'){
					
					ReceiptsNoObj.value=myary[3];
					}
					else
					{
						alert(t[2072]);
						
						}
	
	}
function textimemode()
{
	
	document.all.IDCardNo.style.imeMode = "disabled";
    document.all.PayCompany.style.imeMode = "active";
    document.all.Remark.style.imeMode = "active";
	document.all.amt.style.imeMode = "disabled";
	document.all.CardChequeNo.style.imeMode = "disabled";
	document.all.ChequeDate.style.imeMode = "disabled";
	document.all.PayAccNo.style.imeMode = "disabled";
	}
function SetPayInfoStatus(SFlag)
{
	
		PayCompanyObj.disabled=SFlag;
		BankObj.disabled=SFlag;
		BankCardTypeObj.disabled=SFlag;
		CardChequeNoObj.disabled=SFlag;
		ChequeDateObj.disabled=SFlag;
		PayAccNoObj.disabled=SFlag;
		RemarkObj.disabled=SFlag;

	}
function getacctype(value) {
	
	var val=value.split("^");
	
	AccountTypeobj.value=val[1];
	}
function getCredTypeid(value) {
	
	var val=value.split("^");
	
	CredTypeIDobj.value=val[1];
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
*/
function Clear_Click()
{	
	
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccNew";
	}	
function AddDeposit_Click() {
	//alert(AccountIDobj.value);
	if (AccountIDobj.value!=""){
		var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit&AccountID='+AccountIDobj.value+"&CardNo="+CardNoobj.value+'&RegNo='+RegNoobj.value+'&PatName='+PatNameobj.value;
		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
	}
	else
	{
		alert(t[2030]);
		return;
		}
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
		//alert(value)
		var val=value.split("^");
		if (val[0]==""){
			alert(t[2001])
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
		AccStatusobj.value=val[16];
		DepPriceobj.value=val[7];
		//AccountTypeobj.value=val[8];
		//AccTypeobj.value=val[15];
		CredTypeIDobj.value=val[9];
		//CredTypeobj.value=val[10];
		//IDCardNoobj.value=val[11];
		//if ( AccountTypeobj.value==""){ AccountTypeobj.value="P";AccTypeobj.value="P";}
		
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
			
			alert(t[2003])
			CardNoobj.value=""
			 websys_setfocus('RegNo');
			 return;
			}
		if (val[3]=="N")
		{
			alert(t[2031])
			return
			}
		if (val[3]=="S")
		{
			alert(t[2032])
			return
			}
		RegNoobj.value=val[0];
		PatientIDobj.value=val[1];
		PatNameobj.value=val[2];
		//CardNoobj.value=val[4];
		//CardVerify=val[12];
	    CardIDobj.value=val[13];
		AccountIDobj.value="";           //val[14];
		AccountNoobj.value="";           //val[5];
		AccountBalanceobj.value="";      //val[6];
		AccountStatusobj.value="";		 //val[3];
		AccStatusobj.value="";           //val[16];
		DepPriceobj.value="";            //val[7];
		//AccountTypeobj.value=val[8];
		//AccTypeobj.value=val[15];
		CredTypeIDobj.value=val[9];
		//CredTypeobj.value=val[10];
		//IDCardNoobj.value=val[11];
		
		//if ( AccountTypeobj.value==""){ AccountTypeobj.value="P";}
		websys_setfocus('IdCardNo')
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




function Cancel_Click() {
	 
	}
function NewAccount_Click() {
	var Password="000000";
	
	if ((amtObj.value!="")&&(amtObj.value!="0")&&(ReceiptsNoObj.value=="")&&(m_ReceiptsType!=""))
	{
		alert(t[2072])
		return;
		}
	if(AccountIDobj.value!=""||AccountNoobj.value!="")
	{
		alert(t[2035])
			 websys_setfocus('RegNo');
			 return;
		}
	if (AccountStatusobj.value=="S")
	{
		alert(t[2032])
		websys_setfocus('RegNo');
		return;
		}
	 if (RegNoobj.value==""||PatientIDobj.value=="")
	 {
		 alert(t[2019])
			 websys_setfocus('RegNo');
			 return;
		 }
	if (CardNoobj.value==""||CardIDobj.value=="")
	 {
		alert(t[2002])
			 websys_setfocus('CardNo');
			 return;
		 }
		
	if (AccountTypeListobj.value=="")
	 {
		alert(t[2033])
			 websys_setfocus('AccountTypeList');
			 return;
		 }
	
	  if (SetDefPassWobj.checked)
	  {
		  //var ren=DHCACC_GetValidatePWD(CardVerify);
		  
		  //var ren=DHCACC_GetValidatePWDOld(CardVerify);
		  //var ren=DHCACC_GetValidatePWDOld(Password);
		  //2015-03-31 Lid 修改此处时一定与医生站组发卡界面的程序保持一致。
		  var ren=DHCACC_GetValidatePWD(Password);

		  var myary=ren.split("^");
				
				if (myary[0]=='0'){ 
				 Password=myary[1];
				}
				else
				{
					alert(t[2034]);
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
					alert(t[2034]);
					return;
					}
		  }
	  //str=AccountNo_"^"_papmi_"^"_RegNo_"^"_CardNo_"^"_user_"^"_Password_"^"_Depprice_"^"_AccountType_"^"_CredType_"^"_IDCardNo_"^"_CardID
	  	var mytmparray=PayModeObj.value.split("^");
		var PayModeid=mytmparray[0];
		if (mytmparray[2]=="Y"){
			
				///Require Pay Info
				var myCheckNO=DHCWebD_GetObjValue("CardChequeNo");
				if (myCheckNO==""){
					alert(t['InCheckNo']);     ////
					websys_setfocus("CardChequeNo");
					return false;
				}
				
		   }
		var AccountTypeid=AccountTypeListobj.value
		var Bankid=""
		var BankCardTypeid=""
		var CredTypeid=""
		if (CredTypeListobj.value!=""){
			mytmparray=CredTypeListobj.value.split("^");
			CredTypeid=mytmparray[0]
			}
		if (BankObj.value!="")
		{mytmparray=BankObj.value.split("^");
		 Bankid=mytmparray[0];}
		if (BankCardTypeObj.value!="")
		{mytmparray=BankCardTypeObj.value.split("^");
		 BankCardTypeid=mytmparray[0];}
	  p1=AccountNoobj.value+"^"+PatientIDobj.value+"^"+RegNoobj.value+"^"+CardNoobj.value+"^"+Guser+"^"+Password+"^"+DepPriceobj.value+"^"+AccountTypeid+"^"+CredTypeid+"^"+IDCardNoobj.value+"^"+CardIDobj.value
	  p2=""+"^"+amtObj.value+"^"+Guser+"^"+ReceiptsNoObj.value+"^"+""+"^"+Password+"^"+PayModeid+"^"+BankCardTypeid+"^"+CardChequeNoObj.value+"^"+Bankid+"^"+PayCompanyObj.value+"^"+PayAccNoObj.value+"^"+ChequeDateObj.value+"^"+RemarkObj.value+"^P"
	  ///alert(p1)
	  ///alert(p2)
	  ///return
			var getregno=document.getElementById('NewAccountClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				
				//var ren=cspRunServerMethod(encmeth,'setaccid','',p1,p2)
				var rtn=cspRunServerMethod(encmeth,'','',p1,p2)
				var myary=rtn.split("^");
				var ren=myary[0]
				if (ren=='1'){
					alert(t[2035])
			        return
				}
				if (ren=='-306'){
					alert(t[2036])
			        return
				}
				if (ren=='0'){
					if (amtObj.value>0){
					Print_Click(rtn)
					}
					alert(t[2037])
			        Clear_Click()
				}
				else
				{
					
					alert(ren+t[2038])
			        return
			
					}
				
	}
function Print_Click(value)
{
	var val=value.split("^")
	var TxtInfo,ListInfo
	var c=String.fromCharCode(2)
	TxtInfo="CardNo"+c+CardNoobj.value+"^"+"PatName"+c+PatNameobj.value+"^"+"amt"+c+val[2]+"^"+"amtdx"+c+val[3]+"^"
	TxtInfo=TxtInfo+"Balance"+c+val[4]+"^"+"Guser"+c+GuserCode+"^"+"Datetime"+c+val[5]
	TxtInfo+="^BillNo"+c+val[6];
	//alert(TxtInfo)
	//return
	ListInfo=""
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
	}
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
	///alert(myrtn)
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
		  CardNoobj.value=myary[1];
			CardVerify=myary[2];
			getpatbycard();
			break;
			//alert(t[rtn]);
			//break;
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