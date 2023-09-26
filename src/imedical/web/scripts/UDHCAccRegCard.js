//document.write("<object ID='ClsDHCPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:2759E092-B26D-4A60-B353-4F7402A4BC95' CODEBASE='../addins/client/DHCRegPring.CAB#version=1,0,0,0' VIEWASTEXT>");
//document.write("</object>");
//UDHCAccRegCard.JS
	var GPatType;
	var Guser;
	var GuserCode;
	var GroupID;
	var PatientID;
	var CardID;
	var CardNo;
	var CardVerify;
	var computername;
	var RegNoObj;
	var NameObj;
	var BirthObj;
	var SexObj;
	var BankObj;
	var BankCardTypeObj;
	var AccountTypeObj;
	var CredTypeObj;
	var PayModeObj;
	var PatTypeObj;
	var CardNoObj;
	var SetDefaultPasswordObj;
	var CredNoObj;
	var amtObj;
	var ReceiptsNoObj;
	var PayCompanyObj;
	var CardChequeNoObj;
	var ChequeDateObj;
	var PayAccNoObj;
	var RemarkObj;
	
function DocumentLoadHandler() {
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	GroupID=session['LOGON.GROUPID'];
	//var RegNoObj=document.getElementById('prt');
	//if (RegNoObj) RegNoObj.onclick = prt_click;
	RegNoObj=document.getElementById('ID');
	//if (RegNoObj) RegNoObj.onkeydown = RegNoObj_keydown;
	RegNoObj.readOnly=true;
	NameObj=document.getElementById('Name');
	//if (NameObj) NameObj.onchange = NameObj_onchange;
	if (NameObj) NameObj.onkeydown = nextfocus;
	BirthObj=document.getElementById('Birth');
	if (BirthObj){
		BirthObj.onkeydown =nextfocus;
		BirthObj.onblur=Birth_OnBlur;
	}
	SexObj=document.getElementById('Sex');
	if (SexObj){
		SexObj.onkeydown = nextfocus;
		SexObj.size=1;
		SexObj.multiple=false;
	}
	BankObj=document.getElementById('Bank');
	if (BankObj){
		BankObj.onkeydown = nextfocus;
		BankObj.size=1;
		BankObj.multiple=false;
	}
	BankCardTypeObj=document.getElementById('BankCardType');
	if (BankCardTypeObj){
		BankCardTypeObj.onkeydown = nextfocus;
		BankCardTypeObj.size=1;
		BankCardTypeObj.multiple=false;
	}
	AccountTypeObj=document.getElementById('AccountType');
	if (AccountTypeObj){
		AccountTypeObj.onkeydown = nextfocus;
		AccountTypeObj.size=1;
		AccountTypeObj.multiple=false;
	}
	CredTypeObj=document.getElementById('CredType');
	if (CredTypeObj){
		CredTypeObj.onkeydown = nextfocus;
		CredTypeObj.size=1;
		CredTypeObj.multiple=false;
	}	
	PayModeObj=document.getElementById('PayMode');
	if (PayModeObj){
		PayModeObj.onchange=PayModeObj_OnChange;
		PayModeObj.onkeydown = nextfocus;
		PayModeObj.size=1;
		PayModeObj.multiple=false;	
	}
	PatTypeObj=document.getElementById('PatType');
	if (PatTypeObj){
		PatTypeObj.onkeydown = nextfocus;
		PatTypeObj.size=1;
		PatTypeObj.multiple=false;	
		//PatTypeObj.onchange=PatTypeObj_OnChange;
	}
	CardNoObj=document.getElementById('CardNo');
	CardNoObj.readOnly=true;
	//if (CardNoObj) CardNoObj.onkeydown = CardNoObj_keydown;
	SetDefaultPasswordObj=document.getElementById('SetDefaultPassword');
	CredNoObj=document.getElementById('CredNo');
	if (CredNoObj){
		CredNoObj.onkeydown = nextfocus;
	}
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
	
	var Obj=document.getElementById('InMedicare');
	if (Obj) {Obj.onkeydown = nextfocus;}
	var Obj=document.getElementById('OpMedicare');
	if (Obj) {Obj.onkeydown = nextfocus;}
	var Obj=document.getElementById('TelNo');
	if (Obj) {Obj.onkeydown = nextfocus;}
	var Obj=document.getElementById('IDCardNo1');
	if (Obj) {Obj.onkeydown = nextfocus;}
	var Obj=document.getElementById('Vocation');
	if (Obj) {Obj.onkeydown = nextfocus;}
	var Obj=document.getElementById('Company');
	if (Obj) {Obj.onkeydown = nextfocus;}
	
	var AddressObj=document.getElementById('Address');
	if (AddressObj) {AddressObj.onkeydown = nextfocus;}
	var IDCardNo1Obj=document.getElementById('IDCardNo1');
	if (IDCardNo1Obj) {IDCardNo1Obj.onchange = IDCardNo1Obj_onchange;}
 	
	
	var Obj=document.getElementById('Clear');
	if (Obj) {Obj.onclick = Clear_click;}
	
	var Obj=document.getElementById('ReadCard');
	if (Obj) {Obj.onclick = ReadMagCard_Click;}
	var Obj=document.getElementById('NewCard');
	if (Obj) {Obj.onclick = NewCard_click;}
	
	document.onkeydown=Doc_OnKeyDown;	
	
	IntDoc()
	//SetPayInfoStatus(true)
	PayModeObj_OnChange()
	textimemode()
	DHCP_GetXMLConfig("DepositPrintEncrypt","UDHCAccDeposit");
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
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

function Birth_OnKeydown(){
	var eSrc=window.event.srcElement;
	//alert(eSrc.tabIndex);
	var key=websys_getKey(e);
	if (key==13) {
		var mybirth=DHCWebD_GetObjValue("Birth");
		
		websys_nexttab(eSrc.tabIndex);
	}

}

function Birth_OnBlur(){
	var mybirth=DHCWebD_GetObjValue("Birth");
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("Birth");
		obj.className='clsInvalid';
		websys_setfocus("Birth");
		return websys_cancel();
	}else{
		var obj=document.getElementById("Birth");
		obj.className='clsvalid';
	}
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		DHCWebD_SetObjValueA("Birth",mybirth);
	}
	////alert(mybirth);
	var myrtn=DHCWeb_IsDate(mybirth,"-")
	if (!myrtn){
		var obj=document.getElementById("Birth");
		obj.className='clsInvalid';
		websys_setfocus("Birth");
		return websys_cancel();
	}else{
		var obj=document.getElementById("Birth");
		obj.className='clsvalid';
	}
	///alert();
}

function ReadMagCard_Click(){
	Clear_click();
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		window.status=t[2007]
		var rtn=obj.ReadMagCard("23");
		//alert(rtn)
		var myary=rtn.split("^");
		
		if (myary[0]=='-5') {window.status=t[2008];return;}
		window.status=""
		
		if (myary[0]=='0'){
			
			CardNoObj.value=myary[1];
			CardVerify=myary[2];
			getpatbycard();
		}
		
	}
}
function getpatbycard()
{
	if (CardNoObj.value=="") {alert("no card no");return;}
	var encmeth=DHCWebD_GetObjValue("getpatbyCardNoClass");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,CardNoObj.value,CardVerify);
		var myary=rtn.split("^");
		//rtn_"^"_RegNo_"^"_Papmi_"^"_name_"^"_CardNo_"^"_SecurityNO_"^"_CardID
		//alert(rtn)
		if (myary[0]=='0')
		{
			RegNoObj.value=myary[1]
			PatientID=myary[2]
			NameObj.value=myary[3]
			CardVerify=myary[5]
			CardID=myary[6]
			websys_setfocus('Name');
			}
		else
		{
			if (myary[0]=='-341')
			{alert(t[2024]);}
			if (myary[0]=='-340')
			{alert(t[2003]);}
			
			//Clear_click();
		}
	}
	}
function NewCard_click()
{
	if (PatientID==""||RegNoObj.value=="") {alert(t[2019]);websys_setfocus('ReadCard');return;}
	if (CardID==""||CardNoObj.value=="") {alert(t[2002]);websys_setfocus('ReadCard');return;}
	if (NameObj.value=="") {alert(t["noname"]);websys_setfocus('Name');return;}
	var OpMedicareObj=document.getElementById('OpMedicare');
	////if (OpMedicareObj.value=="") {alert("no OpMedicare");websys_setfocus('OpMedicare');return;}
	if (SexObj.value=="") {alert(t["noSex"]);websys_setfocus('Sex');return;}
	if (PatTypeObj.value=="") {alert(t["noPatType"]);websys_setfocus('PatType');return;}
	if (!IsNumber(amtObj.value)){alert(t[2041]);
   		websys_setfocus('amt');
   		return;
	}
	if (amtObj.value<0){
	    alert(t[2041]);
   		websys_setfocus('amt');
   		return;
	}
	
	var myobj=document.getElementById("Birth");
	if (myobj){
		var myBirth=obj.value;
		if (myBirth==""){
			alert(t["BirthTip"]);
   			websys_setfocus('Birth');
   			return;
		}
	}
	
	var TelNoObj=document.getElementById('TelNo');
	var InMedicareObj=document.getElementById('InMedicare');
	var IDCardNo1Obj=document.getElementById('IDCardNo1');
	var VocationObj=document.getElementById('Vocation');		
	var CompanyObj=document.getElementById('Company');
	var AddressObj=document.getElementById('Address');
	
	var myrtn=WrtCard();
	var myary=myrtn.split("^");
	if (myary[0]!="0"){
		return;
	}
	var mySecrityNo=myary[1];
	
	var encmeth=DHCWebD_GetObjValue("NewCardClass");
	if (encmeth!=""){
		var Password="";
		if (SetDefaultPasswordObj.checked)
		{
		  	var ren=DHCACC_GetValidatePWD(CardVerify);
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
	  	else{
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
		///alert(Password)  
		var mytmparray=SexObj.value.split("^");
		var Sexid=mytmparray[0];
		mytmparray=PatTypeObj.value.split("^");
		var PatTypeid=mytmparray[0];
		mytmparray=CredTypeObj.value.split("^");
		var CredTypeid=mytmparray[0];
		mytmparray=PayModeObj.value.split("^");
		var PayModeid=mytmparray[0];
		var AccountTypeid=AccountTypeObj.value;
		Bankid=""
		BankCardTypeid=""
		if (BankObj.value!="")
		{mytmparray=BankObj.value.split("^");
		var Bankid=mytmparray[0];}
		if (BankCardTypeObj.value!="")
		{
			mytmparray=BankCardTypeObj.value.split("^");
			var BankCardTypeid=mytmparray[0];
		}
		
		////UpdatePatDetail
		var myPatInfo=PatientID+"^"+NameObj.value+"^"+Sexid+"^"+BirthObj.value+"^"+TelNoObj.value+"^"+OpMedicareObj.value+"^"+InMedicareObj.value+"^"+PatTypeid+"^"+IDCardNo1Obj.value+"^"+VocationObj.value+"^"+CompanyObj.value+"^"+AddressObj.value
		////grantcardUpdate
		var myCardInfo=RegNoObj.value+"^"+PatientID+"^"+IDCardNo1Obj.value+"^"+CardNoObj.value+"^"+CardVerify+"^"+""+"^"+""+"^"+Guser+"^"+computername+"^"+CardID+"^"+mySecrityNo
		///NewAccountAdd
		var myAccInfo=""+"^"+PatientID+"^"+RegNoObj.value+"^"+CardNoObj.value+"^"+Guser+"^"+Password+"^"+"0"+"^"+AccountTypeid+"^"+CredTypeid+"^"+CredNoObj.value+"^"+CardID
		///web.UDHCAccAddDeposit
		var myAccDepInfo=""+"^"+amtObj.value+"^"+Guser+"^"+ReceiptsNoObj.value+"^"+""+"^"+Password+"^"+PayModeid+"^"+BankCardTypeid+"^"+CardChequeNoObj.value+"^"+Bankid+"^"+PayCompanyObj.value+"^"+PayAccNoObj.value+"^"+ChequeDateObj.value+"^"+RemarkObj.value+"^P"
		
		////return;
		
		var rtn=cspRunServerMethod(encmeth, myPatInfo, myCardInfo, myAccInfo, myAccDepInfo);
		var myary=rtn.split("^");
		
		if (myary[0]=='0')
		{
			if (amtObj.value>0){
				Print_Click(rtn)
			}
			alert(t[2013]);
			Clear_click();
			////ren=DHCACC_WrtMagCard("3",CardNoObj.value,myary[1])
			//alert(ren);
			//alert("grant card ok");
			////window.status="";
			////while (ren=='-5'||ren=='-6')
			////{
			////	if (ren=='-5') {alert(t[2085]);}
			////	if (ren=='-6') {alert(t[2086]);}
			////	ren=DHCACC_WrtMagCard("3",CardNoObj.value,myary[1])
			////}
			
			////if (ren=='0'){
			////else{
			////	alert(t[2014]);
			////}
		}
		else if (myary[0]=='-302')
			{alert(t[2025]);}
		else if (myary[0]=='-303')
			{alert(t[2002]);}
		else if (myary[0]=='-304')
			{alert(t[2024]);}
		else
			{alert(myary[0]+"  "+t[2015]);}
	}
}

function WrtCard(){
	////Read Secrity
	///ReadSecEnvrypt
	var mySecrityNo="";
	var myencmeth=DHCWebD_GetObjValue("ReadSecEnvrypt");
	if (myencmeth!=""){
		var myPAPMINo=DHCWebD_GetObjValue("ID");
		mySecrityNo=cspRunServerMethod(myencmeth,myPAPMINo);
	}else
	{
		alert("Read Err!");
		return "-1^";
	}
	///Write Card First
	if (mySecrityNo!=""){
		var rtn=DHCACC_WrtMagCard("23",CardNoObj.value,mySecrityNo)
		if (rtn!="0"){
			return "-1^"
		}
	}else{
		return "-1^";
	}
	
	return "0^"+mySecrityNo
}

function Print_Click(value)
{
	var val=value.split("^")
	var TxtInfo,ListInfo
	var c=String.fromCharCode(2)
	TxtInfo="CardNo"+c+CardNoObj.value+"^"+"PatName"+c+NameObj.value+"^"+"amt"+c+val[3]+"^"+"amtdx"+c+val[4]+"^"
	TxtInfo=TxtInfo+"Balance"+c+val[5]+"^"+"Guser"+c+GuserCode+"^"+"Datetime"+c+val[6]
	TxtInfo+="^BillNo"+c+val[7];
	//alert(TxtInfo)
	//return
	ListInfo=""
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
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
	        
			p1=Guser
			p2="D"
			var getregno=document.getElementById('GetCurrentRecNoClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
			var ren=cspRunServerMethod(encmeth,p1,p2)
			 var myary=ren.split("^");
				
				
				if (myary[0]=='0'){
					
					ReceiptsNoObj.value=myary[3]
					}
					else
					{
						alert(t[2072])
						
						}
	
	}
function textimemode()
{
	document.all.ID.style.imeMode = "disabled";
	document.all.Name.style.imeMode = "active";
	document.all.Sex.style.imeMode = "disabled";
	document.all.OpMedicare.style.imeMode = "disabled";
	document.all.InMedicare.style.imeMode = "disabled";
	document.all.IDCardNo1.style.imeMode = "disabled";
	document.all.TelNo.style.imeMode = "disabled";
	document.all.CredNo.style.imeMode = "disabled";
	document.all.amt.style.imeMode = "disabled";
	document.all.Birth.style.imeMode = "disabled";
	document.all.CardChequeNo.style.imeMode = "disabled";
	document.all.ChequeDate.style.imeMode = "disabled";
	document.all.PayAccNo.style.imeMode = "disabled";
	}
function IntDoc(){
	
	DHCWebD_ClearAllListA("Bank");
	var encmeth=DHCWebD_GetObjValue("ReadBankEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","Bank");
		
	}
	DHCWebD_ClearAllListA("AccountType");
	var encmeth=DHCWebD_GetObjValue("ReadAccountType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","AccountType");
		
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
	DHCWebD_ClearAllListA("Sex");
	var encmeth=DHCWebD_GetObjValue("ReadSex");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","Sex");
		
	}
	DHCWebD_ClearAllListA("PatType");
	var encmeth=DHCWebD_GetObjValue("ReadPatType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PatType");
		
	}
	DHCWebD_ClearAllListA("CredType");
	var encmeth=DHCWebD_GetObjValue("ReadCredType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CredType");
		
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
	
	/*
	///Load SS_Group Pay Mode
	///DHCWeb_AddToListA
	///var obj=document.getElementById("PayModeEncrypt");
	DHCWebD_ClearAllListA("PayMode");
	var encmeth=DHCWebD_GetObjValue("PayModeEncrypt");
	var mygLoc=session['LOGON.GROUPID'];
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PayMode",mygLoc);
	}
	
	///Load Bank Name
	
	///Load Pay Type
	DHCWebD_ClearAllListA("FootType");
	var encmeth=DHCWebD_GetObjValue("ReadPMTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","FootType");
	}
	
	///FootType
	var obj=document.getElementById("FootType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
	
	GetReceiptNo();
	///if AccRowID!="" Get AccManagerÐÅÏ¢?
	
	PayMode_OnChange();

	var mygLoc=session['LOGON.GROUPID'];
	///Load Base Config
	var encmeth=DHCWebD_GetObjValue("GSCFEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth,mygLoc);
	}
	var myary=myrtn.split("^");
	if (myary[0]==0){
		///_"^"_GSRowID_"^"_FootFlag_"^"_RecLocFlag_"^"_PrtINVFlag
		///foot Flag
		////Check Invoice PrtFlag
		mPrtINVFlag=myary[4];
		
		////Get PrtXMLName
		var myPrtXMLName=myary[10];
	}
	PrtXMLName=myPrtXMLName;
	DHCP_GetXMLConfig("DepositPrintEncrypt",myPrtXMLName);		///INVPrtFlag
	*/
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
function Clear_click()
{			  			
  			var tmp=document.getElementById('ID');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('Name');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('Birth');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('TelNo');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('OpMedicare');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('InMedicare');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('IDCardNo1');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('Vocation');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('Company');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('Address');
			if (tmp) tmp.value = "";
			
			CardNoObj.value="";
			CredNoObj.value="";
			amtObj.value="";
			PayCompanyObj.value="";
			BankObj.value="";
			BankCardTypeObj.value="";
			CardChequeNoObj.value="";
			ChequeDateObj.value="";
			PayAccNoObj.value="";
			RemarkObj.value="";
			
			PatientID="";
			CardID="";
			CardNo="";
			CardVerify="";
			
			websys_setfocus('ReadCard');
}

//
function nextfocus() {
	var eSrc=window.event.srcElement;
	//alert(eSrc.tabIndex);
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

function PatType_onkeydown() {
	if (evtName=='PatType') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key!=13) {
		return
	}
	var Obj=document.getElementById('PatType');
	if (Obj) {
		if (Obj.value!='') {	
			var tmp=document.getElementById('ID');
			if (tmp) {var p1=tmp.value } else {var p1=''}
			var GetDetail=document.getElementById('PaadmCount');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};

			var rel=cspRunServerMethod(encmeth,'Paadm_count','',p1)
		
			if ((rel>=1) && (GPatType!=Obj.value) ){
				alert(t["04"])
				return
			}
			websys_setfocus('InMedicare');
		}
	}
}


function Paadm_count(value) {
	try {
	} catch(e) {};
}


function prt_click()
{
	 
 var id=document.getElementById('ID').value;
 var name=document.getElementById('Name').value;
 
  if (id==""){
	 alert(t['01']);
	 websys_setfocus('ID');
 }
  if ((id!="")&&(name=="")){
	 alert(t['02']);
	 websys_setfocus('ID');
 }
 
 if ((id!="")&&(name!="")) {
 //alert(id+"!"+name);
 ClsDHCPrint.push_tm(id); 
 
  }
}
function PatInfoFind_click()
{
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPPatInfoFind";
	win=open(lnk,"PatInfoFind","status=1,scrollbars=1,top=100,left=100,width=760,height=420");
}
function Quit_click()
{
  //alert("sdsds")
  //var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCSynStk";
 //	win=open(lnk,"PatInfoFind","status=1,scrollbars=1,top=100,left=100,width=260,height=220");
	
 // return
  window.close()
}

function Save_click(){
	SavePatInfo()
}


//Duplicate name
function NameObj_onchange(e) {
	if (evtName=='Name') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
		var obj=document.getElementById('Name');
		
		if (obj.value!='') {
			var tmp=document.getElementById('Name');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			var GetDetail=document.getElementById('GetName');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'GetDupName_count','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('Name');	
			return websys_cancel();
			}
		obj.className='';
	}
}


function GetDupName_count(value) {
	try {
		Name_obj=document.getElementById('Name');
		PatName=Name_obj.value
		if (value>0) {
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPRegFind&FID="+""+"&NAME="+PatName+"&IDCardNo="+""+"&TelNo="+""+"&InMedicare="+"";
			win=open(lnk,"FindPatBase","width=760,height=400");
		}
		
	} catch(e) {};
}

//Duplicate IDCardNo
function IDCardNo1Obj_onchange() {
	var obj=document.getElementById('IDCardNo1');
	CredNoObj.value=obj.value
	/*
	if (evtName=='IDCardNo1') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
		var obj=document.getElementById('IDCardNo1');
		if (obj.value!='') {	
			var tmp=document.getElementById('IDCardNo1');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			var GetDetail=document.getElementById('GetIDCardNo');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'GetDupIDCardNo1_count','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('Sex');	
			return websys_cancel();
			}
			
		obj.className='';
	}
	*/
}


function GetDupIDCardNo1_count(value) {
	try {
		IDCardNo1_obj=document.getElementById('IDCardNo1');
		IDCardNo1Name=IDCardNo1_obj.value
		if (value>0) {
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPRegFind&FID="+""+"&NAME="+""+"&IDCardNo="+IDCardNo1Name+"&TelNo="+""+"&InMedicare="+"";
			win=open(lnk,"NewWin","width=760,height=400");
		}
		
		//websys_nexttab('6');
	} catch(e) {};
}

//Commit from Address

function AddressObj_keydown(e) {
	//alert(self.name)
	if (evtName=='Address') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}

	var key=websys_getKey(e);
	if (key==13 ) {
		    //ID,Name,Sex,Birth,TelNo,OpMedicare,InMedicare,PatType,Vocation,Company,Address
			//var tmp=document.getElementById('Address');
			//if (tmp) {var p1=tmp.value } else {var p1=''};
			SavePatInfo()		
			
	
	}
}


function SavePatInfo(){
			
			var PatDetailPar=""
			var tmp=document.getElementById('ID');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=p1
			var tmp=document.getElementById('Name');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('Sex');
			if (tmp) {var p1=tmp.value;} else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('Birth');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('TelNo');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('OpMedicare');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('InMedicare');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('PatType');
			if (tmp) {
				var p1=tmp.value
				if (p1==""){
					alert(t["03"])
					return
				} 
			} else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('IDCardNo1');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1

			var tmp=document.getElementById('Vocation');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			
			var tmp=document.getElementById('Company');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('Address');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1

			
			
			var GetDetail=document.getElementById('CommitPatDetail');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'Commit_PatDetail','',PatDetailPar)=='0') {
			//obj.className='clsInvalid';
			//websys_setfocus('Name');	
			return websys_cancel();
		
		}
		obj.className='';
}

function Commit_PatDetail(value) {
	try {
		if (value!=0) {
		 alert("Update Patient Detail failed,Please check every Item!")			
		}
		Clear_click()
		//websys_setfocus('ID')
	} catch(e) {};
}



//Input Patient RegNo
function RegNoObj_keydown(e) {
	//
	if (evtName=='ID') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		FindPatDetail()
	}
}

function FindPatDetail(){
		var obj=document.getElementById('ID');
		if (obj.value!='') {	
			if (obj.value.length<8) {
				for (var i=(8-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
			}}
		
			var tmp=document.getElementById('ID');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			var GetDetail=document.getElementById('GetDetail');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'SetPatient_Sel','',p1)=='0') {
			obj.className='clsInvalid';
			return websys_cancel();
			}
		}
		
		obj.className='';
}

function SetPatient_Sel(value) {
	try {
		var Split_Value=value.split("^")
		var obj_Name=document.getElementById('Name');
		var obj_Sex=document.getElementById('Sex');
		var obj_Birth=document.getElementById('Birth');
		var obj_TelNo=document.getElementById('TelNo');
		var obj_IDCardNo=document.getElementById('IDCardNo1');
		var obj_InMedicare=document.getElementById('InMedicare');
		var obj_PatType=document.getElementById('PatType');
		var obj_Address=document.getElementById('Address');
		var obj_OpMedicare=document.getElementById('OpMedicare');
		var obj_Company=document.getElementById('Company');

		
		if (obj_Name) {
  			obj_Name.value=unescape(Split_Value[0]);
			obj_Name.className='';
			//websys_nexttab('6');		
		}
		if (obj_Sex) {
  			obj_Sex.value=unescape(Split_Value[2]);
			obj_Sex.className='';
			//websys_nexttab('6');
		}
		if (obj_Birth) {
  			obj_Birth.value=unescape(Split_Value[1]);
			obj_Birth.className='';
			//websys_nexttab('6');
		}
		if (obj_TelNo) {
  			obj_TelNo.value=unescape(Split_Value[4]);
			obj_TelNo.className='';
			//websys_nexttab('6');
			//alert(obj_TelNo.tabIndex);
		}
		if (obj_IDCardNo) {
  			obj_IDCardNo.value=unescape(Split_Value[3]);
			obj_IDCardNo.className='';
			//websys_nexttab('6');
		}
		if (obj_InMedicare) {
  			obj_InMedicare.value=unescape(Split_Value[5]);
			obj_InMedicare.className='';
			//websys_nexttab('6');
		}
		if (obj_PatType) {
  			obj_PatType.value=unescape(Split_Value[6]);
  			GPatType=unescape(Split_Value[6])
			obj_PatType.className='';
			//websys_nexttab('6');
		}
		if (obj_Address) {
  			obj_Address.value=unescape(Split_Value[7]);
			obj_Address.className='';
			//websys_nexttab('6');
		}
		if (obj_OpMedicare) {
  			obj_OpMedicare.value=unescape(Split_Value[8]);
			obj_OpMedicare.className='';
			//websys_nexttab('6');
		}
		if (obj_Company) {
  			obj_Company.value=unescape(Split_Value[9]);
			obj_Company.className='';
			//websys_nexttab('6');
		}
		if (obj_Name.value!=""){
		websys_setfocus("Name");
		}
	} catch(e) {};
}



//sex
function Sex_lookupsel(value) {
	try {
		var obj=document.getElementById('Sex');
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
		//websys_nexttab('6');
		}
	} catch(e) {};
}
function Sex_changehandler(encmeth) {
	evtName='Sex';
	if (doneInit) { evtTimer=window.setTimeout("Sex_changehandlerX('"+encmeth+"');",200); }
	else { Sex_changehandlerX(encmeth); evtTimer=""; }
}
function Sex_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var obj=document.getElementById('Sex');
	if (obj.value!='') {
		var tmp=document.getElementById('Sex');
		if (tmp) {var p1=tmp.value } else {var p1=''};
		if (cspRunServerMethod(encmeth,'Sex_lookupsel','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('Sex');
			return websys_cancel();
		}
	}
	obj.className='';
}


//socialstatus
function PatType_lookupsel(value) {
	try {
		var obj=document.getElementById('PatType');
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
		//websys_nexttab('6');
		}
	} catch(e) {};
}
function PatType_changehandler(encmeth) {
	
	evtName='PatType';
	if (doneInit) { evtTimer=window.setTimeout("PatType_changehandlerX('"+encmeth+"');",200); }
	else { PatType_changehandlerX(encmeth); evtTimer=""; }
}
function PatType_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var obj=document.getElementById('PatType');
	if (obj.value!='') {
		var tmp=document.getElementById('PatType');
		if (tmp) {var p1=tmp.value } else {var p1=''};
		if (cspRunServerMethod(encmeth,'PatType_lookupsel','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('PatType');
			return websys_cancel();
		}
	}
	obj.className='';
}
	
function Find_click()
{
	

	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPRegFind";
	win=open(lnk,"NewWin","top=150,left=150,width=760,height=400");
}

document.body.onload = DocumentLoadHandler;

