////UDHCAccAddDeposit.FNoCard.js
////for No Card zhaocz  2006-07-23
	var Guser;
	var GuserCode;
	var RegNo;
	var PatientID;
	var PatName;
	var CardNo;
	var CardVerify;
	var ExchCardVerify;
	var IDCardNo;
	var Companyobj;
	var PayAccNoobj;
	var ChequeDateobj;
	var Remarkobj;
	var AccountIDobj;
	var CardNoobj;
	var amtobj;
	var ReceiptsNoobj;
	var BackReasonobj;
	var AddDepositobj;
	var AddDepositClassobj;
	var PayModeobj;
	var PayModeIDobj;
	var BankCardTypeobj;
	var BankCardTypeIDobj;
	var CardChequeNoobj;
	var Bankobj;
	var BankIDobj;
	var Clearobj;
	var Passwordobj;
	var computername
	var today;
	var PayModeIDobj;
	var CardVerify;
	var readcardobj;
	var Balanceobj;
	var GroupID;
	var PayModeListobj;
	var BankListobj;
	var BankCardTypeobj;
	
function BodyLoadHandler() {
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	GroupID=session['LOGON.GROUPID'];
	
	RegNoobj=document.getElementById('RegNo');
	PatNameobj=document.getElementById('PatName');
	Companyobj=document.getElementById('Company');
	PayAccNoobj=document.getElementById('PayAccNo');
	ChequeDateobj=document.getElementById('ChequeDate');
	Remarkobj=document.getElementById('Remark');
	AccountIDobj=document.getElementById('AccountID');
	CardNoobj=document.getElementById('CardNo');
	amtobj=document.getElementById('amt');
	ReceiptsNoobj=document.getElementById('ReceiptsNo');
	BackReasonobj=document.getElementById('BackReason');
	AddDepositobj=document.getElementById('AddDeposit');
	AddDepositClassobj=document.getElementById('AddDepositClass');
	CardChequeNoobj=document.getElementById('CardChequeNo');
	Clearobj=document.getElementById('Clear');
	Balanceobj=document.getElementById('Balance');
	BankListobj=document.getElementById('BankList');
	if (BankListobj){
		BankListobj.onkeydown = nextfocus;
		BankListobj.size=1;
		BankListobj.multiple=false;
	}
	BankCardTypeListobj=document.getElementById('BankCardTypeList');
	if (BankCardTypeListobj){
		BankCardTypeListobj.onkeydown = nextfocus;
		BankCardTypeListobj.size=1;
		BankCardTypeListobj.multiple=false;
	}
	PayModeListobj=document.getElementById('PayModeList');
	if (PayModeListobj){
		PayModeListobj.onchange=PayModeObj_OnChange;
		PayModeListobj.onkeydown = nextfocus;
		PayModeListobj.size=1;
		PayModeListobj.multiple=false;
	}	
    readcardobj=document.getElementById('ReadCard');
	if (readcardobj) {readcardobj.onclick = ReadMagCard_Click;}
	
	if (AddDepositobj) {AddDepositobj.onclick = AddDeposit_Click;}
	
	if (Clearobj) {Clearobj.onclick = Clear_Click;}
	
	amtobj.onkeydown = nextfocus;
	amtobj.onkeypress= DHCWeb_SetLimitFloat;
	Companyobj.onkeydown = nextfocus;
	
		CardChequeNoobj.onkeydown = nextfocus;
		ChequeDateobj.onkeydown = nextfocus;
		PayAccNoobj.onkeydown = nextfocus;
		Remarkobj.onkeydown = nextfocus;
	if (RegNoobj){
		RegNoobj.onkeydown = getpatbyRegNo;
	}
	if (CardNoobj) CardNoobj.onkeydown = getpatbyCardNo;
	CardNoobj.readOnly=true;
    PatNameobj.readOnly=true;
	if ((PatNameobj)&&(PatNameobj.value!="")){
		PatNameobj.value=unescape(PatNameobj.value)
	}
	ReceiptsNoobj.readOnly=true;
    Balanceobj.readOnly=true;
    getAccBalance()
    IntDoc()
    //SetPayInfoStatus(true);
    PayModeObj_OnChange()
    //getdefaultpaymode();
    DHCP_GetXMLConfig("DepositPrintEncrypt","UDHCAccDeposit");
   // GetCurrentRecNo();
     var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
    if (RegNoobj.value=="")
    {
    	websys_setfocus('RegNo');
    }
    else
    {
	    websys_setfocus('amt');
	}
	DHCWeb_DisBtnA("RePrint");

   	var obj=document.getElementById("PatCal");
   	if (obj){
	   	obj.onclick=PatCal_OnClick;
   	}
	
	document.onkeydown=Doc_OnKeyDown;
}

function PatCal_OnClick(){
	FootExpCalculate();
}

function Doc_OnKeyDown(){
	if ((event.altKey)&&((event.keyCode==82)||(event.keyCode==114)))
	{
		////Alt+R
		document.onkeydown=function(){return false;}
		DHCWeb_DisBtnA("ReadCard");
		///alert("");
		ReadMagCard_Click();
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadMagCard_Click;
		}
		document.onkeydown=Doc_OnKeyDown;
	}
	DHCWeb_EStopSpaceKey();
}

function amt_onkeydown()
{
	var key=websys_getKey(e);
	if (key==13) {
		if (amtobj.value!=""){
			websys_setfocus('AddDeposit');
		}
		}
}
function RePrint_Click(){
	var obj=document.getElementById("PreDepInfo");
	if (obj){
		var mystr=obj.value+"^"+t["RPTip"]+"^";
		Print_Click(mystr);
		///var mystr=obj.value+"^"+t["RPTip"]+"^"+"***********";
		///Print_Click(mystr);
	}
}

function getAccBalance()
{
	if (AccountIDobj.value!="") {
			p1=AccountIDobj.value
			var getregno=document.getElementById('getBalanceClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
			var ren=cspRunServerMethod(encmeth,p1)
			Balanceobj.value=ren
	}
	
	}
function GetCurrentRecNo()
{ 
			p1=Guser
			p2="D"
			var getregno=document.getElementById('GetCurrentRecNoClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
			var ren=cspRunServerMethod(encmeth,p1,p2)
			 var myary=ren.split("^");
				
				
				if (myary[0]=='0'){
					
					ReceiptsNoobj.value=myary[3]
					}
					else
					{
						alert(t[2072])
						
						}
	
	}
function IntDoc(){
	
	DHCWebD_ClearAllListA("BankList");
	var encmeth=DHCWebD_GetObjValue("ReadBankEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","BankList");
		
	}
	
	DHCWebD_ClearAllListA("BankCardTypeList");
	var encmeth=DHCWebD_GetObjValue("ReadBankCardType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","BankCardTypeList");
		
	}
	
	DHCWebD_ClearAllListA("PayModeList");
	var encmeth=DHCWebD_GetObjValue("ReadPayMode");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PayModeList",GroupID);
		
	}
}
function PayModeObj_OnChange()
{
	
		if (PayModeListobj.options.length==0){
			SetPayInfoStatus(true);
			return;
		}
		var myIdx=PayModeListobj.options.selectedIndex;
		if (myIdx==-1){
			SetPayInfoStatus(true);
			return;}
		var myary=PayModeListobj.options[myIdx].value.split("^");
		
		if (myary[2]=="Y"){
			SetPayInfoStatus(false);
		}else{
			SetPayInfoStatus(true);
		}
	
	}
function SetPayInfoStatus(SFlag)
{
	    
		Companyobj.disabled=SFlag;
		BankListobj.disabled=SFlag;
		BankCardTypeListobj.disabled=SFlag;
		CardChequeNoobj.disabled=SFlag;
		ChequeDateobj.disabled=SFlag;
		PayAccNoobj.disabled=SFlag;
		Remarkobj.disabled=SFlag;

	}
function getdefaultpaymode()
{
	var getregno=document.getElementById('getdefaultpaymodeClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				var rtn=cspRunServerMethod(encmeth,GroupID);
				//alert(rtn)
				var myarray=rtn.split("^");
				if (myarray[0]=='0')
				{
					PayModeobj.value=myarray[1];
					PayModeIDobj.value=myarray[2];
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
	//	alert(value)
	var val=value.split("^");
	if (val[0]==""){
		alert(t[2001])
		websys_setfocus('RegNo');
		return;
	}
	AccountIDobj.value=val[14];
	if (AccountIDobj.value==""||val[3]!="N"){
		alert(t[2030])
		websys_setfocus('RegNo');
		return;
	}
	RegNoobj.value=val[0];
	PatNameobj.value=val[2];
	CardNoobj.value=val[4];
	Balanceobj.value=val[6]
	CardVerify=val[12];
	location.href='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit.FNoCard&AccountID='+AccountIDobj.value+'&CardNo='+CardNoobj.value+'&RegNo='+RegNoobj.value+'&PatName='+ escape(PatNameobj.value);
	
	websys_setfocus('amt');
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
	
		var val=value.split("^");
		
		////First ErrCode
		if (val[17]=="-200"){
			alert(t["-200"]);
			websys_setfocus("ReadCard");
			return;
		}
		
		if (val[0]==""){
			alert(t[2001])
			websys_setfocus('ReadCard');
			return;
		}
		
		AccountIDobj.value=val[14];
		
	if (AccountIDobj.value==""||val[3]!="N"){
		alert(t[2030])
		websys_setfocus('ReadCard');
		return;
	}
	RegNoobj.value=val[0];
	PatNameobj.value=val[2];
	
	Balanceobj.value=val[6]
	location.href='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit.FNoCard&AccountID='+AccountIDobj.value+'&CardNo='+CardNoobj.value+'&RegNo='+RegNoobj.value+'&PatName='+ escape(PatNameobj.value);
	websys_setfocus('amt');
}

function getpatbyCardNo()
{
	var key=websys_getKey(e);
	if (key==13) {
		getpatbycard();
	}
}
function getpaymodeid(value) {
	
	var val=value.split("^");
	
	PayModeIDobj.value=val[1];
	}
function getbankcardtypeid(value) {
	var val=value.split("^");	
	BankCardTypeIDobj.value=val[1];
}

function getbankid(value) {
	var val=value.split("^");
	BankIDobj.value=val[1];
}
	
function Clear_Click()
{
	location.href='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit.FNoCard';
}	

function getpatbyCardNo()
{
	
}	
function getpatbyIDCardNo()
{
	
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
	else{
		return false; 
	}
}

function AddDeposit_Click() {
	 var Password
	 DHCWeb_DisBtnA("AddDeposit");
	 
	 if (AccountIDobj.value=="")
	 {
		alert(t[2030])
			
			 return;
		 }
	 if (amtobj.value=="")
	 {
		 alert(t[2039])
			 websys_setfocus('amt');
			 return;
		 }
	if (PayModeListobj.value=="")
	 {
		 alert(t[2040])
		 websys_setfocus('PayModeList');
			 return;
		 }
	
	if (!IsNumber(amtobj.value)){alert(t[2041]);
		websys_setfocus('amt');
		return;
	}
	if (amtobj.value<=0){
		alert(t[2041]);
   		websys_setfocus('amt');
   		return;
	}
	 	 
	    var mytmparray=PayModeListobj.value.split("^");
		var PayModeid=mytmparray[0];
		
		var Bankid=""
		var BankCardTypeid=""
		if (BankListobj.value!="")
		{mytmparray=BankListobj.value.split("^");
		var Bankid=mytmparray[0];}
		if (BankCardTypeListobj.value!="")
		{mytmparray=BankCardTypeListobj.value.split("^");
		var BankCardTypeid=mytmparray[0];}
		// return
		// var Password=Passwordobj.value
		//str=AccountID_"^"_amt_"^"_user_"^"_ReceiptsNo_"^"_BackReason_"^"_Password_"^"_PayModeID_"^"_BankCardTypeID_"^"_CardChequeNo_"^"_BankID_"^"_Company_"^"_PayAccNo_"^"_ChequeDate_"^"_Remark
		var myencrypt=DHCWebD_GetObjValue("MTransEncrypt");
		if (myencrypt!=""){
			var myAmt=amtobj.value;
			if (isNaN(myAmt)){myAmt=0;}
			
			var myRMB=cspRunServerMethod(myencrypt,myAmt);
			myAmt=myAmt.toString();
			///myAmt=myAmt.toFixed(2);
			var myrtn=confirm(t['GetSum']+myAmt+"("+myRMB+")"+t["ConTip"]);
			if (myrtn==false){
				return;
			}
		}
		
		p1=AccountIDobj.value+"^"+amtobj.value+"^"+Guser+"^"+ReceiptsNoobj.value+"^"+BackReasonobj.value+"^"+Password+"^"+PayModeid+"^"+BankCardTypeid+"^"+CardChequeNoobj.value+"^"+Bankid+"^"+Companyobj.value+"^"+PayAccNoobj.value+"^"+ChequeDateobj.value+"^"+Remarkobj.value+"^P"
			var getregno=document.getElementById('AddDepositClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				
				var rtn=cspRunServerMethod(encmeth,'','',p1)
				var myary=rtn.split("^");
				var ren=myary[0]
				//alert(ren)
				if (ren!='0'){
					AddDepositobj=document.getElementById('AddDeposit');
					if (AddDepositobj) AddDepositobj.onclick = AddDeposit_Click;
				}
				if (ren=='passerr'){
			       alert(t[2042])
			       return
				}
				if (ren=='amterr'){
			       alert(t[2041])
			       return
				}
				if (ren=='accerr'){
			       alert(t[2046])
			       return
				}
				if (ren=='0'){
				   
				   var obj=document.getElementById("PreDepInfo");
				   if (obj){
					   obj.value=rtn;
				   }
				   var mystr=obj.value+"^^";
				   Print_Click(mystr);
				   ///String.fromCharCode(2)
					///var myReStr=obj.value+"^^"+"***********";
					///Print_Click(myReStr);
					var obj=document.getElementById("RePrint");
					if (obj){
						obj.disabled=false;
						obj.onclick=RePrint_Click;
					}
					var myrtn=confirm(t["AddOK"]);
					if (myrtn==false){
						location.href='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit.FNoCard';
					}
				}
				else
				{
					alert(ren + t[2045])
				}
}

function Print_Click(value)
{
	var val=value.split("^")
	var TxtInfo,ListInfo
	var c=String.fromCharCode(2)
	TxtInfo="CardNo"+c+CardNoobj.value+"^"+"PatName"+c+PatNameobj.value+"^"+"amt"+c+val[1]+"^"+"amtdx"+c+val[2]+"^"
	TxtInfo=TxtInfo+"Balance"+c+val[3]+"^"+"Guser"+c+GuserCode+"^"+"Datetime"+c+val[4]
	TxtInfo+="^BillNo"+c+val[5];
	TxtInfo+="^RePrintFlag"+c+val[6];
	TxtInfo+="^StubL"+c+val[7];
	
	///alert(TxtInfo)
	//return
	ListInfo=""
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}


function ReadMagCard_Click(){
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		window.status=t[2007]
		var rtn=obj.ReadMagCard("23");
		//obj.DHCACC_ReadMagCard("2");
		//obj.DHCACC_ReadMagCard("3");
		//obj.DHCACC_WrtMagCard("");
		///alert(rtn)
		var myary=rtn.split("^");
		if (myary[0]=='-5') {window.status=t[2008];return;}
		
		window.status=""
		if (myary[0]=="0"){
			
			CardNoobj.value=myary[1];
			CardVerify=myary[2];
			getpatbycard();
			}
		else
		{
		
		//window.status="Cancel Read Card "	
		}
	}
}

function FootExpCalculate()	{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum=";
	var NewWin=open(lnk,"udhcOPCashExpCal","scrollbars=no,resizable=no,top=100,left=100,width=800,height=460");
}


document.body.onload = BodyLoadHandler;
