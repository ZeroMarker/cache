
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
	
	var Guser=session['LOGON.USERID']
	var GuserCode=session["LOGON.USERCODE"];
	var GroupID=session['LOGON.GROUPID'];
	
	var CardNoobj=document.getElementById('CardNo');
	var PatNameobj=document.getElementById('PatName');
	var PatientIDobj=document.getElementById('PatientID');
	  
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
	var obj=document.getElementById('CardBathType');
	if (obj) {
	          ReadCardBathType();
	          obj.setAttribute("isDefualt","true");
	          combo_CardBathType=dhtmlXComboFromSelect("CardBathType");
	          }
	
	if (combo_CardBathType) {
		combo_CardBathType.enableFilteringMode(true);
		//combo_CardBathType.selectHandle=combo_CardBathTypeKeydownHandler;
	}
	var obj=document.getElementById('ReadCard');
	if (obj) obj.onclick=ReadHFMagCard_Click;
	
	var obj=document.getElementById('CardWrite');
	if (obj) obj.onclick=CardWrite_Click;
	
  InitDoc();
  
  getpatinfo();
  
  DHCP_GetXMLConfig("InvPrintEncrypt","UDHCCardBath");
}
function InitDoc() 
{
	var myTitleobj=document.getElementById("myTitle");
	if (myTitleobj){
		var cTitleobj=document.getElementById("cTitle");
		if (cTitleobj) cTitleobj.innerHTML=myTitleobj.value;
       }

       var CardGateWayobj=document.getElementById("CardGateWay");
	var CardBathobj=document.getElementById("CardBath");
	var CardGateWaySelectobj=document.getElementById("CardGateWaySelect");
	var CardBathSelectobj=document.getElementById("CardBathSelect");
	
	if (CardGateWayobj==null) 
	{
		
		DHCWeb_DisBtnA("CardWrite");return;}
	if (CardBathobj==null) 
	{
		
		DHCWeb_DisBtnA("CardWrite");return;}
	
	
		switch (CardGateWayobj.value){
		
		
			case "0":
			if (CardGateWaySelectobj)
			{
				CardGateWaySelectobj.checked=true;
				CardGateWaySelectobj.disabled=true;
				
				}
			break;
		case "1":
			if (CardGateWaySelectobj)
			{
				CardGateWaySelectobj.checked=true;
				CardGateWaySelectobj.disabled=true;
				
				}
			break;
		case "2":
			if (CardGateWaySelectobj)
			{
				CardGateWaySelectobj.checked=true;
				CardGateWaySelectobj.disabled=true;
				
				}
			break;
		case "3":
			if (CardGateWaySelectobj)
			{
				CardGateWaySelectobj.checked=false;
				CardGateWaySelectobj.disabled=true;
				EltStyleHidden("CardGateWaySelect");
				}
			
			break;
		
		default:
			DHCWeb_DisBtnA("CardWrite");return;
			}
		
		switch (CardBathobj.value){
		case "0":
			
			if (CardBathSelectobj)
			{
				CardBathSelectobj.checked=true;
				CardBathSelectobj.disabled=true;
				
				}
			break;
		case "1":
			break;
		case "2":
			
			if (CardBathSelectobj)
			{
				CardBathSelectobj.checked=true;
				CardBathSelectobj.disabled=true;
				
				}
			break;
		case "3":
			if (CardBathSelectobj)
			{
				CardBathSelectobj.checked=false;
				CardBathSelectobj.disabled=true;
				EltStyleHidden("CardBathSelect");
				EltStyleHidden("CardBathAmount");
				EltStyleHidden("CardBathType");
                           combo_CardBathType.DOMelem.style.display = "none";

				}
			break;
		
		default:
			DHCWeb_DisBtnA("CardWrite");return;
			}
	
	}
function ReadCardBathType(){
	DHCWebD_ClearAllListA("CardBathType");
	var encmeth=DHCWebD_GetObjValue("ReadCardBathType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardBathType");
	}
}
function ReadHFMagCard_Click()
{
	
	var myoptval=combo_CardType.getSelectedValue();
	var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeRowID,myoptval);
	var myary=myrtn.split("^");
	if (myary[0]=='-5') {return;};
	
	var rtn=myary[0];
	switch (rtn){
		case "0":
			
			var myobj=document.getElementById("PatientID");
			myobj.value=myary[4];
			myobj=document.getElementById("CardNo");
			if (myobj) myobj.value=myary[1];
			getpatinfo();
			ReadCardBathAmount();
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			var myobj=document.getElementById("PatientID");
			myobj.value=myary[4];
			myobj=document.getElementById("CardNo");
			if (myobj) myobj.value=myary[1];
			getpatinfo();
			ReadCardBathAmount();
			break;
		default:
			///alert("");
	}
}
function getpatinfo()
{
	ClearPatInfo();
	var obj=document.getElementById("PatientID");
	var PatientID=obj.value;
	var encmeth=DHCWebD_GetObjValue("getPatClass");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,PatientID);
		setpatinfo(rtn);
	}
	}
function setpatinfo(val)
{
	  if ((val=="")||(val=="100")) return;
	  var tmparr=val.split("^")
		if (tmparr[0]=="0")
		{
			var PatNameobj=document.getElementById("PatName");
			if (PatNameobj) PatNameobj.value=tmparr[1]
			var Wardobj=document.getElementById("Ward");
			if (Wardobj) Wardobj.value=tmparr[2]
			var WardCodeobj=document.getElementById("WardCode");
			if (WardCodeobj) WardCodeobj.value=tmparr[3]
			}
	
	}

function ClearPatInfo()
{
	    var PatNameobj=document.getElementById("PatName");
			if (PatNameobj) PatNameobj.value="";
			var Wardobj=document.getElementById("Ward");
			if (Wardobj) Wardobj.value="";
			var WardCodeobj=document.getElementById("WardCode");
			if (WardCodeobj) WardCodeobj.value="";
			var CardBathAmountobj=document.getElementById("CardBathAmount");
			if (CardBathAmountobj) CardBathAmountobj.value="";
	
	}
function CardWrite_Click()
{
	DHCWeb_DisBtnA("CardWrite");
	
	var myrtn=CardPublicWrite();
	
	if (!myrtn) 
		{
		this.disabled=false;
		this.onclick=CardWrite_Click;
		return;
        }

	var CardGateWaySelectobj=document.getElementById("CardGateWaySelect");
	var CardBathSelectobj=document.getElementById("CardBathSelect");
	if (CardGateWaySelectobj){
	if (CardGateWaySelectobj.checked)
	{
		var rtn=CardGateWayWrite();
		if (rtn)
		{
			alert(t['CardGateWayWriteOK']);
			}
		else
		{
			
			
			}
		}
	}
	if (CardBathSelectobj){
	if (CardBathSelectobj.checked)
	{
		var rtn=CardBathWrite();
		if (rtn)
		{
			alert(t['CardBathWriteOK']);
			}
		else
		{
			
			}
		}
	}
		this.disabled=false;
		this.onclick=CardWrite_Click;
		return;
	}
function CardPublicWrite()
{
	var myobj=document.getElementById("ClsM1Card");
	if (myobj==null) return false;
	var CardNo="",PatName="",WardCode=""
	var PatNameobj=document.getElementById("PatName");
	if (PatNameobj) PatName=PatNameobj.value;
	var CardNoobj=document.getElementById("CardNo");
	if (CardNoobj) CardNo=CardNoobj.value;
	var WardCodeobj=document.getElementById("WardCode");
	if (WardCodeobj) WardCode=WardCodeobj.value;
	
	if (CardNo=="")
	{
		alert(t['CardNoNull']);
		return false;
		} 
	if (PatName=="")
	{
		alert(t['PatNameNull']);
		return false;
		}
	if (WardCode=="")
	{
		alert(t['WardCodeNull']);
		return false;
		}
		
	var rtn=myobj.CardPubLicDataWrite(CardNo,PatName,WardCode,"")
	var tmparr=rtn.split("^")
	if (tmparr[0]=="0")
	{
		
		}
	else
	{
		alert(t['CardPubLicDataWriteErr']);
		return false;
		}
		
	return true;
	}
function CardGateWayWrite()
{
	var myobj=document.getElementById("ClsM1Card");
	if (myobj==null) return false;
	var CardNo="",PatName="",WardCode=""
	var PatNameobj=document.getElementById("PatName");
	if (PatNameobj) PatName=PatNameobj.value;
	var CardNoobj=document.getElementById("CardNo");
	if (CardNoobj) CardNo=CardNoobj.value;
	var WardCodeobj=document.getElementById("WardCode");
	if (WardCodeobj) WardCode=WardCodeobj.value;
	
	if (CardNo=="")
	{
		alert(t['CardNoNull']);
		return false;
		} 
	if (PatName=="")
	{
		alert(t['PatNameNull']);
		return false;
		}
	if (WardCode=="")
	{
		alert(t['WardCodeNull']);
		return false;
		}
	var CardGateWayobj=document.getElementById("CardGateWay");
	var CardGateWay=CardGateWayobj.value
	
	var rtn=myobj.CardPubLicDataWrite(CardNo,PatName,WardCode,"")
	var tmparr=rtn.split("^")
	if (tmparr[0]=="0")
	{
		var mySnr=tmparr[1];
		rtn=myobj.HDSyncPersonDB(CardGateWay,CardNo,WardCode,PatName,mySnr,"1","","","","20500101")
		if (rtn!="0")
		{
			alert(t['HDSyncPersonDBErr']);
			return false;
			}
		}
	else
	{
		alert(t['CardPubLicDataWriteErr']);
		return false;
		}
		
	return true;
	}
function CardBathWrite()
{
	var myobj=document.getElementById("ClsM1Card");
	if (myobj==null) return false;
	
	var CardBathobj=document.getElementById("CardBath");
	var CardBath=CardBathobj.value
	
	var myCardNo="",myPatName="",myPatientID=""
	var myPatientIDobj=document.getElementById("PatientID");
	if (myPatientIDobj) myPatientID=myPatientIDobj.value;
	var myPatNameobj=document.getElementById("PatName");
	if (myPatNameobj) myPatName=myPatNameobj.value;
	var myCardNoobj=document.getElementById("CardNo");
	if (myCardNoobj) myCardNo=myCardNoobj.value;
	if (myCardNo=="")
	{
		alert(t['CardNoNull']);
		return false;
		} 
	if (myPatName=="")
	{
		alert(t['PatNameNull']);
		return false;
		}
	
	var myAmt=0;
	var myCardBathType=combo_CardBathType.getSelectedValue();
	if (myCardBathType=="")
	{
		alert(t['CardBathTypeNull']);
		return false;
		}
	var myAmtobj=document.getElementById("CardBathAmount");
	if (myAmtobj!=null){
		myAmt=myAmtobj.value;
		if (isNaN(myAmt)){myAmt=0;}
		}
	if ((myCardBathType=="01")&&((CardBath=="0")||(CardBath=="1"))&&(myAmt==0))
	{
		//alert(t['CardBathAmountNull'])
		//return false;
		}
	if (parseFloat(myAmt)>600)
	{
		alert(t['CardBathAmountMax'])
		return false;
		}
	var myPayType="N";
	if (CardBath=="2") 
		{	myPayType="R";
			
		}	
	var rtn=myobj.CardBathDataWrite(myPayType,myCardBathType,myAmt)
	var tmparr=rtn.split("^")
	if (tmparr[0]=="0")
	{
		var mySnr=tmparr[1];
		var myRefAmt=tmparr[2];
		var encmeth=DHCWebD_GetObjValue("getCardBathSave");
		if (encmeth!=""){
			
			if (myPayType=="R") 
			{	
				myAmt=myRefAmt;
				
			}
			if (myAmt==0) return true;
			var myUserID=session['LOGON.USERID']
			var mystr=myCardBathType+"^"+myCardNo+"^"+mySnr+"^"+myPatName+"^"+myPatientID+"^"+myPayType+"^"+myAmt+"^"+myUserID
			var rtn=cspRunServerMethod(encmeth,mystr);
			if (rtn=="0")
			{
				if (myPayType=="R") 
				{	
					alert(t['CardBathRefund']+myAmt)
				}	
				}
			else
			{
				alert(t['CardBathDataDBErr']);
				return false;
			}
		
		}
		
		
		}
	else
	{
		alert(t['CardBathDataWriteErr']);
		return false;
		}
		if (myPayType=="N"){
			CardBathPrint();
			
			}
	return true;
	}
function ReadCardBathAmount()
{
	try{
	var myobj=document.getElementById("ClsM1Card");
	if (myobj==null) return;
	var CardBathobj=document.getElementById("CardBath");
	if (CardBathobj==null) return;
	if (CardBathobj.value=="2")
	{
		var rtn=myobj.ReadCardBathAmount()
	  var tmparr=rtn.split("^")
	  if (tmparr[0]=="0"){
	  	var myAmtobj=document.getElementById("CardBathAmount");
			if (myAmtobj!=null){
				myAmtobj.value=tmparr[2];
				myAmtobj.disabled=true;
				}
	  	
	  	}
		}
	}catch(e)
	{
		
		}
		
	}
	
function CardBathPrint()
{
	var TxtInfo="";
	var ListInfo="";
	var myCardNo=DHCWebD_GetObjValue("CardNo");
	var myPatName=DHCWebD_GetObjValue("PatName");
	var myCardBathAmount=DHCWebD_GetObjValue("CardBathAmount");
	var myRMB=RMBConvert(myCardBathAmount);
  var myToday=DHCWebD_GetObjValue("Today");
  var myUserCode=session['LOGON.USERCODE'];
  var c2=String.fromCharCode(2);
  TxtInfo="CardNo"+c2+myCardNo+"^"+"PatName"+c2+myPatName+"^"+"CardBathAmount"+c2+myCardBathAmount;
  TxtInfo=TxtInfo+"^"+"Today"+c2+myToday+"^"+"UserCode"+c2+myUserCode+"^"+"RMB"+c2+myRMB;
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	
	}	
function RMBConvert(myAmount)
{
	var encmeth=DHCWebD_GetObjValue("RMBConvert");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,myAmount);
		return rtn;
	}
	return myAmount;
	}	
function nextfocus() {
	var eSrc=window.event.srcElement;
	//alert(eSrc.tabIndex);
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}
function EltStyleHidden(myName)
{
	var myobj=document.getElementById(myName);
	if (myobj) myobj.style.visibility="HIDDEN";
	var myobj=document.getElementById("c"+myName);
	if (myobj) myobj.style.visibility="HIDDEN";

}
//document.onkeydown = DHCWeb_EStopSpaceKey;

document.body.onload = BodyLoadHandler;